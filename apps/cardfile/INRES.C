#include "index.h"

/****************************************************************/
/*                                                              */
/*  Windows Cardfile - Written by Mark Cliggett                 */
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved    */
/*                                                              */
/****************************************************************/

int fNeedToUpdateBitmap = FALSE;
extern HANDLE hAccel;

int PASCAL WinMain(hInstance, hPrevInstance, lpszCommandLine, cmdShow)
HANDLE hInstance, hPrevInstance;
LPSTR lpszCommandLine;
int cmdShow;
    {
    MSG msg;
    HDC hDC;

    hIndexInstance = hInstance;

    if (!hPrevInstance)
        {
        if (!IndexInit())
            goto InitError;
        }
    else
        GetOldData(hPrevInstance);

    if (InitInstance(hInstance, lpszCommandLine, cmdShow))
        {
        while(TRUE)
            {
            if (IsWindow(hCardWnd) && !PeekMessage((LPMSG)&msg, hCardWnd, WM_KEYFIRST, WM_KEYLAST, FALSE))
                {
                if (fNeedToUpdateBitmap)
                    {
                    hDC = GetDC(hCardWnd);
                    CardPaint(hDC);
                    ReleaseDC(hCardWnd, hDC);
                    fNeedToUpdateBitmap = FALSE;
                    }
                }
            if (GetMessage((LPMSG)&msg, NULL, 0, 0))
                {
                if (TranslateAccelerator(hIndexWnd, hAccel, (LPMSG)&msg) == 0)
                    {
                    TranslateMessage((LPMSG)&msg);
                    DispatchMessage((LPMSG)&msg);
                    }
                }
            else
                break;
            }
        }
    else
        {
InitError:
        MessageBox(NULL, (LPSTR)NotEnoughMem, (LPSTR)NULL, MB_OK | MB_ICONEXCLAMATION);
        }
    return(0);
    }
