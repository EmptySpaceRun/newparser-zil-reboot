"PLACES  for
        NEW-PARSER GAME
    by Max Fog (using the new parser)"

<GLOBAL DEMO-VERSION? <>>
<GLOBAL MACHINE 0>
<GLOBAL NARROW? <>>
<IF-P-IMAGES
<BEGIN-SEGMENT STARTUP>

<ROUTINE SETUP-SCREEN ()
	 <SETG MACHINE <LOWCORE INTID>>
	 <COND (<OR <EQUAL? ,MACHINE ,IBM>
		    <APPLE?>>
		<SETG NARROW? T>)>
	 <SETG FONT-X <LOWCORE (FWRD 1)>>
	 <SETG FONT-Y <LOWCORE (FWRD 0)>>
	 <MOUSE-LIMIT -1>
	 <COND (<FLAG-ON? ,F-MOUSE>
		<SETG ACTIVE-MOUSE T>)> 
	 <WINSIZE ,S-FULL <LOWCORE VWRD> <LOWCORE HWRD>>
	 <SETG WIDTH <LOWCORE SCRH>>
	 ;"set up SL-LOC-TBL to avoid status line PICINFs on every move"
	 <PICINF-PLUS-ONE ,HERE-LOC>
	 <COPYT ,PICINF-TBL ,SL-LOC-TBL 4>
	 ;<PUT ,SL-LOC-TBL 0 <GET ,PICINF-TBL 0>>
	 ;<PUT ,SL-LOC-TBL 1 <GET ,PICINF-TBL 1>>
	 <PICINF-PLUS-ONE ,YEAR-LOC>
	 <COPYT ,PICINF-TBL <REST ,SL-LOC-TBL 4> 4>
	 ;<PUT ,SL-LOC-TBL 2 <GET ,PICINF-TBL 0>>
	 ;<PUT ,SL-LOC-TBL 3 <GET ,PICINF-TBL 1>>
	 <PICINF-PLUS-ONE ,COMPASS-PIC-LOC>
	 <COPYT ,PICINF-TBL <REST ,SL-LOC-TBL 8> 4>
	 ;<PUT ,SL-LOC-TBL 4 <GET ,PICINF-TBL 0>>
	 ;<PUT ,SL-LOC-TBL 5 <GET ,PICINF-TBL 1>>
	 <PICINF-PLUS-ONE ,U-BOX-LOC>
	 <COPYT ,PICINF-TBL <REST ,SL-LOC-TBL 12> 4>
	 ;<PUT ,SL-LOC-TBL 6 <GET ,PICINF-TBL 0>>
	 ;<PUT ,SL-LOC-TBL 7 <GET ,PICINF-TBL 1>>
	 <PICINF-PLUS-ONE ,D-BOX-LOC>
	 <COPYT ,PICINF-TBL <REST ,SL-LOC-TBL 16> 4>
	 ;<PUT ,SL-LOC-TBL 8 <GET ,PICINF-TBL 0>>
	 ;<PUT ,SL-LOC-TBL 9 <GET ,PICINF-TBL 1>>
	 <PICINF ,ICON-OFFSET ,PICINF-TBL>
	 <COPYT ,PICINF-TBL <REST ,SL-LOC-TBL 20> 4>
	 ;<PUT ,SL-LOC-TBL 10 <GET ,PICINF-TBL 0>>
	 ;<PUT ,SL-LOC-TBL 11 <GET ,PICINF-TBL 1>>>>

<IF-P-IMAGES 
<ROUTINE CLEAR-CRCNT ("AUX" NUM)
	 <SET NUM <WINGET ,S-TEXT ,WCRCNT>>
	 <REPEAT ()
		 <COND (<0? .NUM>
			<RETURN>)>
		 <CRLF>
		 <SET NUM <- .NUM 1>>>>

<CONSTANT SLIDE-SHOW-TIMEOUT 150>
<CONSTANT DEMO-TIMEOUT 600>

<ROUTINE SLIDE-SHOW-HANDLER ()
	<SETG DEMO-VERSION? +1>
	<RTRUE>>

<ROUTINE SLIDE-SHOW () <>>

<ROUTINE READ-DEMO (ARG1 "OPT" (ARG2 <>) "AUX" CHR)
	 <SETG DEMO-VERSION? -1>
	 <SET CHR <READ .ARG1 .ARG2 ,DEMO-TIMEOUT ,SLIDE-SHOW-HANDLER>>
	 <COND (<1? ,DEMO-VERSION?>
		<END-DEMO>)
	       (T
		<WINPUT ,S-TEXT 15 -999> ;"Disable MORE counter."
		.CHR)>>

<ROUTINE INPUT-DEMO (ARG "AUX" CHR)
	 <SETG DEMO-VERSION? -1>
	 <SET CHR <INPUT .ARG ,DEMO-TIMEOUT ,SLIDE-SHOW-HANDLER>>
	 <COND (<1? ,DEMO-VERSION?>
		<END-DEMO>)
	       (T
		<WINPUT ,S-TEXT 15 -999> ;"Disable MORE counter."
		.CHR)>>

<ROUTINE END-DEMO ()
	<CLEAR -1>
	<TELL "|
You have reached the end of this demonstration version of|">
	<V-VERSION>
	<TELL "|
|
">
	<HIT-ANY-KEY>
	<SCREEN ,S-TEXT>
	<DEFAULT-COLORS> ;"return to default before screen clears"
	<RESTART>
	<TELL ,FAILED>
	<AGAIN>>



<BEGIN-SEGMENT STARTUP>>


<ROOM BEDROOM
      (LOC ROOMS)
      (YEAR 2012)
      (DESC "Bedroom")
      (SYNONYM BEDROOM)
      ;(MAP-LOC <PTABLE VILLAGE-MAP-NUM MAP-GEN-Y-4 MAP-GEN-X-1>) ;"From Z0... I haven't the strength to edit it"
      ;(ICON GARRISON-ICON)
      (GLOBAL BEDROOM-DOOR)
      (GENERIC BEDROOM-G)
      (ACTION BEDROOM-F)>

<ROUTINE BEDROOM-F ("OPT" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-ENTER>
		    <IF-P-IMAGES <PICINF ,VILLAGE-SEGMENT-PIC ,PICINF-TBL>> ;"ALSO Z0"
		    <RFALSE>) ;"segment-related kludge"
           (<EQUAL? .RARG ,M-LOOK>
            <TELL
"This is your bedroom. There is a door. The version here 
ncludes a tab marking, so you need to include them in the
new paragraphs.|
|  Such as here. It's only 2 spaces.">)>>

<OBJECT BEDROOM-DOOR
    (LOC LOCAL-GLOBALS)
    (DESC "bedroom door")
    (SYNONYM DOOR BEDROOM)
    (ADJECTIVE BEDROOM TO DOOR)
    (DESCFCN BEDROOM-DOOR-F)
    (ACTION BEDROOM-DOOR-F)
    (GENERIC DOOR-G)
    (FLAGS DOORBIT LOCKEDBIT)>

<ROUTINE BEDROOM-DOOR-F ("OPT" (RARG <>))
    <COND (<AND <EQUAL? ,HERE ,BEDROOM>
                <OR <EQUAL? .RARG ,M-OBJDESC?>
                    <VERB? EXAMINE TOUCH>>>
           <TELL
"The bedroom door shudders as an unknown group of people hurl themselves against it." CR>
           <IF-P-QUOTES <SETG DO-WINDOW <GET ,QUOTES ,Q-OPPENHEIMER>>>
           <STOP>)>>

<OBJECT BED
    (LOC BEDROOM)
    (OWNER PROTAGONIST)
    (SYNONYM BED COVERS)
    (ADJECTIVE COMFY)
    (DESC "bed")
    (FLAGS SURFACEBIT VEHBIT)>



<IF-P-IMAGES 
<END-SEGMENT>


<BEGIN-SEGMENT CASTLE>>

<ROOM GREEN-ROOM
    (LOC ROOMS)
    (SYNONYM ROOM)
    (ADJECTIVE GREEN)
    (FDESC "The room flourishes with all sorts of green plants.")
    (LDESC
"The plants swirling round the walls brighten up
the room with every imaginable shade of green.")
    (YEAR 2013)       ;"I added year stuff but never got round to working it in... You can remove this">

<IF-P-IMAGES <END-SEGMENT>>