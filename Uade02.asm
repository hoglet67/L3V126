;;.OPT
;;UADE02; > Uade02
;;.TTL
;;Fileserver file UADE02

.UADE02

	;**********************************
	;*    H E A D E R  F I L E  2     *
	;**********************************

BRKVEC = &202
BPUTV =  &218
TSTART =  &F800

MAXPW =   6;MAX SIZE OF PASSWORD
MAXID =  10;MAXIMUM SIZE OF SINGLE USER ID
MAXUNM =  2 * MAXID + 1;MAX USER IDS PLUS DOT


	;*** USRMAN MANIFESTS ***
	;USERTB OFFSETS
CLEAR 0,100
ORG 0
.UTMCNO		SKIP 3;START OF 3 BYTE MACHINE NO
.UTUSID		SKIP MAXUNM+1;START OF USERID
.UTDISC		SKIP 2;CURRENTLY SELECTED DISC NUMBER
.UTPRIV		SKIP 1;SYSTEM PRIVILEGE & INUSE FLAG
.UTHSLD		SKIP 1;HANDLE FOR SELECTED DIR
.UTHUFD		SKIP 1;HANDLE FOR UFD
.UTHNDB		SKIP 1;BYTE INDICATING HANDLES IN USE PER MC

UTFRLN =  4;length of free space counter
.UTFREE		SKIP UTFRLN;User disc space allocation ** 2/10/84 **
.UTENSZ;SIZE OF A USERTB ENTRY

USRLIM =  MAXUSE + 1;MAX 40 USERS FOR NOW **
OPTMSK =  &F;Mask for user option bits
NTOPT =  &F0;Complement of OPTMSK


	;*** STRMAN MANIFESTS ***
	;CACHE ENTRY DESCRIPTOR OFFSETS
CLEAR 0,100
ORG 0
.CEDISC		SKIP 2;DISC NO
.CESIN		SKIP 3;SIN OF OBJECT
.CEBKNO		SKIP 2;START BLOCK NUMBER IN OBJECT
.CEBLKS		SKIP 2;NUMBER OF BLOCKS OCCUPIED BY WINDOW
.CESTA		SKIP 2;STORE ADDRESS OF OBJECT
.CERCNT		SKIP 1;REFERENCE COUNT
.CEAGE		SKIP 1;AGE FOR LRU REPLACEMENT ALGORITHM
.CENEXT		SKIP 2;PTR TO NEXT DESCRIPTOR
.CESIZE;SIZE OF A DESCRIPTOR

	;THE ADDRESS OF DIRTY FLAG IS = STORE ADDRESS OF WINDOW - 1

	;STRMAN BUFFER SIZE
LGBFSZ = 6 * BLKSZE;SIZE OF A LARGE BUFFER(MUST BE MULTIPLE OF BLKSZE)

	;BUFFER AGES
LRU =   1;=> LEAST RECENTLY USED
MRU =  &FF;=> MOST RECENTLY USED

	;*** DIRMAN MANIFESTS ***
	;DIRECTORY OFFSETS
	;(HEADER INFORMATION)
	;NOTE THAT A ONE BYTE SEQUENCE NUMBER (INCREMENTED WHEN
	;WRITING A DIR TO DISC) BRACKETS A DIRECTORY.
	;THE LEADING SEQUENCE NUMBER GOES AT BYTE OFFSET 2
	;AND THE TRAILING SQ NO IS THE LAST BYTE OF A DIR.
	;THESE SQ NOS ARE USED TO DETECT DIRS WHICH HAVE NOT
	;BEEN WRITTEN TO DISC COMPLETELY -
	;NOTE DIRS CAN BE MULTI-SECTOR OBJECTS.
	;SQ NOS ARE CHECKED WHENEVER A DIR IS LOADED.
CLEAR 0,100
ORG 0
.DRFRST		SKIP 2;PTR TO 1ST ENTRY (N.B. DON'T CHANGE THIS)
.DRSQNO		SKIP 1;LEADING SEQUENCE NUMBER (1 BYTE)
.DRNAME		SKIP &A;(NAMLNT BYTES) DIRECTORY NAME
.DRFREE		SKIP 2;PTR TO 1ST FREE ENTRY
.DRENTS		SKIP 2;NUMBER OF DIRECTORY ENTRIES
.DRSTAR;FIRST ENTRY IN DIR

	;(OFFSETS IN ENTRY)
CLEAR 0,100
ORG 0
.DRLINK		SKIP 2;PTR TO NEXT ENTRY (DON'T ALTER THIS)
.DRTITL		SKIP &A;TEXT NAME (PADDED WITH ZEROES)
.DRLOAD		SKIP 4;LOAD ADDRESS
.DREXEC		SKIP 4;EXECUTE ADDRESS
.DRACCS		SKIP 1;ACCESS INFO
.DRDATE		SKIP 2;DATE OF CREATION
.DRSIN		SKIP 3;SIN OF OBJECT
.DRENSZ;SIZE OF DIRECTORY ENTRY

	;OFFSETS FOR DETAILS RETRIEVED FROM A DIRECTORY
	;NOTE THAT IF THE SIZE OF THE INFORMATION (INFNXT) IS
	;EVER CHANGED YOU MUST CHANGE THE SIZE OF THE
	;BUFFERS:- USWORK,ATUSRI
CLEAR 0,100
ORG 0
.INFNAM		SKIP &A;FILE TITLE
.INFLOA		SKIP 4;LOAD ADDRESS
.INFEXE		SKIP 4;EXECUTE ADDRESS
.INFACC		SKIP 1;ACCESS INFO (TYPE & ACCESS VECTOR)
.INFDTE		SKIP 2;DATE OF CREATION
.INFSIN		SKIP 3;SIN OF OBJECT
.INFDIS		SKIP 2;DISC NUMBER
.INFSZE		SKIP 3;SIZE OF OBJECT
.INFNXT;NUMBER OF BYTES IN DETAILS

	;DIRMAN CONSTANTS
ACCMSK =  &1F;BITS 0 -> 4 (LWR/WR)
TLAMSK =  &3F;=> type/LWRWR mask
RWMSK =  &F;BITS 0 -> 3 (WR/WR)
DISCIN =  ':';INDICATES DISC NAME IN FILE TITLE
TERMIN =  &D;STRING TERMINATOR
SEPART =  '.';FILE NAME SEPARATOR
NAMLNT =  &A;MAX LENGTH OF TEXT NAME (10 CHARS)
SPACE =  ' ';SPACE CHARACTER
ROOT =  '$';NAME OF ROOT DIRECTORY
MAXDIR =  (HI(DRSTAR + 255 * DRENSZ)+1)*&100
;MAX SIZE A DIR IS ALLOWED TO BE
ENTTRM =   0;ENTRY TERMINATOR
EXTERM =  &80;BLOCK TERMINATOR
JMPINS =  &4C;JMP INSTRUCTION
MAXENA =  LGBFSZ / 27;NO. OF ENTRIES TYPE A
MAXENB =  LGBFSZ / 68;""      ""      "   B
MAXENC =  LGBFSZ / 11;""      ""      "   C
MAXEND =  LGBFSZ / 18;""      ""      "   D

	;*** AUTMAN MANIFESTS ***
	;PASSWORD FILE OFFSETS
CLEAR 0,100
ORG 0
.PWUSID		SKIP MAXUNM -1;USERID
.PWPASS		SKIP MAXPW;PASSWORD
.PWFREE		SKIP UTFRLN;free space for this user
.PWFLAG		SKIP 1;FLAG (INUSE & SYSTEM PRIV)
.PWENSZ;SIZE OF PASSWORD FILE ENTRY

	;*** RNDMAN MANIFESTS ***
	;HANDLE TABLE OFFSETS (HANDTB)
CLEAR 0,100
ORG 0
.HTHAND		SKIP 1;HANDLE NUMBER
.HTMCNO		SKIP 3;MACHINE NUMBER OF OWNING M/C
.HTACC		SKIP 1;ACCESS TO & TYPE OF OBJECT
.HTDISC		SKIP 2;DISC NUMBER OF OBJECT
.HTSIN		SKIP 3;SIN OF OBJECT
.HTMODE		SKIP 1;MODE OF USE FOR WHICH OPENED
.HTRPTR		SKIP 2;Ptr. to RANDTB entry (2 bytes)
.HTENSZ;SIZE OF A HANDTB ENTRY

	;RANDTB OFFSETS
CLEAR 0,100
ORG 0
.RTCSFP		SKIP 3;Current sequential file pointer
	;Note RDSTAR in randman assumes that the
	;two pointers are consecutive in this table
.RTOSFP		SKIP 3;Old sequential file pointer
.RTHWM		SKIP 3;HIGH WATER MARK
.RTFSZE		SKIP 3;FILE SIZE
.RTDESC		SKIP 2;ADDRESS OF CACHE DESCRIPTOR(HINT)
.RTINUS		SKIP 1;INUSE + SEQ. NUMBER
.RTENSZ;SIZE OF EACH RANDTB ENTRY

	;*** MAPMAN MANIFESTS ***
	;MAPTB OFFSETS
CLEAR 0,100
ORG 0
.MPDCNO		SKIP 2;DISC NUMBER
.MPNOCY		SKIP 2;NUMBER OF CYLINDERS
.MPSECS		SKIP 3;NO. OF SECTORS PER DISC
.MPDSCS		SKIP 1;NUMBER OF DISCS
.MPSPCY		SKIP 2;SECTORS PER CYLINDER
.MPBMSZ		SKIP 1;SIZE OF BIT MAP IN BLOCKS
.MPADFT		SKIP 1;ADDED TO GET NEXT PHYSICAL DISC
.MPDRNC		SKIP 1;INCREMENT TO NEXT LOGICAL DRIVE
.MPRTSN		SKIP 3;SIN OF ROOT DIRECTORY
.MPRTDT		SKIP 2;ROOT DATE
.MPSCYL		SKIP 2;START CYLINDER
.MPSZCY		SKIP 1;SIZE IN BYTES OF CYLINDER BIT MAP
.MPSZLN;SIZE OF ENTRY
.MPSCTT		SKIP 3;TOTAL NUMBER OF SECTORS
.MPCYMP		SKIP 2;STORE ADDRESS OF CYLINDER MAP
.MPTBSZ;SIZE OF MAPTB ENTRY

	;** SECTOR ZERO INFO **
CLEAR 0,100
ORG 0
.MPDRNM		SKIP 4;POSN OF 'AFS0' IN SECTOR 0
.MPSZNM		SKIP &10;POSITION OF NAME IN SEC. ZERO
.MPSZNC		SKIP 2;NUMBER OF CYLINDERS PER DISC
.MPSZNS		SKIP 3;NUMBER OF SECTORS PER DISC
.MPSZDN		SKIP 1;NUMBER OF DISCS
.MPSZSC		SKIP 2;SECTORS PER CYLINDER
.MPSZSB		SKIP 1;SIZE OF BIT MAP
.MPSZAF		SKIP 1;ADDITION FOR NEXT PHYSICAL DISC
.MPSZDI		SKIP 1;INCREMENT FOR NEXT LOGICAL DRIVE
.MPSZSI		SKIP 3;SIN OF ROOT
SZOFF =  &F6;OFFSET TO DRIVE DATA SECTOR
.MPSZDT		SKIP 2;DATE OF ROOT
.MPSZSS;START SECTOR

	; MAP BLOCK POINTERS
CLEAR 0,100
ORG 0
.BLKSN		SKIP 3
.BLKNO		SKIP 3
.MBSQNO		SKIP 1
.MGFLG		SKIP 1
.BILB		SKIP 2
.MBENTS;START OF MAP BLOCK ENTRIES
ENSZ =   5;BYTES IN MAP BLOCK ENTRY
MXENTS =  49
LSTENT =  MBENTS+(MXENTS-1)*ENSZ;a better definition
LSTSQ =  255
BTINBK =   256;BYTES IN A NORMAL DISC BLOCK

	;
	;BIT MAP FLAGS

MPVAL =  &FF;offset of 'next bitmaps valid' flag

	;
	; OFFSETS IN CACHE CONTROL BLOCK
	;
CLEAR 0,100
ORG 0
.CAFLG		SKIP 1
.CBDA		SKIP 3
.CBSA		SKIP 2
.CBDR		SKIP 1
.CBAGE		SKIP 1
.CBSZ

	;
	; INFORMATION ABOUT BIT MAP AND MAP BLOCK CACHES
	;
NOBTMP =   5;NUMBER OF BIT MAP CACHE BLOCKS
NOMPBK =   15;NUMBER OF MAP BLOCK CACHE ENTRIES *** LH 15/12/85 ***
SZBMAR =  NOBTMP * BTINBK; NUMBER OF BYTES IN BIT MAP CACHE
SZMBAR =  NOMPBK * BTINBK; NUMBER OF BYTES IN MAP BLOCK CACHE
SZBMCB =  NOBTMP * CBSZ; SIZE OF CACHE CONTROL BLOCK ENTRIES
SZMBCB =  NOMPBK * CBSZ; DITTO FOR MAP BLOCKS

	;NAME TABLE OFFSETS ETC.
DNAMLN =  &10;SIZE OF DISC NAME
NTSIZE =   7;NO. OF ENTRIES
USED =   0;IN USE VALUE
UNUSED =  &FE;MOST RECENTLY USED VALUE

CLEAR 0,100
ORG 0
.NTNAME		SKIP &10;DISC NAME
.NTDNO		SKIP 2;DISC NO.
.NTUSED		SKIP 1;IN USE PTR.
.NTENSZ;SIZE OF ENTRY

	;*** COMMAND PROC. MANIFESTS ***
	;CONSTANTS
RXBUFL = &7F; &50;Receive buffer length
COPORT =  &99
FIFLSZ =  &400;Initial size of file created by FIND
BUFSZ =  &500;TX BUFFER SIZE

	;Function numbers
DRPRS =   1;Preserve in dir. man.
DRRTR =   2;Retrieve in dir. man
MAPCS =   1;Create map space
MAPFS =   2;Free map space
MAPENS =   6
	;Bits and pieces
WAITCL =  &50;No. of msecs wait for client
ONEMS =   5;No. of loops to give 1 msec (see WAIT)

PSAVD =  COPORT + 1;Data port in save
TXRPT =  &FF;Do 255 times
TXDLY =  &14;Delay 20 msec
LF =  &A
CR =  &D
DOT =  '.'
FCCMND =   5;To recognise a command
FCCRET =  29; The create command 11/6/84 BC
FCMAX =  34;32; Max. fn. code
HDRLEN =   5;Header of INCOMING message
TXHDR =   2;Header length of OUTGOING message
CLIDLM = &A0;CR;Delimiter in CLI table
CLIDL1 = &B0;CLIDLM - 1
SAVFTO =  HDRLEN +&B
LODFTO =  HDRLEN
EXAFTO =  HDRLEN + 3
INFFTO =  HDRLEN + 1
FNDFTO =  HDRLEN + 2;File find, not dir. find ??




	;STORE POINTERS
IF DEBUG
	DBGSPC = 256;EXTRA ROOM FOR DEBUG CODE
ELSE
	DBGSPC = 0
ENDIF
	; DMB: 3rd Jan 2023: Added &100 for Atom CAT/LOAD/SAVE command parsing code
IF LNGDAT
	FRESTR=DBGSPC+&8C00;FIRST FREE STORE LOCATION
ELSE
	FRESTR=DBGSPC+&8B00
ENDIF


ORG FRESTR

.STKPTR		SKIP 2;VAL OF HARDWARE STACK PTR (STOP)
.FREPTR		SKIP 2;PTR TO FREE STORE (GETVEC)
.ENDPTR		SKIP 2;PTR TO END OF FREE STORE (GETVEC)
.BIGBUF		SKIP 2;PTR TO BIG BUFFER (STRMAN)
.NUMBCE		SKIP 1;NO. OF CACHE DECRIPTORS
.CACHSZ		SKIP 2;CACHE SIZE

.USERTB		SKIP 2;PTR TO START OF USERTB (USRMAN)
.TITPTR		SKIP 2;PTR TO DIR NAME
.USDISC		SKIP 2;HOLDS DISC NUMBER FOR USRMAN
.USRACC		SKIP 1;ACCESS TO DIRECTORY
.USRROT		SKIP 1;ROOT CHARACTER
.USRSEP		SKIP 1;SEPARATOR CHARACTER
.USRUFD		SKIP MAXUNM;USERID
.USRTER		SKIP 1;DIR NAME TERMINATOR
.USRINF		SKIP INFNXT;OBJECT DETAILS AREA(SEE DIRMAN.RETRV)
.USWORK		SKIP 2;USRMAN WORK VARIABLE
.USTEMP		SKIP 1;Temp general USRMAN store
.UMHUFD		SKIP 1;Temp UFD store.
.UMHCSD		SKIP 1
.UMHLIB		SKIP 1

.MCTEMP		SKIP 3;M/C NUMBER
.USERS		SKIP 1;NO. OF USERS
.USSYS		SKIP 1;flag to indicate priv'd user logged on
.CACHTB		SKIP 2;PTR TO FIRST CACHE ENTRY DESCRIPTOR
.FRECHN		SKIP 2;PTR TO CHAIN OF FREE CACHE DESCRIPTORS
.AMTNED		SKIP 2;AMOUNT OF STORE NEEDED FOR OBJECT
.STRTMP		SKIP 2;STRMAN TEMP VARIABLE
.BSTSTA		SKIP 2;BEST START POSITION
.BSTEND		SKIP 2;BEST END POSITION
.MINCST		SKIP 2;MINIMUM COST
.COST		SKIP 2
.HANDTB		SKIP 2;PTR TO START OF HANDLE TABLE (RNDMAN)
.RANDTB		SKIP 2;PTR TO START OF RANDOM ACCESS TABLE
.RDBFAD		SKIP 2
.BTSXFD		SKIP 2;Bytes xferred in PB/GB (2 bytes) (RNDMAN)
.BTSLFT		SKIP 2;Bytes left to transfer (2 bytes)
.NEWFSZ		SKIP 3;New file size (arg to RDCHSZ routine) - 3 bytes
.EOFFLG		SKIP 1;End-of-file flag (RNDMAN)
.HTENTS		SKIP 1;NO. OF HAND. TBL. ENTRIES
.RTNENT		SKIP 1;No. of RANDTB entries
.INTEGR		SKIP 1;TO HOLD AN INTEGER(RDINT)
.GVWRKA		SKIP 2;GETVEC WORK VARIABLE
.ENWRKA		SKIP 2;ENTRY WORK VAR
.TEMPA		SKIP 2;TEMPORARY VARIABLE
.TEMPB		SKIP 2
.MCNUMB		SKIP 3;MC/NO LOOKED UPIN USERTB(USRMAN-FINDMC)

;CLOCK/DATE
.RTCSWI		SKIP 1;TYPE OF RTC
.TCOUNT		SKIP 1
.OLDDAY		SKIP 1
.DATE		SKIP 2;2 BYTE FILE SERVER DATE

;ORDER AS PER OSWORD 14, FUNCTION 1
.DBLK
.DYEAR		SKIP 1;YEAR
.DMONTH		SKIP 1;MONTH
.DDAY		SKIP 1;DATE
.WKDAY		SKIP 1;DAY OF WEEK
.HRS		SKIP 1;HOURS
.MINS		SKIP 1;MINUTES
.SECS		SKIP 1;SECONDS

;RTC WORKSPACE
.SR			;DONGLE
.REM		SKIP 1;DIVISION REMAINDER
.TWORK		;WORKSPACE, MUST BE AFTER SECS
.DVSOR		SKIP 1;DIVISOR
.TIME		SKIP 5;TIME OF DAY
.OTIME		SKIP 5;COMPARISON
.NTIME		SKIP 5;WORK VARIABLE FOR TIME

.LASTNM		SKIP 2;PTR TO 1ST CHAR OF LAST TEXT NAME(DIRMAN)
.DRDSNM		SKIP &11;BUFFER TO HOLD DISC NAME(17BYTES)
.DIRACC		SKIP 1;TYPE & ACCESS TO DIR (OWNER/ANYBODY)
.DRDISC		SKIP 2;DISC NO OF CURRENT DIR
.DIRSIN		SKIP 3;SIN OF CURRENT DIR
.DIRSTT		SKIP 2;START BLK NO OF DIRECTORY (=0)
.DIRBKS		SKIP 2;NO OF BLKS IN DIR
.DIRSTA		SKIP 2;STORE ADDRESS OF DIR
.DIRSZE		SKIP 3;3 BYTE VARIABLE HOLDING SIZE OF DIR
.TXTNAM		SKIP NAMLNT+1;10 BYTE TEXT NAME (PADDED WITH SPACES)
.DIRTMP		SKIP 3;3 BYTE TEMPORARY VARIABLE
.DMTEMP		SKIP 3
.OBJSIN		SKIP 3;TEMP VAR HOLDING SIN OF OBJECT
.OBJACC		SKIP 1;TEMP VAR HOLDING ACC INFO FOR OBJECT
.EXARG		SKIP 1
.EXENTR		SKIP 1
.EXENTS		SKIP 1
.DMSTX		SKIP 1;1 BYTE
.DRCNT		SKIP 1;1 BYTE LOCN.
.EXRTN		SKIP 3;3 BYTES
.TDATE		SKIP 2
.DIRWC		SKIP 1;FLAG FOR WILD CARDS
.WILD1		SKIP 1;USED IN FNDTEX
.WILD2		SKIP 1
.DIRFLG		SKIP 1
.ATDRIV		SKIP 1;DRIVE NUMBER(AUTMAN)
.ATSTRA		SKIP 2;STORE ADDRESS OF PW FILE
.ATINF		SKIP INFNXT;INFORMATION FROM DIRMAN
.ATUSRI		SKIP UTENSZ;USERINFO VECTOR FOR AUTMAN
.ATWORK		SKIP 3;AUTMAN WORK VARIABLE
.DOTFLG		SKIP 1;FLAG DOT HAS OCCURED
.DRIVES		SKIP 1;NUMBER OF DRIVES ATTACHED TO FS
.MAPTB		SKIP 2;HOLDS ADDRESS OF MAP TABLE(MAPMAN)
.DIVPAR		SKIP 3
.DIVTMP		SKIP 3;HOLDS BLOCKS TO ALLOCATE
.NAMETB		SKIP 2;NAME TABLE
.MAPTMP		SKIP 3;TEMP VARIABLE
.MPTMPA		SKIP 3
.MPTMPB		SKIP 3
.MPTMPC		SKIP 3
.TMPSPC		SKIP 3;TEMPORARY SECTORS PER CYLINDER
.MPSZEQ		SKIP 1;Indicates if zero length chain
.MPCHFL		SKIP 1;HOLDS END OF CHAIN FLAGS
.MPDRVE		SKIP 1;HOLDS CURRENT DRIVE NUMBER
.MPDSNO		SKIP 2;CURRENT DISC NO
.MPSCST		SKIP 2;POINTER TO START OF DISC????
.MPTMPD		SKIP 3;GENERAL PURPOSE VARIABLE
.MPTMPE		SKIP 3;GENERAL PURPOSE VARIABLE
.MPBLOK		SKIP 2;POINTER TO MAP BLOCK
.MKENVA		SKIP 3
.SAVC
.SAVSC		SKIP 3
.SAVPTB		SKIP 3;SAVE POINTER POSITION
.SAVPTA		SKIP 3;SAVE POINTER
.MBCBPT		SKIP 2;POINTER TO MAP BLOCK CONTROL BLOCKS
.BMCBPT		SKIP 2;PONTER TO BIT MAP CONTROL BLOCK
.NCBDB		SKIP 2;NUMBER OF CURRENT CONTROL BLOCK ENTRIES
.CBSIN		SKIP 3;CURRENT CB SIN
.CBSTA		SKIP 2;CURRENT CB STORE ADDRESS
.CBTPPT		SKIP 2;CB TEMPORARY POINTER
.RBDA		SKIP 3;TRANSFER BLOCK DISC ADDRESS
.ERRTYP		SKIP 1;READ OR WRITE DISC ERROR
.DNDLTE		SKIP 1;DELETE CURRENT MAP BLOCK?
.RSTFLG		SKIP 1;CYLINDER MAP STARTUP FLAG
.CURDSC		SKIP 2;CURRENT DSIC NO.
.NXTDNO		SKIP 2;NEXT DISC NO. ALLOCATION
.CURDRV		SKIP 1;CURRENT DRIVE
.LDRNB		SKIP 1;LOGICAL DRIVE NUMBER (DSCMAN)
.DCSECT		SKIP 3;SECTOR NUMBER
.DRIVNO		SKIP 1;ACTUAL DRIVE NUMBER TO BE SELECTED
.DCSTAD		SKIP 2;STORE ADDRESS
.NBLKS		SKIP 2;NUMBER OF DISC BLOCKS TO BE TRANSFERED
.DATARA		SKIP 16;AREA FOR TEST OF DISC BLOCK VALIDITY
.OLDFDR		SKIP 1;LAST FDRIVE USED
.OLDSZE		SKIP 4
.CTRACK		SKIP 1;COPY OF TRACK NUMBER
.CSECTR		SKIP 1;COPY OF 1 BYTE SECTOR NUMBER
.CADDR		SKIP 2;COPY OF STORE ADDRESS
.SECTSD		SKIP 2;NUMB OF SECTORS ON A SIDE OF DISC
.SECTS		SKIP 2;NO. OF SECTS TO XFER
.DCRASH		SKIP 1;DISC CRASH INDICATION

.DSCCB		SKIP 15
.SAVCOM		SKIP 1
.TRACK		SKIP 1
.SECTOR		SKIP 1
.DDRSTA		SKIP 2
.DDRSPA		SKIP 2
.DDRSZE		SKIP 2
.DDRSCT		SKIP 2
.CNTA		SKIP 1
.SECTNO		SKIP 1
.DFNAME		SKIP 10
.DFLOAD		SKIP 2
.DFEXEC		SKIP 2
.DFSIZE		SKIP 3
.DFQUAL		SKIP 10
.DFSECT		SKIP 10
.RAMADR		SKIP 2
.INTROT		SKIP 2;USED FOR A FILE TITLE (INIT)

.USERNM		SKIP MAXUNM+ 1;HOLDS A USERID
.BREGA		SKIP 3;3 BYTE WORK VARIABLE (MULTBS)
.RXTAB		SKIP 1
.RXCBN		SKIP 1;RXCB
.RXCBV
.CBFLG		SKIP 1;RECEIVE C.B. FIELDS
.CBPORT		SKIP 1;PORT
.CBSTID		SKIP 2;STATION ID
.CBBUF		SKIP 4;START
.CBBUFE		SKIP 4;END
.RXBUF		SKIP 1
.FCODE		SKIP 1;FN. code
.CPUFD		SKIP 1
.CPCSD		SKIP 1
.CPLIB		SKIP 1
.MIDRX		SKIP 250
.RXBUFT		SKIP 1

.TXBUF
.CCODE		SKIP 1;Command code
.RTCODE		SKIP 1
.MIDTX

ORG TXBUF + &30

;CONVERT FROM DOS WORKSPACE

;OTHER VARIABLES
.OTHERS
.COTEMP		SKIP 2
.COWORK
.DETRAM
.DETNAM		SKIP &A;DETAILS FROM RETRIEVE
.DETLOA		SKIP 4
.DETEXE		SKIP 4
.DETACC		SKIP 1
.DETDAT		SKIP 2
.DETSIN		SKIP 3
.DETDIS		SKIP 2
.DETSZ		SKIP 3
.TOSEND		SKIP 3
.OFFSET		SKIP 3
.GBBXFD		SKIP 3;Bytes xfd in CP GETBYTES (3 bytes)
.GBEFLG		SKIP 1;End of file flag (CP GETBYTES)
.MAPTBF				;Buffer MAPTB information in MAPMAN.MPREDR
.TXTBUF		SKIP 127;80 byte file title buffer
.QPTR		SKIP 1
.BPTR		SKIP 1
.CURBLK		SKIP 2
.OUTBSZ		SKIP 2
.BBUF		SKIP 2
.BBSIZE		SKIP 2
.BBEND		SKIP 2
.DANDS		SKIP 5
.DSCERR		SKIP 1
.RPLYPT		SKIP 1
.DATAIN		SKIP 3
.FINFLG		SKIP 1
.FILLFL		SKIP 1
.TIMER		SKIP 1
.TIMER1		SKIP 1
.TIMER2		SKIP 1
.QUOTED		SKIP 1
.TXJ		SKIP 1
.TXD		SKIP 1
.TXF		SKIP 1
.MONFLG		SKIP 1
.OLDRXB		SKIP 2
.CDIRTB		SKIP 2
.CVTDRV		SKIP 1
.FSDNO		SKIP 2
.HNDROT		SKIP 1
.QUALIF		SKIP 1
.TXBYTS		SKIP 2
.TXBLKS		SKIP 2
.MEMEND		SKIP 2
.OLDBRK		SKIP 2;
.OFF1		SKIP 1;ARG TO MOVBLK
.OFF2		SKIP 1;ARG TO MOVBLK
.STRPTR		SKIP 2;Ptr. used in AUTMAN
.PTREND		SKIP 2;Ptr. used in AUTMAN
.RIPPLE		SKIP 1
.EVCHAR		SKIP 1
.IOBUF		SKIP 2;new big buffer
.IOBSIZ		SKIP 2
.IOEND		SKIP 2
.ODSCMN		SKIP 11
.MPNWFR		SKIP UTFRLN;user free space calculation
.ERMCNO		SKIP 3;M/C NO USED BY EXTERR

.DYNSTA 	SKIP 0;START OF DYNAMICALLY ALLOCATED STORE


;;.LNK
;;UADE03
