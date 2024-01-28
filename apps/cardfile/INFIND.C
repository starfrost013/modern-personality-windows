#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

FAR DoGoto(pchBuf)
PSTR pchBuf;
    {
    int i;
    int j;
    LPCARDHEADER lpCards;
    LPCARDHEADER lpCardsTmp;
    LPSTR lpchTmp;
    LPSTR lpchTmp2;
    PSTR pchTmp;
    char buf[128];
    int iNextFirst;

    lpCards = (LPCARDHEADER) GlobalLock(hCards);
    lpCardsTmp = lpCards+iFirstCard+1;
    for (i = 1; i <= cCards; ++i)
	{
	if (i + iFirstCard == cCards)
	    lpCardsTmp = lpCards;
	lpchTmp = lpCardsTmp->line;
	for (j = 0; j < LINELENGTH && *lpchTmp; ++j)
	    {
	    lpchTmp2 = lpchTmp;
	    pchTmp = pchBuf;
	    for ( ; *pchTmp && *lpchTmp2; ++pchTmp, ++lpchTmp2)
		if (AnsiUpper((LPSTR)(DWORD)(BYTE)*pchTmp) != AnsiUpper((LPSTR)(DWORD)(BYTE)*lpchTmp2))
		    break;
	    if (!*pchTmp)
		goto DoneSearching;
	    lpchTmp++;
	    }
	lpCardsTmp++;
	}
DoneSearching:
    GlobalUnlock(hCards);
    if (i <= cCards)	 /* found it */
	{
	iNextFirst = iFirstCard + i;
	if (iNextFirst >= cCards)
	    iNextFirst -= cCards;
	GetNewCard(iFirstCard, iNextFirst);
	}
    else
	{
	LoadString(hIndexInstance, ECANTFIND, (LPSTR)buf, 128);
	lstrcat((LPSTR)buf, (LPSTR)"\"");
	lstrcat((LPSTR)buf, (LPSTR)pchBuf);
	lstrcat((LPSTR)buf, (LPSTR)"\"");
	MessageBox(hIndexWnd, (LPSTR)buf, (LPSTR)rgchNote, MB_OK | MB_ICONEXCLAMATION);
	}
    }

FAR FindStrCard()
    {
    int i;
    int fFound;
    LPSTR lpch1;
    char *pch2;
    LPSTR lpch3;
    LPSTR lpText;
    int iCard;
    char buf[128];
    HANDLE hText;
    int ichStart;
    CARDHEADER CardHead;
    CARD Card;
    LPCARDHEADER lpCards;

    hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
    if (!hText)
FSC_INSMEM:
	{
	MessageBox(hIndexWnd, (LPSTR)NotEnoughMem, (LPSTR)NULL, MB_OK | MB_ICONEXCLAMATION);
	return;
	}
    lpText = GlobalLock(hText);
    fFound = FALSE;
    GetWindowText(hCardWnd, lpText, CARDTEXTSIZE);
    ichStart = HIWORD(SendMessage(hCardWnd, EM_GETSEL, 0, 0L));
    iCard = iFirstCard;
    for (lpch1 = lpText+ichStart; *lpch1; ++lpch1)
	{
	for (pch2 = CurIFind, lpch3 = lpch1; *pch2; ++pch2, ++lpch3)
	    if (AnsiUpper((LPSTR)(DWORD)(BYTE)*lpch3) != AnsiUpper((LPSTR)(DWORD)(BYTE)*pch2))
		break;
	if (!*pch2)
	    {
	    fFound = TRUE;
	    goto FS_DONE;
	    }
	}
    iCard++;
    if (iCard == cCards)
	iCard = 0;
    for (i = 0; i < cCards-1; ++i)
	{
	lpCards = (LPCARDHEADER) GlobalLock(hCards);
	lpCards += iCard;
	CardHead = *lpCards;
	GlobalUnlock(hCards);
	ReadCurCardData(&CardHead, &Card, lpText);
	if (Card.hBitmap)
	    DeleteObject(Card.hBitmap);
	for (lpch1 = lpText; *lpch1; ++lpch1)
	    {
	    for (pch2 = CurIFind, lpch3 = lpch1; *pch2; ++pch2, ++lpch3)
		if (AnsiUpper((LPSTR)(DWORD)(BYTE)*lpch3) != AnsiUpper((LPSTR)(DWORD)(BYTE)*pch2))
		    break;
	    if (!*pch2)
		{
		fFound = TRUE;
		goto FS_DONE;
		}
	    }
	iCard++;
	if (iCard == cCards)
	    iCard = 0;
	}
    GetWindowText(hCardWnd, lpText, CARDTEXTSIZE);
    for (lpch1 = lpText; *lpch1 && lpch1 - lpText < ichStart; ++lpch1)
	{
	for (pch2 = CurIFind, lpch3 = lpch1; *pch2; ++pch2, ++lpch3)
	    if (AnsiUpper((LPSTR)(DWORD)(BYTE)*lpch3) != AnsiUpper((LPSTR)(DWORD)(BYTE)*pch2))
		break;
	if (!*pch2)
	    {
	    fFound = TRUE;
	    goto FS_DONE;
	    }
	}
FS_DONE:
    if (fFound)
	{
	if (iCard != iFirstCard && !GetNewCard(iFirstCard, iCard))
	    goto FSC_INSMEM;
	SendMessage(hCardWnd, EM_SETSEL, 0, MAKELONG((int)(lpch1-lpText), (int)(lpch1-lpText)+lstrlen((LPSTR)CurIFind)));
	}
    else
	{
	LoadString(hIndexInstance, ECANTFIND, (LPSTR)buf, 128);
	lstrcat((LPSTR)buf, (LPSTR)"\"");
	lstrcat((LPSTR)buf, (LPSTR)CurIFind);
	lstrcat((LPSTR)buf, (LPSTR)"\"");
	MessageBox(hIndexWnd, (LPSTR)buf, (LPSTR)rgchNote, MB_OK | MB_ICONEXCLAMATION);
	}
    GlobalUnlock(hText);
    GlobalFree(hText);
    }
