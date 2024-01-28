#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

FAR DoCutCopy(event)
int event;
    {
    HBITMAP hBitmap;
    RECT    rect;
    BITMAP  bmInfo;

    if (EditMode == I_TEXT)
	SendMessage(hCardWnd, event == CUT ? WM_CUT : WM_COPY, 0, 0L);
    else if (CurCard.hBitmap && OpenClipboard(hIndexWnd))
	{
	EmptyClipboard();
	hBitmap = CurCard.hBitmap;
	if (event == COPY)
	    {
	    GetObject(CurCard.hBitmap, sizeof(BITMAP), (LPSTR)&bmInfo);
	    if (!(CurCard.hBitmap = MakeBitmapCopy( CurCard.hBitmap, &bmInfo)))
		{
		CurCard.hBitmap = hBitmap;
		IndexOkError(EINSMEMORY);
		hBitmap = NULL;
		}
	    }
	else
	    {
	    SetRect((LPRECT)&rect, CurCard.xBitmap, CurCard.yBitmap, CurCard.cxBitmap+CurCard.xBitmap, CurCard.yBitmap+CurCard.cyBitmap);
	    InflateRect((LPRECT)&rect, 1, 1);
	    InvalidateRect(hCardWnd, (LPRECT)&rect, TRUE);
	    CurCard.hBitmap = 0;
	    CurCardHead.flags |= FDIRTY;
	    dragRect.bottom = dragRect.top + CharFixHeight;
	    dragRect.right = dragRect.left + CharFixWidth;
	    }
	if (hBitmap)
	    SetClipboardData(CF_BITMAP, hBitmap);
	CloseClipboard();
	}
    }

FAR DoPaste()
    {
    HBITMAP hBitmap;
    BITMAP bmInfo;
    RECT rect;

    if (EditMode == I_TEXT)
	{
	if (!SendMessage(hCardWnd, WM_PASTE, 0, 0L))
	    IndexOkError(ECLIPEMPTYTEXT);
	}
    else if (OpenClipboard(hIndexWnd))
	{
	if (hBitmap = (HBITMAP) GetClipboardData(CF_BITMAP))
	    {
	    GetObject(hBitmap, sizeof(BITMAP), (LPSTR)&bmInfo);
	    hBitmap = MakeBitmapCopy( hBitmap, &bmInfo);
	    if (!hBitmap)
		{
		IndexOkError(EINSMEMORY);
		}
	    else
		{
		if (CurCard.hBitmap)
		    {
		    SetRect((LPRECT)&rect, CurCard.xBitmap, CurCard.yBitmap, CurCard.cxBitmap+CurCard.xBitmap, CurCard.yBitmap+CurCard.cyBitmap);
		    InvalidateRect(hCardWnd, (LPRECT)&rect, TRUE);
		    DeleteObject(CurCard.hBitmap);
		    }
		CurCard.cxBitmap = bmInfo.bmWidth;
		CurCard.cyBitmap = bmInfo.bmHeight;
		CurCard.bmSize = bmInfo.bmHeight * bmInfo.bmWidthBytes;
		CurCard.xBitmap = dragRect.left;
		CurCard.yBitmap = dragRect.top;
		CurCard.hBitmap = hBitmap;
		SetFocus(NULL);
		SetFocus(hCardWnd);
		SetRect((LPRECT)&rect, CurCard.xBitmap, CurCard.yBitmap, CurCard.cxBitmap+CurCard.xBitmap, CurCard.yBitmap+CurCard.cyBitmap);
		InvalidateRect(hCardWnd, (LPRECT)&rect, TRUE);
		CurCardHead.flags |= FDIRTY;
		}
	    }
	else
	    IndexOkError(ECLIPEMPTYPICT);
	CloseClipboard();
	}
    }


MakeBitmapCopy( hbmSrc, pBitmap)
HBITMAP hbmSrc;
PBITMAP pBitmap;
    {
    HBITMAP hBitmap = NULL;
    HDC hDCSrc = NULL;
    HDC hDCDest = NULL;
    HDC hDC;

    hDC = GetDC(hIndexWnd);
    hDCSrc = CreateCompatibleDC( hDC ); /* get memory dc */
    hDCDest = CreateCompatibleDC( hDC );
    ReleaseDC(hIndexWnd, hDC);
    if (!hDCSrc || !hDCDest)
	goto MakeCopyEnd;

    /* select in passed bitmap */
    if (!SelectObject( hDCSrc, hbmSrc ))
	goto MakeCopyEnd;

    /* create new monochrome bitmap */

    if (!(hBitmap = CreateBitmap( pBitmap->bmWidth, pBitmap->bmHeight, 1, 1, (LPSTR) NULL )))
	goto MakeCopyEnd;

    /* Now blt the bitmap contents.  The screen driver in the source will
       "do the right thing" in copying color to black-and-white. */

    if (!SelectObject(hDCDest, hBitmap) ||
	!BitBlt( hDCDest, 0, 0, pBitmap->bmWidth, pBitmap->bmHeight, hDCSrc, 0, 0, SRCCOPY ))
	{
	DeleteObject(hBitmap);
	hBitmap = NULL;
	}

MakeCopyEnd:
    if (hDCSrc)
	DeleteObject(hDCSrc);
    if (hDCDest)
	DeleteObject(hDCDest);
    return (hBitmap);
    }
