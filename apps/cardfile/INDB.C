#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

int fWinIniModem = FALSE;
int DBcmd;
#define ATTRDIRLIST 0x4010
char szExtSave[] = "\\*.CRD";

int far PASCAL fnOpen(hwnd, msg, wParam, lParam)
HWND hwnd;
unsigned msg;
WORD wParam;
LONG lParam;
    {
    int item;
    int cchFile, cchDir;
    char *pchFile;
    BOOL    fWild;
    char *pResultBuf = NULL;
    char szNewName[PATHMAX];
    int len;

    switch (msg)
	{
	case WM_INITDIALOG:
	    SetDlgItemText(hwnd, ID_EDIT, (LPSTR)"*.CRD");
	    SendDlgItemMessage(hwnd, ID_EDIT, EM_LIMITTEXT, 128, 0L);
	    DlgDirList(hwnd, (LPSTR)"*.CRD", ID_LISTBOX, ID_PATH, ATTRDIRLIST);
	    break;

	case WM_COMMAND:
	    switch (wParam)
		{
		case IDOK:
LoadIt:
		    if (IsWindowEnabled(GetDlgItem(hwnd,IDOK)))
			{
			len = 7+GetWindowTextLength(GetDlgItem(hwnd, ID_EDIT));
			if(pResultBuf = (char *)LocalAlloc(LPTR, len))
			    {
			    GetDlgItemText(hwnd, ID_EDIT, (LPSTR)pResultBuf, len);
			    lstrcpy((LPSTR)szNewName, (LPSTR)pResultBuf);

			    /* Append appropriate extension to user's entry */
			    DlgAddCorrectExtension(szNewName, TRUE);

			    /* Try to open directory.  If successful, fill listbox with
			       contents of new directory.  Otherwise, open datafile. */
			    if (FSearchSpec(szNewName))
				{
				if (DlgDirList(hwnd, (LPSTR)szNewName, ID_LISTBOX, ID_PATH, ATTRDIRLIST))
				    {
				    SetDlgItemText(hwnd, ID_EDIT, (LPSTR)szNewName);
				    break;
				    }
				}

			    DlgAddCorrectExtension(pResultBuf, FALSE);
			    /* If no directory list and filename contained search spec,
			       honk and don't try to open. */
			    if (FSearchSpec(pResultBuf))
				{
				MessageBeep(0);
				break;
				}
			    AnsiUpper((LPSTR)pResultBuf);
			    }
			}
		    EndDialog(hwnd, (WORD)pResultBuf);
		    break;
		case IDCANCEL:
		    EndDialog(hwnd, NULL);
		    break;

		case ID_LISTBOX:
		    switch (HIWORD(lParam))
			{
			case 1:
			    len = GetWindowTextLength(GetDlgItem(hwnd, ID_EDIT));
			    if(pResultBuf = (char *)LocalAlloc(LPTR, ++len))
				{
				GetDlgItemText(hwnd, ID_EDIT, (LPSTR)pResultBuf, len);
				if (DlgDirSelect(hwnd, (LPSTR)szNewName, ID_LISTBOX))
				    {
				    cchDir = lstrlen((LPSTR)szNewName);
				    cchFile = lstrlen((LPSTR)pResultBuf);
				    pchFile = pResultBuf+cchFile;
				    fWild = (*pchFile == '*' || *pchFile == ':');
				    while (pchFile > pResultBuf)
					{
					pchFile = (char *)AnsiPrev((LPSTR)(pResultBuf), (LPSTR)pchFile);
					if (*pchFile == '*' || *pchFile == '?')
					    fWild = TRUE;
					if (*pchFile == '\\' || *pchFile == ':')
					    {
					    pchFile = (char *)AnsiNext((LPSTR)pchFile);
					    break;
					    }
					}
				    if (fWild)
					lstrcpy((LPSTR)szNewName + cchDir, (LPSTR)pchFile);
				    else
					lstrcpy((LPSTR)szNewName + cchDir, (LPSTR)"*.CRD");
				    }
				SetDlgItemText(hwnd, ID_EDIT, (LPSTR)szNewName);
				LocalFree((HANDLE)pResultBuf);
				}
			    break;
			case 2:
			    if (DlgDirList(hwnd, (LPSTR)szNewName, ID_LISTBOX, ID_PATH, 0x4010))
				{
				SetDlgItemText(hwnd, ID_EDIT, (LPSTR)szNewName);
				break;
				}
			    goto LoadIt;    /* go load it up */
			}
		    break;
		case ID_EDIT:
		    CheckOkEnable(hwnd, HIWORD(lParam));
		    break;
		default:
		    return(FALSE);
		}
	    break;
	default:
	    return FALSE;
	}
    return(TRUE);
    }

/* ** Given filename or partial filename or search spec or partial
      search spec, add appropriate extension. */
DlgAddCorrectExtension(szEdit, fSearching)
char	*szEdit;
BOOL	fSearching;
{
    register char    *pchLast;
    register char    *pchT;
    int ichExt;
    BOOL    fDone = FALSE;
    int     cchEdit;

    pchT = pchLast = (char *)AnsiPrev((LPSTR)szEdit, (LPSTR)(szEdit + (cchEdit = lstrlen((LPSTR)szEdit))));

    if (*pchLast == ':' || (*pchLast == '.' && *(pchLast-1) == '.') && cchEdit == 2)
	ichExt = 0;
    else if (*pchLast == '\\')
	ichExt = 1;
    else {
	ichExt = fSearching ? 0 : 2;
	for (; pchT > szEdit; pchT = (char *)AnsiPrev((LPSTR)szEdit, (LPSTR)pchT)) {
	    if (*pchT == '.')
		return;
	}
    }
    lstrcpy((LPSTR)(pchLast+1), (LPSTR)(szExtSave+ichExt));
}

/* ** return TRUE iff 0 terminated string contains a '*' or '\' */
BOOL	FSearchSpec(sz)
register char	 *sz;
{
    for (; *sz;sz++) {
	if (*sz == '*' || *sz == '?')
	    return TRUE;
    }
    return FALSE;
}

/* ** Dialog function for "Save as" .  User must specify new name of file. */
int far PASCAL fnSave(hwnd, msg, wParam, lParam)
HWND hwnd;
unsigned msg;
WORD wParam;
LONG lParam;
    {
    char *pResultBuf;
    int len;
    char rgch[128];
    char    *pchFileName;
    char    *pchCmp;
    char    *pchTest;
    char    *PFileInPath();

    switch (msg)
	{
	case WM_INITDIALOG:
	    /* Initialize Path field with current directory */
	    DlgDirList(hwnd, (LPSTR)0, 0, ID_PATH, 0);

	    if (CurIFile[0])
		{
		/* rgch gets current directory string, terminated with "\\\0" */
		len = GetDlgItemText(hwnd, ID_PATH, (LPSTR)rgch, 128);
		if (rgch[len-1] != '\\')
		    {
		    rgch[len] = '\\';
		    rgch[++len] = 0;
		    }

		/* Now see if path in reopen buffer matches current directory. */
		for (pchFileName = CurIFile,
		     pchTest = PFileInPath(CurIFile),
		     pchCmp = rgch;
		     pchFileName < pchTest;
		     pchFileName = AnsiNext(pchFileName), pchCmp = AnsiNext(pchCmp))
		    {
		    if (*pchFileName != *pchCmp)
			break;
		    }
		/* If paths don't match, reset pchFileName to point to fully qualified
		   path. (Otherwise, pchFileName already points to filename. */
		if (*pchCmp || pchFileName < pchTest)
		    pchFileName = CurIFile;
		SetDlgItemText(hwnd, ID_EDIT, (LPSTR)pchFileName);
		}
	    else
		EnableWindow(GetDlgItem(hwnd, IDOK), FALSE);
	    break;

	case WM_COMMAND:
	    switch (wParam)
		{
		case IDOK:
		    if (IsWindowEnabled(GetDlgItem(hwnd, IDOK)))
			{
			len = 4+GetWindowTextLength(GetDlgItem(hwnd, ID_EDIT));
			if(pResultBuf = (char *)LocalAlloc(LPTR, ++len))
			    {
			    GetDlgItemText(hwnd, ID_EDIT, (LPSTR)pResultBuf, len);
			    AppendExtension(pResultBuf, pResultBuf);
			    }
			EndDialog(hwnd, (WORD)pResultBuf);
			}
		    break;

		case IDCANCEL:
		    EndDialog(hwnd, NULL);
		    break;
		case ID_EDIT:
		    CheckOkEnable(hwnd, HIWORD(lParam));
		    break;
		default:
		    return(FALSE);
		}
	    break;
	default:
	    return FALSE;
	}
    return(TRUE);
    }

/* ** Given filename which may or maynot include path, return pointer to
      filename (not including path part.) */
char * PFileInPath(sz)
char *sz;
{
    char    *pch;

    /* Strip path/drive specification from name if there is one */
    pch = (char *)AnsiPrev((LPSTR)sz, (LPSTR)(sz + lstrlen((LPSTR)sz)));
    while (pch > sz) {
	pch = (char *)AnsiPrev((LPSTR)sz, (LPSTR)pch);
	if (*pch == '\\' || *pch == ':') {
	    pch = (char *)AnsiNext((LPSTR)pch);
	    break;
	}
    }
    return(pch);
}



CheckOkEnable(hwnd, message)
HWND	hwnd;
unsigned message;
    {
	    if (message == EN_CHANGE)
		EnableWindow(GetDlgItem(hwnd, IDOK), (SendMessage(GetDlgItem(hwnd, ID_EDIT), WM_GETTEXTLENGTH, 0, 0L)));
    }

int far PASCAL fnAbout(hwnd, msg, wParam, lParam)
HWND hwnd;
unsigned msg;
WORD wParam;
LONG lParam;
    {
    char buf[40];
    int len;
    int id;

    if (msg == WM_INITDIALOG)
	{
	len = itoa(cCards, buf);
	if (cCards == 1)
	    id = ICARD;
	else
	    id = ICARDS;
	LoadString(hIndexInstance, id, (LPSTR)(buf+len), 40-len);
	SetDlgItemText(hwnd, 4, (LPSTR)buf);
	return(TRUE);
	}
    else if (msg == WM_COMMAND && wParam == IDOK)
	{
	EndDialog(hwnd, NULL);
	return(TRUE);
	}
    return(FALSE);
    }

/* convert an int to ascii */
itoa(n, psz)
unsigned n;
char *psz;
    {
    char *pch = psz;
    char ch;
    int len;

    do
	{
	*pch++ = n % 10 + '0';
	n /= 10;
	}
    while (n > 0);

    len = pch - psz;
    *pch-- = '\0';
    /* reverse the digits */

    while (psz < pch)
	{
	ch = *psz;
	*psz++ = *pch;
	*pch-- = ch;
	}
    return(len);
    }

BOOL far PASCAL DlgProc(hDB, message, wParam, lParam)
HWND hDB;
unsigned message;
WORD wParam;
LONG lParam;
    {
    char *pResultBuf;
    char *pchInit;
    int len;
    char PhoneNumber[30];

    switch (message)
	{
	case WM_INITDIALOG:
	    switch(DBcmd)
		{
		case DTHEADER:
		    pchInit = CurCardHead.line;
		    break;
		case DTFIND:
		    pchInit = CurIFind;
		    break;
		case DTDIAL:
		    pchInit = PhoneNumber;
		    GetPhoneNumber(PhoneNumber,30);
		    break;
		default:
		    pchInit = "";
		}
	    SetDlgItemText(hDB, 4, (LPSTR)pchInit);
#ifdef NEVER
	    SendMessage(GetDlgItem(hDB, ID_EDIT), EM_SETSEL, 0, MAKELONG(0, lstrlen((LPSTR)pchInit)));
#endif
	    SetFocus(GetDlgItem(hDB, 4));
	    return(TRUE);
	    break;

	case WM_COMMAND:
	    pResultBuf = NULL;
	    switch (wParam)
		{
		case IDOK:
		    if ((len = GetWindowTextLength(GetDlgItem(hDB, 4))) || DBcmd == DTHEADER || DBcmd == DTADD)
			if(pResultBuf = (char *)LocalAlloc(LPTR, ++len))
			    GetDlgItemText(hDB, 4, (LPSTR)pResultBuf, len);
		    break;
		case IDCANCEL:
		    break;
		default:
		    return(FALSE);
		}
	    EndDialog(hDB, (int)pResultBuf);	 /* return pointer to buffer */
	    return(TRUE);
	    break;
	default:
	    return(FALSE);
	}
    }

BOOL far PASCAL fnDial(hDB, message, wParam, lParam)
HWND hDB;
unsigned message;
WORD wParam;
LONG lParam;
    {
    char *pResultBuf;
    char *pch;
    int len;
    char PhoneNumber[40];
    char ComPortandDialType[15];
    int tmp;

    switch (message)
	{
	case WM_INITDIALOG:
	    GetPhoneNumber(PhoneNumber,40);
	    SetDlgItemText(hDB, 4, (LPSTR)PhoneNumber);
	    SendMessage(GetDlgItem(hDB, ID_EDIT), EM_SETSEL, 0, MAKELONG(0, lstrlen((LPSTR)PhoneNumber)));
	    if (!fWinIniModem)
		{
		if (GetProfileString((LPSTR)rgchWindows, (LPSTR)"Modem", (LPSTR)"", (LPSTR)ComPortandDialType, 40))
		    {
		    for (pch = ComPortandDialType; *pch && *pch != ',' && *pch != ' '; ++pch)
			;
		    if (*pch)
			*pch++ = 0;
		    if (lstrcmp((LPSTR)ComPortandDialType, (LPSTR)"COM1"))
			fModemOnCom1 = FALSE;
		    while (*pch == ',' || *pch == ' ')
			pch++;
		    if (*pch == 'P' || *pch == 'p')
			fTone = FALSE;
		    while (*pch && *pch != ',')
			pch++;
		    while (*pch == ',' || *pch == ' ')
			pch++;
		    if (*pch == 'F' || *pch == 'F')
			fFastModem = TRUE;
		    fWinIniModem = TRUE;
		    }
		}
	    CheckRadioButton(hDB, RB_TONE, RB_PULSE, fTone ? RB_TONE : RB_PULSE);
	    CheckRadioButton(hDB, RB_COM1, RB_COM2, fModemOnCom1 ? RB_COM1 : RB_COM2);
	    CheckRadioButton(hDB, RB_1200, RB_300, fFastModem ? RB_1200 : RB_300);
	    SetFocus(GetDlgItem(hDB, 4));
	    return(TRUE);

	case WM_COMMAND:
	    pResultBuf = NULL;
	    switch (wParam)
		{
		case IDOK:
		    tmp = IsDlgButtonChecked(hDB, RB_TONE);
		    if (tmp != fTone)
			fWinIniModem = FALSE;
		    fTone = tmp;
		    tmp = IsDlgButtonChecked(hDB, RB_COM1);
		    if (tmp != fModemOnCom1)
			fWinIniModem = FALSE;
		    fModemOnCom1 = tmp;
		    tmp = IsDlgButtonChecked(hDB, RB_1200);
		    if (tmp != fFastModem)
			fWinIniModem = FALSE;
		    fFastModem = tmp;

		    if (!fWinIniModem)
			{
			lstrcpy((LPSTR)ComPortandDialType, (LPSTR)"COM2,P,S");
			if (fModemOnCom1)
			    ComPortandDialType[3] = '1';
			if (fTone)
			    ComPortandDialType[5] = 'T';
			if (fFastModem)
			    ComPortandDialType[7] = 'F';
			/* write stuff out in win.ini */
			WriteProfileString((LPSTR)rgchWindows, (LPSTR)"Modem", (LPSTR)ComPortandDialType);
			fWinIniModem = TRUE;
			}

		    if ((len = GetWindowTextLength(GetDlgItem(hDB, 4))) || DBcmd == DTHEADER || DBcmd == DTADD)
			if(pResultBuf = (char *)LocalAlloc(LPTR, ++len))
			    GetDlgItemText(hDB, 4, (LPSTR)pResultBuf, len);
		case IDCANCEL:
		    EndDialog(hDB, (int)pResultBuf);
		    break;
		case RB_TONE:
		case RB_PULSE:
		    CheckRadioButton(hDB, RB_TONE, RB_PULSE, wParam);
		    break;
		case RB_COM1:
		case RB_COM2:
		    CheckRadioButton(hDB, RB_COM1, RB_COM2, wParam);
		    break;
		case RB_300:
		case RB_1200:
		    CheckRadioButton(hDB, RB_1200, RB_300, wParam);
		    break;
		default:
		    return(FALSE);
		}
	    return(TRUE);
	    break;
	default:
	    return(FALSE);
	}
    }
