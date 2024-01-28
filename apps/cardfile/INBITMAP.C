#include "index.h"

/****************************************************************/
/*                                                              */
/*  Windows Cardfile - Written by Mark Cliggett                 */
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved    */
/*                                                              */
/****************************************************************/

POINT   dragPt;
int     fBMDown;
int     xmax;
int     ymax;

FAR BMMouse(hWindow, message, wParam, pt)
HWND hWindow;
int message;
WORD wParam;
POINT pt;
    {
    RECT rect;
    int iCard;
    HDC hDC;
    int t;

    switch(message)
        {
        case WM_LBUTTONDOWN:
            if (PtInRect((LPRECT)&dragRect, pt))
                {
                SetCapture(hWindow);
                GetClientRect(hWindow, (LPRECT)&rect);
                xmax = rect.right - CharFixWidth;
                ymax = rect.bottom - CharFixHeight;
                fBMDown = TRUE;
                dragPt = pt;
                }
            break;
        case WM_LBUTTONUP:
            if (fBMDown)
                {
                ReleaseCapture();
                if (dragRect.top != CurCard.yBitmap || dragRect.left != CurCard.xBitmap)
                    {
                    SetRect((LPRECT)&rect, CurCard.xBitmap, CurCard.yBitmap, CurCard.xBitmap+CurCard.cxBitmap, CurCard.yBitmap+CurCard.cyBitmap);
                    CurCard.xBitmap = dragRect.left;
                    CurCard.yBitmap = dragRect.top;
                    InvalidateRect(hCardWnd, (LPRECT)&rect, TRUE);
                    InvalidateRect(hCardWnd, (LPRECT)&dragRect, TRUE);
                    if (CurCard.hBitmap)
                        CurCardHead.flags |= FDIRTY;
                    }
                dragPt.x = CurCard.xBitmap;
                dragPt.y = CurCard.yBitmap;
                fBMDown = FALSE;
                }
            break;
        case WM_MOUSEMOVE:
            if (fBMDown)
                {
                t = dragRect.left + pt.x - dragPt.x;
                if (t > xmax)
                    pt.x = xmax - dragRect.left + dragPt.x;
                else if (t < CharFixWidth - (dragRect.right - dragRect.left))
                    pt.x = CharFixWidth - (dragRect.right - dragRect.left) - dragRect.left + dragPt.x;

                t = dragRect.top + pt.y - dragPt.y;
                if (t > ymax)
                    pt.y = ymax - dragRect.top + dragPt.y;
                else if (t < CharFixHeight - (dragRect.bottom - dragRect.top))
                    pt.y = CharFixHeight - (dragRect.bottom - dragRect.top) - dragRect.top + dragPt.y;

                if (dragPt.x != pt.x || dragPt.y != pt.y)
                    {
                    hDC = GetDC(hCardWnd);
                    DrawXorRect(hDC, &dragRect);
                    OffsetRect((LPRECT)&dragRect, pt.x - dragPt.x, pt.y - dragPt.y);
                    dragPt = pt;
                    DrawXorRect(hDC, &dragRect);
                    ReleaseDC(hCardWnd, hDC);
                    }
                }
            break;
        }
    }

FAR TurnOnBitmapRect()
    {
    if (CurCard.hBitmap)
        SetRect((LPRECT)&dragRect, CurCard.xBitmap, CurCard.yBitmap, CurCard.xBitmap+CurCard.cxBitmap, CurCard.yBitmap+CurCard.cyBitmap);
    else
        SetRect((LPRECT)&dragRect, 5, 5, 5+CharFixWidth, 5+CharFixHeight);
    XorBitmapRect();
    }

FAR TurnOffBitmapRect()
    {
    XorBitmapRect();
    }

XorBitmapRect()
    {
    HDC hDC;

    hDC = GetDC(hCardWnd);
    DrawXorRect(hDC, &dragRect);
    ReleaseDC(hCardWnd, hDC);
    }

FAR DrawXorRect(hDC, pRect)
HDC hDC;
RECT *pRect;
    {
    int     x,y;
    POINT   point;

    SelectObject(hDC, hbrWhite);

    x = pRect->right  - (point.x = pRect->left);
    y = pRect->bottom - (point.y = pRect->top);

    PatBlt(hDC, point.x, point.y, x, 1, PATINVERT);
    point.y = pRect->bottom - 1;
    PatBlt(hDC, point.x, point.y, x, 1, PATINVERT);
    point.y = pRect->top;
    PatBlt(hDC, point.x, point.y, 1, y, PATINVERT);
    point.x = pRect->right - 1;
    PatBlt(hDC, point.x, point.y, 1, y, PATINVERT);
    }

FAR BMKey(wParam)
WORD wParam;
    {
    int x;
    int y;

    x = dragRect.left;
    y = dragRect.top;

    switch(wParam)
        {
        case VK_UP:
            y -= CharFixHeight;
            break;
        case VK_DOWN:
            y += CharFixHeight;
            break;
        case VK_LEFT:
            x -= CharFixWidth;
            break;
        case VK_RIGHT:
            x += CharFixWidth;
            break;
        default:
            return(FALSE);
        }

    if (x > (LINELENGTH-1) * CharFixWidth)
        x = (LINELENGTH-1) * CharFixWidth;
    else if (x < CharFixWidth - (dragRect.right - dragRect.left))
        x = CharFixWidth - (dragRect.right - dragRect.left);

    if (y > 10 * CharFixHeight)
        y = 10 * CharFixHeight;
    else if (y < CharFixHeight - (dragRect.bottom - dragRect.top))
        y = CharFixHeight - (dragRect.bottom - dragRect.top);

    if (x != dragRect.left || y != dragRect.top)
        {
        InvalidateRect(hCardWnd, (LPRECT)&dragRect, TRUE);
        CurCard.xBitmap = x;
        CurCard.yBitmap = y;
        OffsetRect((LPRECT)&dragRect, x-dragRect.left, y-dragRect.top);
        InvalidateRect(hCardWnd, (LPRECT)&dragRect, TRUE);
        }
    CurCardHead.flags |= FDIRTY;
    return(TRUE);
    }
