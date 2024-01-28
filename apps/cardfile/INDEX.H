#define NOSOUND
#define NOCREATESTRUCT
#define NOMETAFILE
#define NOPEN
#define NORGN
#define NOWH
#include "windows.h"
#include "winexp.h"

#define RB_TONE 6
#define RB_PULSE 7
#define RB_COM1 9
#define RB_COM2 10
#define RB_1200 12
#define RB_300  13

#define     NEW         101
#define     OPEN        102
#define     SAVE        103
#define     SAVEAS      104
#define     PRINT       105
#define     PRINTALL    106
#define     MERGE       107
#define     CCARDFILE   141
#define     PHONEBOOK   142
#define     UNDO        118
#define     HEADER      111
#define     RESTORE     112
#define     CUT         113
#define     COPY        114
#define     PASTE       115
#define     I_TEXT      116
#define     I_BITMAP    117
#define     ADD         121
#define     DELETE      122
#define     DUPLICATE   123
#define     DIAL        124
#define     GOTO        131
#define     FIND        132
#define     FINDNEXT    133
#define     ABOUT       8887
#define     EDITWINDOW  200

#define PATHMAX 128

extern  HANDLE  hIndexInstance;
extern  HWND    hIndexWnd;
extern  HWND    hCardWnd;
extern  FARPROC lpDlgProc;
extern  FARPROC lpfnOpen;
extern  FARPROC lpfnSave;
extern  FARPROC lpfnDial;
extern  FARPROC lpfnAbout;
extern  FARPROC lpEditWndProc;
extern HBRUSH   hbrBack;

extern int fSettingText;
extern int fNeedToUpdateBitmap;

#define CARRETURN   0x0d
#define BACKSPACE   0x08
#define TAB         0x09
#define TABLENGTH   8           /* each tab is worth 8 spaces */
#define LINEFEED    0x0a

char *PutUpDB(int);

extern char CurIFile[];
extern char CurIFind[];

#define LINELENGTH 40
#define CARDLINES 11
#define CARDTEXTSIZE ((LINELENGTH+1) * CARDLINES)
#define CARDCY 12

typedef struct
    {
    int     iCard;                  /* the number of this card */
    unsigned long    lfHead;                 /* file offset of card */
    unsigned long    lfData;                 /* file offset of data */
    unsigned char flags;            /* flags */
    char    line[LINELENGTH+1];               /* 40 character lines plus null */
    }CARDHEADER;
typedef CARDHEADER *PCARDHEADER;
typedef CARDHEADER far *LPCARDHEADER;

typedef struct
    {
    int        cxBitmap;
    int        cyBitmap;
    int        xBitmap;
    int        yBitmap;
    unsigned    bmSize;
    HANDLE  hBitmap;
    HANDLE  hText;
    }CARD;
typedef CARD *PCARD;

extern int cCards;          /* the current count of cards */

extern HANDLE hCards;       /* the handle to the buffer */

extern int CharFixWidth;    /* the character width */
extern int CharFixHeight;   /* the character height */
extern int ExtLeading;      /* the external leading */

extern int CardWidth;
extern int CardHeight;
extern int fColor;

extern int fReadOnly;

extern HBRUSH hbrWhite;
extern HBRUSH hbrBlack;
extern HBRUSH hbrGray;
extern HBRUSH hbrBlue;
extern HBRUSH hbrRed;
extern HBRUSH hbrLine;
extern HANDLE hArrowCurs;
extern HANDLE hWaitCurs;

extern CARDHEADER CurCardHead;
extern CARD       CurCard;

#define FNEW     0x01
#define FDIRTY   0x02
#define FTMPFILE 0x04

extern RECT dragRect;

extern int iTopScreenCard;
extern int iCurCard;
extern int iFirstCard;

#define LEFTMARGIN 8
#define RIGHTMARGIN 8
#define BOTTOMMARGIN 8

extern int cScreenHeads;
extern int cScreenCards;
extern int cFSHeads;        /* count of fully visible headers */

#define SBINDEX SB_HORZ

extern int ySpacing;
extern int xFirstCard;
extern int yFirstCard;

extern int EditMode;
extern CATCHBUF CatchBuf;
extern int fModemOnCom1;
extern int fTone;
extern int fFastModem;

#define INDEXEXTENSION ".CRD"

extern int fFileDirty;          /* does disk match current set of cards? */

#define ID_PATH     10
#define ID_EDIT     11
#define ID_LISTBOX  12

#define DTOPEN      1
#define DTSAVE      2
#define DTHEADER    3
#define DTADD       5
#define DTMERGE     6
#define DTGOTO      7
#define DTFIND      8
#define DTABOUT     9
#define DTABORTDLG  10
#define DTDIAL      11

#define INDEXICON  1
#define MAINACC    1
#define MTINDEX    1

/* prompts */
#define IDELCURCARD     0
#define ICREATEFILE     1
#define IOKTOSAVE       2
#define IABOUT          3
#define ICARDS          4
#define ICARD           5
#define IUNTITLED       6
#define ICARDDATA       7
#define IWARNING        8
#define INOTE           9
#define IPICKUPPHONE    10
/* errors */
#define ECANTDIAL       16
#define ECANTPRINTPICT  17
#define EINSMEMORY      18
#define EFILEEXISTS     19
#define EINVALIDFILE    20
#define ECLIPEMPTYTEXT  21
#define ENOTEXTSEL      22
#define EDISKFULLFILE   23
#define ECANTMAKETEMP   24
#define EINSMEMSAVE     25
#define EDISKFULLSAVE   26
#define EOPENTEMPSAVE   27
#define ECANTREADPICT   28
#define EINSMEMRUN      29
#define ENOTVALIDFILE   30
#define ECANTFIND       31
#define EINSMEMREAD     32
#define ECANTPRINT      33
#define ECLIPEMPTYPICT  34
#define ENOMODEM        35
#define ENOPICTURES     36
#define ECANTMAKEFILE   37
#define EMEMPRINT       38
#define EDISKPRINT      39

extern char rgchCardfile[];
extern char rgchWindows[];
extern char rgchDevice[];

extern char rgchCardData[];
extern char NotEnoughMem[];
extern char rgchUntitled[];
extern char rgchWarning[];
extern char rgchNote[];

extern RECT dragRect;
extern char TmpFile[];
extern int CardPhone;
extern int iTopCard;

FARPROC lpfnAbortProc;
FARPROC lpfnAbortDlgProc;

int FAR IndexInit();
int FAR GetOldData(HANDLE);
int FAR InitInstance(HANDLE, LPSTR, int);
int FAR MergeCardFile(PSTR);
int FAR ReadCardFile(PSTR);
int FAR WriteCardFile(PSTR);
int FAR WriteCurCard();
int FAR ReadCurCardData();
FAR AppendExtension(PSTR, PSTR);
int FAR MakeTmpFile(HANDLE);
FAR Fdelete(PSTR);
FAR IndexOkError(int);
FAR AddCurCard();
FAR BuildCaption(PSTR);
FAR PrintCards(int);
FAR PrintList();
FAR DoGoto();
FAR FindStrCard();
FAR GetNewCard(int, int);
FAR DoOpen(PSTR);
FAR DoCutCopy(int);
FAR DoPaste();
FAR BMMouse(HWND, int, WORD, POINT);
FAR TurnOnBitmapRect();
FAR TurnOffBitmapRect();
FAR DrawXorRect(HDC, RECT *);
FAR BMKey(WORD);
FAR IndexWinIniChange();
FAR GetPhoneNumber(PSTR, int);
FAR DoDial(PSTR);
FAR CardPaint(HDC);
