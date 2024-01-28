#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

HWND hAbortDlgWnd;
int fAbort;
int fError;
int CharPrintWidth;
int CharPrintHeight;
int CardPrintWidth;
int CardPrintHeight;
int ExtPrintLeading;

HDC SetupPrinting()
    {
    char buf[40];
    char *pch;
    char *pchFile;
    char *pchPort;
    char fileandport[128];
    HDC hPrintDC;
    TEXTMETRIC Metrics;

    GetProfileString((LPSTR)rgchWindows, (LPSTR)rgchDevice, (LPSTR)"", (LPSTR)fileandport, 40);
    for (pch = fileandport; *pch && *pch != ','; ++pch)
	;
    if (*pch)
	*pch++=0;
    while(*pch && *pch <= ' ')
	pch++;
    pchFile = pch;
    while(*pch && *pch != ',' && *pch > ' ')
	pch++;
    if (*pch)
	*pch++ = 0;
    while (*pch && (*pch <= ' ' || *pch == ','))
	pch++;
    pchPort = pch;
    while (*pch && *pch > ' ')
	pch++;
    *pch = 0;

    if (!(hPrintDC = CreateDC((LPSTR)pchFile, (LPSTR)fileandport, (LPSTR)pchPort, (LPSTR)NULL)))
	{
CantPrint:
	if (hPrintDC)
	    DeleteDC(hPrintDC);
	IndexOkError(ECANTPRINT);
	return(NULL);
	}
    GetTextMetrics(hPrintDC, (LPTEXTMETRIC)&Metrics);
    CharPrintHeight = Metrics.tmHeight+Metrics.tmExternalLeading;
    ExtPrintLeading = Metrics.tmExternalLeading;
    CharPrintWidth = Metrics.tmAveCharWidth;	      /* the average width */

    Escape(hPrintDC, SETABORTPROC, 0, lpfnAbortProc, (LPSTR)0);
    BuildCaption(buf);
    if (Escape(hPrintDC, STARTDOC, lstrlen((LPSTR)buf), (LPSTR)buf, (LPSTR)0) < 0)
	goto CantPrint;

    fError = FALSE;
    fAbort = FALSE;
    hAbortDlgWnd = CreateDialog(hIndexInstance,
				(LPSTR)DTABORTDLG,
				hIndexWnd,
				lpfnAbortDlgProc);
    if (!hAbortDlgWnd)
	goto CantPrint;

    EnableWindow(hIndexWnd, FALSE);
#ifdef NEVER
    SendMessage(hCardWnd, WM_SETREDRAW, FALSE, 0L);
#endif
    return(hPrintDC);
    }

FinishPrinting(hPrintDC)
HDC hPrintDC;
    {
    if (!fAbort)
	{
	if (!fError)
	    Escape(hPrintDC, ENDDOC, 0, (LPSTR)0, (LPSTR)0);
	EnableWindow(hIndexWnd, TRUE);
	DestroyWindow(hAbortDlgWnd);
	}
    DeleteDC(hPrintDC);
#ifdef NEVER
    SendMessage(hCardWnd, WM_SETREDRAW, TRUE, 0L);
#endif
    }

FAR PrintList()
    {
    HDC hPrintDC;
    int xPrintRes;
    int yPrintRes;
    int curcard;
    int i;
    int y;
    int cCardsPerPage;
    LPCARDHEADER lpCards;
    int iError;

    if (!(hPrintDC = SetupPrinting()))
	return;

    xPrintRes = GetDeviceCaps(hPrintDC, HORZRES);
    yPrintRes = GetDeviceCaps(hPrintDC, VERTRES);

    cCardsPerPage = yPrintRes / CharPrintHeight;
    if (!cCardsPerPage)
	cCardsPerPage++;
    lpCards = (LPCARDHEADER)GlobalLock(hCards);
    for (curcard = 0; curcard < cCards; )
	{
	y = 0;
	for (i = 0; i < cCardsPerPage && curcard < cCards; ++i)
	    {
	    TextOut(hPrintDC, CharPrintWidth, y, lpCards->line, lstrlen(lpCards->line));
	    y += CharPrintHeight;
	    lpCards++;
	    curcard++;
	    }
	if ((iError = Escape(hPrintDC, NEWFRAME, 0, (LPSTR)NULL, (LPSTR)0)) < 0)
	    {
	    PrintError(iError);
	    break;
	    }
	if (fAbort)
	    break;
	}
    GlobalUnlock(hCards);
    FinishPrinting(hPrintDC);
    }

FAR PrintCards(count)
int count;
    {
    HDC hPrintDC;
    char printer[40];
    char fileandport[40];
    char *pch;
    char ch;
    int xPrintRes;
    int yPrintRes;
    int curcard;
    int i;
    int y;
    int cCardsPerPage;
    char *pchFile;
    char *pchPort;
    HANDLE hText;
    LPSTR lpText;
    CARDHEADER CardHead;
    LPCARDHEADER lpCards;
    CARD Card;
    HDC hMemoryDC;
    HWND hPrintWnd;
    HANDLE hOldObject;
    int fPictureWarning;
    int iError;

    hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
    if (!hText)
	{
InsMemPrint:
	IndexOkError(EINSMEMORY);
	return;
	}

    hPrintWnd = CreateWindow(
		(LPSTR)"Edit",
		(LPSTR)"",
		WS_CHILD | ES_MULTILINE,
		0, 0, (LINELENGTH*CharFixWidth)+1, CARDLINES*CharFixHeight,
		hIndexWnd,
		NULL,
		hIndexInstance,
		(LPSTR)NULL);

    if (!hPrintWnd)
	{
	GlobalFree(hText);
	goto InsMemPrint;
	}

    if (!(hPrintDC = SetupPrinting()))
	{
	GlobalFree(hText);
	return;
	}

    lpText = GlobalLock(hText);

    CardPrintWidth = (LINELENGTH * CharPrintWidth) + 2;
    CardPrintHeight = (CARDLINES*CharPrintHeight) + CharPrintHeight + 1 + 2 + 2;

    hOldObject = SelectObject(hPrintDC, GetStockObject(HOLLOW_BRUSH));

    hMemoryDC = CreateCompatibleDC(hPrintDC);
    fPictureWarning = FALSE;

    if (count == 1)
	{
	if (!hMemoryDC && CurCard.hBitmap)
	    IndexOkError(ENOPICTURES);
	PrintCurCard(hPrintDC, hMemoryDC, 0, &CurCardHead, &CurCard, hCardWnd);
	if ((iError = Escape(hPrintDC, NEWFRAME, 0, (LPSTR)NULL, (LPSTR)0)) < 0)
	    PrintError(iError);
	}
    else
	{
	xPrintRes = GetDeviceCaps(hPrintDC, HORZRES);
	yPrintRes = GetDeviceCaps(hPrintDC, VERTRES);

	cCardsPerPage = yPrintRes / (CardPrintHeight + CharPrintHeight);
	if (!cCardsPerPage)
	    cCardsPerPage++;
	for (curcard = 0; curcard < count; )
	    {
	    y = 0;
	    for (i = 0; i < cCardsPerPage && curcard < count; ++i)
		{
		if (curcard != iFirstCard)
		    {
		    lpCards = (LPCARDHEADER) GlobalLock(hCards);
		    lpCards += curcard;
		    CardHead = *lpCards;
		    GlobalUnlock(hCards);
		    if (!ReadCurCardData(&CardHead, &Card, lpText))
			IndexOkError(ECANTPRINTPICT);
		    }
		else
		    {
		    CardHead = CurCardHead;
		    Card = CurCard;
		    GetWindowText(hCardWnd, lpText, CARDTEXTSIZE);
		    }
		SetWindowText(hPrintWnd, lpText);
		if (!hMemoryDC && Card.hBitmap && !fPictureWarning)
		    {
		    fPictureWarning++;
		    IndexOkError(ENOPICTURES);
		    }
		PrintCurCard(hPrintDC, hMemoryDC, y, &CardHead, &Card, hPrintWnd);
		if (curcard != iFirstCard && Card.hBitmap)
		    DeleteObject(Card.hBitmap);
		y += CardPrintHeight + CharPrintHeight;
		curcard++;
		}
	    if ((iError = Escape(hPrintDC, NEWFRAME, 0, (LPSTR)NULL, (LPSTR)0)) < 0)
		{
		PrintError(iError);
		break;
		}
	    if (fAbort)
		break;
	    }
	}
PrintCardsDone:
    DestroyWindow(hPrintWnd);
    GlobalUnlock(hText);
    GlobalFree(hText);
    SelectObject(hPrintDC, hOldObject);
    FinishPrinting(hPrintDC);
    if (hMemoryDC)
	DeleteDC(hMemoryDC);
    }


PrintCurCard(hPrintDC, hMemoryDC, line, pCardHead, pCard, hWnd)
HDC hPrintDC;
HDC hMemoryDC;
int line;
PCARDHEADER pCardHead;
PCARD	pCard;
HWND	hWnd;
    {
    int y;
    HANDLE hOldObject;
    RECT rect;
    int level;
    int xratio;
    int yratio;
    int i;
    int cLines;
    char buf[LINELENGTH];
    int cch;

    SetBkMode(hPrintDC, TRANSPARENT);
    TextOut(hPrintDC, 1, line + 1+(ExtPrintLeading / 2), (LPSTR)pCardHead->line, lstrlen((LPSTR)pCardHead->line));

    if (pCard->hBitmap && hMemoryDC)
	{
	level = SaveDC(hPrintDC);
	IntersectClipRect(hPrintDC, 1, line+CharPrintHeight+4, CardPrintWidth-1, line+CardPrintHeight-1);
	hOldObject = SelectObject(hMemoryDC, pCard->hBitmap);
	if (!StretchBlt(hPrintDC,
			(pCard->xBitmap*CharPrintWidth)/CharFixWidth,
			line+CharPrintHeight+4+(pCard->yBitmap*CharPrintHeight)/CharFixHeight,
			(pCard->cxBitmap * CharPrintWidth)/ CharFixWidth,
			(pCard->cyBitmap * CharPrintHeight)/ CharFixHeight,
			hMemoryDC,
			0,
			0,
			pCard->cxBitmap,
			pCard->cyBitmap,
			SRCCOPY))
	    IndexOkError(ECANTPRINTPICT);
	SelectObject(hMemoryDC, hOldObject);
	RestoreDC(hPrintDC, level);
	}

    /* draw the text */
    y = line+CharPrintHeight + 4 + (ExtPrintLeading / 2);
    cLines = SendMessage(hWnd, EM_GETLINECOUNT, 0, 0L);
    for (i = 0; i < cLines; ++i)
	{
	buf[0] = LINELENGTH;
	buf[1] = 0;
	cch = SendMessage(hWnd, EM_GETLINE, i, (LPSTR)buf);
	TextOut(hPrintDC, 1, y, (LPSTR)buf, cch);
	y += CharPrintHeight;
	}
    Rectangle(hPrintDC, 0, line, CardPrintWidth, line+CardPrintHeight);
    Rectangle(hPrintDC, 0, line+1+CharPrintHeight, CardPrintWidth, line+2+CharPrintHeight);
    Rectangle(hPrintDC, 0, line+3+CharPrintHeight, CardPrintWidth, line+4+CharPrintHeight);
    }

int FAR PASCAL fnAbortProc(hPrintDC, iReserved)
HDC hPrintDC;	    /* what is this useless parameter? */
int iReserved;	    /* and this one? */
    {
    MSG msg;

    while (!fAbort && PeekMessage((LPMSG)&msg, NULL, NULL, NULL, TRUE))
	if (!hAbortDlgWnd || !IsDialogMessage(hAbortDlgWnd, (LPMSG)&msg))
	    {
	    TranslateMessage((LPMSG)&msg);
	    DispatchMessage((LPMSG)&msg);
	    }
    return(!fAbort);
    }

HANDLE hSysMenu;

int FAR PASCAL fnAbortDlgProc(hwnd, msg, wParam, lParam)
HWND hwnd;
unsigned msg;
WORD wParam;
LONG lParam;
    {
    HMENU hMenu;
    PSTR pchTmp;

    switch(msg)
	{
	case WM_COMMAND:
	    fAbort = TRUE;
	    EnableWindow(hIndexWnd, TRUE);
	    DestroyWindow(hwnd);
	    hAbortDlgWnd = NULL;
	    return(TRUE);
	case WM_INITDIALOG:
	    hSysMenu = GetSystemMenu(hwnd, FALSE);
	    if (CurIFile[0])
		{
		for (pchTmp = CurIFile + lstrlen((LPSTR)CurIFile) - 1;
		    pchTmp >= CurIFile && *pchTmp != '\\' && *pchTmp != ':';
		    pchTmp--)
		    ;
		pchTmp++;
		SetDlgItemText(hwnd, 4, (LPSTR)pchTmp);
		}
	    else
		SetDlgItemText(hwnd, 4, (LPSTR)rgchUntitled);
	    SetFocus(hwnd);
	    return(TRUE);
	case WM_INITMENU:
	    EnableMenuItem(hSysMenu, SC_CLOSE, MF_GRAYED);
	    return(TRUE);
	}
    return(FALSE);
    }

PrintError(iError)
int iError;
    {
    fError = TRUE;
    if (iError & SP_NOTREPORTED)
	{
	switch(iError)
	    {
	    case -5:
		IndexOkError(EMEMPRINT);
		break;
	    case -4:
		IndexOkError(EDISKPRINT);
		break;
	    case -3:
	    case -2:
		break;
	    default:
		IndexOkError(ECANTPRINT);
		break;
	    }
	}
    }
