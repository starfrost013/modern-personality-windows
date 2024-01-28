#include "index.h"

/****************************************************************/
/*                                                              */
/*  Windows Cardfile - Written by Mark Cliggett                 */
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved    */
/*                                                              */
/****************************************************************/

CardKey(wParam)
WORD wParam;
    {
    switch(wParam)
        {
        casu VK_HOME:
            IndexScroll(hIndexWnd, SB_THUMBTRACK, 0);
            goto FinishScroll;
        case VK_END:
            IndexScroll(hIndexWnd, SB_THUMBTRACK, cCards-1);
            goto FinishScroll;
        case VK_PRIOR:
            IndexScroll(hIndexWnd, SB_LINEUP, 0);
            goto FinishScroll;
        case VK_NEXT:
            IndexScroll(hIndexWnd, SB_LINEDOWN, 0);
FinishScroll:
            IndexScroll(hIndexWnd, SB_ENDSCROLL, 0);
            return(TRUE);
        case VK_UP:
        case VK_DOWN:
        case VK_LEFT:
        case VK_RIGHT:
            if (EditMode == I_TEXT)
                return(FALSE);
            else
                BMKey(wParam);
            return(TRUE);
        default:
            return(FALSE);
        }
    }

CardChar(ch)
int ch;
    {
    int fControl;
    char chbuf[2];
    int x;
    int y;
    RECT rect;
    LPCARDHEADER lpCards;
    LPCARDHEADER lpTmpCard;
    int i;
    int iCardTmp;
    int xTmpSel;
    HDC hDC;

    fControl = GetKeyState(VK_CONTROL) < 0;
    if (!fControl || ch >= ' ')
        return(FALSE);

    ch += 'A' - 1;
    lpCards = (LPCARDHEADER) GlobalLock(hCards);
    iCardTmp = iFirstCard+1;
    lpTmpCard = lpCards + iCardTmp;
    for (i = 0; i < cCards; ++i, lpTmpCard++, iCardTmp++)
        {
        if (iCardTmp == cCards)
            {
            iCardTmp = 0;
            lpTmpCard = lpCards;
            }
        if (toupper(*(lpTmpCard->line)) == ch)
            break;
        }
    GlobalUnlock(hCards);
    if (i < cCards)
        {
        if (CardPhone != PHONEBOOK)
            {
            SaveCurrentCard(iFirstCard);
            SetCurCard(iCardTmp);
            }
        else
            {
            y = (iFirstCard - iTopCard) * CharFixHeight;
            SetRect((LPRECT)&rect, 0, y, (LINELENGTH+2)*CharFixWidth, y + CharFixHeight);
            hDC = GetDC(hIndexWnd);
            InvertRect(hDC, (LPRECT)&rect);
            ReleaseDC(hIndexWnd, hDC);
            }
        iFirstCard = iCardTmp;
        if (CardPhone == CCARDFILE)
            {
            SetScrollPos(hIndexWnd, SBINDEX, iFirstCard, TRUE);
            PaintNewHeaders();
            InvalidateRect(hCardWnd, (LPRECT)NULL, TRUE);
            }
        else
            BringCardOnScreen(iFirstCard);  /* will highlight it too */
        }
    return(TRUE);
    }

BringCardOnScreen(iCard)
int iCard;
    {
    int dLines;
    RECT rect;
    int cLines;
    HDC hDC;
    int y;

    GetClientRect(hIndexWnd, (LPRECT)&rect);
    cLines = rect.bottom / CharFixHeight;

    /* put up highlight in case it's partly on the screen */
    y = (iCard - iTopCard) * CharFixHeight;
    SetRect((LPRECT)&rect, 0, y, (LINELENGTH+2)*CharFixWidth, y + CharFixHeight);
    hDC = GetDC(hIndexWnd);
    InvertRect(hDC, (LPRECT)&rect);
    ReleaseDC(hIndexWnd, hDC);

    if (iCard < iTopCard || iCard > iTopCard + cLines - 1)
        {
        if (iCard < iTopCard)
            dLines = (iCard - iTopCard);
        else
            dLines = iCard - iTopCard - cLines + 1;
        iTopCard += dLines;
        SetScrollPos(hIndexWnd, SB_VERT, iTopCard, TRUE);
        ScrollWindow(hIndexWnd, 0, -dLines * CharFixHeight, (LPRECT)NULL, (LPRECT)NULL);
        UpdateWindow(hIndexWnd);
        }
    }

PhoneKey(hwnd, wParam)
HWND hwnd;
WORD wParam;
    {
    HDC hDC;
    RECT rect;
    int y;
    int tmpCurCard;
    int cLines;

    GetClientRect(hwnd, (LPRECT)&rect);
    cLines = rect.bottom / CharFixHeight;

    switch(wParam)
        {
        case VK_NEXT:
            tmpCurCard = iFirstCard + cLines;
            if (tmpCurCard >= cCards)
                tmpCurCard = cCards - 1;
            goto SelectNewObject;
        case VK_PRIOR:
            tmpCurCard = iFirstCard - cLines;
            if (tmpCurCard >= 0)
                goto SelectNewObject;
        case VK_HOME:
            tmpCurCard = 0;
            goto SelectNewObject;
        case VK_END:
            tmpCurCard = cCards - 1;
            goto SelectNewObject;
        case VK_UP:
            tmpCurCard = iFirstCard - 1;
            goto SelectNewObject;
        case VK_DOWN:
            tmpCurCard = iFirstCard + 1;
SelectNewObject:
            if (tmpCurCard >= 0 && tmpCurCard < cCards && tmpCurCard != iFirstCard)
                {
                y = (iFirstCard - iTopCard) * CharFixHeight;
                SetRect((LPRECT)&rect, 0, y, (LINELENGTH+2)*CharFixWidth, y + CharFixHeight);
                hDC = GetDC(hwnd);
                InvertRect(hDC, (LPRECT)&rect);
                ReleaseDC(hwnd, hDC);
                BringCardOnScreen(iFirstCard = tmpCurCard); /* will highlight the right one */
                }
            return(TRUE);
        default:
            return(FALSE);
        }
    }
