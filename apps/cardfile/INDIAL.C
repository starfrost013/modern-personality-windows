#include "index.h"

int fModemOnCom1 = TRUE;
int fTone = TRUE;
int fFastModem = TRUE;

FAR GetPhoneNumber(pchBuf, cchMax)
PSTR pchBuf;
int cchMax;
    {
    LPCARDHEADER lpCard;
    int fFound = FALSE;
    LPSTR lpText;
    HANDLE hText;
    unsigned long lSelection;

    lSelection = SendMessage(hCardWnd, EM_GETSEL, 0, 0L);
    if (HIWORD(lSelection) == LOWORD(lSelection))
	{
	lpCard = (LPCARDHEADER) GlobalLock(hCards) + iFirstCard;
	fFound = ParseNumber((LPSTR)lpCard->line, pchBuf, cchMax);
	GlobalUnlock(hCards);
	}
    if (!fFound)
	{
	hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
	if (hText)
	    {
	    lpText = GlobalLock(hText);
	    GetWindowText(hCardWnd, lpText, CARDTEXTSIZE);
	    if (HIWORD(lSelection) != LOWORD(lSelection))
		{
		lstrcpy(lpText, lpText+LOWORD(lSelection));
		*(lpText + (HIWORD(lSelection) - LOWORD(lSelection))) = 0;
		}
	    fFound = ParseNumber(lpText, pchBuf, cchMax);
	    GlobalUnlock(hText);
	    GlobalFree(hText);
	    }
	}
    if (!fFound)
	*pchBuf = 0;
    }

ParseNumber(lpSrc, pchBuf, cchMax)
LPSTR lpSrc;
char *pchBuf;
int cchMax;
    {
    LPSTR lpchTmp;
    LPSTR lpchEnd;
    PSTR pchTmp;
    int fValid;
    char ch;

    for (lpchTmp = lpSrc; *lpchTmp; ++lpchTmp)
	{
	pchTmp = pchBuf;
	lpchEnd = lpchTmp;
	while(pchTmp - pchBuf < cchMax)
	    {
	    ch = *lpchEnd++;
	    if (ch == '-')
		{
		fValid = TRUE;
		*pchTmp++ = ch;
		}
	    else if ((ch >= '0' && ch <= '9') || ch == '@' ||
		     ch == ',' || ch == '(' || ch == ')' || ch == '*' || ch == '#')
		*pchTmp++ = ch;
	    else
		{
		*pchTmp = 0;
		break;
		}
	    }
	if (fValid && pchTmp - pchBuf > 5)
	    return(TRUE);
	}
    return(FALSE);
    }

FAR DoDial(pchNumber)
PSTR pchNumber;
    {
    int cid;
    char rgchComm[5];
    char cmdBuf[80];
    char inBuf[80];
    int cch;
    COMSTAT ComStatInfo;
    long oldtime;

    lstrcpy((LPSTR)rgchComm, (LPSTR)"COM2");
    if (fModemOnCom1)
	rgchComm[3] = '1';
    if ((cid = OpenComm((LPSTR)rgchComm, 256, 256))>=0)
	{
	SetPortState(cid);
	GetCommError(cid, (LPSTR)&ComStatInfo);
	cch = MakeDialCmd(cmdBuf, 80, pchNumber);
	while (WriteComm(cid, (LPSTR)cmdBuf, cch) <= 0)
	    {
	    GetCommError(cid, (LPSTR)&ComStatInfo);
	    FlushComm(cid, 0);
	    FlushComm(cid, 1);
	    }
	oldtime = GetCurrentTime();
	while(TRUE)
	    {
	    GetCommError(cid, (LPSTR)&ComStatInfo);
	    if (GetCurrentTime() - oldtime > 3000)
		{
		IndexOkError(ENOMODEM);
		goto DoneDialing;
		}
	    if (!ComStatInfo.cbOutQue)
		break;
	    }
	FlushComm(cid, 1);
	LoadString(hIndexInstance, IPICKUPPHONE, (LPSTR)cmdBuf, 80);
	MessageBox(hIndexWnd, (LPSTR)cmdBuf, (LPSTR)rgchCardfile, MB_OKCANCEL | MB_ICONQUESTION);
	lstrcpy((LPSTR)cmdBuf, (LPSTR)"ATH0");
	cmdBuf[4] = 0x0d;
	while(WriteComm(cid, (LPSTR)cmdBuf, 5) <= 0)
	    {
	    GetCommError(cid, (LPSTR)&ComStatInfo);
	    FlushComm(cid, 0);
	    FlushComm(cid, 1);
	    }
	while(TRUE)
	    {
	    GetCommError(cid, (LPSTR)&ComStatInfo);
	    if (!ComStatInfo.cbOutQue)
		break;
	    }
DoneDialing:
	CloseComm(cid);
	}
    else
	{
	LoadString(hIndexInstance, ECANTDIAL, (LPSTR)cmdBuf, 80);
	MessageBox(hIndexWnd, (LPSTR)cmdBuf, (LPSTR)rgchCardfile, MB_OK | MB_ICONEXCLAMATION);
	}
    }

SetPortState(cid)
int  cid;
    {
    DCB   dcb;
    char rgchPortInfo[30];
    char *pch;
    char rgchPort[6];

    if (GetCommState(cid, (int far *) &dcb)!=-1)
	{
	if (fFastModem)
	    dcb.BaudRate = 1200;
	else
	    dcb.BaudRate = 300;
	lstrcpy((LPSTR)rgchPort, (LPSTR)"COM1:");
	rgchPort[3] = '1' + cid;
	GetProfileString((LPSTR)"Ports", (LPSTR)rgchPort, (LPSTR)"300,n,8,1", (LPSTR)rgchPortInfo, 30);
	for (pch = rgchPortInfo; *pch && *pch != ','; ++pch)
	    ;
	while(*pch == ',' || *pch == ' ')
	    pch++;
	dcb.Parity = *pch == 'n' ? NOPARITY : (*pch == 'o' ? ODDPARITY : EVENPARITY);
	if (*pch)
	    pch++;
	while(*pch == ',' || *pch == ' ')
	    pch++;
	dcb.ByteSize = *pch == '8' ? 8 : 7;
	if (*pch)
	    pch++;
	while (*pch == ',' || *pch == ' ')
	    pch++;
	dcb.StopBits = *pch == '2' ? 2 : 0;
	SetCommState((int far *)&dcb);
	}
    }

/* Create a modem command for dialing */
int MakeDialCmd(pBuf, cchMax, pchNumber)
char *pBuf;
int  cchMax;
PSTR pchNumber;
    {
    PSTR pch1;
    PSTR pch2;
    int   cb;
    char  rgchCmd[80];
    char ch;

    lstrcpy((LPSTR)rgchCmd, (LPSTR)"ATD");
    for (pch2 = rgchCmd; *pch2; ++pch2)
	;
    *pch2++ = fTone ? 'T' : 'P';
    for (pch1 = pchNumber; ch = *pch1++; )
	if ((ch >= '0' && ch <= '9') || (ch == ',') || (ch == '#') || (ch == '*'))
	    *pch2++ = ch;
	else if (ch == '@')
	    {
	    *pch2++ = ',';
	    *pch2++ = ',';
	    *pch2++ = ',';
	    }
	else if (ch == 'P' || ch == 'T')
	    {
	    *pch2++ = 'D';
	    *pch2++ = ch;
	    }

    *pch2++ = ';';
    *pch2++ = 0x0d;
    *pch2 = 0;

    cb = lstrlen((LPSTR)rgchCmd);
    if (cchMax < pch2 - rgchCmd)
	{
	rgchCmd[cchMax] = 0;
	cb = cchMax;
	}
    lstrcpy((LPSTR)pBuf, (LPSTR)rgchCmd);
    return cb;
    }
