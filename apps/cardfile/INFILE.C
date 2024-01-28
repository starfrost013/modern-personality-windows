#define NOCOMM
#define NOVIRTUALKEYCODES
#define NOWINMESSAGES
#include "index.h"

/****************************************************************/
/*								*/
/*  Windows Cardfile - Written by Mark Cliggett 		*/
/*  (c) Copyright Microsoft Corp. 1985 - All Rights Reserved	*/
/*								*/
/****************************************************************/

char TmpFile[PATHMAX];
OFSTRUCT tmpreopen;
OFSTRUCT mainreopen;
int fReadOnly = FALSE;

FAR MergeCardFile(pchName)
PSTR pchName;
    {
    int fh;
    unsigned i;
    char buf[PATHMAX];
    char MarkCliggett[4];
    OFSTRUCT mergereopen;
    int cEighths;
    HBITMAP hBits;
    LPSTR lpBits;
    LPSTR lpText;
    HANDLE hText;
    unsigned cMergeCards;
    unsigned tSize;
    unsigned long lCurPos;
    HBITMAP hBitmap;
    int result = FALSE;
    unsigned long fhLoc;

    AppendExtension(pchName, buf);

    /* open file */
    if ((fh = OpenFile((LPSTR)buf, (LPOFSTRUCT)&mergereopen, OF_PROMPT | OF_CANCEL)) < 0)
	return(0);

    /* now read it in */
    MarkCliggett[3] = 0;
    myread(fh, MarkCliggett, 3);
    if (lstrcmp((LPSTR)MarkCliggett, (LPSTR)"MGC"))
	{
	IndexOkError(ENOTVALIDFILE);
	goto MergeClean;
	}

    /* read the number of cards in the file */
    myread(fh, &cMergeCards, sizeof(int));

    if (!GlobalReAlloc(hCards, (unsigned long)((cCards+cMergeCards)*sizeof(CARDHEADER)),GMEM_MOVEABLE))
	{
MergeInsMem:
	_lclose(fh);
	Throw((LPCATCHBUF)CatchBuf, EINSMEMORY);
	}

    hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
    if (!hText)
	goto MergeInsMem;
    lpText = GlobalLock(hText);

    for(i = 0; i < cMergeCards; ++i)
	{
	myread(fh, &CurCardHead, sizeof(CARDHEADER));
	lCurPos = _llseek(fh, 0L, 1);
	_llseek(fh, CurCardHead.lfData, 0);

	CurCard.hBitmap = 0;

	myread(fh, &CurCard.bmSize, sizeof(int));
	if (CurCard.bmSize)
	    {
	    myread(fh, &CurCard.cxBitmap, sizeof(int));
	    myread(fh, &CurCard.cyBitmap, sizeof(int));
	    myread(fh, &cEighths, sizeof(int));
	    CurCard.xBitmap = (cEighths * CharFixWidth) / 8;
	    myread(fh, &cEighths, sizeof(int));
	    CurCard.yBitmap = (cEighths * CharFixHeight) / 8;
	    if(hBits = GlobalAlloc(GHND, (unsigned long)CurCard.bmSize))
		{
		lpBits = (LPSTR)GlobalLock(hBits);
		mylread(fh, lpBits, CurCard.bmSize);
		fhLoc = _llseek(fh, 0L, 1);
		if (hBitmap = CreateBitmap(CurCard.cxBitmap, CurCard.cyBitmap, 1, 1, lpBits))
		    CurCard.hBitmap = hBitmap;
		while (_llseek(fh, fhLoc, 0) == -1)
		    fh = OpenFile((LPSTR)buf, (LPOFSTRUCT)&mergereopen, OF_PROMPT | OF_REOPEN);
		GlobalUnlock(hBits);
		GlobalFree(hBits);
		}
	    else
		_llseek(fh, (unsigned long)CurCard.bmSize, 1);
	    }
	myread(fh, &tSize, sizeof(int));
	if (tSize >= CARDTEXTSIZE)
	    tSize = CARDTEXTSIZE-1;
	mylread(fh, lpText, tSize);
	*(lpText+tSize) = 0;
	if (tSize = WriteCurCard(&CurCardHead, &CurCard, lpText))
	    {
	    iFirstCard = AddCurCard();
	    }
	if (CurCard.hBitmap)
	    DeleteObject(CurCard.hBitmap);
	_llseek(fh, lCurPos, 0);
	if (!tSize)
	    goto MergeClean;
	}
    GlobalUnlock(hText);
    GlobalFree(hText);
    fFileDirty = TRUE;
    result = TRUE;
MergeClean:
    _lclose(fh);
    return(result);
    }

FAR ReadCardFile(pchName)
PSTR pchName;
    {
    int fh;
    LPCARDHEADER lpTCards;
    unsigned i;
    char buf[PATHMAX];
    char MarkCliggett[4];
    unsigned cNewCards;
    int result = FALSE;
    OFSTRUCT tmpmain;

    AppendExtension(pchName, buf);

    /* open file */
    if ((fh = OpenFile((LPSTR)buf, (LPOFSTRUCT)&tmpmain, OF_PROMPT | OF_CANCEL)) < 0)
	return(0);

    /* now read it in */
    MarkCliggett[3] = 0;
    myread(fh, MarkCliggett, 3);
    if (lstrcmp((LPSTR)MarkCliggett, (LPSTR)"MGC"))
	{
	IndexOkError(ENOTVALIDFILE);
	goto ReadClean;
	}

    /* read the number of cards in the file */
    myread(fh, &cNewCards, sizeof(int));

    /* allocate the object to hold all the headers */
    if (!GlobalReAlloc(hCards, (unsigned long)(cNewCards * sizeof(CARDHEADER)), GMEM_MOVEABLE))
	{
	_lclose(fh);
	Throw((LPCATCHBUF)CatchBuf, EINSMEMORY);
	}
    cCards = cNewCards;
    lpTCards = (LPCARDHEADER) GlobalLock(hCards);

    for(i = 0; i < cNewCards; ++i)
	{
	myread(fh, &CurCardHead, sizeof(CARDHEADER));
	*lpTCards++ = CurCardHead;
	}
    GlobalUnlock(hCards);
    fFileDirty = FALSE;

    mainreopen = tmpmain;     /* save new OFSTRUCT */
    lstrcpy((LPSTR)CurIFile, (LPSTR)mainreopen.szPathName);
    result = TRUE;
ReadClean:
    _lclose(fh);
    return(result);
    }

FAR AppendExtension(pchName, pchBuf)
PSTR pchName;
PSTR pchBuf;
    {
    char *pch1;
    char *pch2;

    for (pch1 = pchName, pch2 = pchBuf; *pch1 && *pch1 != '.'; )
	*pch2++ = *pch1++;
    if (!*pch1)
	pch1 = INDEXEXTENSION;
    lstrcpy((LPSTR)pch2, (LPSTR)pch1);
    AnsiUpper((LPSTR)pchBuf);
    }

FAR WriteCardFile(pchName)
PSTR pchName;
    {
    LPCARDHEADER lpTCards = NULL;	/* so cleaning works */
    char bakName[PATHMAX];
    char dolName[PATHMAX];
    unsigned i;
    int fhBak;
    int fhDollar;
    int fhOld;
    int fh;
    unsigned long lCurLoc;
    unsigned long lCardData;
    unsigned bmSize;
    unsigned cchWritten;
    unsigned bmInfo[4];
    HANDLE hText;
    LPSTR lpText;
    HANDLE hBits;
    LPSTR lpBits;
    char buf[PATHMAX];
    unsigned tSize;
    int fSameFile;
    char *pchFileName;
    int result = FALSE;
    CARDHEADER CardHeader;
    LPCARDHEADER lpCards;
    OFSTRUCT bakofStruct;

    AppendExtension(pchName, buf);

    if (fSameFile = !lstrcmp((LPSTR)buf, (LPSTR)CurIFile))
	{
	if(!GetTempFileName(CurIFile[0] | TF_FORCEDRIVE, (LPSTR)"CRD", 0, (LPSTR)bakName))
	    goto SaveTempProblem;
	}
    else
	lstrcpy((LPSTR)bakName, (LPSTR)buf);

    fhBak = OpenFile((LPSTR)bakName, (LPOFSTRUCT)&bakofStruct, OF_CREATE);
    /* open files */
    if (CurIFile[0])
	pchFileName = CurIFile;
    else
	pchFileName = rgchCardData;
    if(fReadOnly || !(fhDollar = OpenFile((LPSTR)pchFileName, (LPOFSTRUCT)&tmpreopen, OF_PROMPT | OF_REOPEN | 2)) == -1)
	{
SaveTempProblem:
	IndexOkError(EDISKFULLFILE);
	return(0);
	}
    if (fhBak < 0)
	{
	goto CantMakeFile;
	}
    /* if curifile is null, then won't use fhOld */
    if (CurIFile[0])
	fhOld = OpenFile((LPSTR)CurIFile, (LPOFSTRUCT)&mainreopen, OF_PROMPT | OF_REOPEN);

    /* truncate file */
    if (_llseek(fhBak, 0L, 0) == -1)
	{
	if (CurIFile[0])
	    _lclose(fhOld);
CantMakeFile:
	_lclose(fhDollar);
	LoadString(hIndexInstance, ECANTMAKEFILE, (LPSTR)bakName, PATHMAX);
	lstrcat((LPSTR)bakName, (LPSTR)buf);
	MessageBox(hIndexWnd, (LPSTR)bakName, (LPSTR)rgchNote, MB_OK | MB_ICONEXCLAMATION);
	return(0);
	}
    mywrite(fhBak, "", 0);

    mywrite(fhBak, "MGC", 3);

    /* write the number of cards in the file */
    mywrite(fhBak, &cCards, sizeof(int));
    lCardData = _llseek(fhBak, 0L, 1) + (cCards * sizeof(CARDHEADER));

    /* allocate buf for card text */
    hText = GlobalAlloc(GHND, (long)CARDTEXTSIZE);
    if (!hText)
	goto WFInsMem;
    lpText = (LPSTR)GlobalLock(hText);

    /* lock down the card headers */
    lpCards = lpTCards = (LPCARDHEADER) GlobalLock(hCards);

    for(i = 0; i < cCards; ++i)
	{
	if (lpTCards->flags & FTMPFILE)
	    fh = fhDollar;
	else
	    fh = fhOld;
	_llseek(fh, lpTCards->lfData, 0);
	CardHeader = *lpTCards++;
	CardHeader.flags &= (!FTMPFILE);
	CardHeader.lfData = lCardData;
	if (mylwrite(fhBak, (LPCARDHEADER)&CardHeader, sizeof(CARDHEADER)) < sizeof(CARDHEADER))
	    goto WFDiskFull;
	lCurLoc = _llseek(fhBak, 0L, 1);
	_llseek(fhBak, lCardData, 0);
	myread(fh, &bmSize, sizeof(int));
	mywrite(fhBak, &bmSize, sizeof(int));

	if (bmSize)
	    {
	    myread(fh, bmInfo, 4 * sizeof(int));
	    mywrite(fhBak, bmInfo, 4 * sizeof(int));
	    hBits = GlobalAlloc(GHND, (unsigned long)bmSize);
	    if (!hBits)
		{
WFInsMem:
		_lclose(fhBak);
		_lclose(fhOld);
		_lclose(fhDollar);
		Fdelete(bakName);
		Throw((LPCATCHBUF)CatchBuf, EINSMEMORY);
		}
	    lpBits = (LPSTR)GlobalLock(hBits);
	    mylread(fh, lpBits, bmSize);
	    cchWritten = mylwrite(fhBak, lpBits, bmSize);
	    GlobalUnlock(hBits);
	    GlobalFree(hBits);
	    if (cchWritten < bmSize)
		goto WFDiskFull;
	    }
	myread(fh, &tSize, sizeof(int));
	if (mywrite(fhBak, &tSize, sizeof(int)) < sizeof(int))
	    goto WFDiskFull;
	mylread(fh, lpText, tSize);
	if (mylwrite(fhBak, lpText, tSize) < tSize)
	    {
WFDiskFull:
	    _lclose(fhBak);
	    _lclose(fhOld);
	    _lclose(fhDollar);
	    Fdelete(bakName);
	    IndexOkError(EDISKFULLFILE);
	    goto WriteFileClean;
	    }

	lCardData = _llseek(fhBak, 0L, 1);
	_llseek(fhBak, lCurLoc, 0);
	}
    _lclose(fhBak);
    if (CurIFile[0])
	_lclose(fhOld);
    _llseek(fhDollar, 0L, 0);
    mywrite(fhDollar, "", 0);
    _lclose(fhDollar);
    if (fSameFile)
	{
	Fdelete(buf);
	Frename(bakName, buf);
	fhOld = OpenFile((LPSTR)buf, (LPOFSTRUCT)&mainreopen, 2);
	}
    else
	{
	AnsiUpper((LPSTR)CurIFile);
	fhOld = OpenFile((LPSTR)bakName, (LPOFSTRUCT)&mainreopen, 2);
	}

    lstrcpy((LPSTR)CurIFile, (LPSTR)mainreopen.szPathName);

    _llseek(fhOld, 5L, 0);
    lpTCards = lpCards;
    for(i = 0; i < cCards; ++i)
	{
	myread(fhOld, &CardHeader, sizeof(CARDHEADER));
	*lpTCards++ = CardHeader;
	}
    _lclose(fhOld);
    fFileDirty = FALSE;
    result = TRUE;
WriteFileClean:
    if (hText)
	{
	GlobalUnlock(hText);
	GlobalFree(hText);
	}
    if (lpTCards)
	GlobalUnlock(hCards);
    return(result);
    }

FAR WriteCurCard(pCardHead, pCard, lpText)
PCARDHEADER pCardHead;
PCARD pCard;
LPSTR lpText;
    {
    int fh;
    unsigned long lEnd;
    HANDLE hBits;
    LPSTR lpBits;
    int zero = 0;
    unsigned i;
    unsigned tSize;
    LPSTR lpTmp2Text;
    int cEighths;
    char *pchFileName;
    unsigned cchWritten;
    unsigned long fhLoc;

    if (CurIFile[0])
	pchFileName = CurIFile;
    else
	pchFileName = rgchCardData;

    if ((fh = OpenFile((LPSTR)pchFileName, (LPOFSTRUCT)&tmpreopen, OF_CANCEL | OF_PROMPT | OF_REOPEN | 2)) == -1)
	{
	IndexOkError(EOPENTEMPSAVE);
	return(0);
	}

    lEnd = _llseek(fh, 0L, 2);
    if (pCard->hBitmap)
	{
	if (hBits = GlobalAlloc(GHND, (unsigned long)pCard->bmSize))
	    {
	    lpBits = (LPSTR)GlobalLock(hBits);
	    mywrite(fh, &pCard->bmSize, sizeof(int));
	    mywrite(fh, &pCard->cxBitmap, sizeof(int));
	    if(mywrite(fh, &pCard->cyBitmap, sizeof(int)) < sizeof(int))
		goto WCDiskFull;
	    cEighths = (pCard->xBitmap * 8) / CharFixWidth;
	    mywrite(fh, &cEighths, sizeof(int));
	    cEighths = (pCard->yBitmap * 8) / CharFixHeight;
	    if(mywrite(fh, &cEighths, sizeof(int)) < sizeof(int))
		goto WCDiskFull;
	    fhLoc = _llseek(fh, 0L, 1);
	    GetBitmapBits(pCard->hBitmap, (unsigned long)pCard->bmSize, lpBits);
	    while (_llseek(fh, fhLoc, 0) == -1)
		fh = OpenFile((LPSTR)pchFileName, (LPOFSTRUCT)&tmpreopen, OF_PROMPT | OF_REOPEN | OF_READWRITE);
	    if (mylwrite(fh, lpBits, pCard->bmSize) < pCard->bmSize)
		goto WCDiskFull;
	    GlobalUnlock(hBits);
	    GlobalFree(hBits);
	    }
	else
	    {
	    _lclose(fh);
	    IndexOkError(EINSMEMSAVE);
	    return(0);
	    }
	}
    else
	mywrite(fh, &zero, sizeof(int));

    tSize = lstrlen((LPSTR)lpText);
    if (tSize >= CARDTEXTSIZE)
	tSize = CARDTEXTSIZE-1;
    if (mywrite(fh, &tSize, sizeof(int)) < sizeof(int))
	goto WCDiskFull;
    cchWritten = mylwrite(fh, lpText, tSize);
    _lclose(fh);
    if (cchWritten < tSize)
	{
WCDiskFull:
	IndexOkError(EDISKFULLSAVE);
	return(FALSE);
	}
    pCardHead->flags |= FTMPFILE;
    pCardHead->lfData = lEnd;
    return(TRUE);
    }

FAR ReadCurCardData(pCardHead, pCard, lpText)
PCARDHEADER pCardHead;
PCARD pCard;
LPSTR lpText;
    {
    int fh;
    HANDLE hBits;
    LPSTR lpBits;
    HBITMAP hBitmap;
    unsigned i;
    unsigned tSize;
    int cEighths;
    int fZero;
    char *pchFileName;
    int result = TRUE;
    unsigned long fhLoc;

    pCard->hBitmap = 0;

    if (pCardHead->flags & FNEW)
	{
	lpText = (LPSTR)"";
	return(result);
	}

    if (pCardHead->flags & FTMPFILE)
	{
	if (CurIFile[0])
	    pchFileName = CurIFile;
	else
	    pchFileName = rgchCardData;
	fh = OpenFile((LPSTR)pchFileName, (LPOFSTRUCT)&tmpreopen, OF_PROMPT | OF_REOPEN | 2);
	}
    else
	fh = OpenFile((LPSTR)CurIFile, (LPOFSTRUCT)&mainreopen, OF_PROMPT | OF_REOPEN);

    _llseek(fh, pCardHead->lfData, 0);

    myread(fh, &(pCard->bmSize), sizeof(int));
    if (pCard->bmSize)
	{
	myread(fh, &(pCard->cxBitmap), sizeof(int));
	myread(fh, &(pCard->cyBitmap), sizeof(int));
	myread(fh, &cEighths, sizeof(int));
	pCard->xBitmap = (cEighths * CharFixWidth) / 8;
	myread(fh, &cEighths, sizeof(int));
	pCard->yBitmap = (cEighths * CharFixHeight) / 8;
	if(hBits = GlobalAlloc(GHND, (unsigned long)pCard->bmSize))
	    {
	    lpBits = (LPSTR)GlobalLock(hBits);
	    mylread(fh, lpBits, pCard->bmSize);
	    fhLoc = _llseek(fh, 0L, 1);
	    if (!(pCard->hBitmap = CreateBitmap(pCard->cxBitmap, pCard->cyBitmap, 1, 1, lpBits)))
		result = FALSE;
	    while (_llseek(fh, fhLoc, 0) == -1)
		{
		if (pCardHead->flags & FTMPFILE)
		    {
		    if (CurIFile[0])
			pchFileName = CurIFile;
		    else
			pchFileName = rgchCardData;
		    fh = OpenFile((LPSTR)pchFileName, (LPOFSTRUCT)&tmpreopen, OF_PROMPT | OF_REOPEN | OF_READWRITE);
		    }
		else
		    fh = OpenFile((LPSTR)CurIFile, (LPOFSTRUCT)&mainreopen, OF_PROMPT | OF_REOPEN);
		}
	    GlobalUnlock(hBits);
	    GlobalFree(hBits);
	    }
	else
	    {
	    _llseek(fh, (unsigned long)pCard->bmSize, 1);
	    result = FALSE;
	    }
	}
    myread(fh, &tSize, sizeof(int));
    if (tSize >= CARDTEXTSIZE)
	tSize = CARDTEXTSIZE-1;
    mylread(fh, lpText, tSize);
    *(lpText+tSize) = 0;
    _lclose(fh);
    return (result);
    }

FAR MakeTmpFile(hInstance)
HANDLE hInstance;
    {
    int  fh;

    if(GetTempFileName(CurIFile[0], (LPSTR)"CRD", 0, (LPSTR)TmpFile))
	{
	if ((fh = OpenFile((LPSTR)TmpFile, (LPOFSTRUCT)&tmpreopen, OF_CREATE)) < 0)
	    goto CantMakeTmp;
	else
	    _lclose(fh);
	}
    else
	{
CantMakeTmp:
	IndexOkError(ECANTMAKETEMP);
	fReadOnly = TRUE;
	}
    }

htoa(h, pch)
unsigned int h;
char *pch;
    {
    char tmp[5];
    int i;
    unsigned int n;
    char *pchTmp;

    pchTmp = tmp;
    for (i = 0; i < 4; ++i, pchTmp++)
	{
	n = h & 0x0f;
	h = h >> 4;
	if (n < 10)
	    *pchTmp = '0'+n;
	else
	    *pchTmp = 'A' + n - 10;
	}
    pchTmp--;
    for (i = 0; i < 4; ++i)
	*pch++ = *pchTmp--;
    *pch = 0;
    }
