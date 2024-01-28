#include "index.h"

/****************************************************************/
/*                                                              */
/*  Windows Cardfile - Written by Mark Cliggett                 */
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved    */
/*                                                              */
/****************************************************************/

int fSettingText = FALSE;
int iTopScreenCard;
int iFirstCard = 0;
int cScreenHeads;       /* the number of headers that are partially visible (>=1) */
int cFSHeads;           /* the number of fully visible headers */
int cScreenCards;       /* the number of cards that are partially visible (>=1) */
int xFirstCard;         /* the x */
int yFirstCard;         /* and y coordinates of the front card */
int ySpacing;           /* the y offset of each card (CharFixHeight + 1) */
int IndexWidth;
int IndexHeight;
int iTopCard;

IndexEraseBkGnd(hWnd, hDC)
HWND hWnd;
HDC  hDC;
    {
    HBRUSH  hbr, hbrOld;
    RECT    rect;
    POINT pt;

    GetClientRect(hWnd, (LPRECT)&rect);
    if (CardPhone == PHONEBOOK)
        hbr = CreateSolidBrush(GetSysColor(COLOR_WINDOW));
    else
        hbr = hbrBack;
    if (hbr)
        {
        UnrealizeObject(hbr);
        pt.x = 0;
        pt.y = 0;
        ClientToScreen(hWnd, (LPPOINT)&pt);
        SetBrushOrg( hDC, pt.x, pt.y);
        hbrOld = SelectObject(hDC, hbr);
        FillRect(hDC, (LPRECT)&rect, hbr);
        SelectObject(hDC, hbrOld);
        if (CardPhone == PHONEBOOK)
            DeleteObject(hbr);
        }
    }

IndexPaint(hWindow, hDC, lpRectangle)
HWND hWindow;                /* a handle to a window data structure */
HDC  hDC;                    /* a handle to a GDI display context */
LPRECT lpRectangle;
    {
    RECT rect;
    LPCARDHEADER lpCards;
    LPCARDHEADER lpTCards;
    int xCur, yCur;
    int vcCards;
    int hcCards;
    int ipcCards;
    int extra;
    int width;
    int height;
    int idCard;
    int i;
    int len;

    if (fSettingText)
        return;
    width = IndexWidth - LEFTMARGIN;
    if (width - RIGHTMARGIN > CardWidth)
        width -= RIGHTMARGIN;
    height = IndexHeight;
    if (IndexHeight - BOTTOMMARGIN > CardHeight)
        height -= BOTTOMMARGIN;
    hcCards = 1;
    cFSHeads = cScreenHeads = 1;
    if (yFirstCard < height)
        {
        cScreenHeads += (yFirstCard+ySpacing-1) / ySpacing;
        cFSHeads += (yFirstCard / ySpacing);
        }
    if ((extra = width - CardWidth) > 0)
        hcCards += (extra / (2 * CharFixWidth));
    vcCards = height / ySpacing;
    if (cScreenHeads > cCards)
        cScreenHeads = cCards;
    if (cFSHeads > cCards)
        cFSHeads = cCards;
    ipcCards = hcCards > vcCards ? hcCards : vcCards;
    ipcCards = cCards < ipcCards ? cCards : ipcCards;
    cScreenCards = ipcCards;

    lpCards = (LPCARDHEADER) GlobalLock(hCards);

    yCur = yFirstCard - (cScreenCards - 1)*ySpacing;
    xCur = xFirstCard + (cScreenCards - 1)* (2 * CharFixWidth);
    idCard = (iFirstCard + cScreenCards-1) % cCards;
    lpTCards = lpCards + idCard;

    for (i = 0; i < cScreenCards; ++i)
        {
        SetRect((LPRECT)&rect, xCur, yCur, xCur+CardWidth, yCur+CardHeight);
        FrameRect(hDC, (LPRECT)&rect, hbrBlack);
        InflateRect((LPRECT)&rect, -1, -1);
        FillRect(hDC, (LPRECT)&rect, hbrWhite);
        SetBkMode(hDC, TRANSPARENT);
        TextOut(hDC, xCur+1, yCur+1+(ExtLeading / 2), lpTCards->line, lstrlen(lpTCards->line));
        xCur -= (2*CharFixWidth);
        yCur += ySpacing;
        lpTCards--;
        idCard--;
        if (idCard < 0)
            {
            idCard = cCards - 1;
            lpTCards = lpCards+idCard;
            }
        }
    SetRect((LPRECT)&rect, xFirstCard, yFirstCard+1+CharFixHeight, xFirstCard+CardWidth, yFirstCard+2+CharFixHeight);
    FillRect(hDC, (LPRECT)&rect, hbrLine);
    SetRect((LPRECT)&rect, xFirstCard, yFirstCard+3+CharFixHeight, xFirstCard+CardWidth, yFirstCard+4+CharFixHeight);
    FillRect(hDC, (LPRECT)&rect, hbrLine);
    GlobalUnlock(hCards);
    }

PhonePaint(hWindow, hDC, lpRectangle)
HWND hWindow;                /* a handle to a window data structure */
HDC  hDC;                    /* a handle to a GDI display context */
LPRECT lpRectangle;
    {
    RECT rect;
    LPCARDHEADER lpCards;
    int y;
    int i;
    int cScrCards;

    GetClientRect(hWindow, (LPRECT)&rect);
    cScrCards = (rect.bottom + CharFixHeight - 1) / CharFixHeight;

    lpCards = (LPCARDHEADER) GlobalLock(hCards);
    lpCards += iTopCard;

    SetTextColor(hDC, GetSysColor(COLOR_WINDOWTEXT));
    SetBkMode(hDC, TRANSPARENT);

    y = 0;

    for (i = 0; i < cScrCards; ++i)
        {
        if (i + iTopCard >= cCards)
            break;
        TextOut(hDC, CharFixWidth, y, lpCards->line, lstrlen(lpCards->line));
        y += CharFixHeight;
        lpCards++;
        }
    GlobalUnlock(hCards);
    if (GetFocus() == hIndexWnd)
        {
        y = (iFirstCard - iTopCard) * CharFixHeight;
        SetRect((LPRECT)&rect, 0, y, (LINELENGTH+2)*CharFixWidth, y+CharFixHeight);
        InvertRect(hDC, (LPRECT)&rect);
        }
    }

PaintNewHeaders()
    {
    HDC hDC;
    int idCard;
    LPCARDHEADER lpCards;
    LPCARDHEADER lpTCards;
    int xCur;
    int yCur;
    int i;
    RECT rect;
    int len;

    lpCards = (LPCARDHEADER) GlobalLock(hCards);

    yCur = yFirstCard - (cScreenHeads - 1)*ySpacing;
    xCur = xFirstCard + (cScreenHeads - 1)* (2 * CharFixWidth);
    idCard = (iFirstCard + cScreenHeads-1) % cCards;
    lpTCards = lpCards + idCard;

    if (!(hDC = GetDC(hIndexWnd)))
        goto PNH_END;
/* for all cards with headers showing */
    for (i = 0; i < cScreenHeads; ++i)
        {
        SetRect((LPRECT)&rect, xCur+1, yCur+1, xCur+CardWidth-1, yCur+CharFixHeight+1);
        FillRect(hDC, (LPRECT)&rect, hbrWhite);
        SetBkMode(hDC, TRANSPARENT);
        TextOut(hDC, xCur+1, yCur+1+(ExtLeading/2), lpTCards->line, lstrlen(lpTCards->line));

        xCur -= (2*CharFixWidth);
        yCur += ySpacing;
        lpTCards--;
        idCard--;
        if (idCard < 0)
            {
            idCard = cCards - 1;
            lpTCards = lpCards+idCard;
            }
        }
    ReleaseDC(hIndexWnd, hDC);
PNH_END:
    GlobalUnlock(hCards);
    }


IndexSize(hWindow, newWidth, newHeight)
HWND    hWindow;
int newWidth;
int newHeight;
    {
    int yCard;

    IndexWidth = newWidth;
    IndexHeight = newHeight;

    yFirstCard = (newHeight - BOTTOMMARGIN) - CardHeight;
    yFirstCard = (CharFixHeight / 2) > yFirstCard ? (CharFixHeight / 2) : yFirstCard;
    xFirstCard = LEFTMARGIN;

    yCard = yFirstCard + 1 + CharFixHeight + 1 + 2;

    if (hCardWnd)
        MoveWindow(hCardWnd, xFirstCard+1, yCard, (LINELENGTH*CharFixWidth)+1, CARDLINES*CharFixHeight, FALSE);
    }
