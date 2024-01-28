/* ** This file contains routines required to display a standard open
      dialog box.  Apps can directly link to object file or modify this
      source for slightly different dialog box.

      Note - in order to use these routines, the application must
      export DlgfnOpen().  Also, an app that uses these routines must
      be running ss=ds, since they use near pointers into stack.
*/

#include "windows.h"
#define LSTRING
#include "winexp.h"

#define CCHFILENAMEMAX  128  /* max number of characters in filename for dos 3.0 */
#define ATTRDIRLIST     0x4010  /* include directories and drives in listbox */
#define ID_LISTBOX      10
#define ID_EDIT         11

int idEditSave;
int idListboxSave;
int idPathSave;
char *   szExtSave;
char *   szFileNameSave;
int     *pfpSave;
char *  rgbOpenSave;

#define CCHNG       15
char    rgchNg[CCHNG] =  {'.', '"', '\\', '/', '[', ']', ':', '|',
                          '<', '>', '+', '=', ';', ',', 0};

int far PASCAL DlgfnOpen();


/* ** Display dialog box for opening files.  Allow user to interact with
      dialogbox, change directories as necessary, and try to open file if user
      selects one.  Automatically append extension to filename if necessary.
      The open dialog box contains an edit field, listbox, static field,
      and OK and CANCEL buttons.

      This routine correctly parses filenames containing KANJI characters.

      Input -   hInstance if app module instance handle.
                hwndParent is window handle of parent window
                idDlgIn is dialog id
                idEditIn is id of edit field
                idListboxIn is id of listbox
                idPathIn is id of static field which gets path name
                szExtIn is pointer to zero terminated string containing
                        default extension to be added to filenames.

      Output - *pfp gets value of file handle if file is opened.
                    or -1 if file could not be opened.
               *rgbOpenIn is initialized with file info by OpenFile()
               *szFileNameIn gets name of selected file (fully qualified)
               (szFileName must point to buffer which of size CCHFILENAMEMAX.)
               Any leading blanks are removed from szFileName.
               Trailing blanks are replaced with a 0 terminator.

      Returns -     -1 if user enters illegal file name and presses ok
                     0 if user presses cancel
                     1 if user enters legal filename and presses ok
*/
int DlgOpen(hInstance, hwndParent, idDlgIn, idEditIn, idListboxIn, idPathIn,
                szExtIn, szFileNameIn, rgbOpenIn, pfp)
HANDLE  hInstance;
HWND    hwndParent;
int     idDlgIn, idEditIn, idListboxIn, idPathIn;
char    *szExtIn;
char    *szFileNameIn;
char *  rgbOpenIn;
int     *pfp;
{
    BOOL    fResult;
    FARPROC lpProc;

    idEditSave = idEditIn;
    idListboxSave = idListboxIn;
    idPathSave = idPathIn;
    szExtSave = szExtIn;
    szFileNameSave = szFileNameIn;
    rgbOpenSave = rgbOpenIn;
    pfpSave = pfp;
    fResult = DialogBox(hInstance, MAKEINTRESOURCE(idDlgIn), hwndParent, lpProc = MakeProcInstance(DlgfnOpen, hInstance));
    FreeProcInstance(lpProc);
    return fResult;
}


/* ** Dialog function for Open File */
int far PASCAL DlgfnOpen(hwnd, msg, wParam, lParam)
HWND hwnd;
unsigned msg;
WORD wParam;
LONG lParam;
{
    int item;
    char rgch[CCHFILENAMEMAX];
    int cchFile, cchDir;
    char *pchFile;
    BOOL    fWild;
    int     result = -1;    /* Assume illegal filename */

    switch (msg) {
    case WM_INITDIALOG:
        /* Set edit field with default search spec */
        SetDlgItemText(hwnd, idEditSave, (LPSTR)(szExtSave+1));

        /* fill list box with filenames that match spec, and fill static
           field with path name */
        DlgDirList(hwnd, (LPSTR)(szExtSave+1), idListboxSave, idPathSave, ATTRDIRLIST);
        break;

    case WM_COMMAND:
        if (wParam == idListboxSave)
            wParam = ID_LISTBOX;
        else if (wParam == idEditSave)
            wParam = ID_EDIT;
        switch (wParam) {
        case IDOK:
            if (IsWindowEnabled(GetDlgItem(hwnd, IDOK))) {
                /* Get contents of edit field */
                /* Add search spec if it does not contain one. */
                GetDlgItemText(hwnd, idEditSave, (LPSTR)szFileNameSave, CCHFILENAMEMAX);

                /* First try to change to specified directory */
                if (DlgDirList(hwnd, (LPSTR)szFileNameSave, idListboxSave, idPathSave, ATTRDIRLIST)){
                    SetDlgItemText(hwnd, idEditSave, (LPSTR)szFileNameSave);
                    break;
                }

                /* Append appropriate extension to user's entry */
                DlgAddCorrectExtension(szFileNameSave);
                /* Try to open directory.  If successful, fill listbox with
                   contents of new directory.  Otherwise, open datafile. */
                if (DlgDirList(hwnd, (LPSTR)szFileNameSave, idListboxSave, idPathSave, ATTRDIRLIST)){
                    SetDlgItemText(hwnd, idEditSave, (LPSTR)szFileNameSave);
                    break;
                }
LoadIt:
                /* Make filename upper case and if it's a legal dos
                   name, try to open the file. */
                AnsiUpper((LPSTR)szFileNameSave);
                if (DlgCheckFileName(szFileNameSave)) {
                    result = 1;
                    *pfpSave = OpenFile((LPSTR)szFileNameSave, (LPOFSTRUCT)rgbOpenSave, 0);
                }
                EndDialog(hwnd, result);
            }
            break;

        case IDCANCEL:
            /* User pressed cancel.  Just take down dialog box. */
            EndDialog(hwnd, 0);
            break;


        /* User single clicked or doubled clicked in listbox -
           Single click means fill edit box with selection.
           Double click means go ahead and open the selection. */
        case ID_LISTBOX:
            switch (HIWORD(lParam)) {

            /* Single click case */
            case 1:
                GetDlgItemText(hwnd, idEditSave, (LPSTR)rgch, CCHFILENAMEMAX);

                /* Get selection, which may be either a prefix to a new search
                   path or a filename. DlgDirSelect parses selection, and
                   appends a backslash if selection is a prefix */
                if (DlgDirSelect(hwnd, (LPSTR)szFileNameSave, idListboxSave)) {
                    cchDir = lstrlen((LPSTR)szFileNameSave);
                    cchFile = lstrlen((LPSTR)rgch);
                    pchFile = rgch+cchFile;

                    /* Now see if there are any wild characters (* or ?) in
                       edit field.  If so, append to prefix. If edit field
                       contains no wild cards append default search spec
                       which is  "*.TXT" for notepad. */
                    fWild = FALSE;
                    while (pchFile >= rgch && *pchFile != '\\' && *pchFile != ':') {
                        if (*pchFile == '*' || *pchFile == '?')
                            fWild = TRUE;
                        pchFile = (char *)AnsiPrev((LPSTR)(rgch-1), (LPSTR)pchFile);
                    }
                    pchFile = (char *)AnsiNext((LPSTR)pchFile);
                    if (fWild)
                        lstrcpy((LPSTR)szFileNameSave + cchDir, (LPSTR)pchFile);
                    else
                        lstrcpy((LPSTR)szFileNameSave + cchDir, (LPSTR)(szExtSave+1));
                }

                /* Set edit field to entire file/path name. */
                SetDlgItemText(hwnd, idEditSave, (LPSTR)szFileNameSave);

                break;

            /* Double click case - first click has already been processed
               as single click */
            case 2:
                /* Basically the same as ok.  If new selection is directory,
                   open it and list it.  Otherwise, open file. */
                if (DlgDirList(hwnd, (LPSTR)szFileNameSave, idListboxSave, idPathSave, ATTRDIRLIST)) {
                    SetDlgItemText(hwnd, idEditSave, (LPSTR)szFileNameSave);
                    break;
                }
                goto LoadIt;    /* go load it up */
            }
            break;

        case ID_EDIT:
            DlgCheckOkEnable(hwnd, idEditSave, HIWORD(lParam));
            break;

        default:
            return(FALSE);
        }
    default:
        return FALSE;
    }
    return(TRUE);
}


/* ** Enable ok button in a dialog box if and only if edit item
      contains text.  Edit item must have id of idEditSave */
DlgCheckOkEnable(hwnd, idEdit, message)
HWND    hwnd;
int     idEdit;
unsigned message;
{
    if (message == EN_CHANGE) {
        EnableWindow(GetDlgItem(hwnd, IDOK), (SendMessage(GetDlgItem(hwnd, idEdit), WM_GETTEXTLENGTH, 0, 0L)));
    }
}

/* ** Given filename or partial filename or search spec or partial
      search spec, add appropriate extension. */
DlgAddCorrectExtension(szEdit)
char    *szEdit;
{
    register char    *pchLast;
    register char    *pchT;
    int ichExt;
    BOOL    fDone = FALSE;

    pchT = pchLast = (char *)AnsiPrev((LPSTR)szEdit, (LPSTR)(szEdit + lstrlen((LPSTR)szEdit)));

    if (*pchLast == ':' || (*pchLast == '.' && *(pchLast-1) == '.'))
        ichExt = 0;
    else if (*pchLast == '\\')
        ichExt = 1;
    else {
        ichExt = 2;
        for (; pchT > szEdit; pchT = (char *)AnsiPrev((LPSTR)szEdit, (LPSTR)pchT)) {
            if (*pchT == '.')
                return;
        }
    }
    lstrcpy((LPSTR)(pchLast+1), (LPSTR)(szExtSave+ichExt));
}

/* ** Check for legal filename. Strip leading blanks and
      0 terminate */
BOOL    DlgCheckFilename(pch)
register char   *pch;
{
    int     cchFN;
    register int     cchT;
    char        *pchIn;
    char        *pchFirst;
    char        *pchSave;
    int     s;

    s = 0;
    pchIn = pch;
    for (;; pch = (char *)AnsiNext((LPSTR)pch)) {

        switch (s) {

        case 0:
            if (!IsChLegal(*pch))
                return FALSE;
            if (*pch != ' ') {
                s = 1;
                cchT = 1;
                pchFirst = pch;
            }
            break;

        case 1:
            if (cchT++ > 7 || *pch == ' ')
                return FALSE;
            if (*pch == '.') {
                s = 2;
                cchT = 0;
            } else if (!IsChLegal(*pch))
                return FALSE;
            break;

        case 2:
            if (*pch == 0) {
                goto   RetGood;
            }

            if (cchT++ > 3 || !IsChLegal(*pch))
                return FALSE;

            if (*pch == ' ') {
                pchSave = pch;
                s = 3;
            }
            break;

        case 3:
            if (*pch == 0) {
                *pchSave = 0;
                goto RetGood;
            } else if (*pch != ' ')
                return FALSE;
        break;
        }
    }
RetGood:
    if (pchFirst != pchIn)
        lstrcpy((LPSTR)pchIn, (LPSTR)pchFirst);
    return TRUE;
}

/* ** Check for legal MS-DOS filename characters.
      return TRUE if legal, FALSE otherwise. */
BOOL IsChLegal(ch)
int     ch;
{
        register char    *pch = rgchNg;
        register int ich = 0;

        if (ch < ' ')
            return FALSE;

        rgchNg[CCHNG-1] = ch;
        while (ch != *pch++)
            ich++;

        return (ich == CCHNG-1);
}
