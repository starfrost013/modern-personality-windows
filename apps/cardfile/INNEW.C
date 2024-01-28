#define NOCOMM
#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

char rgchCardfile[] = "Cardfile";
char rgchWindows[] = "Windows";
char rgchDevice[] = "Device";

long far PASCAL IndexWndProc();
HANDLE hAccel;
HBRUSH hbrBack;
int fColor = FALSE;

FAR  GetOldData(hInstance)
HANDLE hInstance;
    {
    GetInstanceData(hInstance, (PSTR)&hbrWhite, 2);
    GetInstanceData(hInstance, (PSTR)&hbrBlack, 2);
    GetInstanceData(hInstance, (PSTR)&hbrGray, 2);
    GetInstanceData(hInstance, (PSTR)&hbrRed, 2);
    GetInstanceData(hInstance, (PSTR)&hbrLine, 2);
    GetInstanceData(hInstance, (PSTR)&hbrBlue, 2);
    GetInstanceData(hInstance, (PSTR)&hbrBack, 2);
    GetInstanceData(hInstance, (PSTR)&CharFixHeight, 2);
    GetInstanceData(hInstance, (PSTR)&CharFixWidth, 2);
    GetInstanceData(hInstance, (PSTR)&ySpacing, 2);
    GetInstanceData(hInstance, (PSTR)&CardWidth, 2);
    GetInstanceData(hInstance, (PSTR)&CardHeight, 2);
    GetInstanceData(hInstance, (PSTR)&hArrowCurs, 2);
    GetInstanceData(hInstance, (PSTR)&hWaitCurs, 2);
    GetInstanceData(hInstance, (PSTR)&hAccel, 2);
    GetInstanceData(hInstance, (PSTR)&fColor, 2);
    }

FAR InitInstance(hInstance, lpszCommandLine, cmdShow)
HANDLE hInstance;
LPSTR lpszCommandLine;
int cmdShow;
    {
    int i;
    LPCARDHEADER lpCards;
    HWND hwnd = NULL;
    LPSTR lpchTmp;
    PSTR pchTmp;
    int far PASCAL DlgProc();
    int far PASCAL fnOpen();
    int far PASCAL fnDial();
    int far PASCAL fnSave();
    int far PASCAL fnAbout();
    int far PASCAL fnAbortProc();
    int far PASCAL fnAbortDlgProc();
    int far PASCAL CardWndProc();
    FARPROC lpCardWndProc;
    OFSTRUCT ofStruct;

    LoadString(hInstance, EINSMEMORY, (LPSTR)NotEnoughMem, 50);
    LoadString(hInstance, IUNTITLED, (LPSTR)rgchUntitled, 30);
    LoadString(hInstance, ICARDDATA, (LPSTR)rgchCardData, 40);
    LoadString(hInstance, IWARNING, (LPSTR)rgchWarning, 30);
    LoadString(hInstance, INOTE, (LPSTR)rgchNote, 30);
    if (!LoadString(hInstance, EINSMEMORY, (LPSTR)NotEnoughMem, 50))
	goto InitError;

    lpDlgProc = MakeProcInstance( DlgProc, hInstance );
    lpfnOpen = MakeProcInstance( fnOpen, hInstance );
    lpfnSave = MakeProcInstance( fnSave, hInstance );
    lpfnDial = MakeProcInstance( fnDial, hInstance );
    lpfnAbout = MakeProcInstance( fnAbout, hInstance );
    lpCardWndProc = MakeProcInstance( CardWndProc, hInstance);
    lpfnAbortProc = MakeProcInstance( fnAbortProc, hInstance);
    lpfnAbortDlgProc = MakeProcInstance( fnAbortDlgProc, hInstance);
    /* unlikely that last one will work but others won't */
    if (!lpfnAbortDlgProc)
	goto InitError;

    hCards = GlobalAlloc(GHND, (long)sizeof(CARDHEADER)); /* alloc first card */
    if (!hCards)
	goto InitError;
    iTopScreenCard = 0;

    /* make a single blank card */
    CurIFile[0] = 0;	    /* file is untitled */
    cCards = 1;
    CurCardHead.line[0] = 0;
    CurCard.hBitmap = 0;
    CurCardHead.flags = FNEW;
    lpCards = (LPCARDHEADER)GlobalLock(hCards);
    *lpCards = CurCardHead;
    GlobalUnlock(hCards);

    hwnd = CreateWindow(
	      (LPSTR) rgchCardfile,
	      (LPSTR) "",
	      WS_TILEDWINDOW | WS_HSCROLL | WS_VSCROLL,
	      0, 0, 0, 100,
	      NULL, NULL,
	      hInstance,
	      (LPSTR)NULL);

    if (!hwnd)
	goto InitError;

    hCardWnd = CreateWindow(
		(LPSTR)"Edit",
		(LPSTR)"",
		WS_CHILD | WS_VISIBLE | ES_MULTILINE,
		0, 0, 0, 0,
		hwnd,
		EDITWINDOW,
		hInstance,
		(LPSTR)NULL);

    if (!hCardWnd)
	{
InitError:
	MessageBox(hwnd, (LPSTR)NotEnoughMem, (LPSTR)NULL, MB_OK | MB_ICONEXCLAMATION);
	return(0);
	}

    SendMessage(hCardWnd, EM_LIMITTEXT, CARDTEXTSIZE, 0L);

    lpEditWndProc = (FARPROC)GetWindowLong(hCardWnd, GWL_WNDPROC);
    SetWindowLong(hCardWnd, GWL_WNDPROC, (LONG)lpCardWndProc);

    ShowWindow(hwnd, cmdShow);

    MakeTmpFile(hInstance);

    for (lpchTmp = lpszCommandLine; *lpchTmp == ' '; lpchTmp++)
	;
    for (pchTmp = CurIFile, i = 0; i < PATHMAX-1 && *lpchTmp > ' '; ++i)
	*pchTmp++ = *lpchTmp++;
    *pchTmp = 0;
    AnsiUpper((LPSTR)CurIFile);

    if (*CurIFile)
	if (!DoOpen(CurIFile))
	    CurIFile[0] = 0;
    return(TRUE);
    }

FAR IndexInit()
    {
    PWNDCLASS	pIndexClass;
    HANDLE	hIndexIcon;
    TEXTMETRIC	Metrics;    /* structure filled with font info */
    extern int ySpacing;
    HDC hMemoryDC;
    LOGBRUSH logBrush;
    HDC hIC;

    /* initialize the brushes */

    hbrWhite	= GetStockObject(WHITE_BRUSH);
    hbrBlack	= GetStockObject(BLACK_BRUSH);
    hbrGray	= GetStockObject(GRAY_BRUSH);
    GetObject(hbrGray, sizeof(LOGBRUSH), (LPSTR)&logBrush);
    if (!(hbrGray = CreateBrushIndirect((LPLOGBRUSH)&logBrush)))
	hbrGray = hbrWhite;

    if (!(hbrBlue = (HBRUSH) CreateSolidBrush((unsigned long int) 0xff0000)))
	hbrBlue = hbrWhite;
    if (!(hbrRed = (HBRUSH) CreateSolidBrush((unsigned long int) 0x0000ff)))
	hbrRed = hbrBlack;

/* get a memory dc for cheap dc stuff */
    hIC = CreateIC((LPSTR)"DISPLAY", (LPSTR)NULL, (LPSTR)NULL, (LPSTR)NULL);
    if (!hIC)
	return(FALSE);

    if((GetDeviceCaps(hIC,BITSPIXEL)+GetDeviceCaps(hIC,PLANES)) < 3)
	{
	hbrBack = hbrGray;
	hbrLine = hbrBlack;
	}
    else
	{
	fColor = TRUE;
	hbrBack = hbrBlue;
	hbrLine = hbrRed;
	}

    /* Setup the fonts */

    GetTextMetrics(hIC, (LPTEXTMETRIC)(&Metrics));  /* find out what kind of font it really is */
    DeleteDC(hIC);
    CharFixHeight = Metrics.tmHeight+Metrics.tmExternalLeading; 	      /* the height */
    ExtLeading = Metrics.tmExternalLeading;
    CharFixWidth = Metrics.tmAveCharWidth;	    /* the average width */
    ySpacing = CharFixHeight+1;

    CardWidth = (LINELENGTH * CharFixWidth) + 3;
    CardHeight = (CARDLINES*CharFixHeight) + CharFixHeight + 1 + 2 + 2;

    /* get the resource file info, such as icons, and IT tables */
    hArrowCurs	= LoadCursor(NULL, IDC_ARROW);
    hWaitCurs	= LoadCursor(NULL, IDC_WAIT);
    hIndexIcon	  = LoadIcon(hIndexInstance,(LPSTR)INDEXICON);
    hAccel = LoadAccelerators(hIndexInstance, (LPSTR)MAINACC);
    if (!hArrowCurs || !hWaitCurs || !hIndexIcon || !hAccel)
	return(FALSE);

    pIndexClass = (PWNDCLASS) LocalAlloc(LPTR, sizeof(WNDCLASS));
    if (!pIndexClass)
	return(FALSE);
    pIndexClass->lpszClassName = (LPSTR)rgchCardfile;
    pIndexClass->hCursor       = hArrowCurs;	/* normal cursor is arrow */
    pIndexClass->hIcon	       = hIndexIcon;
    pIndexClass->hbrBackground = NULL;
    pIndexClass->style	       = CS_VREDRAW | CS_DBLCLKS;
    pIndexClass->lpfnWndProc   = IndexWndProc;
    pIndexClass->hInstance     = hIndexInstance;
    pIndexClass->lpszMenuName  = (LPSTR)MTINDEX;
    if (!RegisterClass((LPWNDCLASS) pIndexClass))
	return FALSE;
    LocalFree((HANDLE)pIndexClass);

    return TRUE;
    }
