#include "index.h"

/****************************************************************/
/*                                                              */
/*  Windows Cardfile - Written by Mark Cliggett                 */
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved    */
/*                                                              */
/****************************************************************/

int fCardCleared = FALSE;
int iCardStartScroll;
int fScrolling = FALSE;

IndexScroll(hWindow, cmd, pos)
HWND hWindow;
int cmd;
int pos;
    {
    int OldFirst = iFirstCard;
    int NewFirst;
    HDC hDC;
    RECT rect;
    int result = TRUE;

    if (cCards < 2)
        return(result);
    if (!fScrolling)
        iCardStartScroll = iFirstCard;
    fScrolling = TRUE;
    switch (cmd)
        {
/* these always change the card (unless only one card) */
        case SB_LINEUP:
            iFirstCard--;
            if (iFirstCard < 0)
                iFirstCard = cCards-1;
            break;
        case SB_LINEDOWN:
            iFirstCard++;
            if (iFirstCard == cCards)
                iFirstCard = 0;
            break;
        case SB_PAGEUP:
            if (cFSHeads == cCards)
                return(result);
            iFirstCard -= cFSHeads;
            if (iFirstCard < 0)
                iFirstCard += cCards; /* a negative number */
            break;
        case SB_PAGEDOWN:
            if (cFSHeads == cCards)
                return(result);
            iFirstCard += cFSHeads;
            if (iFirstCard >= cCards)
                iFirstCard -= cCards;
            break;
/* these may change or not change */
        case SB_THUMBPOSITION:
        case SB_ENDSCROLL:
            if (iFirstCard != iCardStartScroll)
                {
                if (SaveCurrentCard(iCardStartScroll))
                    SetCurCard(iFirstCard);
                else
                    {
                    iFirstCard = iCardStartScroll;
                    result = FALSE;
                    }
                }
            SetScrollPos(hWindow, SB_HORZ, iFirstCard, TRUE);
            InvalidateRect(hCardWnd, (LPRECT)NULL, TRUE);
            fCardCleared = FALSE;
            fScrolling = FALSE;
            return(result);
        case SB_THUMBTRACK:
            iFirstCard = pos;
            break;
        default:
            return(result);
        }
    if (iFirstCard != OldFirst)
        {
        if (!fCardCleared)
            {
            hDC = GetDC(hCardWnd);
            GetClientRect(hCardWnd, (LPRECT)&rect);
            FillRect(hDC, (LPRECT)&rect, hbrWhite);
            ReleaseDC(hCardWnd, hDC);
            fCardCleared = TRUE;
            }
        if (cmd != SB_THUMBTRACK)
            SetScrollPos(hWindow, SB_HORZ, iFirstCard, TRUE);
        PaintNewHeaders();
        }
    return(result);
    }

PhoneScroll(hWindow, cmd, pos)
HWND hWindow;
int cmd;
int pos;
    {
    int OldTop = iTopCard;
    HDC hDC;
    RECT rect;
    int cLines;
    int dCards;

    GetClientRect(hWindow, (LPRECT)&rect);
    cLines = rect.bottom / CharFixHeight;

    dCards = 0;
    switch (cmd)
        {
        case SB_LINEUP:
            dCards = -1;
            break;
        case SB_LINEDOWN:
            dCards = 1;
            break;
        case SB_PAGEUP:
            dCards = -cLines;
            break;
        case SB_PAGEDOWN:
            dCards = cLines;
            break;
        case SB_THUMBTRACK:
            dCards = pos - iTopCard;
            break;
        case SB_THUMBPOSITION:
            SetScrollPos(hWindow, SB_VERT, pos, TRUE);
            return;
        }
    iTopCard += dCards;
    if (iTopCard > cCards - cLines)
        iTopCard = cCards - cLines;
    else if (iTopCard < 0)
        iTopCard = 0;

    dCards = OldTop - iTopCard;

    if (dCards)
        {
        if (cmd != SB_THUMBTRACK)
            SetScrollPos(hWindow, SB_VERT, iTopCard, TRUE);
        ScrollWindow(hWindow, 0, dCards * CharFixHeight, (LPRECT)NULL, (LPRECT)NULL);
        UpdateWindow(hWindow);
        }
    }

SetScrRangeAndPos()
    {
    int range;
    RECT rect;
    int cLines;

    if (CardPhone == PHONEBOOK)
        {
        GetClientRect(hIndexWnd, (LPRECT)&rect);
        if ((cLines = rect.bottom / CharFixHeight) >= cCards)
            range = 0;
        else
            {
            if (!cLines)
                cLines = 1;
            range = cCards - cLines;
            }
        }
    else
        range = cCards-1;
    SetScrollRange(hIndexWnd, CardPhone == PHONEBOOK ? SB_VERT : SB_HORZ, 0, range, FALSE);
    SetScrollPos(hIndexWnd, CardPhone == PHONEBOOK ? SB_VERT : SB_HORZ, CardPhone == PHONEBOOK ? iTopCard : iFirstCard, TRUE);
    }
