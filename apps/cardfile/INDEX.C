#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

HBRUSH hbrWhite;
HBRUSH hbrBlack;
HBRUSH hbrGray;
HBRUSH hbrBlue;
HBRUSH hbrRed;
HBRUSH hbrLine;

int CardPhone = CCARDFILE;
int CharHeight, CharWidth;
int ExtLeading;

HANDLE hArrowCurs;
HANDLE hWaitCurs;

HANDLE hIndexInstance;
HWND   hIndexWnd;

char CurIFile[PATHMAX];
char CurIFind[40];
char rgchUntitled[30];

int fFileDirty = FALSE;

int EditMode = I_TEXT;

int cCards;		       /* the current number of cards */

HANDLE	hCards; 		/* the handle of the header buffer */

int	CardWidth;
int	CardHeight;

int	CharFixWidth;
int	CharFixHeight;

FARPROC lpDlgProc;
FARPROC lpfnOpen;
FARPROC lpfnSave;
FARPROC lpfnAbout;
FARPROC lpEditWndProc;
FARPROC lpfnAbortProc;
FARPROC lpfnAbortDlgProc;
FARPROC lpfnDial;

CARDHEADER CurCardHead;
CARD	   CurCard;
extern char TmpFile[];
char NotEnoughMem[50];
char rgchCardData[40];
char rgchWarning[30];
char rgchNote[30];

long far PASCAL IndexWndProc(hwnd, message, wParam, lParam)
HWND hwnd;
unsigned message;
WORD wParam;
LONG lParam;
{
    PAINTSTRUCT ps;
    LPCARDHEADER lpCards;
    int range;
    HMENU hMenu;
    char buf[30];
    HDC hDC;
    MSG msg;
    RECT rect;
    int y;

    switch (message)
	{
	case WM_CREATE:
	    hIndexWnd = hwnd;
	    IndexWinIniChange();
	    hMenu = GetSystemMenu(hwnd, FALSE);
	    ChangeMenu(hMenu, 0, (LPSTR)NULL, -1, MF_APPEND | MF_SEPARATOR);
	    LoadString(hIndexInstance, IABOUT, (LPSTR)buf, 30);
	    ChangeMenu(hMenu, 0, (LPSTR)buf, ABOUT, MF_APPEND | MF_STRING);
	    SetCaption();
	    SetScrollRange(hwnd, SB_HORZ, 0, cCards-1, FALSE);
	    SetScrollRange(hwnd, SB_VERT, 0, 0, FALSE);
	    break;
	case WM_LBUTTONDOWN:
	case WM_LBUTTONDBLCLK:
	    IndexMouse(hwnd, message, wParam, MAKEPOINT(lParam));
	    break;
	case WM_ENDSESSION:
	    if (wParam)
		Fdelete(TmpFile);
	    break;
	case WM_QUERYENDSESSION:
	    if (MaybeSaveFile(TRUE))
		{
		SetCurCard(iFirstCard);
		return(TRUE);
		}
	    else
		return(FALSE);
	    break;
	case WM_CLOSE:
	    if (MaybeSaveFile(FALSE))
		{
		DestroyWindow(hwnd);
		}
	    return(TRUE);
	case WM_DESTROY:
	    Fdelete(TmpFile);
	    if (GetModuleUsage(hIndexInstance) == 1)
		{
		DeleteObject(hbrGray);
		DeleteObject(hbrRed);
		DeleteObject(hbrBlue);
		}
	    PostQuitMessage(0);
	    return(TRUE);
	case WM_INITMENU:
	    UpdateMenu();
	    break;
	case WM_COMMAND:
	    if (LOWORD(lParam) == hCardWnd && HIWORD(lParam) == EN_ERRSPACE)
		IndexOkError(EINSMEMORY);
	    else if (wParam == EDITWINDOW)
		{
		if (!fSettingText && HIWORD(lParam) == EN_CHANGE)
		    fNeedToUpdateBitmap = TRUE;
		fSettingText = FALSE;
		}
	    else
		IndexInput(hwnd, wParam);
	    break;
	case WM_CTLCOLOR:
	    if (LOWORD(lParam) == hCardWnd)
		{
		SetBkColor((HDC)wParam, 0x00ffffff);
		SetTextColor((HDC)wParam, 0L);
		return((long)hbrWhite);
		}
	    goto CallDefProc;
	case WM_ERASEBKGND:
	    IndexEraseBkGnd(hwnd, (HDC)wParam);
	    break;
	case WM_PAINT:
	    BeginPaint(hwnd, (LPPAINTSTRUCT)&ps);
	    if (CardPhone == PHONEBOOK)
		PhonePaint(hwnd, ps.hdc, (LPRECT)&ps.rcPaint);
	    else
		IndexPaint(hwnd, ps.hdc, (LPRECT)&ps.rcPaint);
	    EndPaint(hwnd, (LPPAINTSTRUCT)&ps);
	    break;
	case WM_SIZE:
	    if (wParam != SIZEICONIC)
		IndexSize(hwnd, LOWORD(lParam), HIWORD(lParam));
	    break;
	case WM_HSCROLL:
	    IndexScroll(hwnd, wParam, LOWORD(lParam));
	    break;
	case WM_VSCROLL:
	    PhoneScroll(hwnd, wParam, LOWORD(lParam));
	    break;
	case WM_CHAR:
	    CardChar(wParam);
	    break;
	case WM_KEYDOWN:
	    PhoneKey(hwnd, wParam);
	    break;
	case WM_ACTIVATE:
	    if (wParam && !HIWORD(lParam))
		if (CardPhone == CCARDFILE)
		    SetFocus(hCardWnd);
		else
		    SetFocus(hIndexWnd);
	    break;
	case WM_WININICHANGE:
	    IndexWinIniChange();
	    break;
	case WM_SETFOCUS:
	case WM_KILLFOCUS:
	    if(CardPhone == PHONEBOOK)
		{
		hDC = GetDC(hIndexWnd);
		y = (iFirstCard - iTopCard) * CharFixHeight;
		SetRect((LPRECT)&rect, 0, y, (LINELENGTH+2)*CharFixWidth, y+CharFixHeight);
		InvertRect(hDC, (LPRECT)&rect);
		ReleaseDC(hIndexWnd, hDC);
		}
	    break;
	case WM_SYSCOMMAND:
	    if (wParam == ABOUT)
		{
		IndexInput(hwnd, wParam);
		break;
		}
	default:
CallDefProc:
	    return(DefWindowProc(hwnd, message, wParam, lParam));
	    break;
	}
    return(0L);
}
