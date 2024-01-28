#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

HWND	hCardWnd;
RECT	dragRect;

long far PASCAL CardWndProc(hwnd, message, wParam, lParam)
HWND hwnd;
unsigned message;
WORD wParam;
LONG lParam;
{
    PAINTSTRUCT ps;

    switch (message)
	{
	case WM_LBUTTONDOWN:
	case WM_MOUSEMOVE:
	case WM_LBUTTONUP:
	    if (EditMode == I_BITMAP)
		BMMouse(hwnd, message, wParam, MAKEPOINT(lParam));
	    else
		goto PassMessageOn;
	    break;
	case WM_CHAR:
	    if (!CardChar(wParam) && EditMode == I_TEXT)
		goto PassMessageOn;
	    break;
	case WM_KEYDOWN:
	    if (!CardKey(wParam) && EditMode == I_TEXT)
		goto PassMessageOn;
	    break;
	case WM_PAINT:
	    if (fSettingText)
		break;
	    BeginPaint(hwnd, (LPPAINTSTRUCT)&ps);
	    CallWindowProc(lpEditWndProc, hCardWnd, message, ps.hdc, 0L);
	    CardPaint(ps.hdc);
	    EndPaint(hwnd, (LPPAINTSTRUCT)&ps);
	    break;
	case WM_SETFOCUS:
	    if (EditMode == I_TEXT)
		goto PassMessageOn;
	    else
		TurnOnBitmapRect();
	    break;
	case WM_KILLFOCUS:
	    if (EditMode == I_TEXT)
		goto PassMessageOn;
	    else
		TurnOffBitmapRect();
	    break;
	default:
PassMessageOn:
	    return(CallWindowProc(lpEditWndProc, hCardWnd, message, wParam, lParam));
	    break;
	}
    return(0L);
}

FAR CardPaint(hDC)
HDC hDC;
    {
    HANDLE hOldObject;
    HDC hMemoryDC;
    long Selection;
    long rgbText;
    int i;
    int cOnes;
    HWND hWndFocus;

    if (CardPhone == PHONEBOOK)
	return;
    hWndFocus = GetFocus();
    /* draw bitmap if there is one */
    if (CurCard.hBitmap)
	{
#ifdef NEVER
	Selection = SendMessage(hCardWnd, EM_GETSEL, 0, 0L);
	SendMessage(hCardWnd, EM_SETSEL, 0, MAKELONG(HIWORD(Selection), HIWORD(Selection)));
#endif
	if (hWndFocus == hCardWnd)
	    SetFocus(NULL);
	if (hMemoryDC = CreateCompatibleDC(hDC))
	    {
	    hOldObject = SelectObject(hMemoryDC, CurCard.hBitmap);
	    BitBlt(hDC, CurCard.xBitmap, CurCard.yBitmap, CurCard.cxBitmap, CurCard.cyBitmap, hMemoryDC, 0, 0, SRCAND);
	    SelectObject(hMemoryDC, hOldObject);
	    DeleteDC(hMemoryDC);
	    }
	if (hWndFocus == hCardWnd)
	    SetFocus(hCardWnd);
#ifdef NEVER
	SendMessage(hCardWnd, EM_SETSEL, 0, Selection);
#endif
	}
    if (EditMode == I_BITMAP && hWndFocus == hCardWnd)
	DrawXorRect(hDC, &dragRect);
    }

DeleteCard(iCard)
int iCard;
    {
    LPCARDHEADER lpCards;

    cCards--;
    lpCards = (LPCARDHEADER) GlobalLock(hCards);
    RepMov(lpCards+iCard, lpCards+iCard+1, (cCards-iCard)*sizeof(CARDHEADER));
    GlobalUnlock(hCards);
    }

FAR AddCurCard()
    {
    LPCARDHEADER lpCards;
    LPCARDHEADER lpTCards;
    char *pch1;
    LPSTR lpch2;
    int i;

    lpCards = (LPCARDHEADER) GlobalLock(hCards);
    lpTCards = lpCards;
    for (i = 0; i < cCards; i++)
	{
	for(pch1 = CurCardHead.line, lpch2 = lpTCards->line; *pch1; ++pch1,++lpch2)
	    if (toupper(*pch1) != toupper(*lpch2))
		break;
	if (toupper(*pch1) <= toupper(*lpch2))
	    break;
	lpTCards++;
	}
    if (i != cCards)
	RepMovUp(lpTCards+1, lpTCards, (cCards - i) * sizeof(CARDHEADER));
    *lpTCards = CurCardHead;
    GlobalUnlock(hCards);
    cCards++;
    return(i);
    }

toupper(ch)
char ch;
    {
    if (ch >= 'a' && ch <= 'z')
	ch -= ('a' - 'A');
    return(ch);
    }

SaveCurrentCard(iCard)
int iCard;
    {
    LPCARDHEADER lpCards;
    HANDLE hText;
    LPSTR lpText;

    /* save the card if it's dirty */
    /* dirty if bitmap has changed or edittext has changed */
    if (CurCardHead.flags & (FDIRTY+FNEW) || SendMessage(hCardWnd, EM_GETMODIFY, 0, 0L))
	{
	hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
	if (!hText)
	    {
	    IndexOkError(EINSMEMSAVE);
	    return(FALSE);
	    }
	lpText = GlobalLock(hText);
	GetWindowText(hCardWnd, lpText, CARDTEXTSIZE);
	if (WriteCurCard(&CurCardHead, &CurCard, lpText))
	    {
	    if (CurCardHead.flags & FDIRTY || SendMessage(hCardWnd, EM_GETMODIFY, 0, 0L))
		fFileDirty = TRUE;
	    SendMessage(hCardWnd, EM_SETMODIFY, FALSE, 0L);
	    CurCardHead.flags &= (!FNEW);
	    CurCardHead.flags &= (!FDIRTY);
	    CurCardHead.flags |= FTMPFILE;
	    lpCards = (LPCARDHEADER) GlobalLock(hCards);
	    lpCards += iCard;
	    *lpCards = CurCardHead;
	    GlobalUnlock(hCards);
	    }
	else
	    return(FALSE);
	GlobalUnlock(hText);
	GlobalFree(hText);
	}
    if (CurCard.hBitmap)
	{
	DeleteObject(CurCard.hBitmap);
	CurCard.hBitmap = 0;
	}
    return(TRUE);
    }

SetCurCard(iCard)
int iCard;
    {
    LPCARDHEADER lpCards;
    LPSTR lpText;
    HANDLE hText;

    hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
    if (!hText)
	{
	IndexOkError(EINSMEMREAD);
	return;
	}
    lpCards = (LPCARDHEADER) GlobalLock(hCards);
    lpCards += iCard;
    CurCardHead = *lpCards;
    GlobalUnlock(hCards);
    lpText = GlobalLock(hText);
    if (!ReadCurCardData(&CurCardHead, &CurCard, lpText))
	IndexOkError(ECANTREADPICT);
    SetEditText(lpText);
    GlobalUnlock(hText);
    GlobalFree(hText);
    if (CurCard.hBitmap)
	SetRect((LPRECT)&dragRect, CurCard.xBitmap, CurCard.yBitmap, CurCard.xBitmap+CurCard.cxBitmap, CurCard.yBitmap+CurCard.cyBitmap);
    else
	SetRect((LPRECT)&dragRect, 5, 5, 5+CharFixWidth, 5+CharFixHeight);
    }
