"VERBS for
        NEW-PARSER GAME
    by Max Fog (using the new parser)"

<BEGIN-SEGMENT 0>

<INCLUDE "pdefs">

;"subtitle game commands"

<GLOBAL VERBOSITY 1> ;"0 = superbrief, 1 = brief, 2 = verbose"

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSITY 2>
	 <TELL "Maximum verbosity." CR CR>
	 <V-LOOK>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSITY 1>
	 <TELL "Brief descriptions." CR>>

<ROUTINE V-SUPERBRIEF ()
	 <SETG VERBOSITY 0>
	 <TELL "Superbrief descriptions." CR>>

<ROUTINE NOT-IN-DEMO ()
	<TELL
"[Sorry, but that command is not available in this demonstration version.]"CR>>

<ROUTINE V-FOO ()
    <TELL "[FOO!! This is a bug!]" CR>>

<ROUTINE V-SAVE ("AUX" X)
	 ;<COND (,DEBUG
		<TELL
"[Saving: Foregnd Color is " N ,FG-COLOR "; Backgnd Color is " N ,BG-COLOR "]" CR>)>
	 <COND (,DEMO-VERSION?
		<NOT-IN-DEMO>
		<RFATAL>)>
	 <PUTB ,G-INBUF 2 0>
	 <SETG P-CONT <>> ;"flush anything on input line after SAVE"
	 <SET X <SAVE>>
	 <COND (<ZERO? .X>
		<SETG P-CONT -1>
	        <TELL "SAVE failed!" CR>
		<RFATAL>)
	       (<EQUAL? .X 1>
		<RESTORE-ORPHAN>
		<TELL "SAVE completed." CR>
		<RFATAL>)>
	 ;<COND (,DEBUG
		<TELL
"[Restored: Foregnd Color is " N ,FG-COLOR "; Backgnd Color is " N ,BG-COLOR "]" CR>)>
	 <COLOR ,FG-COLOR ,BG-COLOR>
	 <SETG OLD-HERE <>>
	 ;<SETUP-SCREEN>
	 <V-$REFRESH>
	 <RESTORE-ORPHAN>
	 <TELL "Okay, restored." CR CR>
	 <SETG P-CONT -1> ;<RFATAL>
	 <COND (<APPLE?> ;"force flip to correct segment before doing LOOK"
		<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>)>
	 <V-LOOK>>

;<ROUTINE SAVE-UNDO-CHECK ()
	 <COND (<EQUAL? ,HERE ,ROOM-OF-THREE-DOORS>
		<TELL
"[You can't SAVE or UNDO here. You'll have to solve the puzzle!]" CR>)>>

<ROUTINE RESTORE-ORPHAN ()
	 <COND (<FSET? ,PROTAGONIST ,LIGHTBIT> ;"Until I find something, impossible"
            <SETUP-ORPHAN "answer">)>
     ;<COND (<AND <IN? ,JESTER ,HERE>
		     ,LIT
		     <OR <AND <EQUAL? ,HERE ,ENTRANCE-HALL>
			      <NOT <FSET? ,PORTCULLIS ,OPENBIT>>>
			 <AND <EQUAL? ,HERE ,SOLAR>
			      <IN? ,EAST-KEY ,JESTER>>
			 <EQUAL? ,HERE ,OUBLIETTE>
			 <AND <EQUAL? ,HERE ,CAVE-IN>
			      <IN? ,PIT-BOMB ,LOCAL-GLOBALS>>
			 <AND <EQUAL? ,HERE ,TAX-OFFICE>
			      <IN? ,ZORKMID-COIN ,LOCAL-GLOBALS>>
			 <AND <EQUAL? ,HERE ,STREAM>
			      <FSET? ,DIPLOMA ,TRYTAKEBIT>>>>
		<SETUP-ORPHAN "answer">)>>

<ROUTINE V-RESTORE ()
	 ;<COND (,DEBUG
		<TELL
"[Restoring: Foregnd Color is " N ,FG-COLOR "; Backgnd Color is " N ,BG-COLOR "]" CR>)>
	 <COND (,DEMO-VERSION?
		<NOT-IN-DEMO>
		<RFATAL>)>
	 <COND (<NOT <RESTORE>>
		<TELL ,FAILED>)>>

<ROUTINE V-UNDO ("AUX" X)
	 <COND (<NOT <FLAG-ON? ,F-UNDO>>
		<TELL "UNDO is unavailable on your computer system." CR>
		<RTRUE>)>
	;<SETG OLD-HERE <>>
	;<SETG OLD-YEAR <>>
	;"SAVE-UNDO-CHECK handled in ROOM-OF-THREE-DOORS-F"
	<IRESTORE>
	<TELL ,FAILED>>

<ROUTINE V-SCRIPT ()
	 <COND (,DEMO-VERSION?
		<NOT-IN-DEMO>
		<RFATAL>)>
	 <TELL "[Transcript on.]" CR>
	 <DIROUT ,D-PRINTER-ON>
	 <CORP-NOTICE "begins"> ;"this message prints only to transcript">

<ROUTINE V-UNSCRIPT ()
	 <COND (,DEMO-VERSION?
		<NOT-IN-DEMO>
		<RFATAL>)>
	 <CORP-NOTICE "ends"> ;"this message prints only to transcript"
	 <DIROUT ,D-PRINTER-OFF>
	 <TELL "[Transcript off.]" CR>>

<ROUTINE CORP-NOTICE (STRING)
	 <DIROUT ,D-SCREEN-OFF>
	 <TELL CR "Here " .STRING " a transcript of interaction with" CR>
	 <V-VERSION>
	 <CRLF>
	 <DIROUT ,D-SCREEN-ON>
	 <RTRUE>>

<ROUTINE 2CR-TO-PRINTER ()
	 <DIROUT ,D-SCREEN-OFF>
	 <CRLF> <CRLF> ;"send linefeeds to printer but not screen"
	 <DIROUT ,D-SCREEN-ON>>

<GLOBAL COLOR-NOTE <>>

<GLOBAL FG-COLOR 1>

<GLOBAL BG-COLOR 1>

<GLOBAL DEFAULT-FG 1>

<GLOBAL DEFAULT-BG 1>

<ROUTINE V-COLOR ("AUX" (DEFAULT <>))
	 <COND (<APPLE?>
		<TELL
"[Sorry -- you can't change your text and background colors on this system.]" CR>
		<RTRUE>)
	       (<NOT ,COLOR-NOTE>
		<SETG COLOR-NOTE T>
		<TELL
"Aesthetically, we recommend not changing the standard setting, which is ">
		<COND (<OR <APPLE?>
			   <AND <EQUAL? <LOWCORE INTID> ,IBM>
				<NOT <FLAG-ON? ,F-COLOR>>>>
		       <TELL "white">)
		      (T
		       <TELL "black">)>
		<TELL " text on a ">
		<COND (<OR <APPLE?>
			   <AND <EQUAL? <LOWCORE INTID> ,IBM>
				<NOT <FLAG-ON? ,F-COLOR>>>>
		       <TELL "black">)
		      (<EQUAL? <LOWCORE INTID> ,AMIGA>
		       <TELL "light gray">)
		      (T
		       <TELL "white">)>
		<TELL " background. ">
		<COND (<AND <EQUAL? <LOWCORE INTID> ,MACINTOSH>
			    <MAC-II?>>
		       <TELL
"Also, if your Mac II displays only 16 colors, you probably won't get
the color you ask for. ">)>
		<TELL "Do you still want to go ahead?" CR "(Y or N) >">
		<COND (<NOT <Y?>>
		       <RTRUE>)>)>
	 <CRLF>
	 <REPEAT ()
	     <DO-COLOR>
	     <TELL
"You should now get " <GET ,COLOR-TABLE ,FG-COLOR> " text on a "
<GET ,COLOR-TABLE ,BG-COLOR> " background. Is that what you want?|
(Y or N) >">
	     <COND (<Y?>
		    <RETURN>)>
	     <COND (<MAC-I-COLOR-SWITCH>
		    <RETURN>)>
	     <TELL CR
"Do you want to pick again, or would you like to just go back to the
standard colors? (Type Y to pick again) >">
	     <COND (<Y?>
		    <CRLF>)
		   (T
		    <SET DEFAULT T>
		    <RETURN>)>>
	 <COND (.DEFAULT
		<DEFAULT-COLORS>)
	       (T
		<COLOR ,FG-COLOR ,BG-COLOR>
		<SCREEN ,S-FULL>
		<COLOR ,FG-COLOR ,BG-COLOR>
		<SCREEN ,S-TEXT>)>
	 <V-$REFRESH>>

<ROUTINE MAC-I-COLOR-SWITCH ()
	 <COND (<OR <AND <EQUAL? <LOWCORE INTID> ,IBM>
		         <NOT <FLAG-ON? ,F-COLOR>>>
		    <AND <EQUAL? <LOWCORE INTID> ,MACINTOSH>
		         <NOT <MAC-II?>>>>
		<COND (<EQUAL? ,BG-COLOR 2>
		       <SETG BG-COLOR 9>
		       <SETG FG-COLOR 2>)
		      (T
		       <SETG BG-COLOR 2>
		       <SETG FG-COLOR 9>)>
		<RTRUE>)>>

<ROUTINE DO-COLOR ()
	 <COND (<MAC-I-COLOR-SWITCH>
		<RTRUE>)
	       (T
		<SETG FG-COLOR <PICK-COLOR ,FG-COLOR "text" T>>
		<SETG BG-COLOR <PICK-COLOR ,BG-COLOR "background">>
		;<COND (,DEBUG
		       <TELL
"[Changed: Foregnd Color is " N ,FG-COLOR "; Backgnd Color is " N ,BG-COLOR "]" CR>)>)>>

<ROUTINE PICK-COLOR (WHICH STRING "OPTIONAL" (SETTING-FG <>) "AUX" CHAR)
	 <TELL
"The current " .STRING " color is " <GET ,COLOR-TABLE .WHICH> ,PERIOD-CR>
	 <FONT 4>
	 <TELL "   1 --> WHITE   4 --> GREEN">
	 <COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
		<TELL "    7 --> LIGHT GRAY">)>
	 <CRLF>
	 <TELL "   2 --> BLACK   5 --> YELLOW">
	 <COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
		<TELL "   8 --> MEDIUM GRAY">)>
	 <CRLF>
	 <TELL "   3 --> RED     6 --> BLUE">
	 <COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
		<TELL "     9 --> DARK GRAY">)>
	 <CRLF>
	 <FONT 1>
	 <TELL "Type a number to select the " .STRING " color you want. >">
	 <REPEAT ()
		 <COND ;(,DEMO-VERSION?
			<SET CHAR <INPUT-DEMO 1>>)
		       (T
			<SET CHAR <INPUT 1>>)>
		 <SET CHAR <- .CHAR 48>> ;"convert from ASCII"
		 <COND (<AND <EQUAL? <LOWCORE INTID> ,AMIGA>
			     <EQUAL? .CHAR 7 8 9>>
			<SET CHAR <+ .CHAR 3>>)
		       (<EQUAL? .CHAR 1> ;"white is really 9, not 1"
			<SET CHAR 9>)>
		 <COND (<OR <EQUAL? .CHAR 2 3 4 5 6 9>
			    <AND <EQUAL? <LOWCORE INTID> ,AMIGA>
				 <EQUAL? .CHAR 10 11 12>>>
			<COND (<AND <NOT .SETTING-FG>
				    <EQUAL? .CHAR ,FG-COLOR>>
			       <TELL CR
"You can't make the background the same color as the text! Pick another color. >">)
			      (T
			       <RETURN>)>)
		       (T
			<TELL CR ,TYPE-A-NUMBER>
			<COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
			       <TELL "9">)
			      (T
			       <TELL "6">)>
			<TELL ". >">)>>
	 <CRLF> <CRLF>
	 <RETURN .CHAR>>

<CONSTANT COLOR-TABLE
	  <PTABLE ;0 "no change"
		 ;1 "the default color"
		 ;2 "black"
		 ;3 "red"
		 ;4 "green"
		 ;5 "yellow"
		 ;6 "blue"
		 ;7 "magenta"
		 ;8 "cyan"
		 ;9 "white"
		;10 "light gray" ;"Amiga only"
		;11 "medium gray" ;"Amiga only"
		;12 "dark gray" ;"Amiga only">>

<ROUTINE DEFAULT-COLORS ()
	 <SETG FG-COLOR ,DEFAULT-FG>
	 <SETG BG-COLOR ,DEFAULT-BG>
	 ;<COND (,DEBUG
		<TELL
"[Changed: Foregnd Color is " N ,FG-COLOR "; Backgnd Color is " N ,BG-COLOR "]" CR>)>
	 <COLOR ,FG-COLOR ,BG-COLOR>
	 <SCREEN ,S-FULL>
	 <COLOR ,FG-COLOR ,BG-COLOR>
	 <SCREEN ,S-TEXT>>

<ROUTINE V-CREDITS ()
	 <CENTER-1 "M O O R B E A D" T>
	 <CENTER-1 "An Interactive Endgame" T>
	 <CRLF>
	 <CENTER-1 "designed and written by" T>
	 <CENTER-1 "Max Fog">
	 <CRLF>>

<ROUTINE CENTER-1 (STR "OPTIONAL" BOLD "AUX" Y X LEN)
	 <CENTER-LINE .STR 0 <COND (.BOLD ,H-BOLD) (T 0)>>
	 <CRLF>>

;<ROUTINE CENTER-1 (STR "OPTIONAL" BOLD "AUX" Y X LEN)
	 <CURGET ,SLINE>
	 <SET Y <GET ,SLINE 0>> ;"current line num"
	 <SET X </ <WINGET ,S-TEXT ,WWIDE> 2>> ;"center of text screen"
	 <COND (.BOLD
		<HLIGHT ,H-BOLD>)>
	 <DIROUT ,D-TABLE-ON ,SLINE ;-80>
	 <TELL .STR>
	 <DIROUT ,D-TABLE-OFF>
	 <SET LEN <LOWCORE TWID>>
	 <CURSET .Y <- .X </ .LEN 2>>>
	 <TELL .STR>
	 <HLIGHT ,H-NORMAL>
	 <CRLF>>

<IF-P-IMAGES
<ROUTINE CENTER-2 (STR1 STR2 "AUX" Y X1 X2 LEN)
	 <CURGET ,SLINE>
	 <SET Y <GET ,SLINE 0>> ;"current line num"
	 <SET X1 </ <WINGET ,S-TEXT ,WWIDE> 3>> ;"one-third across"
	 <SET X2 <* .X1 2>> ;"two-thirds across"
	 <DIROUT ,D-TABLE-ON ,SLINE ;-80>
	 <TELL .STR1>
	 <DIROUT ,D-TABLE-OFF>
	 <SET LEN <LOWCORE TWID>>
	 <CURSET .Y <- .X1 </ .LEN 2>>>
	 <TELL .STR1>
	 <DIROUT ,D-TABLE-ON ,SLINE ;-80>
	 <TELL .STR2>
	 <DIROUT ,D-TABLE-OFF>
	 <SET LEN <LOWCORE TWID>>
	 <CURSET .Y <- .X2 </ .LEN 2>>>
	 <TELL .STR2>
	 <CRLF>>

<ROUTINE CENTER-3 (STR1 STR2 STR3 "AUX" Y X1 X2 X3 LEN)
	 <CURGET ,SLINE>
	 <SET Y <GET ,SLINE 0>> ;"current line num"
	 <SET X1 </ <WINGET ,S-TEXT ,WWIDE> 4>> ;"one-quarter across"
	 <SET X2 <* .X1 2>> ;"halfway across"
	 <SET X3 <* .X1 3>> ;"three-quarters across"
	 <DIROUT ,D-TABLE-ON ,SLINE ;-80>
	 <TELL .STR1>
	 <DIROUT ,D-TABLE-OFF>
	 <SET LEN <LOWCORE TWID>>
	 <CURSET .Y <- .X1 </ .LEN 2>>>
	 <TELL .STR1>
	 <DIROUT ,D-TABLE-ON ,SLINE ;-80>
	 <TELL .STR2>
	 <DIROUT ,D-TABLE-OFF>
	 <SET LEN <LOWCORE TWID>>
	 <CURSET .Y <- .X2 </ .LEN 2>>>
	 <TELL .STR2>
	 <DIROUT ,D-TABLE-ON ,SLINE ;-80>
	 <TELL .STR3>
	 <DIROUT ,D-TABLE-OFF>
	 <SET LEN <LOWCORE TWID>>
	 <CURSET .Y <- .X3 </ .LEN 2>>>
	 <TELL .STR3>
	 <CRLF>>>

<ROUTINE V-DIAGNOSE ()
	 <COND ;(<G? ,HUNGER-COUNT 0>
		<TELL "You feel ">
		<COND (<EQUAL? ,HUNGER-COUNT 2>
		       <TELL "very ">)
		      (<EQUAL? ,HUNGER-COUNT 3>
		       <TELL "incredibly ">)>
		<TELL "hungry." CR>)
	       (T
		<TELL "You're as fit as can be, although a little shaken from recent events." CR>)>>	 

<ROUTINE V-INVENTORY ()
	 <SETG D-BIT <- ,WORNBIT>>
	 <COND (<NOT <D-CONTENTS ,WINNER <> <+ ,D-ALL? ,D-PARA?>>>
		<TELL "You are empty-handed.">)>
	 <SETG D-BIT ,WORNBIT>
	 <D-CONTENTS ,WINNER <> <+ ,D-ALL? ,D-PARA?>>
	 <SETG D-BIT <>>
	 <CRLF>>

<GLOBAL BORDER-ON T>

<IF-P-IMAGES
<ROUTINE V-MODE ()
	 <CLEAR -1>
	 <COND (,BORDER-ON
		<SETG BORDER-ON <>>)
	       (T
		<SETG BORDER-ON T>)>
	 ;<SPLIT-BY-PICTURE ,CURRENT-SPLIT> ;"called by INIT-STATUS-LINE"
	 <SCREEN ,S-FULL>
	 <INIT-STATUS-LINE T>
	 <SCREEN ,S-TEXT>
	 <TELL "Border o">
	 <COND (,BORDER-ON
		<TELL "n">)
	       (T
		<TELL "ff">)>
	 <TELL " (obviously)." CR>>>

<ROUTINE V-QUIT ()
	 ;<PARSER-REPORT>
	 <V-SCORE>
	 <DO-YOU-WISH "leave the game">
	 <COND (<Y?>
		<QUIT>)
	       (T
		<TELL ,OK>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE>
	 <DO-YOU-WISH "restart">
	 <COND (<Y?>
		<TELL "Restarting." CR>
		<DEFAULT-COLORS> ;"return to default colors before screen clears"
		<RESTART>
		<TELL ,FAILED>)>>

<ROUTINE DO-YOU-WISH (STRING)
	 <TELL CR "Do you really want to " .STRING " (y or n)? >">>

<ROUTINE FINISH ("AUX" (REPEATING <>) (CNT 0))
	 <PROG ()
	       <CRLF>
	       <COND (<NOT .REPEATING>
		      <SET REPEATING T>
		      <V-SCORE>)>
	       ;"<COND <IF-P-QUOTES
                 (,DO-WINDOW
                  <CREATE-WINDOW ,DO-WINDOW>)>
                 (ELSE"
		          <UPDATE-STATUS-LINE>;")>"
	       <TELL
"Would you like to start over, restore a saved position, ">
	       <COND (<AND <FLAG-ON? ,F-UNDO>
			   ;<NOT <EQUAL? ,HERE ,ROOM-OF-THREE-DOORS>>>
		      <TELL "undo your last turn, ">)>
	       <TELL "end this session of the game, or ">
	       <COND (<EQUAL? ,SCORE 1000>
		      <TELL "see the credits?" CR>)
		     (T
		      <TELL "get a hint?" CR>)>
	       <TELL "(Type RESTART, RESTORE, ">
	       <COND (<AND <FLAG-ON? ,F-UNDO>
			   ;<NOT <EQUAL? ,HERE ,ROOM-OF-THREE-DOORS>>>
		      <TELL "UNDO, ">)>
	       <TELL "QUIT, or ">
	       <COND (<EQUAL? ,SCORE 1000>
		      <TELL "CREDITS">)
		     (T
		      <TELL "HINT">)>
	       <TELL "): ">
	       <IF-P-IMAGES
           <COND (<L? <- <WINGET ,S-TEXT ,WWIDE>
			     <WINGET ,S-TEXT ,WXPOS>>
			  <* ,FONT-X 9>>
		      <CRLF>)>>
	       <TELL ">">
	       <PUTB ,P-LEXV 0 10>
	       <PUTB ,P-INBUF 1 0>
	       <COND ;(,DEMO-VERSION?
		      <READ-DEMO ,P-INBUF ,P-LEXV>)
		     (T
		      <READ ,P-INBUF ,P-LEXV>)>
	       <MOUSE-INPUT?>
	       <PUTB ,P-LEXV 0 ,LEXV-LENGTH>
	       <SET CNT <+ .CNT 1>>
	       <2CR-TO-PRINTER>
	       <COND (<EQUAL? <GET ,P-LEXV 1> ,W?RESTART>
		      <DEFAULT-COLORS> ;"return to default before screen clears"
	              <RESTART>
		      <TELL ,FAILED>
		      <AGAIN>)
	       	     (<AND <EQUAL? <GET ,P-LEXV 1> ,W?RESTORE>
		      	   <NOT <RESTORE>>>
		      <TELL ,FAILED>
		      <AGAIN>)
	       	     (<OR <EQUAL? <GET ,P-LEXV 1> ,W?QUIT ,W?Q>
			  <G? .CNT 10>>
		      ;<PARSER-REPORT>
		      <QUIT>)
		     (<AND <EQUAL? <GET ,P-LEXV 1> ,W?UNDO>
			   <V-UNDO>>
		      <AGAIN>)
		     (<AND <EQUAL? <GET ,P-LEXV 1> ,W?CREDIT ,W?CREDITS>>
		      <V-CREDITS>
		      <AGAIN>)
		     (<EQUAL? <GET ,P-LEXV 1> ,W?HINTS ,W?HINT ,W?HELP
			      		      ,W?CLUE ,W?CLUES>
		      <V-HINT>
		      <AGAIN>)>
	       <AGAIN>>>

<ROUTINE V-VERSION ()
	 <TELL 
"Moorbead: A interactive climax|
By Max Fog" CR>
	 <INTERPRETER-ID>
	 <TELL "Release " N <BAND <LOWCORE ZORKID> *3777*>>
	 <IF-P-IMAGES <PICINF 0 ,PICINF-TBL>>
	 <TELL " / Pix " N <GET ,PICINF-TBL 1> " / Serial number ">
	 <LOWCORE-TABLE SERIAL 6 PRINTC>
	 <CRLF>>

<ROUTINE INTERPRETER-ID ()
	 ;"changed 7/21/88 per mail from TAA"
	 ;"changed again 9/12/88 per mail from Duncan"
	 <TELL
<GET ,MACHINES <LOWCORE INTID>> " Interpreter version "
N <LOWCORE (ZVERSION 0)> "." N <LOWCORE INTVR> CR>>

<CONSTANT MACHINES
	  <PLTABLE "Debugging"
		  "Apple IIe"
		  "Macintosh"
		  "Amiga"
		  "Atari ST"
		  "IBM"
		  "Commodore 128"
		  "Commodore 64"
		  "Apple IIc"
		  "Apple IIgs"
		  ""
		  "">>

<ROUTINE MAC-II? ()
	 <COND (<EQUAL? <GET ,SL-LOC-TBL 10> 0>
		<RTRUE>)
	       (T
		<RFALSE>)>>

;<CONSTANT D-RECORD-ON 4>
;<CONSTANT D-RECORD-OFF -4>

;"<END-SEGMENT>
<BEGIN-SEGMENT STARTUP>"

<ROUTINE V-$COMMAND ()
	 <DIRIN 1>
	 <RTRUE>>

<ROUTINE V-$RANDOM ()
	 <COND (<NOT <PRSO? ,INTNUM>>
		<TELL "ILLEGAL." CR>)
	       (T
		<RANDOM <- 0 ,P-NUMBER>>
		<RTRUE>)>>

<ROUTINE V-$RECORD ()
	 <DIROUT ,D-RECORD-ON> ;"all READS and INPUTS get sent to command file"
	 <RTRUE>>

<ROUTINE V-$UNRECORD ()
	 <DIROUT ,D-RECORD-OFF>
	 <RTRUE>>

<ROUTINE V-$VERIFY ()
	 <COND (<AND <PRSO? ,INTNUM>
		     <EQUAL? ,P-NUMBER 232>>
		<TELL N ,SERIAL CR>)
	       (T
		<INTERPRETER-ID>
		<TELL "Verifying..." CR>
	 	<COND (<VERIFY>
		       <TELL ,OK>)
	       	      (T
		       <TELL "** Bad **" CR>)>)>>

<CONSTANT SERIAL 0>

;"<END-SEGMENT>
<BEGIN-SEGMENT STARTUP>"

<GLOBAL DEBUG <>>

<ROUTINE V-$DEBUG ()
	 <COND (,DEBUG
		<SETG DEBUG <>>
		<TELL "Nothing left, eh, boss?">)
	       (T
		<SETG DEBUG T>
		<TELL "Go catch 'em, boss!">)>
	 <TELL ,PERIOD-CR>>

<ROUTINE V-$SKIP ()
     <TELL "[I give up. We'll deal with this later.]" CR>
	 ;<COND (<NOT ,PRSO>
		<V-VERSION>
		<CRLF>
		<DEQUEUE I-PROLOGUE>
		<DEQUEUE I-GIVE-OBJECT>
		<DEQUEUE I-TAKE-OBJECT>
		<MOVE ,PARCHMENT ,GREAT-HALL>
		<MOVE ,CAULDRON ,BANQUET-HALL>
		<MOVE ,STRAW ,SCULLERY>
		<ROB ,PROTAGONIST>
	 	<REMOVE ,DIMWIT>
	 	<REMOVE ,MEGABOZ>
	 	<MOVE ,UNOPENED-NUT ,ROOT-CELLAR>
	 	<FCLEAR ,BANQUET-HALL ,TOUCHBIT>
	 	<FCLEAR ,SCULLERY ,TOUCHBIT>
	 	<FCLEAR ,KITCHEN ,TOUCHBIT>
	 	<FCLEAR ,ROOT-CELLAR ,ONBIT>
	 	<FCLEAR ,WINE-CELLAR ,ONBIT>
	 	<SETG UNDER-TABLE <>>
	 	;<SETG MID-NAME-NUM <- <TELL-RANDOM 12> 1>>
		<SETG MID-NAME-NUM <- <RANDOM 12> 1>>
		;<SETG DIAL-NUMBER <TELL-RANDOM 2400>>
		<SETG DIAL-NUMBER <RANDOM 2400>>
	 	;<SETG HOLEY-SLAB <GET ,SLAB-TABLE <- <TELL-RANDOM 7> 1>>>
		<SETG HOLEY-SLAB <GET ,SLAB-TABLE <- <RANDOM 7> 1>>>
	 	<MOVE ,CALENDAR ,GREAT-HALL>
		<MOVE ,PROCLAMATION ,ENTRANCE-HALL>
		<REMOVE ,TABLES>
		<REMOVE ,BANQUET-FOOD>
		<MOVE ,CROWN ,TREASURE-CHEST>
		<FSET ,CROWN ,TAKEBIT>
		<MOVE ,ROBE ,TRUNK>
		<FSET ,ROBE ,TAKEBIT>
	 	<GOTO ,GREAT-HALL>)
	       (T
		<MOVE ,CANDLE ,PROTAGONIST>
		<FSET ,PORTCULLIS ,OPENBIT>
		<FSET ,EAST-DOOR ,OPENBIT>
		<FSET ,WEST-DOOR ,OPENBIT>
		<SETG NUT-EATEN T>
		<SETG SECRET-PASSAGE-OPEN T>
		<FSET ,DRAWBRIDGE ,OPENBIT>
		<COND (<PRSO? ,CAULDRON>
		       <GOTO ,BANQUET-HALL>
		       <MOVE ,NOTEBOOK ,HERE>
		       <COND (<EQUAL? ,SACRED-WORD-NUMBER 10>
			      ;<SETG SACRED-WORD-NUMBER <- <TELL-RANDOM 10> 1>>
			      <SETG SACRED-WORD-NUMBER <- <RANDOM 10> 1>>)>
		       <MOVE ,CROWN ,HERE>
		       <MOVE ,SCEPTRE ,HERE>
		       <MOVE ,ZORKMID-BILL ,HERE>
		       <MOVE ,DIPLOMA ,HERE>
		       <FCLEAR ,DIPLOMA ,TRYTAKEBIT>
		       <FCLEAR ,DIPLOMA ,NDESCBIT>
		       <MOVE ,SILK-TIE ,HERE>
		       <MOVE ,STOCK-CERTIFICATE ,HERE>
		       <MOVE ,QUILL-PEN ,HERE>
		       <MOVE ,MANUSCRIPT ,HERE>
		       <MOVE ,VIOLIN ,HERE>
		       <MOVE ,METRONOME ,HERE>
		       <MOVE ,FAN ,HERE>
		       <MOVE ,FLASK ,HERE>
		       <MOVE ,SCREWDRIVER ,HERE>
		       <MOVE ,LANTERN ,HERE>
		       <FCLEAR ,LANTERN ,TRYTAKEBIT>
		       <MOVE ,SCALE-MODEL ,HERE>
		       <MOVE ,T-SQUARE ,HERE>
		       <MOVE ,BAT ,HERE>
		       <FCLEAR ,BAT ,TRYTAKEBIT>
		       <MOVE ,DUMBBELL ,HERE>
		       <MOVE ,LANCE ,HERE>
		       <MOVE ,SADDLE ,HERE>
		       <MOVE ,SPYGLASS ,HERE>
		       <FCLEAR ,SPYGLASS ,TRYTAKEBIT>
		       <MOVE ,SEAMANS-CAP ,HERE>
		       <MOVE ,EASLE ,HERE>
		       <MOVE ,LANDSCAPE ,HERE>)
		      (<PRSO? ,T-OF-B>
		       <GOTO ,JESTERS-QUARTERS>)
		      (<PRSO? ,PBOZ-OBJECT>
		       <GOTO ,PEG-ROOM>)
		      (<PRSO? ,DOUBLE-FANUCCI>
		       <GOTO ,CASINO>)
		      (<PRSO? ,HOTHOUSE>
		       <MOVE ,DIRIGIBLE ,SMALLER-HANGAR>
		       <GOTO ,HOTHOUSE>)
		      (<PRSO? ,REBUS>
		       <REMOVE ,REBUS-MOUSE>
		       <REMOVE ,REBUS-GOOSE>
		       <REMOVE ,REBUS-SLIME-MONSTER>
		       <REMOVE ,REBUS-CAMEL>
		       <REMOVE ,REBUS-SNAKE>
		       <REMOVE ,REBUS-FISH>
		       <FSET ,BASEMENT-REBUS-BUTTON ,TOUCHBIT>
		       <FSET ,CLOSET-REBUS-BUTTON ,TOUCHBIT>
		       <FSET ,CRAG-REBUS-BUTTON ,TOUCHBIT>
		       <FSET ,CRAWL-REBUS-BUTTON ,TOUCHBIT>
		       <FSET ,GROTTO-REBUS-BUTTON ,TOUCHBIT>
		       <FSET ,ATTIC-REBUS-BUTTON ,TOUCHBIT>
		       <GOTO ,GALLERY>)
		      (<PRSO? ,ORACLE-OBJECT>
		       <MOVE ,RUBY ,DEPRESSION>
		       <FSET ,RUBY ,NDESCBIT>
		       <FSET ,RUBY ,NALLBIT>
		       <MOVE ,AMULET ,PROTAGONIST>
		       <GOTO ,ORACLE>)
		      (<IN? ,PRSO ,ROOMS>
		       <GOTO ,PRSO>)
		      (T
		       <TELL ,HUH>)>)>>

;<END-SEGMENT>

;"subtitle real verbs"

;<BEGIN-SEGMENT 0>

<ROUTINE V-ALARM ()
	 <COND (<PRSO? ,ROOMS ,ME>
		<PERFORM-PRSA ,ME>
		<RTRUE>)
	       (<AND <FSET? ,PRSO ,ACTORBIT>
                 <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<COND (<FSET? ,PRSO ,FEMALEBIT>
		       <TELL "Sh">)
		      (T
		       <TELL "H">)>
		<TELL "e's wide awake, or haven't you noticed..." CR>)
	       (T
		<TELL "You're nuts." CR>)>>

;<ROUTINE V-APPLAUD ()
	 <TELL "\"Clap.\"" CR>>

<ROUTINE V-ASK-ABOUT ("AUX" OWINNER)
	 <COND (<PRSO? ,ME>
		<PERFORM ,V?TELL ,ME>
		<RTRUE>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<SET OWINNER ,WINNER>
		<SETG WINNER ,PRSO>
		<PERFORM ,V?TELL-ABOUT ,ME ,PRSI>
		<SETG WINNER .OWINNER>
		<THIS-IS-IT ,PRSI>
		<THIS-IS-IT ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TELL ,PRSO>
		<RTRUE>)>>

<ROUTINE V-ASK-FOR ()
	 <COND ;(<PRSO? ,BROGMOID>	;"moved to -F"
		<TELL ,TALK-TO-BROGMOID>)
	       (T
		<TELL "Unsurprisingly," T ,PRSO " doesn't oblige." CR>)>>

<ROUTINE V-ASK-NO-ONE-FOR ("AUX" ACTOR)
	 <COND (<SET ACTOR <FIND-IN ,HERE ,ACTORBIT>>
		<PERFORM ,V?ASK-FOR .ACTOR ,PRSO>
		<RTRUE>)
	       (T
		<PRINT "There's no one here to ">
		<TELL "ask." CR>)>>

<ROUTINE V-BEHEAD ("OPTIONAL" (CALLED-BY-V-HANG <>))
	 <TELL "You usually need a ">
	 <COND (.CALLED-BY-V-HANG
		<TELL "noose">)
	       (T
		<TELL "axe">)>
	 <TELL " to do this">
	 <COND (<AND <NOT <FSET? ,PRSO ,ACTORBIT>>
		     <NOT <EQUAL? ,PRSO ,ME>>>
		<TELL
", and besides, it doesn't look like" T ,PRSO " even has a ">
		<COND (.CALLED-BY-V-HANG
		       <TELL "neck">)
		      (T
		       <TELL "head">)>)>
	 <TELL ,PERIOD-CR>>

;<ROUTINE V-BEND ()
	 <COND (<EQUAL? ,P-PRSA-WORD ,W?SPREAD>
		<COND (<FSET? ,PRSO ,ACTORBIT>
		       <V-ENTER>)
		      (T
		       <HACK-HACK "Spreading">)>)
	       (T
	        <HACK-HACK "Bending">)>>

<ROUTINE V-BITE ()
	 <HACK-HACK "Biting">>

<ROUTINE V-BURN ()
	 <COND (<NOT ,PRSI>
		<COND (<SETG PRSI <FIND-IN ,PROTAGONIST ,FLAMEBIT>>
		       <TELL "[with" T ,PRSI "]" CR>
		       <PERFORM ,V?BURN ,PRSO ,PRSI>
		       <RTRUE>)
		      (T
		       <TELL "Your burning gaze is insufficient." CR>
		       <RTRUE>)>)>
	 <COND (<NOT <FSET? ,PRSI ,FLAMEBIT>>
		<TELL "With" A ,PRSI "??!?" CR>)
	       (<FSET? ,PRSO ,BURNBIT>
		<TELL "Instantly," T ,PRSO " catches fire and is consumed.">
		<COND (<ULTIMATELY-IN? ,PRSO>
		       <JIGS-UP
" Unfortunately, you were holding it at the time.">)
		      (T
		       <REMOVE ,PRSO>
		       <CRLF>)>)
	       ;(<PRSO? ,CANDLE>
		<FSET ,CANDLE ,FLAMEBIT>
		<FSET ,CANDLE ,ONBIT>
		<TELL "You relight the candle." CR>)
	       (T
		<TELL ,YOU-CANT "burn" AR ,PRSO>)>>

<ROUTINE V-BUY ()
	 <TELL "That's not for sale." CR>>

<ROUTINE V-CALL ()
	 <COND (<PRSO? ,INTQUOTE>
		<V-SAY>)
	       (<AND <VISIBLE? ,PRSO>
		     <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
	        <PERFORM ,V?TELL ,PRSO>
	        <RTRUE>)
	       (T
		<DO-FIRST "discover a telephone right in your hands! No, actually, you don't">)>>

<ROUTINE V-CATCH ()
	 <COND (,PRSI
		<TELL
"Sorry," T ,PRSI " isn't much help in catching" TR ,PRSO>)
	       (T
		<TELL "The only thing you're likely to catch is a cold." CR>)>>

<ROUTINE V-CHASTISE ()
	 <COND (<PRSO? ,INTDIR>
		<TELL
,YOULL-HAVE-TO "go in that direction to see what's there." CR>)
	       (T
		<USE-PREPOSITIONS "LOOK " "AT" "INSIDE" "UNDER">)>>

<ROUTINE USE-PREPOSITIONS (VRB PREP1 PREP2 PREP3)
	 <TELL
"[Use prepositions to indicate precisely what you want to do: " .VRB .PREP1
" the object, " .VRB .PREP2 " it, " .VRB .PREP3 " it, etc.]" CR>>

;<ROUTINE V-CHEER ()
	 <COND (<PRSO? ,ROOMS>
		<TELL ,OK>)
	       (T
		<TELL "Probably," T ,PRSO " is as happy as possible." CR>)>>

<ROUTINE V-CLEAN ()
	 <SETG AWAITING-REPLY 1>
	 <QUEUE I-REPLY 2>
	 <TELL "Do you also do windows?" CR>>

<ROUTINE V-CLIMB ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?UP>)
	       (<AND <ULTIMATELY-IN? ,PRSO>>
		<TELL ,HOLDING-IT>)
	       (T
		<IMPOSSIBLES>)>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?DOWN>)
	       (<AND <ULTIMATELY-IN? ,PRSO>>
		<TELL ,HOLDING-IT>)
	       (T
		<IMPOSSIBLES>)>>

<ROUTINE V-CLIMB-ON ()
	 <COND ;(<AND <PRSO? ,CAMEL>
		     <IN? ,PROTAGONIST ,CAMEL>
		     <EQUAL? ,P-PRSA-WORD ,W?RIDE>>
		<TELL
"[" ,YOULL-HAVE-TO "say which direction you want to ride in.]" CR>)
	       ;(<AND <PRSO? ,INTDIR>
		     <VISIBLE? ,CAMEL>>
		<COND (<IN? ,PROTAGONIST ,CAMEL>
		       <PERFORM ,V?RIDE-DIR ,CAMEL ,PRSO>
		       <RTRUE>)
		      (T
		       <DO-FIRST "mount" ,CAMEL>)>)                ;"FOR YOU GUYS"
	       (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (<AND <ULTIMATELY-IN? ,PRSO>>
		<TELL ,HOLDING-IT>)
	       (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?IN>
		<CANT-VERB-A-PRSO "climb into">)
	       (T
		<CANT-VERB-A-PRSO "climb onto">)>>

<ROUTINE V-CLIMB-OVER ()
	 <COND (<AND <ULTIMATELY-IN? ,PRSO>>
		<TELL ,HOLDING-IT>)
	       (T
	 	<IMPOSSIBLES>)>>

<ROUTINE V-CLIMB-UP ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?UP>)
	       (<AND <ULTIMATELY-IN? ,PRSO>>
		<TELL ,HOLDING-IT>)
	       (T
		<IMPOSSIBLES>)>>

<ROUTINE V-CLOSE ()
	 <COND (<OR <FSET? ,PRSO ,SURFACEBIT>
		    <FSET? ,PRSO ,ACTORBIT>
		    <AND <FSET? ,PRSO ,VEHBIT>>>
		<YOU-MUST-TELL-ME>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,CONTBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "Okay," T ,PRSO " is now closed." CR>
		       <NOW-DARK?>)
		      (T
		       <TELL ,ALREADY-IS>)>)
	       (T
		<YOU-MUST-TELL-ME>)>>

<ROUTINE V-COUGH ()
	<TELL
"Don't get sick over me! The stress of handling all your dumb commands
(ahem) is already enough. I don't need to get you medicine as well..." CR>>

<ROUTINE PRE-COUNT ()
	 <COND (<EQUAL? ,PRSO ,ROOMS>	;"multiple objects?"
		<TELL "There are " N ,P-MULT ,PERIOD-CR>)>>

<ROUTINE V-COUNT ()
	 <IMPOSSIBLES>>

<ROUTINE V-CRAWL-UNDER ()
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
	        <TELL-HIT-HEAD>)
	       (T
		<IMPOSSIBLES>)>>

<ROUTINE V-CROSS ()
	 <V-WALK-AROUND>>

<ROUTINE V-CUT ()
	 <COND (<NOT ,PRSI>
		<IMPOSSIBLES>)
	       (T
		<TELL "Strange concept, cutting" TR ,PRSO>)>>

<ROUTINE V-DATE ()
	 <TELL
"The date is......." CR>>

<ROUTINE V-DECODE ()
	 <TELL ,YOULL-HAVE-TO "figure it out yourself." CR>>

;<ROUTINE V-DEFLATE ()
	 <IMPOSSIBLES>>

<ROUTINE V-DIG ()
	 <COND ;(<PRSI? ,SHOVEL>
		<COND (<NOT <PRSO? ,GROUND>>
		       <IMPOSSIBLES>)
		      (<AND <NOT <FSET? ,HERE ,OUTSIDEBIT>>>
		       <TELL "The floor is a bit harder than the shovel." CR>)
		      (T
		       <TELL
"You dig a sizable hole but, finding nothing of interest, you fill it in
again out of consideration to future passersby and current gamewriters." CR>)>)
	       (T
		<TELL "Digging with">
		<COND (<ZERO? ,PRSI>
		       <TELL " your hands">)
		      (T
		       <TELL T ,PRSI>)>
		<TELL " is slow and tedious." CR>)>>

<ROUTINE V-DIG-WITH ()
	 <PERFORM ,V?DIG ,GROUND ,PRSO>
	 <RTRUE>>

;<ROUTINE V-DRESS ()
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,ACTORBIT>
		       <COND (<FSET? ,PRSO ,FEMALEBIT>
			      <TELL "Sh">)
			     (T
			      <TELL "H">)>
		       <TELL "e is dressed!" CR>)
		      (T
		       <IMPOSSIBLES>)>)
	       (T
		<SETG PRSO ,ROOMS>
		<V-GET-DRESSED>)>>

<ROUTINE V-DRINK ()
	 <COND (<FSET? ,PRSO ,WATERBIT>
		<PERFORM-PRSA ,WATER>)
	       (T
		<CANT-VERB-A-PRSO "drink">)>>

<ROUTINE V-DRINK-FROM ()
	 <COND (<FSET? ,PRSO ,WATERBIT>
		<PERFORM ,V?DRINK ,WATER>
		<RTRUE>)
	       (T
	        <IMPOSSIBLES>)>>

<ROUTINE V-DRINK-WITH ()
	<TELL ,YOU-CANT "drink something with" AR ,PRSI>>

<ROUTINE V-DROP ("AUX" CHESSPIECE)
	 <COND ;(<IN? ,PRSO ,WALDO>
		<COND (<EQUAL? ,HERE ,HOLD>
		       <MOVE ,PRSO ,HOLD>)
		      (T
		       <MOVE ,PRSO ,LAKE-BOTTOM>)>
		<TELL "You release" TR ,PRSO>)
	       (<NOT <SPECIAL-DROP ,PRSO>>
		<COND (<FSET? <LOC ,PROTAGONIST> ,DROPBIT>
		       <MOVE ,PRSO <LOC ,PROTAGONIST>>)
		      (T
		       <MOVE ,PRSO ,HERE>)>
		<COND ;(<PRSO? ,LARGE-FLY ,LARGER-FLY
			      ,EVEN-LARGER-FLY ,LARGEST-FLY>
		       <TELL "You release" T ,PRSO>)
		      (T
		       <TELL "Dropped">)>
		 <TELL ,PERIOD-CR>)>> 

<ROUTINE SPECIAL-DROP (OBJ "OPT" (CALLED-BY-ROB <>)) ;"else drop or throw"
	 <COND ;(<EQUAL? ,HERE ,UNDER-THE-WORLD ,HANGING-FROM-ROOTS>
		<TELL
"As you release" T ,PRSO ", it dwindles into the mist and is gone
from this world forever." CR>
		<RTRUE>)
	       (T
	 	<RFALSE>)>>

<ROUTINE PRE-INGEST ()
	 <>>

<ROUTINE V-EAT ()
	 <TELL "It's not likely that" T ,PRSO " would agree with you." CR>>

<ROUTINE V-EMPTY ("AUX" OBJ NXT)
	 <COND (<NOT ,PRSI>
		<SETG PRSI ,GROUND>)>
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL ,HUH>)
	       (<NOT <FSET? ,PRSO ,OPENBIT>>
		<TELL "But" T ,PRSO " isn't open." CR>)
	       (<NOT <FIRST? ,PRSO>>
		<TELL "But" T ,PRSO " is already empty!" CR>)
	       (<AND <PRSI? <FIRST? ,PRSO>>
		     <NOT <NEXT? ,PRSI>>>
		<TELL ,THERES-NOTHING "in" T ,PRSO " but" TR ,PRSI>)
	       (T
		<SET OBJ <FIRST? ,PRSO>>
		<REPEAT ()
			<SET NXT <NEXT? .OBJ>>
			<COND (<NOT <EQUAL? .OBJ ,PROTAGONIST>>
			       <TELL D .OBJ ": ">
			       <COND (<FSET? .OBJ ,TAKEBIT>
				      <MOVE .OBJ ,PROTAGONIST>
				      <COND (<PRSI? ,HANDS>
					     <TELL "You take" TR .OBJ>)
					    (<PRSI? ,GROUND>
					     <PERFORM ,V?DROP .OBJ>)
					    (<FSET? ,PRSI ,SURFACEBIT>
					     <PERFORM ,V?PUT-ON .OBJ ,PRSI>)
					    (T
					     <PERFORM ,V?PUT .OBJ ,PRSI>)>)
				     (T
				      <YUKS>)>)>
			<COND (.NXT
			       <SET OBJ .NXT>)
			      (T
			       <RETURN>)>>)>>

<ROUTINE V-EMPTY-FROM ()
	 <COND (<IN? ,PRSO ,PRSI>
		<COND (<FSET? ,PRSO ,TAKEBIT>
		       <MOVE ,PRSO ,PROTAGONIST>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
		      (T
		       <YUKS>)>)
	       (T
		<NOT-IN>)>>

<ROUTINE PRE-ENTER ()
	 <COND (<IN? ,PROTAGONIST ,PRSO>
		<TELL ,LOOK-AROUND>)	       
	       (<AND <ULTIMATELY-IN? ,PRSO>>
		<TELL ,HOLDING-IT>)
	       (<UNTOUCHABLE? ,PRSO>
		<CANT-REACH ,PRSO>)
	       (<AND <FSET? ,PRSO ,VEHBIT>
		     <NOT <IN? ,PRSO ,HERE>>>
		<TELL
,YOULL-HAVE-TO "remove" T ,PRSO " from" T <LOC ,PRSO> " first." CR>)>>

<ROUTINE V-ENTER ("AUX" DIR)
	<COND (<PRSO? ,INTDIR> ;"for example, ENTER EAST"
	       <DO-WALK <DIRECTION-CONVERSION>>)
	      (<FSET? ,PRSO ,WATERBIT>
	       <PERFORM-PRSA ,WATER>)
	      (<FSET? ,PRSO ,DOORBIT>
	       <DO-WALK <OTHER-SIDE ,PRSO>>
	       <RTRUE>)
	      (<FSET? ,PRSO ,VEHBIT>
	       <COND (<NOT <EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS>>
		      <TELL ,YOU-CANT "board" T ,PRSO " when it's ">
		      <COND (<FSET? <LOC ,PRSO> ,SURFACEBIT>
			     <TELL "on">)
			    (T
			     <TELL "in">)>
		      <TELL TR <LOC ,PRSO>>)
		     (T
		      <MOVE ,PROTAGONIST ,PRSO>
		      <SETG OLD-HERE <>>
		      <TELL "You are now ">
		      <COND (<FSET? ,PRSO ,INBIT>
		       	     <TELL "in">)
		      	    (T
		       	     <TELL "on">)>
		      <TELL T ,PRSO ".">
		      <COND (<NOT <APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>>
			     <CRLF>)>
		      <FSET ,PRSO ,TOUCHBIT>)>)
	      (<IN? ,PRSO ,ROOMS>
	       <COND (<SET DIR <FIND-NEXT-ROOM>>
		      <DO-WALK .DIR>)
		     (T
		      <V-WALK-AROUND>)>)
	      (<NOT <FSET? ,PRSO ,TAKEBIT>>
	       <TELL-HIT-HEAD>)
	      (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?IN>
	       <CANT-VERB-A-PRSO "get into">)
	      (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?ON>
	       <CANT-VERB-A-PRSO "get onto">)
	      (T
	       <SETG AWAITING-REPLY 1>
	       <QUEUE I-REPLY 2>
	       <TELL
"You have a theory on how to board" A ,PRSO ", perhaps?" CR>)>>

<ROUTINE FIND-NEXT-ROOM ("AUX" PT PTS (DIR 0) ;(CNT 0))
	 <REPEAT ()
		 <SET DIR <NEXTP ,HERE .DIR>>
		 <COND (<OR <ZERO? .DIR>
			    <L? .DIR ,LOW-DIRECTION>>
			;<EQUAL? .CNT 10>
			<RETURN <>>)>
		 ;<SET DIR <GET ,DIRECTION-TABLE .CNT>>
		 <COND (<SET PT <GETPT ,HERE .DIR>>
			<SET PTS <PTSIZE .PT>>
			<COND (<EQUAL? .PTS ,UEXIT ,CEXIT>
			       <COND (<EQUAL? <GETB .PT ,REXIT> ,PRSO>
				      <RETURN .DIR>)>)
			      (<EQUAL? .PTS ,DEXIT>
			       <COND (<EQUAL? <GETB .PT ,DEXITRM> ,PRSO>
				      <RETURN .DIR>)>)>)>
		 ;<SET CNT <+ .CNT 1>>>>

;<CONSTANT DIRECTION-TABLE
	  <TABLE ,P?NORTH
		 ,P?NE
		 ,P?EAST
		 ,P?SE
		 ,P?SOUTH
		 ,P?SW
		 ,P?WEST
		 ,P?NW
		 ,P?UP
		 ,P?DOWN>>

<ROUTINE V-EXAMINE ()
	 <COND (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>>
		<IMPOSSIBLES>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<COND (<FIRST? ,PRSO>
		       <PERFORM ,V?LOOK-INSIDE ,PRSO>
		       <RTRUE>)
		      (T
		       <NOTHING-INTERESTING>
		       <TELL "about" TR ,PRSO>)>)
	       (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE>)
	       (<FSET? ,PRSO ,DOORBIT>
		<TELL ,IT-SEEMS-THAT T ,PRSO " is ">
		<OPEN-CLOSED ,PRSO>
		<TELL ,PERIOD-CR>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>			    
		       <V-LOOK-INSIDE>)
		      (T
		       <TELL HS ,PRSO "closed.">
		       <COND (<AND <FSET? ,PRSO ,TRANSBIT>
				   <FIRST? ,PRSO>>
			      <TELL " ">
			      <V-LOOK-INSIDE>)
			     (T
			      <CRLF>)>)>)
	       (<FSET? ,PRSO ,LIGHTBIT>
		<TELL HS ,PRSO "o">
		<COND (<FSET? ,PRSO ,ONBIT>
		       <TELL "n">)
		      (T
		       <TELL "ff">)>
		<TELL ,PERIOD-CR>)
	       (<FSET? ,PRSO ,READBIT>
		<PERFORM ,V?READ ,PRSO>
		<RTRUE>)
	       (<IN? ,PRSO ,ROOMS>
		<PRINT "You can't see much">
		<TELL " from here." CR>)
	       (<FSET? ,PRSO ,NARTICLEBIT>
		<SENSE-OBJECT "look">)
	       (<PROB 25>
		<TELL "Totally ordinary looking " D ,PRSO ,PERIOD-CR>)
	       (<OR <PROB 60>
		    <FSET? ,PRSO ,PLURALBIT>
		    <PRSO? ,GROUND>>
		<NOTHING-INTERESTING>
		<TELL "about" TR ,PRSO>)
	       (T
	        <PRONOUN>
		<TELL " look">
		<COND (<AND <NOT <FSET? ,PRSO ,PLURALBIT>>
			    <NOT <PRSO? ,ME>>>
		       <TELL "s">)>
		<TELL " like every other " D ,PRSO " you've ever seen." CR>)>>

<ROUTINE NOTHING-INTERESTING ()
	 <TELL ,THERES-NOTHING>
	 <COND (<PROB 25>
		<TELL "unusual">)
	       (<PROB 33>
		<TELL "noteworthy">)
	       (<PROB 50>
		<TELL "eye-catching">)
	       (T
		<TELL "special">)>
	 <TELL " ">>

<ROUTINE V-EXIT ()
	 <COND (<OR <NOT ,PRSO>
		    <PRSO? ,ROOMS>>
		<COND (<NOT <IN? ,PROTAGONIST ,HERE>>
		       <PERFORM ,V?EXIT <LOC ,PROTAGONIST>>
		       <RTRUE>)
		      (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?DOWN>
		       <TELL "You're not on anything." CR>)
		      (T
		       <DO-WALK ,P?OUT>)>)
	       (<EQUAL? ,P-PRSA-WORD ,W?TAKE> ;"since GET OUT is also TAKE OUT"
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<NOT <IN? ,PROTAGONIST ,PRSO>>
		<SETG P-CONT -1> ;<RFATAL>
		<TELL ,LOOK-AROUND>)
           (T
		<MOVE ,PROTAGONIST ,HERE>
		<SETG OLD-HERE <>>
		<TELL "You get ">
		<COND (<FSET? ,PRSO ,INBIT>
		       <TELL "out of">)
		      (T
		       <TELL "off">)>
		<TELL T ,PRSO ".">		
		<CRLF>)>>

<ROUTINE V-FEED ()
         <TELL "You have no food for" TR ,PRSO>>

<ROUTINE PRE-FILL ()
	 <COND (,PRSI
		<RFALSE>)
	       (<FIND-WATER>
		<SETG PRSI ,WATER>
		<RFALSE>)
	       ;(<AND <VISIBLE? ,LARGE-VIAL-WATER>
		     <VISIBLE? ,SMALL-VIAL-WATER>>
		<COND (<PRSO? ,SMALL-VIAL>
		       <PERFORM ,V?EMPTY ,LARGE-VIAL ,SMALL-VIAL>
		       <RTRUE>)
		      (<PRSO? ,LARGE-VIAL>
		       <PERFORM ,V?EMPTY ,SMALL-VIAL ,LARGE-VIAL>
		       <RTRUE>)
		      (T
		       <TELL
"[" ,YOULL-HAVE-TO "specify which water you mean, the large vial
or the small vial.]" CR>)>)                ;"I HATE IT WHEN THIS SORT OF THING HAPPENS..."
	       (T
		<PERFORM ,V?FILL ,PRSO ,WATER>
		<RTRUE>)>>

<ROUTINE V-FILL ()
	 <COND (<FSET? ,PRSI ,WATERBIT>
		<PERFORM-PRSA ,PRSO ,WATER>)
	       (T
	 	<IMPOSSIBLES>)>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<NOT .L>
		<PRONOUN>
		<TELL " could be anywhere!" CR>)
	       (<IN? ,PRSO ,PROTAGONIST>
		<TELL "You have it!" CR>)
	       (<IN? ,PRSO ,HERE>
		<TELL "Right in front of you." CR>)
	       (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<V-DECODE>)
	       (<AND <FSET? .L ,ACTORBIT>
		     <VISIBLE? .L>>
		<TELL "Looks as if" T .L " has it." CR>)
	       (<AND <FSET? .L ,CONTBIT>
		     <VISIBLE? ,PRSO>
		     <NOT <IN? .L ,GLOBAL-OBJECTS>>>
		<COND (<FSET? .L ,SURFACEBIT>
		       <TELL "O">)
		      (<AND <FSET? .L ,VEHBIT>
			    <NOT <FSET? .L ,INBIT>>>
		       <TELL "O">)
		      (T
		       <TELL "I">)>
		<TELL "n" TR .L>)
	       (T
		<V-DECODE>)>>

<ROUTINE V-FLY ()
	 <COND (T
		<IMPOSSIBLES>)>>

<ROUTINE V-FOLLOW ()
	 <COND (<VISIBLE? ,PRSO>
		<TELL "But" T-IS-ARE ,PRSO "right here!" CR>)
	       (<NOT <FSET? ,PRSO ,ACTORBIT>>
		<IMPOSSIBLES>)
	       (T
		<TELL "You have no idea where" T ,PRSO>
		<COND (<FSET? ,PRSO ,PLURALBIT>
		       <TELL " are">)
		      (T
		       <TELL " is">)>
		<TELL ,PERIOD-CR>)>>

;<GLOBAL FOLLOW-FLAG <>>

;<ROUTINE I-FOLLOW ()
	 <SETG FOLLOW-FLAG <>>
	 <RFALSE>>

<ROUTINE PRE-GIVE ()
	 <COND (<AND <VERB? GIVE>
		     <PRSO? ,HANDS>>
		<PERFORM ,V?SHAKE-WITH ,PRSI>
		<RTRUE>)
	       (<PRSO? ,EYES>
		;<PRE-SWITCH>
		<PERFORM ,V?EXAMINE ,PRSI ,EYES>
		<RTRUE>)
	       ;(<AND <EQUAL? ,P-PRSA-WORD ,W?FEED>
		     <NOT <FSET? ,PRSO ,FOODBIT>>>
		<TELL "That's not food!" CR>)
	       (<IDROP>
		<RTRUE>)>>

<ROUTINE PRE-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SGIVE ()
    <V-FOO>>

<ROUTINE V-GET-NEAR ()
	 <WASTES>>

<ROUTINE V-GIVE ()
	 <COND (<FSET? ,PRSI ,ACTORBIT>
		<TELL "Briskly," T ,PRSI " refuse">
		<COND (<NOT <FSET? ,PRSI ,PLURALBIT>>
		       <TELL "s">)>
		<TELL " your offer." CR>)
	       (T
		<TELL ,YOU-CANT "give" A ,PRSO " to" A ,PRSI "!" CR>)>> 
		 
<ROUTINE V-GIVE-UP ()
	 <COND (<PRSO? ,ROOMS>
		<V-QUIT>)
	       (T
		<RECOGNIZE>)>>

<ROUTINE V-HANG ()
	 <V-BEHEAD T>>

<ROUTINE V-HELLO ()
       <COND (,PRSO
	      <TELL
"[The proper way to talk to characters in the story is PERSON, HELLO.">
	      <COND (<PRSO? ,SAILOR>
		     <TELL " Besides, nothing happens here.">)>
	      <TELL "]" CR>)
	     (T
	      <PERFORM ,V?TELL ,ME>
	      <RTRUE>)>>

<ROUTINE V-HIDE ()
	 <TELL ,YOU-CANT "hide ">
	 <COND (,PRSO
		<TELL "t">)>
	 <TELL "here." CR>>

<ROUTINE V-HINTS-NO ()
	 <COND (<NOT <PRSO? ,ROOMS>>
		<RECOGNIZE>
		<RTRUE>)
	       (<EQUAL? ,HINTS-OFF 1>
		<TELL "[You've already deactivated">)
	       (T
		<SETG HINTS-OFF 1>
		<TELL "[Okay, you will no longer have access to">)>
	 <TELL " help in this session.]" CR>>

<ROUTINE V-IN ()
	 <DO-WALK ,P?IN>>

<ROUTINE V-INFLATE ()
	 <IMPOSSIBLES>>

<ROUTINE V-KICK ()
	 <HACK-HACK "Kicking">>

<ROUTINE V-KILL ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL "Trying to kill" A ,PRSO " with">
		<COND (,PRSI
		       <TELL A ,PRSI>)
		      (T
		       <TELL " your bare hands">)>
		<TELL " is suicidal." CR>)
	       (T
		<TELL "How strange, fighting" A ,PRSO "!" CR>)>>

<ROUTINE V-KISS ()
	<TELL "I'd sooner kiss a pig." CR>>

;<ROUTINE V-KNEEL ()
	 <COND (<EQUAL? ,P-PRSA-WORD ,W?BOW>
		<TELL "You begin to get a sore waist." CR>)
	       (T
	 	<TELL "You begin to get a sore knee." CR>)>>

<ROUTINE V-KNOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<TELL "Nobody's home." CR>)
	       (T
		<HACK-HACK "Knocking on">)>>
		
;<ROUTINE V-LAND ()
	 <COND (<AND <NOT ,PRSO>
		     <EQUAL? <LOC ,PROTAGONIST> ,RAFT ,BARGE>>
		<PERFORM-PRSA <LOC ,PROTAGONIST>>
		<RTRUE>)
	       (T
	 	<TELL ,HUH>)>>

<ROUTINE V-LEAD-TO ()
	 <COND (T
	 	<TELL
"It doesn't look like you'll be leading" T ,PRSO " anywhere, let alone
to" TR ,PRSI>)>>

<ROUTINE V-LEAP ()
	 <COND (<PRSO? <> ,ROOMS>
		<COND (<JUMPLOSS>
		       <RTRUE>)
		      (T
		       <V-SKIP>)>)
	       (<PRSO? ,INTDIR>
		<TELL "Interesting concept. However, we're not in Zork Zero anymore." CR>)
	       (<NOT <IN? ,PRSO ,HERE>>
		<IMPOSSIBLES>)
	       (<JUMPLOSS>
		<RTRUE>)
	       (T
		<V-SKIP>)>>

<ROUTINE JUMPLOSS ()
	 <COND ;(<EQUAL? ,HERE ,PARAPET ,UPPER-LEDGE ,LOWER-LEDGE
			      ,G-U-MOUNTAIN ,BALCONY ,ROOF ,QUARRYS-EDGE>
		<COND (<PROB 33>
		       <TELL "Geronimo">)
		      (<PROB 50>
		       <TELL "You should have looked before you leapt">)
		      (T
		       <TELL "This was not a very good place to try jumping">)>
		<JIGS-UP "!">)                                  ;"If you have a similar place, re-add this"
	       (T
		<RFALSE>)>>

<ROUTINE V-LEAP-OFF ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?EXIT ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?LEAP ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LEAVE ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?OUT>)
	       (<IN? ,PROTAGONIST ,PRSO>
		<PERFORM ,V?EXIT ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LET-OUT ()
	 <TELL "But" T ,PRSO " isn't all that confined." CR>>

;<ROUTINE V-LICK ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?EAT ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TASTE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LIE-DOWN ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (<AND <PRSO? ,ROOMS>
		     <EQUAL? ,HERE ,BEDROOM>>
		<PERFORM ,V?ENTER ,BED>
		<RTRUE>)
	       (T
		<WASTES>)>>

<ROUTINE PRE-LISTEN ()
	 <>
     ;<COND (,TIME-STOPPED
		<TELL "Unremitting silence." CR>)>>

<ROUTINE V-LISTEN ("AUX" PLANT)
	 <COND (,PRSO
	 	<SENSE-OBJECT "sound">)
	       (T
		<TELL "You hear nothing of interest." CR>)>>

<ROUTINE PRE-LOCK ("AUX" KEY)
	 <COND (<NOT ,PRSI>
		<COND (<SET KEY <FIND-IN ,PROTAGONIST ,KEYBIT>>
		       <SETG PRSI .KEY>
		       <TELL "[with" T .KEY "]" CR>
		       <RFALSE>)
		      (T
		       <SETG AWAITING-REPLY 1>
		       <QUEUE I-REPLY 2>
		       <TELL "What? With your nose?" CR>)>)>>

<ROUTINE V-LOCK ("AUX" KEY)
	 <COND (<FSET? ,PRSO ,LOCKEDBIT>
		<TELL ,ALREADY-IS>)
	       (<OR <FSET? ,PRSO ,DOORBIT>>
		<TELL "Unfortunately," T ,PRSI " doesn't lock" TR ,PRSO>)
	       (T
		<TELL ,YOU-CANT "lock" AR ,PRSO>)>>

<ROUTINE PRE-LOOK ()
	 <COND (<NOT ,LIT>
		<TELL ,TOO-DARK CR>)
	       (<AND <VERB? READ>
		     <UNTOUCHABLE? ,PRSO>
		     <FSET? ,PRSO ,TAKEBIT>>
		<TELL ,YNH TR ,PRSO>)>>

<ROUTINE V-LOOK ()
	 <COND (<D-ROOM T>
		<D-OBJECTS>)>
	 <RTRUE>>

<ROUTINE V-LOOK-BEHIND ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)>
	 <TELL "There is nothing behind" TR ,PRSO>>

<ROUTINE V-LOOK-DOWN ()
	 <COND (<PRSO? ,ROOMS>
		<PERFORM ,V?EXAMINE ,GROUND>
		<RTRUE>)
	       (T
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LOOK-INSIDE ("AUX" (X-RAYED <>))
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL ,IT-SEEMS-THAT T ,PRSO " has">
		<COND (<NOT <D-NOTHING>>
		       <TELL ,PERIOD-CR>)>
		<RTRUE>)
	       (<IN? ,PROTAGONIST ,PRSO>
		<D-VEHICLE>)
	       (<FSET? ,PRSO ,DOORBIT>
		<TELL "All you can tell is that" T ,PRSO " is ">
		<OPEN-CLOSED ,PRSO>
		<TELL ,PERIOD-CR>)
	       ;(<EQUAL? <GET ,P-ITBL ,P-PREP1> ,PR?OUT ,W?OUTSIDE>
		<TELL "You see nothing special." CR>)
	       (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?OUT>
		<TELL "You see nothing special." CR>)
	       (<FSET? ,PRSO ,SURFACEBIT>		
		<TELL "On the surface of" T ,PRSO " you see">
		<COND (<NOT <D-NOTHING>>
		       <TELL ,PERIOD-CR>)>
		<RTRUE>)
	       (<AND <FSET? ,PRSO ,VEHBIT>
		     <NOT <FIRST? ,PRSO>>>
		;"if you're in it, it's handled above"
		<COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <DO-FIRST "open" ,PRSO>
		       <RTRUE>)>
		<TELL "There is no one ">
		<COND (<FSET? ,PRSO ,INBIT>
		       <TELL "i">)
		      (T
		       <TELL "o">)>
		<TELL "n" TR ,PRSO>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<SEE-INSIDE? ,PRSO>
		       <TELL "Within" T ,PRSO " you see">
		       <COND (<NOT <D-NOTHING>>
		              <TELL ,PERIOD-CR>)>
		       <RTRUE>)
		      (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
			    <FIRST? ,PRSO>
			    <EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?IN>
			   ;<EQUAL? <GET ,P-ITBL ,P-PREP1> ,PR?IN ;,PR?INSIDE>>
		       <COND (<UNTOUCHABLE? ,PRSO>
			      <CANT-REACH ,PRSO>
			      <RTRUE>)>
		       <PERFORM ,V?OPEN ,PRSO>
		       <RTRUE>)
		      (T
		       <DO-FIRST "open" ,PRSO>)>)
	       ;(<EQUAL? <GET ,P-ITBL ,P-PREP1> ,PR?IN ;,PR?INSIDE>
		<CANT-VERB-A-PRSO "look inside">)
	       (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?IN>
		<CANT-VERB-A-PRSO "look inside">)
	       (T
		<CANT-VERB-A-PRSO "look through">)>>

<ROUTINE V-LOOK-OVER ()
	 <V-EXAMINE>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<AND <ULTIMATELY-IN? ,PRSO>>
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "You see yourself." CR>)
		      (T
		       <TELL ,HOLDING-IT>)>)
	       (<FSET? ,PRSO ,WATERBIT>
		<PERFORM-PRSA ,WATER>)
	       (T
		<TELL "There is nothing but ">
		<COND (<PRSO? ,WATER>
		       <TELL "more water">)
		      (T
		       <TELL "dust">)>
		<TELL " there." CR>)>>

;<ROUTINE V-LOVE ()
	 <TELL "Not difficult, considering how lovable" T ,PRSO " ">
	 <COND (<FSET? ,PRSO ,PLURALBIT>
		<TELL "are">)
	       (T
		<TELL "is">)>
	 <TELL ,PERIOD-CR>>

<ROUTINE V-LOWER ()
	 <V-RAISE>>

;<ROUTINE V-MAKE ()
	 <TELL ,YOU-CANT "just make" A ,PRSO " out of thin air." CR>>

;<ROUTINE V-MAKE-WITH ()
	 <PERFORM ,V?SET ,PRSI ,PRSO>
	 <RTRUE>>

<IF-P-IMAGES                 ;"As with pervious times, I'm not dealing with this.... SIGH"
<GLOBAL MAP-NOTE <>>

<GLOBAL CHANGED-MAP-WARNING <>>

<CONSTANT MAIN-MAP-NUM 1>
<CONSTANT SECRET-WING-MAP-NUM 2>
<CONSTANT VILLAGE-MAP-NUM 3>
<CONSTANT LOWER-LEVEL-MAP-NUM 4>
<CONSTANT LAKE-MAP-NUM 5>
<CONSTANT DESERT-MAP-NUM 6>
<CONSTANT FOOZLE-MAP-NUM 7>
<CONSTANT FENSHIRE-MAP-NUM 8>
<CONSTANT FJORD-MAP-NUM 9>
<CONSTANT GRAY-MOUNTAINS-MAP-NUM 10>
<CONSTANT DELTA-MAP-NUM 11>
<CONSTANT FUBLIO-MAP-NUM 12>
<CONSTANT ANTHARIA-MAP-NUM 13>

<GLOBAL MAP-TOP-LEFT-X 0>
<GLOBAL MAP-TOP-LEFT-Y 0>
<GLOBAL MAP-ELEMENT-WIDTH 0>
<GLOBAL MAP-ELEMENT-HEIGHT 0>
<GLOBAL MAP-BOX-WIDTH 0>
<GLOBAL MAP-BOX-HEIGHT 0>
<GLOBAL MAP-SPACE-WIDTH 0>
<GLOBAL MAP-SPACE-HEIGHT 0>

<CONSTANT MAP-GEN-X-1 0>
<CONSTANT MAP-GEN-X-2 -1>
<CONSTANT MAP-GEN-X-3 -2>
<CONSTANT MAP-GEN-X-4 -3>
<CONSTANT MAP-GEN-X-5 -4>
<CONSTANT MAP-GEN-X-6 -5>
<CONSTANT MAP-GEN-X-7 -6>
<CONSTANT MAP-GEN-X-8 -7>
<CONSTANT MAP-GEN-X-9 -8>
<CONSTANT MAP-GEN-X-10 -9>
<CONSTANT MAP-GEN-X-11 -10>
<CONSTANT MAP-GEN-Y-1 0>
<CONSTANT MAP-GEN-Y-2 -1>
<CONSTANT MAP-GEN-Y-3 -2>
<CONSTANT MAP-GEN-Y-4 -3>
<CONSTANT MAP-GEN-Y-5 -4>
<CONSTANT MAP-GEN-Y-6 -5>
<CONSTANT MAP-GEN-Y-7 -6>

<CONSTANT MAP-PICSET-TBL
	  <TABLE N-S-CON
		 E-W-CON
		 NE-SW-CON
		 NW-SE-CON
		 ICONLESS-ROOM-BOX
		 YOU-ARE-HERE-SYMBOL
		 MAP-N-HL
		 MAP-NE-HL
		 MAP-E-HL
		 MAP-SE-HL
		 MAP-S-HL
		 MAP-SW-HL
		 MAP-W-HL
		 MAP-NW-HL
		 MAP-N-UNHL
		 MAP-NE-UNHL
		 MAP-E-UNHL
		 MAP-SE-UNHL
		 MAP-S-UNHL
		 MAP-SW-UNHL
		 MAP-W-UNHL
		 MAP-NW-UNHL
		 DOWN-NORTH-SYMBOL
		 DOWN-SOUTH-SYMBOL
		 DOWN-EAST-SYMBOL
		 DOWN-WEST-SYMBOL
		 DOWN-NE-SYMBOL
		 DOWN-NW-SYMBOL
		 DOWN-SW-SYMBOL
		 DOWN-SE-SYMBOL
		 ;"stuff room icons in these 20 slots, ending with a zero"
		 <> <> <> <> <>
		 <> <> <> <> <>
		 <> <> <> <> <>
		 <> <> <> <> <> >>

<CONSTANT MAIN-ICON-TBL
	<PLTABLE GONDOLA-ICON
		PEG-ROOM-ICON
		WEST-WING-ICON
		GYM-ICON
		TORCH-ROOM-ICON
		ROOF-ICON
		PARLOR-ICON
		FORMAL-GARDEN-ICON
		BALCONY-ICON
		GALLERY-ICON
		THRONE-ROOM-ICON
		BANQUET-HALL-ICON
		KITCHEN-ICON
		WINE-CELLAR-ICON
		LIBRARY-ICON
		EAST-WING-ICON
		CHAPEL-ICON
		J-QUARTER-ICON
		PYRAMID-ICON
		0>>

<CONSTANT SECRET-WING-ICON-TBL
	 <PLTABLE DIMWITS-ROOM-ICON
		 MAGIC-CLOSET-ICON
		 PARAPET-ICON
		 BASTION-ICON
		 SECRET-PASSAGE-ICON
		 TEE-ICON
		 TOP-OF-STAIR-ICON
		 BOTTOM-OF-STAIR-ICON
		 ORACLE-ICON
		 DUNGEON-ICON
		 CELL-ICON
		 0>>

<CONSTANT VILLAGE-ICON-TBL
	 <PLTABLE PERIMETER-WALL-ICON
		 GARRISON-ICON
		 OUTER-BAILEY-ICON
		 DRAWBRIDGE-ICON
		 BARBICAN-ICON
		 UPPER-BARBICAN-ICON
		 CAUSEWAY-ICON
		 INNER-BAILEY-ICON
		 URS-OFFICE-ICON
		 SHADY-PARK-ICON
		 CHURCH-ICON
		 COURTROOM-ICON
		 POST-OFFICE-ICON
		 FR-HQ-ICON
		 MAGIC-SHOP-ICON
		 BACK-ALLEY-ICON
		 OFFICES-ICON
		 PENTHOUSE-ICON
		 0>>

<CONSTANT LOWER-LEVEL-ICON-TBL
	 <PLTABLE ROOTS-ICON
		 EAR-ICON
		 MOUTH-OF-CAVE-ICON
		 LEDGE-IN-PIT-ICON
		 PASSAGE-STORAGE-ICON
		 VAULT-ICON
		 G-U-HIGHWAY-ICON
		 EXIT-ICON
		 KENNELS-ICON
		 ROYAL-ZOO-ICON
		 LABORATORY-ICON
		 0>>

<CONSTANT LAKE-ICON-TBL
	 <PLTABLE HOLD-ICON
		 UNDERWATER-ICON
		 LAKE-BOTTOM-ICON
		 EAST-SHORE-ICON
		 WEST-SHORE-ICON
		 NORTH-SHORE-ICON
		 SOUTH-SHORE-ICON
		 LAKE-FLATHEAD-ICON
		 RING-OF-DUNES-ICON
		 G-U-SAVANNAH-ICON
		 BATS-LAIR-ICON
		 BASE-OF-MT-ICON
		 G-U-MOUNTAIN-ICON
		 STABLE-ICON
		 SHRINE-ICON
		 0>>

<CONSTANT DESERT-ICON-TBL
	 <PLTABLE CACTUS-PATCH-ICON
		 TALL-DUNES-ICON
		 G-U-OASIS-ICON
		 0>>

<CONSTANT FOOZLE-ICON-TBL
	 <PLTABLE WHARF-ICON
		 FISHING-VILLAGE-ICON
		 QUILBOZZA-BEACH-ICON
		 WARNING-ROOM-ICON
		 FISHY-ODOR-ICON
		 ROOM-OF-3-DOORS-ICON
		 FORK-ICON
		 WISHYFOO-ICON
		 REST-STOP-ICON
		 CROSSROADS-ICON
		 TOLL-PLAZA-ICON
		 FISSURES-EDGE-ICON
		 ORB-ROOM-ICON
		 0>>

<CONSTANT FENSHIRE-ICON-TBL
	 <PLTABLE GONDOLA-ICON
		 RUINED-HALL-ICON
		 SECRET-ROOM-ICON
		 HOTHOUSE-ICON
		 MARSH-ICON
		 0>>

<CONSTANT CRAG-ICON-TBL
	 <PLTABLE CRAG-ICON
		 UPPER-LEDGE-ICON
		 LOWER-LEDGE-ICON
		 IRON-MINE-ICON
		 NATURAL-ARCH-ICON
		 ENCHANTED-CAVE-ICON
		 0>>

<CONSTANT GLACIER-ICON-TBL
	 <PLTABLE MIRROR-LAKE-ICON
		 CHALET-ICON
		 0>>

<CONSTANT DELTA-ICON-TBL
	 <PLTABLE RIVERS-END-ICON
		 OCEANS-EDGE-ICON
		 DELTA-ICON
		 0>>

<CONSTANT FUBLIO-ICON-TBL
	 <PLTABLE ON-TOP-OF-WORLD-ICON
		 AMONGST-CLOUDS-ICON
		 TIMBERLINE-ICON
		 AVALANCHE-ICON
		 ZORBEL-PASS-ICON
		 BASE-OF-MTS-ICON
		 FOOT-OF-STATUE-ICON
		 OUTSIDE-HUT-ICON
		 ATTIC-ICON
		 CAIRN-ICON
		 QUARRYS-EDGE-ICON
		 QUARRY-ICON
		 0>>

<CONSTANT ANTHARIA-ICON-TBL
	 <PLTABLE STADIUM-ICON
		 COAST-ROAD-ICON
		 MINE-ENTRANCE-ICON
		 STADIUM-ICON
		 COAST-ROAD-ICON
		 MINE-ENTRANCE-ICON
		 DEAD-END-ICON
		 CLIFF-BOTTOM-ICON
		 PRECIPICE-ICON
		 AERIE-ICON
		 ICKY-CAVE-ICON
		 0>>

<ROUTINE V-MAP ("AUX" TBL RM RM-ICON CX CY CHAR)
	 <COND (,DEBUG
		<SET RM <FIRST? ,ROOMS>>
		<REPEAT ()
			<COND (<NOT .RM>
			       <RETURN>)>
			<FSET .RM ,TOUCHBIT>
			<SET RM <NEXT? .RM>>>
		<SETG BEEN-IN-FR-UPPER-FLOORS T>)>
	 <COND (,DEMO-VERSION?
		<NOT-IN-DEMO>
		<RFATAL>)
	       (<EQUAL? <DO-MAP> ,M-FATAL> ;"no map available, for example"
		<RFATAL>)>
	 <SET TBL <GETP ,HERE ,P?MAP-LOC>>
	 <SET CY <MAP-Y <ZGET .TBL 1>>>
	 <SET CX <MAP-X <ZGET .TBL 2>>>
	 <REPEAT ()
		 <COND (<EQUAL? 2 <ISAVE>>
			<V-$REFRESH>)>
		 <SET CHAR <BLINK <COND (<SET RM-ICON <GETP ,HERE ,P?ICON>>
					 .RM-ICON)
					(T
					 ,ICONLESS-ROOM-BOX)>
		            	  ,YOU-ARE-HERE-SYMBOL .CY .CX ,S-FULL>>
		 <COND (<EQUAL? .CHAR ,CLICK1 ,CLICK2>
			<COND (<MAP-CLICK> ;"rtrue if moved"
			       <SETG ROSE-NEEDS-UPDATING T>
			       <COND (<NOT <EQUAL? ,CURRENT-SPLIT
						   ,MAP-TOP-LEFT-LOC>>
				      ;"exit function caused you to leave map"
				      <RETURN>)
				     (<FSET? ,HERE ,DELTABIT>
				      ;"else defeats maze -- rooms stay on map"
				      <RETURN-FROM-MAP>
				      <RETURN>)
				     (,CHANGE-MAP
				      <DO-MAP>)>
			       ;"update map"
			       <SET TBL <GETP ,HERE ,P?MAP-LOC>>
			       <SET CY <MAP-Y <ZGET .TBL 1>>>
			       <SET CX <MAP-X <ZGET .TBL 2>>>)>
			<COND (<NOT <EQUAL? ,CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>>
			       <RETURN>)>)
		       (T
			<RETURN>)>>
	 <RETURN-FROM-MAP>>

<GLOBAL ROSE-NEEDS-UPDATING <>>

<GLOBAL CHANGE-MAP <>>

<ROUTINE DO-MAP ("AUX" TBL MAP-NUM RM RM-ICON)
     <SETG CHANGE-MAP <>>
	 <COND (<AND <EQUAL? ,HERE ,GONDOLA>
		     <EQUAL? <GET <GETP ,HERE ,P?MAP-LOC> 0> <>>>
		<TELL "[Mapping is temporarily unavailable.]" CR>
		<RFATAL>)
	       (<NOT <GETP ,HERE ,P?MAP-LOC>>
		<TELL "[No on-screen map is available for this location.]" CR>
		<RFATAL>)
           (<NOT ,MAP-NOTE>
		<SETG MAP-NOTE T>
		<TELL
"Please read the section in the manual on on-screen mapping, if you have not
already done so. Are you ready to see the map (y or n)? >">
		<COND (<NOT <Y?>>
		       <RFATAL>)>)>
	 <IF-SOUND <SETG SOUND-QUEUED? <>>
		   <KILL-SOUNDS>>
	 <PICINF ,MAP-BOX-SIZE ,PICINF-TBL>
	 <SETG MAP-BOX-WIDTH <ZGET ,PICINF-TBL 1>>
	 <SETG MAP-BOX-HEIGHT <ZGET ,PICINF-TBL 0>>
	 <PICINF ,MAP-SPACE-SIZE ,PICINF-TBL>
	 <SETG MAP-SPACE-WIDTH <ZGET ,PICINF-TBL 1>>
	 <SETG MAP-SPACE-HEIGHT <ZGET ,PICINF-TBL 0>>
	 <PICINF-PLUS-ONE ,MAP-TOP-LEFT-LOC>
	 <SETG MAP-TOP-LEFT-X <ZGET ,PICINF-TBL 1>>
	 <SETG MAP-TOP-LEFT-Y <ZGET ,PICINF-TBL 0>>
	 <PICINF ,MAP-BASIC-ELT-SIZE ,PICINF-TBL>
	 <SETG MAP-ELEMENT-WIDTH <ZGET ,PICINF-TBL 1>>
	 <SETG MAP-ELEMENT-HEIGHT <ZGET ,PICINF-TBL 0>>
	 <SET TBL <GETP ,HERE ,P?MAP-LOC>>
	 <SET MAP-NUM <GET .TBL 0>>
	 <SET RM <FIRST? ,ROOMS>>
	 <COND (<APPLE?>
		<FORCE-DISK-FLIP .MAP-NUM> ;"before screen clear to erase flip msg.")>
	 <CLEAR -1>
	 <SCREEN ,S-FULL>
	 <SETG CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>
	 <CURSET -1> ;"turn cursor off"
	 <DISPLAY ,MAP-BORDER 1 1>
	 <MODIFY-PICSET-TBL .MAP-NUM>
	 <PICSET ,MAP-PICSET-TBL>
	 <DRAW-TITLES .MAP-NUM>
	 <REPEAT ()
	    <COND (<NOT .RM>
		   <RETURN>)>
	    <COND (<SET TBL <GETP .RM ,P?MAP-LOC>> ;"not all rooms go on a map"
		   <COND (<AND <EQUAL? <GET .TBL 0> .MAP-NUM>
			       <OR <FSET? .RM ,TOUCHBIT>
				   <EQUAL? ,HERE .RM> ;"if you're in dark room"
				   <AND <EQUAL? .RM ,FR-OFFICES
						,OFFICES-NORTH ,OFFICES-SOUTH
						,OFFICES-EAST ,OFFICES-WEST>
					,BEEN-IN-FR-UPPER-FLOORS>>>
			  <COND (<AND <FSET? .RM ,DELTABIT>
				      <NOT <FIRST? .RM>>>
				 T)
				(<SET RM-ICON <GETP .RM ,P?ICON>>
				 <DISPLAY-ROOM .RM-ICON
					       <GET .TBL 1> <GET .TBL 2>>
				 <DRAW-CONS .RM .TBL>)
				(T
				 <DISPLAY-ROOM ,ICONLESS-ROOM-BOX
					       <GET .TBL 1> <GET .TBL 2>>
				 <DRAW-CONS .RM .TBL>)>)>)>
	    <SET RM <NEXT? .RM>>>
	 <REPEAT ((BIT 64)) ;"clear the compass rose state info"
	    <COND (<L? <SET BIT <- .BIT 1>> ,LOW-DIRECTION>
		   <RETURN>)
		  (T
		   <FCLEAR ,ROOMS <- 64 .BIT>>)>>
	 <PICINF-PLUS-ONE ,MAP-ROSE-LOC>
	 <DISPLAY ,MAP-ROSE-BG <GET ,PICINF-TBL 0> <GET ,PICINF-TBL 1>>
	 <UPDATE-MAP-ROSE>>

<ROUTINE FORCE-DISK-FLIP (MAP-NUM)
	 <PICINF <COND (<EQUAL? .MAP-NUM ,MAIN-MAP-NUM> ,CASTLE-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,SECRET-WING-MAP-NUM> ,SECRET-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,VILLAGE-MAP-NUM> ,VILLAGE-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,LOWER-LEVEL-MAP-NUM> ,LOWER-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,LAKE-MAP-NUM> ,LAKE-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,DESERT-MAP-NUM> ,LAKE-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,FOOZLE-MAP-NUM> ,FOOZLE-SEGMENT-PIC)
		       (<EQUAL? .MAP-NUM ,FENSHIRE-MAP-NUM> ,FENSHIRE-SEGMENT-PIC)
		       (T ,ORACLE-SEGMENT-PIC)> ,PICINF-TBL>>

<ROUTINE UPDATE-MAP-ROSE ()
	 <SETG ROSE-NEEDS-UPDATING <>>
	 <PICINF-PLUS-ONE ,MAP-COMPASS-PIC-LOC>
	 <DRAW-COMPASS-ROSE ,P?NORTH ,MAP-N-HL ,MAP-N-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?NE ,MAP-NE-HL ,MAP-NE-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?EAST ,MAP-E-HL ,MAP-E-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?SE ,MAP-SE-HL ,MAP-SE-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?SOUTH ,MAP-S-HL ,MAP-S-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?SW ,MAP-SW-HL ,MAP-SW-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?WEST ,MAP-W-HL ,MAP-W-UNHL T>
	 <DRAW-COMPASS-ROSE ,P?NW ,MAP-NW-HL ,MAP-NW-UNHL T>>

<ROUTINE MODIFY-PICSET-TBL (MAP-NUM "AUX" TBL)
	 <SET TBL <COND (<EQUAL? .MAP-NUM ,MAIN-MAP-NUM>
			 ,MAIN-ICON-TBL)
			(<EQUAL? .MAP-NUM ,SECRET-WING-MAP-NUM>
			 ,SECRET-WING-ICON-TBL)
			(<EQUAL? .MAP-NUM ,VILLAGE-MAP-NUM>
			 ,VILLAGE-ICON-TBL)
			(<EQUAL? .MAP-NUM ,LOWER-LEVEL-MAP-NUM>
			 ,LOWER-LEVEL-ICON-TBL)
			(<EQUAL? .MAP-NUM ,LAKE-MAP-NUM>
			 ,LAKE-ICON-TBL)
			(<EQUAL? .MAP-NUM ,DESERT-MAP-NUM>
			 ,DESERT-ICON-TBL)
			(<EQUAL? .MAP-NUM ,FOOZLE-MAP-NUM>
			 ,FOOZLE-ICON-TBL)
			(<EQUAL? .MAP-NUM ,FENSHIRE-MAP-NUM>
			 ,FENSHIRE-ICON-TBL)
			(<EQUAL? .MAP-NUM ,FJORD-MAP-NUM>
			 ,CRAG-ICON-TBL)
			(<EQUAL? .MAP-NUM ,GRAY-MOUNTAINS-MAP-NUM>
			 ,GLACIER-ICON-TBL)
			(<EQUAL? .MAP-NUM ,DELTA-MAP-NUM>
			 ,DELTA-ICON-TBL)
			(<EQUAL? .MAP-NUM ,FUBLIO-MAP-NUM>
			 ,FUBLIO-ICON-TBL)
			(T
			 ,ANTHARIA-ICON-TBL)>>
	 <COPYT <REST .TBL 2> <REST ,MAP-PICSET-TBL 60> <* 2 <GET .TBL 0>>>>

<ROUTINE MAP-CLICK ("AUX" TL-X TL-Y BR-X BR-Y TOP (CNT-X 1) (CNT-Y 1)
			        (DONE <>) DIR OHERE TBL MAP-NUM)
	 <COND (<SET DIR <MAP-NEIGHBORS>>
		<DO-WALK .DIR>
		<IFFLAG (P-DEBUGGING-PARSER
			 <D-APPLY "map" <GETP ,HERE ,P?ACTION> ,M-END>)
			(T
			 <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-END>)>
		<CLOCKER>
		<RTRUE>)
	       (<SET DIR <COMPASS-CLICK ,MAP-COMPASS-PIC-LOC ,MAP-N-HL>>
		<SET OHERE ,HERE>
		<SET TBL <GETP ,HERE ,P?MAP-LOC>>
		<SET MAP-NUM <GET .TBL 0>>
		<DO-WALK .DIR>
		<COND (<EQUAL? ,HERE .OHERE>
		       <SOUND 1>
		       <RFALSE>)
		      (<SET TBL <GETP ,HERE ,P?MAP-LOC>>
		       <COND (<NOT <EQUAL? .MAP-NUM <GET .TBL 0>>>
			      <SETG CHANGE-MAP T>)>)
		      (T ;"you've entered a room that's not on the map"
		       <RETURN-FROM-MAP>)> 
		<IFFLAG (P-DEBUGGING-PARSER
			 <D-APPLY "map" <GETP ,HERE ,P?ACTION> ,M-END>)
			(T
			 <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-END>)>
		<CLOCKER>
		<RTRUE>)
	       (T
		<SOUND 1>
		<RFALSE>)>>

;"call me with a ROOM and a FUNCTION to test/act on; if this function returns
non-false, MAP-NEIGHBORS returns the direction to the neighboring room"

<ROUTINE MAP-NEIGHBORS ("AUX" DIR PT PTS TMP)
	 <MAP-DIRECTIONS (DIR PT ,HERE)
		<SET PTS <PTSIZE .PT>>
		<COND (<EQUAL? .PTS ,NEXIT>)
		      (<EQUAL? .PTS ,UEXIT ,CEXIT>
		       <SET TMP <GETB .PT ,REXIT>>
		       <COND (<CLICKED-ON-NEIGHBOR .TMP>
			      <RETURN .DIR>)>)
		      (<EQUAL? .PTS ,DEXIT>
		       <SET TMP <GETB .PT ,DEXITRM>>
		       <COND (<CLICKED-ON-NEIGHBOR .TMP>
			      <RETURN .DIR>)>)
		      (<EQUAL? .PTS ,FEXIT>
		       <SETG PRSO .DIR> ;"so exit routines return correct info"
		       <COND (<SET TMP <APPLY <GET .PT ,FEXITFCN> ,M-ENTER>>
			      <COND (<CLICKED-ON-NEIGHBOR .TMP>
				     <RETURN .DIR>)>)>)>>
	 <RFALSE>>

<ROUTINE CLICKED-ON-NEIGHBOR (RM "AUX" TL-X TL-Y BR-X BR-Y TBL MAP-NUM)
	 <SET TBL <GETP ,HERE ,P?MAP-LOC>>
	 <SET MAP-NUM <GET .TBL 0>>
	 <COND (<SET TBL <GETP .RM ,P?MAP-LOC>>
		<COND (<NOT <EQUAL? <GET .TBL 0> .MAP-NUM>>
		       <RFALSE>)>
		<SET TL-Y <MAP-Y <GET .TBL 1>>>
		<SET TL-X <MAP-X <GET .TBL 2>>>
		<PICINF ,MAP-BOX-SIZE ,PICINF-TBL>
		<SET BR-Y <+ .TL-Y <GET ,PICINF-TBL 0>>>
		<SET BR-X <+ .TL-X <GET ,PICINF-TBL 1>>>
		<COND (<WITHIN? .TL-X .TL-Y .BR-X .BR-Y>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)>>

<ROUTINE RETURN-FROM-MAP ()
	 <COND (<EQUAL? ,CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>
		<SETG CHANGE-MAP <>>
		<SETG CURRENT-SPLIT ,TEXT-WINDOW-PIC-LOC>
		<CURSET -2> ;"turn cursor back on"
	 	<V-$REFRESH>
		<COND (<EQUAL? ,VERBOSITY 2>
		       <V-LOOK>)>
	 	<IF-SOUND <COND (,SOUND-ON?
				 <CHECK-LOOPING>)>>
		<RFATAL>)>>

;"if either POS positive, it's the top-left x or y + pos*element-width/height.
  if negative, it's the ID of a picture that gives the appropriate coordinate."

<ROUTINE MAP-X (X-POS)
	 <COND (<G? .X-POS 0>
		<PICINF-PLUS-ONE .X-POS>
		<ZGET ,PICINF-TBL 1>)
	       (T
		<+ ,MAP-TOP-LEFT-X <* <- .X-POS> ,MAP-ELEMENT-WIDTH>>)>>

<ROUTINE MAP-Y (Y-POS)
	 <COND (<G? .Y-POS 0>
		<PICINF-PLUS-ONE .Y-POS>
		<ZGET ,PICINF-TBL 0>)
	       (T
		<+ ,MAP-TOP-LEFT-Y <* <- .Y-POS> ,MAP-ELEMENT-HEIGHT>>)>>

<ROUTINE DISPLAY-ROOM (PICTURE-ID Y-POS X-POS "OPT" (Y-FUDGE 0) (X-FUDGE 0))
  <DISPLAY .PICTURE-ID
	   <+ .Y-FUDGE <MAP-Y .Y-POS>> <+ .X-FUDGE <MAP-X .X-POS>>>>

<ROUTINE DRAW-TITLES (MAP-NUM "AUX" TMP TMP1)
	 <COND (<EQUAL? .MAP-NUM ,MAIN-MAP-NUM>
		<DISPLAY-ROOM ,MAIN-TITLE ,MAIN-TITLE-LOC ,MAIN-TITLE-LOC>
		<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-1 ,MAP-GEN-X-1>
		<COND (<FSET? ,CHAPEL ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-EAST-SYMBOL ,MAP-GEN-Y-6
				     ,MAP-GEN-X-8 0 ,MAP-BOX-WIDTH>)>
		<COND (<FSET? ,GREAT-HALL ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-NE-SYMBOL ,MAP-GEN-Y-4 ,MAP-GEN-X-5
				     <- ,MAP-BOX-HEIGHT 2>
				     <- <+ ,MAP-SPACE-WIDTH 2>>>
		       <DISPLAY-ROOM ,DOWN-SE-SYMBOL ,MAP-GEN-Y-4 ,MAP-GEN-X-5
				     <- ,MAP-BOX-HEIGHT 2>
				     <- ,MAP-BOX-WIDTH 2>>)>)
	       (<EQUAL? .MAP-NUM ,SECRET-WING-MAP-NUM>
		<DISPLAY-ROOM ,SECRET-WING-TITLE
			      ,SECRET-WING-TITLE-LOC ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-1 ,MAP-GEN-X-8>
		<COND (<FSET? ,CRYPT ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-EAST-SYMBOL ,MAP-GEN-Y-3
				     ,MAP-GEN-X-8 0 ,MAP-BOX-WIDTH>)>)
	       (<EQUAL? .MAP-NUM ,VILLAGE-MAP-NUM>
	 	<DISPLAY-ROOM ,VILLAGE-TITLE ,MAP-GEN-Y-5 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,VERTICAL-LEGEND ,MAP-GEN-Y-1 ,MAP-GEN-X-10>
		<COND (<AND <FSET? ,SHADY-PARK ,TOUCHBIT>
			    <FSET? ,VILLAGE-CENTER ,TOUCHBIT>>
		       <DISPLAY-ROOM ,E-W-CON ,MAP-GEN-Y-3 ,MAP-GEN-X-6>
		       <SET TMP <MAP-X ,5-FUDGE>>
		       <DISPLAY-ROOM ,E-W-CON
				     ,MAP-GEN-Y-3 ,MAP-GEN-X-6 0 .TMP>
		       <DISPLAY-ROOM ,E-W-CON
				     ,MAP-GEN-Y-3 ,MAP-GEN-X-6 0 <* .TMP 2>>
		       <DISPLAY-ROOM ,E-W-CON
				     ,MAP-GEN-Y-3 ,MAP-GEN-X-6 0 <* .TMP 3>>)>
		<COND (<FSET? ,FR-HQ ,TOUCHBIT>
		       <DISPLAY-ROOM ,LOBBY-OFFICE-CON
				     ,MAP-GEN-Y-3 ,MAP-GEN-X-8
				     <- ,MAP-BOX-HEIGHT 2>
				     <- ,MAP-BOX-WIDTH 2>>)>
		<COND (,BEEN-IN-FR-UPPER-FLOORS
		       <DISPLAY-ROOM ,OFFICE-PENTHOUSE-CON
				     ,MAP-GEN-Y-5 ,MAP-GEN-X-8
				     <- ,MAP-BOX-HEIGHT 2>
				     <- ,MAP-BOX-WIDTH 2>>)>)
	       (<EQUAL? .MAP-NUM ,LOWER-LEVEL-MAP-NUM>
	 	<DISPLAY-ROOM ,LOWER-LEVEL-TITLE ,MAP-GEN-Y-5 ,MAP-GEN-X-9>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-2 ,MAP-GEN-X-8>
		<COND (<FSET? ,LOWEST-HALL ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-SW-SYMBOL ,MAP-GEN-Y-4 ,MAP-GEN-X-4
				     <- ,MAP-BOX-HEIGHT 2>
				     <- ,MAP-BOX-WIDTH 2>>
		       <DISPLAY-ROOM ,LOW-HALL-CON ,MAP-GEN-Y-5
				     ,MAP-GEN-X-4 0 ,MAP-BOX-WIDTH>)>
		<COND (<FSET? ,LOWER-HALL ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-WEST-SYMBOL ,MAP-GEN-Y-5
				     ,MAP-GEN-X-6 0 ,MAP-BOX-WIDTH>)>)
	       (<EQUAL? .MAP-NUM ,LAKE-MAP-NUM>
	 	<DISPLAY-ROOM ,LAKE-TITLE
			      ,LAKE-TITLE-LOC ,LAKE-TITLE-LOC>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-6 ,MAP-GEN-X-8>
	 	<COND (<FSET? ,HOLD ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-SOUTH-SYMBOL ,MAP-GEN-Y-4
				     ,MAP-GEN-X-1 ,MAP-BOX-HEIGHT>
		       <DISPLAY-ROOM ,DOWN-SOUTH-SYMBOL ,MAP-GEN-Y-5
				     ,MAP-GEN-X-1 ,MAP-BOX-HEIGHT>)>
	 	<COND (<FSET? ,UNDERWATER ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-SOUTH-SYMBOL ,MAP-GEN-Y-6
				     ,MAP-GEN-X-1 ,MAP-BOX-HEIGHT>)>
	        <COND (<FSET? ,GROTTO ,TOUCHBIT>
		       <DISPLAY-ROOM ,N-S-CON ,MAP-GEN-Y-4 ,MAP-GEN-X-7>
		       <SET TMP <MAP-Y ,5-FUDGE>>
		       <DISPLAY-ROOM ,N-S-CON
				     ,MAP-GEN-Y-4 ,MAP-GEN-X-7 .TMP>
		       <DISPLAY-ROOM ,N-S-CON
				     ,MAP-GEN-Y-4 ,MAP-GEN-X-7 <* .TMP 2>>
		       <DISPLAY-ROOM ,N-S-CON
				     ,MAP-GEN-Y-4 ,MAP-GEN-X-7 <* .TMP 3>>)>
	 	<COND (<FSET? ,CONDUCTOR-PIT ,TOUCHBIT>
		       <DISPLAY-ROOM ,DOWN-WEST-SYMBOL ,MAP-GEN-Y-3
				     ,MAP-GEN-X-3 0 ,MAP-BOX-WIDTH>)>)
	       (<EQUAL? .MAP-NUM ,DESERT-MAP-NUM>
		<DISPLAY-ROOM ,DESERT-TITLE ,MAP-GEN-Y-2 ,MAP-GEN-X-2>
		<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-3 ,MAP-GEN-X-8>)
	       (<EQUAL? .MAP-NUM ,FOOZLE-MAP-NUM>
	 	<DISPLAY-ROOM ,FOOZLE-TITLE ,MAP-GEN-Y-1 ,MAP-GEN-X-2>
	 	<DISPLAY-ROOM ,VERTICAL-LEGEND ,MAP-GEN-Y-1 ,MAP-GEN-X-10>
	 	<DISPLAY-ROOM ,FOOZLE-MAP-ILL ,MAP-GEN-Y-6 ,MAP-GEN-X-8>
		<COND (<FSET? ,WISHYFOO-TERRITORY ,TOUCHBIT>
		       <DISPLAY-ROOM ,WISHYFOO-FORK-CON ,MAP-GEN-Y-4
				     ,MAP-GEN-X-4 ,MAP-BOX-HEIGHT>)>
		<COND (<FSET? ,CAVE-IN ,TOUCHBIT>
		       <DISPLAY-ROOM ,E-W-CON ,MAP-GEN-Y-3
				     ,MAP-GEN-X-8 0 ,MAP-BOX-WIDTH>)>
	 	<COND (<FSET? ,FISSURE-EDGE ,TOUCHBIT>
		       <DISPLAY-ROOM ,N-S-CON ,MAP-GEN-Y-4
				     ,MAP-GEN-X-7 ,MAP-BOX-HEIGHT>)>)
	       (<EQUAL? .MAP-NUM ,FENSHIRE-MAP-NUM>
	 	<DISPLAY-ROOM ,FENSHIRE-TITLE ,MAP-GEN-Y-3 ,MAP-GEN-X-5>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-6 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,FENSHIRE-MAP-ILL ,MAP-GEN-Y-5 ,MAP-GEN-X-6>)
	       (<EQUAL? .MAP-NUM ,FJORD-MAP-NUM>
	 	<DISPLAY-ROOM ,FJORD-TITLE ,MAP-GEN-Y-2 ,MAP-GEN-X-8>
		<DISPLAY-ROOM ,VERTICAL-LEGEND ,MAP-GEN-Y-1 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,FJORD-MAP-ILL ,MAP-GEN-Y-6 ,MAP-GEN-X-5>
		<DISPLAY-ROOM ,RV-TELEPORT-ARROW
			      ,MAP-GEN-Y-4 ,MAP-GEN-X-4 ,MAP-BOX-HEIGHT>
		<COND (<AND <FSET? ,CRAG ,TOUCHBIT>
			    <FSET? ,NATURAL-ARCH ,TOUCHBIT>>
		       <DISPLAY-ROOM ,ARCH-N-CON
				     ,MAP-GEN-Y-4 ,MAP-GEN-X-4
				     <+ <- <MAP-Y ,ARCH-N-CON-SIZE>> 1>
				     ,MAP-BOX-WIDTH>
		       <DISPLAY-ROOM ,ARCH-S-CON
				     ,MAP-GEN-Y-4 ,MAP-GEN-X-4
				     ,MAP-BOX-HEIGHT
				     ,MAP-BOX-WIDTH>)>)
	       (<EQUAL? .MAP-NUM ,GRAY-MOUNTAINS-MAP-NUM>
		<DISPLAY-ROOM ,GRAY-MTS-TITLE ,MAP-GEN-Y-5 ,MAP-GEN-X-7>
		<DISPLAY-ROOM ,VERTICAL-LEGEND ,MAP-GEN-Y-1 ,MAP-GEN-X-2>
	 	<DISPLAY-ROOM ,GRAY-MTS-MAP-ILL ,MAP-GEN-Y-5 ,MAP-GEN-X-1>
		<DISPLAY-ROOM ,RV-TELEPORT-ARROW
			      ,MAP-GEN-Y-1 ,MAP-GEN-X-10 ,MAP-BOX-HEIGHT>
		<COND (<FSET? ,GLACIER ,TOUCHBIT>
		       <DISPLAY-ROOM ,GLACIER-MIRROR-CON
				     ,MAP-GEN-Y-1 ,MAP-GEN-X-8
				     <- ,MAP-BOX-HEIGHT 2>
				     <- ,MAP-BOX-WIDTH 2>>)>)
	       (<EQUAL? .MAP-NUM ,DELTA-MAP-NUM>
	 	<DISPLAY-ROOM ,DELTA-TITLE ,MAP-GEN-Y-6 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-3 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,DELTA-MAP-ILL ,MAP-GEN-Y-1 ,MAP-GEN-X-1>
		<DISPLAY-ROOM ,RV-TELEPORT-ARROW
			      ,MAP-GEN-Y-5 ,MAP-GEN-X-10 ,MAP-BOX-HEIGHT>
		<COND (<AND <FIRST? ,DELTA-1>
			    <FIRST? ,DELTA-2>>
		       <DISPLAY-ROOM ,ARCH-S-CON
				     ,MAP-GEN-Y-5 ,MAP-GEN-X-8
				     ,MAP-BOX-HEIGHT ,MAP-BOX-WIDTH>
		       <DISPLAY-ROOM ,ARCH-N-CON
				     ,MAP-GEN-Y-5 ,MAP-GEN-X-8
				     <+ <- <MAP-Y ,ARCH-N-CON-SIZE>> 1>
				     ,MAP-BOX-WIDTH>)>
		<COND (<AND <FIRST? ,DELTA-1>
			    <FIRST? ,DELTA-3>>
		       <COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
			      <DISPLAY-ROOM ,DELTA-1-3-CON ,MAP-GEN-Y-3 ,MAP-GEN-X-8
					   </ ,MAP-BOX-HEIGHT 2> ,MAP-BOX-WIDTH>)
			     (T
			      <DISPLAY-ROOM ,DELTA-1-3-CON ,MAP-GEN-Y-3 ,MAP-GEN-X-8
				       <- </ ,MAP-BOX-HEIGHT 2> 1> ,MAP-BOX-WIDTH>)>)>
		<COND (<AND <FIRST? ,DELTA-1>
			    <FIRST? ,DELTA-4>>
		       <DISPLAY-ROOM ,DELTA-1-4-CON ,MAP-GEN-Y-2 ,MAP-GEN-X-9
				     0 ,MAP-BOX-WIDTH>)>
		<COND (<AND <FIRST? ,DELTA-2>
			    <FIRST? ,DELTA-7>>
		       <DISPLAY-ROOM ,RUBBLE-SE-CON
				     ,MAP-GEN-Y-5 ,MAP-GEN-X-7
				     ,MAP-BOX-HEIGHT ,MAP-BOX-WIDTH>)>
		<COND (<AND <FIRST? ,DELTA-2>
			    <FIRST? ,DELTA-3>>
		       <DISPLAY-ROOM ,DELTA-2-3-CON
				     ,MAP-GEN-Y-3 ,MAP-GEN-X-8 ,MAP-BOX-HEIGHT
				     <+ <- <MAP-X ,2-3-CON-SIZE>> 1>>)>
		<COND (<AND <FIRST? ,DELTA-3>
			    <FIRST? ,DELTA-4>>
		       <COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
			      <DISPLAY-ROOM ,RUBBLE-NW-CON
				    ,MAP-GEN-Y-3 ,MAP-GEN-X-9
				    <- <MAP-Y ,RUBBLE-CON-SIZE>>
				    <- <- <MAP-X ,RUBBLE-CON-SIZE>> 1>>)
			     (T
			      <DISPLAY-ROOM ,RUBBLE-NW-CON
				    ,MAP-GEN-Y-3 ,MAP-GEN-X-9
				    <- <- <MAP-Y ,RUBBLE-CON-SIZE>> 1>
				    <- <- <MAP-X ,RUBBLE-CON-SIZE>> 1>>)>)>
		<COND (<AND <FIRST? ,DELTA-3>
			    <FIRST? ,DELTA-5>>
		       <DISPLAY-ROOM ,DELTA-3-5-CON
				     ,MAP-GEN-Y-2 ,MAP-GEN-X-8
				     ,MAP-BOX-HEIGHT
				     <+ <- <MAP-X ,3-5-CON-SIZE>> 1>>)>
		<COND (<AND <FIRST? ,DELTA-4>
			    <FIRST? ,DELTA-5>>
		       <DISPLAY-ROOM ,ARCH-N-CON
				     ,MAP-GEN-Y-2 ,MAP-GEN-X-7
				     <+ <- <MAP-Y ,ARCH-N-CON-SIZE>> 1>
				     ,MAP-BOX-WIDTH>)>
		<COND (<AND <FIRST? ,DELTA-5>
			    <FIRST? ,DELTA-6>
			    <FSET? ,DELTA-6 ,TOUCHBIT>>
		       <DISPLAY-ROOM ,DELTA-5-6-CON
				     ,MAP-GEN-Y-2 ,MAP-GEN-X-7
				     ,MAP-BOX-HEIGHT
				     <+ <- <MAP-X ,5-6-CON-SIZE>> 1>>)>
		<COND (<AND <FIRST? ,DELTA-6>
			    <FSET? ,DELTA-6 ,TOUCHBIT>
			    <FIRST? ,DELTA-7>>
		       <DISPLAY-ROOM ,DELTA-6-7-CON
				     ,MAP-GEN-Y-5 ,MAP-GEN-X-7
				     0 <- <MAP-X ,6-7-CON-SIZE>>>)>)
	       (<EQUAL? .MAP-NUM ,FUBLIO-MAP-NUM>
	 	<DISPLAY-ROOM ,FUBLIO-TITLE ,MAP-GEN-Y-2 ,MAP-GEN-X-9>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-4 ,MAP-GEN-X-1>
		<DISPLAY-ROOM ,TELEPORT-ARROW ,MAP-GEN-Y-4 ,MAP-GEN-X-8
			      <- <MAP-Y ,TELEPORT-ARROW-SIZE>>>)
	       (<EQUAL? .MAP-NUM ,ANTHARIA-MAP-NUM>
	 	<DISPLAY-ROOM ,ANTHARIA-TITLE ,MAP-GEN-Y-5 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,HORIZONTAL-LEGEND ,MAP-GEN-Y-6 ,MAP-GEN-X-1>
	 	<DISPLAY-ROOM ,ANTHARIA-MAP-ILL ,MAP-GEN-Y-1 ,MAP-GEN-X-1>
		<DISPLAY-ROOM ,TELEPORT-ARROW ,MAP-GEN-Y-4 ,MAP-GEN-X-8
			      <- <MAP-Y ,TELEPORT-ARROW-SIZE>>>
		<COND (<AND <FSET? ,RUBBLE-ROOM ,TOUCHBIT>
			    <FSET? ,HEART-OF-MINE ,TOUCHBIT>>
		       <DISPLAY-ROOM ,RUBBLE-SE-CON
				     ,MAP-GEN-Y-3 ,MAP-GEN-X-9
				     ,MAP-BOX-HEIGHT ,MAP-BOX-WIDTH>
		       <COND (<EQUAL? <LOWCORE INTID> ,AMIGA>
			      <DISPLAY-ROOM ,RUBBLE-NW-CON
				    ,MAP-GEN-Y-4 ,MAP-GEN-X-10
				    <- <MAP-Y ,RUBBLE-CON-SIZE>>
				    <- <- <MAP-X ,RUBBLE-CON-SIZE>> 1>>)
			     (T
			      <DISPLAY-ROOM ,RUBBLE-NW-CON
				    ,MAP-GEN-Y-4 ,MAP-GEN-X-10
				    <- <- <MAP-Y ,RUBBLE-CON-SIZE>> 1>
				    <- <- <MAP-X ,RUBBLE-CON-SIZE>> 1>>)>)>
		<COND (<FSET? ,NORTH-OF-ANTHAR ,TOUCHBIT>
		       <DISPLAY-ROOM ,N-S-CON ,MAP-GEN-Y-6 ,MAP-GEN-X-6
				     ,MAP-BOX-HEIGHT>)>)>>

<ROUTINE DRAW-CONS (RM TBL "AUX" Y X PTS NEXT-RM NEXT-TBL NEXT-Y NEXT-X)
 <SET Y <MAP-Y <GET .TBL 1>>>
 <SET X <MAP-X <GET .TBL 2>>>
 <COND (<SHOW-DIRECTION? .RM ,P?NORTH>
	<DISPLAY ,N-S-CON <- .Y ,MAP-SPACE-HEIGHT> .X>)>
 <COND (<SHOW-DIRECTION? .RM ,P?NE>
	<DISPLAY ,NE-SW-CON
		 <- .Y ,MAP-SPACE-HEIGHT> <+ .X ,MAP-BOX-WIDTH>>)>
 <COND (<SHOW-DIRECTION? .RM ,P?EAST>
	<DISPLAY ,E-W-CON .Y <+ .X ,MAP-BOX-WIDTH>>)>
 <COND (<SHOW-DIRECTION? .RM ,P?SE>
	<DISPLAY ,NW-SE-CON
		 <+ .Y ,MAP-BOX-HEIGHT> <+ .X ,MAP-BOX-WIDTH>>)>
 <COND (<SHOW-DIRECTION? .RM ,P?SOUTH>
	<DISPLAY ,N-S-CON <+ .Y ,MAP-BOX-HEIGHT> .X>)>
 <COND (<SHOW-DIRECTION? .RM ,P?SW>
	<DISPLAY ,NE-SW-CON
		 <+ .Y ,MAP-BOX-HEIGHT> <- .X ,MAP-SPACE-WIDTH>>)>
 <COND (<SHOW-DIRECTION? .RM ,P?WEST>
	<DISPLAY ,E-W-CON .Y <- .X ,MAP-SPACE-WIDTH>>)>
 <COND (<SHOW-DIRECTION? .RM ,P?NW>
	<DISPLAY ,NW-SE-CON
		 <- .Y ,MAP-SPACE-HEIGHT> <- .X ,MAP-SPACE-WIDTH>>)>
 <COND (<SET PTS <GETPT .RM ,P?DOWN>>
	<COND (<EQUAL? <PTSIZE .PTS> ,UEXIT ,CEXIT>
	       <SET NEXT-RM <GETB .PTS ,REXIT>>)
	      (<EQUAL? <PTSIZE .PTS> ,DEXIT>
	       <SET NEXT-RM <GETB .PTS ,DEXITRM>>)>
	<COND (<AND <EQUAL? .RM ,LOWER-HALL>
		    <FSET? ,LOWEST-HALL ,TOUCHBIT>>
	       T)
	      (<EQUAL? .RM ,WISHYFOO-TERRITORY>
	       T)
	      (<AND .NEXT-RM
		    <SET NEXT-TBL <GETP .NEXT-RM ,P?MAP-LOC>>
		    <EQUAL? <GET .NEXT-TBL 0> <GET .TBL 0>>>
	       <SET NEXT-Y <MAP-Y <GET .NEXT-TBL 1>>>
	       <SET NEXT-X <MAP-X <GET .NEXT-TBL 2>>>
	       <COND (<EQUAL? .X .NEXT-X>
		      <COND (<G? .Y .NEXT-Y>
			     <DISPLAY ,DOWN-NORTH-SYMBOL
				      <- .Y ,MAP-SPACE-HEIGHT> .X>)
			    (T
			     <DISPLAY ,DOWN-SOUTH-SYMBOL
				      <+ .Y ,MAP-BOX-HEIGHT> .X>)>)
		     (<EQUAL? .Y .NEXT-Y>
		      <COND (<G? .X .NEXT-X>
			     <DISPLAY ,DOWN-WEST-SYMBOL
				      .Y <- .X ,MAP-SPACE-WIDTH>>)
			    (T
			     <DISPLAY ,DOWN-EAST-SYMBOL
				      .Y <+ .X ,MAP-BOX-WIDTH>>)>)>)>)>
 <SET NEXT-RM <>> ;"it might not be, if it got set by the DOWN clause"
 <COND (<SET PTS <GETPT .RM ,P?UP>>
	<COND (<EQUAL? <PTSIZE .PTS> ,UEXIT ,CEXIT>
	       <SET NEXT-RM <GETB .PTS ,REXIT>>)
	      (<EQUAL? <PTSIZE .PTS> ,DEXIT>
	       <SET NEXT-RM <GETB .PTS ,DEXITRM>>)>
	<COND (<AND .NEXT-RM
		    <SET NEXT-TBL <GETP .NEXT-RM ,P?MAP-LOC>>
		    <EQUAL? <GET .NEXT-TBL 0> <GET .TBL 0>>>
	       <SET NEXT-Y <MAP-Y <GET .NEXT-TBL 1>>>
	       <SET NEXT-X <MAP-X <GET .NEXT-TBL 2>>>
	       <COND (<EQUAL? .X .NEXT-X>
		      <COND (<G? .Y .NEXT-Y>
			     <DISPLAY ,DOWN-SOUTH-SYMBOL
				      <- .Y ,MAP-SPACE-HEIGHT> .X>)
			    (T
			     <DISPLAY ,DOWN-NORTH-SYMBOL
				      <+ .Y ,MAP-BOX-HEIGHT> .X>)>)
		     (<EQUAL? .Y .NEXT-Y>
		      <COND (<G? .X .NEXT-X>
			     <DISPLAY ,DOWN-EAST-SYMBOL
				      .Y <- .X ,MAP-SPACE-WIDTH>>)
			    (T
			     <DISPLAY ,DOWN-WEST-SYMBOL
				      .Y <+ .X ,MAP-BOX-WIDTH>>)>)>)>)>>>

<ROUTINE V-MAYBE ()
	 <YOU-SOUND "indecis">>

<ROUTINE V-MEET ()
	 <PERFORM ,V?TELL ,PRSO>
	 <RTRUE>>

<ROUTINE V-MEASURE ()
	 <COND (<OR <FSET? ,PRSO ,PARTBIT>
		    <PRSO? ,ME>>
		<TELL "Usual size." CR>)
	       (T
	 	<TELL "The same size as any other " D ,PRSO ,PERIOD-CR>)>>

<ROUTINE V-MIRROR-LOOK ()
	 <COND (<IN? ,PRSO ,PRSI>
		<PERFORM ,V?EXAMINE ,PRSO>
		<RTRUE>)
	       (T
		<TELL "But" T ,PRSO " isn't in" TR ,PRSI>)>>

<ROUTINE V-MOVE ()
	 <COND (<ULTIMATELY-IN? ,PRSO>
		<WASTES>)
	       (<FSET? ,PRSO ,INTEGRALBIT>
		<PART-OF>)
	       (<LOC-CLOSED ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving" T ,PRSO " reveals nothing." CR>)
	       (<EQUAL? ,P-PRSA-WORD ,W?PULL>
		<HACK-HACK "Pulling">)
	       (<AND <EQUAL? ,P-PRSA-WORD ,W?MOVE>
		     <PRSO? ,INTDIR>>
		<DO-WALK <DIRECTION-CONVERSION>>)
	       (T
		<CANT-VERB-A-PRSO "move">)>>

<ROUTINE V-MOVE-DIR ()
	 <TELL "Pick up" T ,PRSO " and go that way!" CR>>

<ROUTINE V-MOVE-TO ()
	 <COND (<NOT <ULTIMATELY-IN? ,PRSO>>
		<TELL ,YNH TR ,PRSO>)
	       (T
		<PERFORM ,V?PUT ,PRSO ,PRSI>
		<RTRUE>)>>

<ROUTINE V-MUNG ()
         <HACK-HACK "Trying to destroy">>

<ROUTINE V-NO ()
	 <COND (<EQUAL? ,AWAITING-REPLY 1>
		<V-YES>)
	       (T
		<YOU-SOUND "negat">)>>

;<ROUTINE V-NO-VERB ()
	 <COND (<NOUN-USED? ,ME ,W?I>
		<V-INVENTORY>)
	       (,ORPHAN-FLAG
		<WASTES>)
	       (<NOT <VISIBLE? ,PRSO>>
		<CANT-SEE ,PRSO>)
	       ;(<FSET? ,PRSO ,ACTORBIT> 
		<PERFORM ,V?TELL ,PRSO>
		<RTRUE>)
	       (,P-CONT
		<PERFORM ,V?TELL ,PRSO>
		<RTRUE>)
	       (T
		;<TELL "[Examine" T ,PRSO "]" CR CR>
		<PERFORM ,V?EXAMINE ,PRSO>
		<RTRUE>)>>

;<GLOBAL ORPHAN-FLAG <>>

;<ROUTINE I-ORPHAN ()
	 <SETG ORPHAN-FLAG <>>
	 <RFALSE>>

<ROUTINE NO-WORD (WRD)
	 <COND (<OR <EQUAL? .WRD ,W?NO ,W?NOPE>
		    <EQUAL? .WRD ,W?NAH ,W?UH-UH>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-OFF ()
	 <COND (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<FSET? ,PRSO ,ONBIT>
		       <FCLEAR ,PRSO ,ONBIT>
		       <FCLEAR ,PRSO ,FLAMEBIT>
		       <TELL "Okay," T ,PRSO " is now o">
		       <COND ;(<PRSO? ,CANDLE>
			      <TELL "ut">)
			     (T
			      <TELL "ff">)>
		       <TELL ,PERIOD-CR>
		       <NOW-DARK?>)
		      (T
		       <TELL HS ,PRSO "not on!" CR>)>)
	       (T
		<CANT-TURN "ff">)>>

<ROUTINE V-ON ()
	 <COND ;(<FSET? ,PRSO ,ACTORBIT>
		<TELL "Hopefully, your sexy body will do the trick." CR>)
	       (<FSET? ,PRSO ,LIGHTBIT>
		<COND (<FSET? ,PRSO ,ONBIT>
		       <TELL ,ALREADY-IS>)
		      (T
		       <FSET ,PRSO ,ONBIT>
		       <TELL "Okay," T ,PRSO " is now on." CR>
		       <NOW-LIT?>)>)
	       (T
		<CANT-TURN "n">)>>

<ROUTINE V-OPEN ()
	 <COND (<AND ,PRSI
		     <FSET? ,PRSI ,KEYBIT>>
		<PERFORM ,V?UNLOCK ,PRSO ,PRSI>
		<RTRUE>)
	       (<OR <FSET? ,PRSO ,SURFACEBIT>
		    <FSET? ,PRSO ,ACTORBIT>
		    <FSET? ,PRSO ,VEHBIT>>
		<IMPOSSIBLES>)
	       (<FSET? ,PRSO ,OPENBIT>
		<TELL ,ALREADY-IS>)
	       (<FSET? ,PRSO ,LOCKEDBIT>
		<TELL "The " D ,PRSO " is locked." CR>)
	       (<FSET? ,PRSO ,DOORBIT>
		<FSET ,PRSO ,OPENBIT>
		<TELL "The " D ,PRSO " swings open." CR>)
	       (<FSET? ,PRSO ,CONTBIT>
		<FSET ,PRSO ,OPENBIT>
		<FSET ,PRSO ,TOUCHBIT>
		<COND (<OR <NOT <FIRST? ,PRSO>>
			    <FSET? ,PRSO ,TRANSBIT>>
		       <TELL "Opened." CR>)
		      (T
		       <TELL "Opening" T ,PRSO " reveals">
		       <COND (<NOT <D-NOTHING>>
			      <TELL ,PERIOD-CR>)>
		       <NOW-LIT?>)>
		<RTRUE>)
	       (T
		<YOU-MUST-TELL-ME>)>>

<ROUTINE V-PAY ("AUX" (MONEY <>))
	 <COND (.MONEY
		<PERFORM ,V?GIVE .MONEY ,PRSO>
		<RTRUE>)
	       (T
		<TELL "You have no money!" CR>)>>

<ROUTINE V-PICK ()
	 <CANT-VERB-A-PRSO "pick">>

<ROUTINE V-PLAY ()
	 <CANT-VERB-A-PRSO "play">>

<ROUTINE V-POINT ()
	 <TELL "That would be pointless." CR>>

<ROUTINE V-POUR ()
	 <IMPOSSIBLES>>

<ROUTINE V-PRAY ()
	<TELL "You're agnostic. But sure, why not?" CR>>

;<ROUTINE V-PULL-OVER ()
	 <HACK-HACK "Pulling">>

<ROUTINE V-PUSH ()
	 <HACK-HACK "Pushing">>

<ROUTINE V-PUSH-DIR ()
	 <V-PUSH>>

;<ROUTINE V-PUSH-OFF ()
	 <COND (<AND <PRSO? ,ROOMS ,DOCK-OBJECT ,RAFT ,BARGE>
		     <NOT <IN? ,PROTAGONIST ,HERE>>>
		<PERFORM ,V?LAUNCH <LOC ,PROTAGONIST>>
		<RTRUE>)
	       (T
		<TELL ,HUH>)>>

<ROUTINE PRE-PUT ()
	 <COND (<PRSO? ,HANDS>
		<COND (<AND <VERB? PUT-ON PUT>
			    <FSET? ,PRSI ,PARTBIT>>
		       <RFALSE>)
		      (<VERB? PUT>
		       <PERFORM ,V?REACH-IN ,PRSI>
		       <RTRUE>)
		      (T
		       <IMPOSSIBLES>)>)
           (<AND <NOT <FSET? ,PRSI ,PARTBIT>>
		     <PRE-LOOK>>		     
		<RTRUE>)
	       (<ULTIMATELY-IN? ,PRSI ,PRSO>		      
		<TELL ,YOU-CANT "put" T ,PRSO>
		<COND (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?ON>
		       ;<FSET? ,PRSO ,SURFACEBIT>
		       ;<EQUAL? <GET ,P-ITBL ,P-PREP2> ,PR?ON>
		       <TELL " on">)
		      (T
		       <TELL " in">)>
		<TELL T ,PRSI " when" T ,PRSI " is already ">
		<COND (<FSET? ,PRSO ,SURFACEBIT>
		       <TELL "on">)
		      (T
		       <TELL "in">)>
		<TELL T ,PRSO "!" CR>)
	       (<UNTOUCHABLE? ,PRSI>
		<CANT-REACH ,PRSI>)
	       ;(,IN-FRONT-FLAG  ;"you dont have to have it"
		<PERFORM ,V?PUT-IN-FRONT ,PRSO ,PRSI>
		<RTRUE>)
	       (<IDROP>
		<RTRUE>)>>

<ROUTINE V-PUT ()
	 <COND (<FSET? ,PRSI ,WATERBIT>
		<COND ;(<PRSO? ,SMALL-VIAL ,LARGE-VIAL>
		       <PERFORM ,V?FILL ,PRSO ,WATER>
		       <RTRUE>)
		      (T
		       <PERFORM-PRSA ,PRSO ,WATER>)>)
	       (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,CONTBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<TELL ,YOU-CANT "put" T ,PRSO " in" A ,PRSI "!" CR>)
	       (<OR <PRSI? ,PRSO>
		    <AND <ULTIMATELY-IN? ,PRSO>
			 <NOT <FSET? ,PRSO ,TAKEBIT>>>>
		<PRINT "How can you do that?">
		<CRLF>)
	       (<FSET? ,PRSI ,DOORBIT>
		<TELL ,CANT-FROM-HERE>)
	       (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>>
		<THIS-IS-IT ,PRSI>
		<DO-FIRST "open" ,PRSI>)
	       (<IN? ,PRSO ,PRSI>
		<TELL "But" T ,PRSO " is already in" TR ,PRSI>)
	       (<FSET? ,PRSI ,ACTORBIT>
		<TELL ,HUH>)
	       (<AND <G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
			    <GETP ,PRSI ,P?SIZE>>
		    	 <GETP ,PRSI ,P?CAPACITY>>
		     <NOT <ULTIMATELY-IN? ,PRSO ,PRSI>>>
		<TELL "There's no room ">
		<COND (<FSET? ,PRSI ,SURFACEBIT>
		       <TELL "on">)
		      (T
		       <TELL "in">)>
		<TELL T ,PRSI " for" TR ,PRSO>)
	       (<AND <NOT <ULTIMATELY-IN? ,PRSO>>
		     <EQUAL? <ITAKE> ,M-FATAL <>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>
		<SCORE-OBJ ,PRSO>)>>

<ROUTINE V-PUT-BEHIND ()
	 <WASTES>>

;<ROUTINE V-PUT-NEAR ()
	 <WASTES>>

<ROUTINE V-PUT-ON ()
	 <COND (<PRSI? ,ME>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSI ,SURFACEBIT>
		<V-PUT>)
	       (<AND <FSET? ,PRSI ,ACTORBIT>
		     <FSET? ,PRSO ,WEARBIT>>
		<TELL "But it's not" T ,PRSI"'s size." CR>)
	       (T
		<TELL "There's no good surface on" TR ,PRSI>)>>

<ROUTINE V-PUT-THROUGH ()
	 <COND (<FSET? ,PRSI ,DOORBIT>
		<COND (<FSET? ,PRSI ,OPENBIT>
		       <V-THROW>)
		      (T
		       <DO-FIRST "open" ,PRSI>)>)
	       (<AND <PRSI? <LOC ,PROTAGONIST>>
		     <EQUAL? ,P-PRSA-WORD ,W?THROW ,W?TOSS ,W?HURL>>
		<SETG PRSI <>>
		<V-THROW>)
	       (T
	 	<IMPOSSIBLES>)>>

<ROUTINE V-PUT-TO ()
	 <WASTES>>

<ROUTINE V-PUT-UNDER ()
         <WASTES>>

<ROUTINE V-RAISE ()
	 <HACK-HACK "Playing in this way with">>

<ROUTINE PRE-RESEARCH ()
	 <COND (<PRSO? ,ROOMS> ;"input was LOOK UP"
		<COND (<NOT ,LIT>
		       <TELL ,TOO-DARK CR>)
		      (<FSET? ,HERE ,OUTSIDEBIT>
		       <COND (<EQUAL? <GETP ,HERE ,P?YEAR> 2012>
                      <TELL "It's night. Or, rather, dawn. I mean, one could say it's day already." CR>)
                     (T <TELL "Weak rays of sunlight stream down to the floor." CR>)>)
		      (T
		       <PERFORM ,V?EXAMINE ,CEILING>
		       <RTRUE>)>)
	       (<NOT ,PRSI>
            <TELL "You can look up " T ,PRSO " in a book, you can look up a chimney, you
can look up your best friend's shorts for a laugh; but you CAN'T look up " A ,PRSO "!" CR>)
           (<NOT <FSET? ,PRSI ,READBIT>>
		<TELL ,YOU-CANT "read about things in" AR ,PRSI>)
	       (T
		<RFALSE>)>>

<ROUTINE V-RESEARCH ("AUX" ENTRY BOK)
	 <COND (<EQUAL? ,PRSO ,INTQUOTE>
		<COND (<EQUAL? <GET <NP-LEXBEG <SET ENTRY <GET-NP ,PRSO>>> 0>
			       ,W?QUOTE>
		       <CHANGE-LEXV <NP-LEXBEG .ENTRY> ,W?NO.WORD>)>
		<COND (<EQUAL? <GET <NP-LEXEND .ENTRY> 0>
			       ,W?QUOTE>
		       <CHANGE-LEXV <NP-LEXEND .ENTRY> ,W?NO.WORD>)>
		;<DO-IT-AGAIN>
		<SETG P-CONT <GET ,OOPS-TABLE ,O-START>>
		<SETG P-LEN ,P-WORDS-AGAIN>
		<TELL "[Uh, the quotation marks confused me...]" CR>)
	       (T
        <SET BOK <FIND-IN ,PLAYER ,READBIT>>
		<TELL "You look up \"">
		<NP-PRINT <GET-NP ,PRSO>>
		<TELL "\" in " T .BOK ", but find no entry." CR>)>>

<ROUTINE V-SRESEARCH ()
    <V-FOO>>

<ROUTINE PRE-SRESEARCH ()
	 <PERFORM ,V?RESEARCH ,PRSI ,PRSO>
	 <RTRUE>>

;<ROUTINE V-RAPE ()
	 <TELL "Unacceptably ungallant behavior." CR>>

<ROUTINE PRE-SRIDE-DIR ()
	 <PERFORM ,V?RIDE-DIR ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SRIDE-DIR ()
    <V-FOO>>

<ROUTINE V-RIDE-DIR ()
	 <COND (<NOT <IN? ,PROTAGONIST ,PRSO>>
		<TELL "But you're not even ">
		<COND (<FSET? ,PRSO ,INBIT>
		       <TELL "i">)
		      (T
		       <TELL "o">)>
		<TELL "n" TR ,PRSO>)
	       (<PRSI? ,INTDIR>
		<DO-WALK <WORD-DIR-ID <NP-NAME <GET-NP ,PRSI>>>>)
	       ;(<PRSO? ,CAMEL>
		<TELL "Please use directions, as in RIDE CAMEL WEST." CR>)
	       (T
		<TELL "How can you do that?" CR>)>>

;<ROUTINE V-RIDE-TO ("AUX" V)
	 <COND (<SET V <FIND-IN ,HERE ,VEHBIT>>
		<PERFORM ,V?ENTER .V>
		<RTRUE>)
	       (T
		<TELL ,THERES-NOTHING "to ride." CR>)>>

<ROUTINE V-REACH-IN ("AUX" OBJ)
	 <SET OBJ <FIRST? ,PRSO>>
	 <COND (<FSET? ,PRSO ,WATERBIT>
		<PERFORM-PRSA ,WATER>)
	       (<OR <FSET? ,PRSO ,ACTORBIT>
		    <FSET? ,PRSO ,SURFACEBIT>
		    <NOT <FSET? ,PRSO ,CONTBIT>>>
		<YUKS>)
	       (<NOT <FSET? ,PRSO ,OPENBIT>>
		<DO-FIRST "open" ,PRSO>)
	       (<OR <NOT .OBJ>
		    <FSET? .OBJ ,INVISIBLE>
		    <NOT <FSET? .OBJ ,TRYTAKEBIT>>>
		<TELL ,THERES-NOTHING "in" TR ,PRSO>)
	       (T
		<TELL "You feel something inside" TR ,PRSO>)>>

<ROUTINE V-READ ()
	 <COND (<FSET? ,PRSO ,READBIT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
               (T
                <CANT-VERB-A-PRSO "read">)>>

;<ROUTINE V-RELIEVE ()
	 <TELL ,HUH>>

<ROUTINE V-REMOVE ()
	 <COND (<FSET? ,PRSO ,WEARBIT>
		<PERFORM ,V?TAKE-OFF ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-ROLL ()
	 <TELL "A rolling " D ,PRSO " gathers no moss." CR>>

<ROUTINE V-ROLL-DIR ("AUX" OHERE)
	 <COND ;(<NOT <PRSI? ,INTDIR>>
		<RECOGNIZE>)
	       ;(<PRSO? ,DUMBBELL ,CANNONBALL>
		<COND (<AND <ULTIMATELY-IN? ,PRSO>
			    <NOT <IN? ,PRSO ,WALDO>>>
		       <TELL ,HOLDING-IT>
		       <RTRUE>)>
		<SET OHERE ,HERE>
		<DO-WALK <DIRECTION-CONVERSION>>
		<COND (<NOT <EQUAL? ,HERE .OHERE>>
		       <MOVE ,PRSO ,HERE>
		       <TELL "  " CT ,PRSO " rolls to a stop">)>
		<RTRUE>)
	       (T
		<V-ROLL>)>>

<ROUTINE DIRECTION-CONVERSION ()
	 <WORD-DIR-ID <NP-NAME <GET-NP ,INTDIR>>>>

<ROUTINE V-ROLL-DOWN ("AUX" OHERE)
	 <COND ;(<PRSO? ,DUMBBELL ,CANNONBALL>
		<COND (<AND <ULTIMATELY-IN? ,PRSO>
			    <NOT <IN? ,PRSO ,WALDO>>>
		       <TELL ,HOLDING-IT>
		       <RTRUE>)>
		<SET OHERE ,HERE>
		<DO-WALK ,P?DOWN>
		<COND (<NOT <EQUAL? ,HERE .OHERE>>
		       <TELL "  " CT ,PRSO>
		       <MOVE ,PRSO ,HERE>
			   <TELL " rolls to a stop" ,PERIOD-CR>)>
		<RTRUE>)
	       (T
		<V-ROLL>)>>

<ROUTINE V-ROLL-UP ("AUX" OHERE)
	 <COND ;(<PRSO? ,DUMBBELL ,CANNONBALL>
		<COND (<AND <ULTIMATELY-IN? ,PRSO>
			    <NOT <IN? ,PRSO ,WALDO>>>
		       <TELL ,HOLDING-IT>
		       <RTRUE>)>
		<SET OHERE ,HERE>
		<DO-WALK ,P?UP>
		<COND (<NOT <EQUAL? ,HERE .OHERE>>
		       <MOVE ,PRSO ,HERE>
		       <TELL "  " CT ,PRSO>
		       <PRINT " rolls to a stop">
		       <TELL "." CR>)>
		<RTRUE>)
	       (T
		<V-ROLL>)>>

;<ROUTINE V-SACRED-WORD ()
	 <COND (<AND <NOT <EQUAL? ,SACRED-WORD-NUMBER 10>> ;"haven't seen word"
		     <EQUAL? ,P-PRSA-WORD
			     <GET ,SACRED-WORD-WORDS ,SACRED-WORD-NUMBER>>
		     ,TIME-STOPPED>
		<SETG TIME-STOPPED <>>
		<FSET ,OUTER-GATE ,OPENBIT>
		<FSET ,PERIMETER-WALL ,REDESCBIT>
		<QUEUE I-END-GAME -1>
		<TELL
"As you utter the sacred word, time resumes its normal motion! ">
		<COND (<EQUAL? ,HERE ,PERIMETER-WALL>
		       <TELL "The huge outer gates burst open, and t">)
		      (T
		       <TELL
"You hear a distant grinding sound like the opening of a huge door. T">)>
		<TELL
"he entire structure around you begins to shake and tremble; the last moments
of the castle are at hand!" CR>)
	       (T
	 	<TELL
"As you utter it, the power of the sacred word sends you staggering." CR>)>>

;<ROUTINE V-NOT-SO-SACRED-WORD ()
	 <TELL
"The word hangs in the air like a damp fog before dissipating." CR>>

<ROUTINE V-SADDLE ()
	 <TELL
"You can only saddle something with a saddle! In fact, that's probably
where the word comes from!" CR>>

<ROUTINE V-SAVE-SOMETHING ()
	 <COND (<PRSO? ,ME>
		<V-HINT>)
	       (T
		<TELL "Sorry, but" T ,PRSO " is beyond help." CR>)>>

;"<ADD-WORD 'TIME'	MISCWORD>
<ADD-WORD 'TRIPLET'	MISCWORD>
<ADD-WORD 'TRIPLETS'	MISCWORD>
<ADD-WORD 'QUADRUPLET'	MISCWORD>
<ADD-WORD 'QUINTUPLET'	MISCWORD>
<ADD-WORD 'LETTER'	MISCWORD>
<ADD-WORD 'A'		MISCWORD>
<ADD-WORD 'THE'		MISCWORD>
<ADD-WORD 'Y'		MISCWORD>
<ADD-WORD 'MUSIC'	MISCWORD>
<ADD-WORD 'MUSICAL'	MISCWORD>
<ADD-WORD 'INSTRUMENTS'	MISCWORD>
<ADD-WORD 'BOOKKEEPER'  MISCWORD>
<ADD-WORD 'BOOKKEEPING'  MISCWORD>"

<ROUTINE V-SAY ("OPT" V "AUX" V2 TMP)
	 <COND (<NOT <ASSIGNED? V>>
		<SET TMP <NP-LEXBEG <GET-NP>>>
		<COND (<EQUAL? ,PRSO ,INTQUOTE>
		       <SET TMP <ZREST .TMP <* 2 ;3 ,LEXV-ELEMENT-SIZE-BYTES>>>)>
		<SET V <GET .TMP 0>>
		<SET V2 <GET .TMP ,P-LEXELEN>>)>
	 <COND (<AND ,AWAITING-REPLY
		     <YES-WORD .V>>
		<V-YES>)
	       (<AND ,AWAITING-REPLY
		     <NO-WORD .V>>
		<V-NO>)
	       ;(<INTBL? .V ,SACRED-WORD-WORDS ,SACRED-WORD-WORDS-LENGTH>
		<SETG P-PRSA-WORD .V>
		<V-SACRED-WORD>)                                ;"USEFUL"
	       ;(<AND ,PRSO
		     <PRSO? ,SACRED-WORD-OBJ>>
		<SETG P-PRSA-WORD <NP-NAME <GET-NP ,PRSO>>>
	        <V-SACRED-WORD>)                            ;"ALSO USEFUL"
	       (<SET V <FIND-IN ,HERE ,ACTORBIT>>
		<SETG CLOCK-WAIT T>
		<TELL
"[If you want" T .V " to do something, the proper way is|
   >" D .V ", do something]" CR>) 
	       (T
		<TELL "You say that out loud, but with no effect." CR>)>
	 <STOP>>

;<ROUTINE V-ANSWER-KLUDGE ()
	 <COND (<NOUN-USED? ,W?I ,ME>
		<V-INVENTORY>)
	       (T
	 	<SETG P-WON <>>
		<TELL ,NO-VERB>
		<STOP>)>>

<ROUTINE V-SCORE ()
	 <TELL "You have scored " N ,SCORE " point">
	 <COND (<NOT <EQUAL? ,SCORE 1>>
		<TELL "s">)>
	 <TELL " (out of 1000) in " N ,MOVES " turn">
	 <COND (<NOT <EQUAL? ,MOVES 1>>
		<TELL "s">)>
	 <TELL ". This gives you the rank of ">
	 <COND (<EQUAL? ,SCORE 1000>
		<TELL "Dungeon Master">)
	       (<G? ,SCORE 875>
		<TELL "Cursebuster">)
	       (<G? ,SCORE 750>
		<TELL "Master Explorer">)
	       (<G? ,SCORE 625>
		<TELL "Expert Adventurer">)
	       (<G? ,SCORE 500>
		<TELL "Respected Adventurer">)
	       (<G? ,SCORE 375>
		<TELL "Nobleman">)
	       (<G? ,SCORE 250>
		<TELL "Knight">)
	       (<G? ,SCORE 125>
		<TELL "Tradesman">)
	       (T
		<COND (<L? ,SCORE 0>
		       <TELL "Incompetent ">)>
		<TELL "Peasant">)>
	 <TELL ,PERIOD-CR>>

<ROUTINE SCORE-OBJ (OBJ "AUX" VAL)
	 <>
     ;<SET VAL <GETP .OBJ ,P?VALUE>>
	 ;<COND (.VAL
		<INC-SCORE .VAL>
		<PUTP .OBJ ,P?VALUE 0>)>>

<ROUTINE V-NOTIFY ()
	 <TELL "Okay, you will no">
	 <COND (,NOTIFICATION-ON
		<SETG NOTIFICATION-ON <>>
		<TELL " longer">)
	       (T
		<SETG NOTIFICATION-ON T>
		<TELL "w">)>
	 <TELL " be notified when your score changes." CR>>

<GLOBAL NOTIFICATION-ON T>

<GLOBAL NOTIFICATION-WARNING <>>

<ROUTINE INC-SCORE (PTS)
	 <COND (<NOT <EQUAL? .PTS 0>>
		<COND (,NOTIFICATION-ON
		       <SOUND 1>
		       <HLIGHT ,H-BOLD>
		       <TELL "  [Your score has just gone ">
		       <COND (<G? .PTS 0>
			      <TELL "up">)
			     (T
			      <TELL "down">)>
		       <TELL " by ">
		       <COND (<G? .PTS 0>
			      <PRINTN .PTS>)
			     (T
			      <PRINTN <* .PTS -1>>)>
		       <TELL ".">
		       <COND (<NOT ,NOTIFICATION-WARNING>
			      <SETG NOTIFICATION-WARNING T>
			      <TELL
" Note: you can turn this feature on and off using the NOTIFY command.">)>
		       <TELL "]" CR>
		       <HLIGHT ,H-NORMAL>)>
		<SETG SCORE <+ ,SCORE .PTS>>)>
	 <RTRUE>>

<ROUTINE V-SEARCH ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<V-SHAKE>)
	       (<IN? ,PROTAGONIST ,PRSO>
		<D-VEHICLE>)
	       (<AND <FSET? ,PRSO ,CONTBIT>
		     <NOT <FSET? ,PRSO ,OPENBIT>>>
		<DO-FIRST "open" ,PRSO>)
	       (<FSET? ,PRSO ,CONTBIT>
		<TELL "You find">
		<COND (<NOT <D-NOTHING>>
		       <TELL ,PERIOD-CR>)>
		<RTRUE>)
	       (T
		<CANT-VERB-A-PRSO "search">)>>

<ROUTINE V-SSEARCH-OBJECT-FOR ()
    <V-FOO>>

<ROUTINE PRE-SSEARCH-OBJECT-FOR ()
	 <PERFORM ,V?SEARCH-OBJECT-FOR ,PRSI, PRSO>
	 <RTRUE>>

<ROUTINE V-SEARCH-OBJECT-FOR ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?SEARCH ,PRSO>
		<RTRUE>)
	       (<AND <FSET? ,PRSO ,CONTBIT>
		     <NOT <FSET? ,PRSO ,OPENBIT>>>
		<DO-FIRST "open" ,PRSO>)
	       (<OR <IN? ,PRSI ,PRSO>
		    <IN? ,PRSI ,HERE>>
		<TELL "Very observant. There " HE-V ,PRSI "is" "." CR>)
	       (T 
		<TELL "You don't find" T ,PRSI " there." CR>)>>

<ROUTINE V-SEND ()
	 <TELL
"You haven't any stamps, and there isn't a mailbox in sight!" CR>>

<ROUTINE V-SET ()
	 <COND (<NOT ,PRSI>
		<COND (<PRSO? ,ROOMS> ;"input was TURN AROUND"
		       <TELL
"You do a 360 degree spin. You're not a ballet dancer, are you?" CR>
               <SETG AWAITING-REPLY 1>
               <QUEUE I-REPLY 2>)
		      (<OR <FSET? ,PRSO ,TAKEBIT>
			   <FSET? ,PRSO ,INTEGRALBIT>>
		       <HACK-HACK "Turning">)
		      (T
		       <TELL ,YNH TR ,PRSO>)>) 
	       (T
		<IMPOSSIBLES>)>>

<ROUTINE V-SET-DIR ()
	 <IMPOSSIBLES>>

<ROUTINE V-SHAKE ("AUX" PERSON)
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL "That wouldn't be polite." CR>)
	       ;(<EQUAL? ,PRSO ,HANDS> ;"in hands-f"
		<COND (<SET PERSON <FIND-IN ,HERE ,ACTORBIT "with">>
		       <PERFORM ,V?SHAKE-WITH ,PRSO .PERSON>
		       <RTRUE>)>)
	       (T
		<HACK-HACK "Shaking">)>>

<ROUTINE V-SHAKE-WITH ()
	 <COND (<NOT ,PRSI>
		<PERFORM ,V?SHAKE-WITH ,HANDS ,PRSO>
		<RTRUE>)
	       (<NOT <PRSO? ,HANDS>>
		<RECOGNIZE>)
	       (<NOT <FSET? ,PRSI ,ACTORBIT>>
		<TELL "I don't think" T ,PRSI " even has hands." CR>)
	       (T
		<PERFORM ,V?THANK ,PRSI>
		<RTRUE>)>>

<ROUTINE V-SHOW ("AUX" ACTOR)
	 <COND (<AND <NOT ,PRSI>
		     <SET ACTOR <FIND-IN ,HERE ,ACTORBIT>>>
		<PERFORM ,V?SHOW ,PRSO .ACTOR>
		<RTRUE>)
	       (<NOT ,PRSI>
		<PRINT "There's no one here to ">
		<TELL "show it to." CR>)
	       (T
		<TELL 
"It doesn't look like" T-IS-ARE ,PRSI "interested." CR>)>>

<ROUTINE V-SHUT-UP ()
	 <COND (<PRSO? ,ROOMS>
		<TELL "[I hope you're not addressing me...]" CR>)
	       (T
		<PERFORM ,V?CLOSE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-SING ()
	 <TELL ,HUH>>

<ROUTINE V-SING-TO ()
	<WASTES>>

<ROUTINE V-SINK ()
	 <IMPOSSIBLES>>

<ROUTINE V-SIT ("AUX" VEHICLE)
	 <COND (<AND ,PRSO
		     <NOT <PRSO? ,ROOMS>>>
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (<NOT <IN? ,PROTAGONIST ,HERE>>
		<TELL ,LOOK-AROUND>)
	       ;(<EQUAL? ,HERE ,CASINO>
		<TELL "[at the card table]" CR>
		<PERFORM ,V?ENTER ,CARD-TABLE>
		<RTRUE>)
	       (<SET VEHICLE <FIND-IN ,HERE ,VEHBIT "on">>
		<PERFORM ,V?ENTER .VEHICLE>
		<RTRUE>)
               (T
		<WASTES>)>>

<ROUTINE V-SKIP ()
	 <TELL "Wasn't that fun?" CR>
     <SETG AWAITING-REPLY 1>
     <QUEUE I-REPLY 2>>

<ROUTINE V-SLEEP ()
	 <TELL "You're not tired" ,PERIOD-CR>>

<ROUTINE PRE-SMELL ()
	 <>
     ;<COND (<FSET? ,CLOWN-NOSE ,WORNBIT>
		<TELL ,YOU-CANT "smell a thing with this clown nose on!" CR>)>>

<ROUTINE V-SMELL ()
	 <COND (<NOT ,PRSO>
		<TELL "You smell nothing unusual at the moment." CR>)
	       (T
		<SENSE-OBJECT "smell">)>>

<ROUTINE SENSE-OBJECT (STRING)
	 <PRONOUN>
	 <TELL " " .STRING>
	 <COND (<AND <NOT <FSET? ,PRSO ,PLURALBIT>>
		     <NOT <PRSO? ,ME>>>
		<TELL "s">)>
	 <TELL " just like" AR ,PRSO>>

<ROUTINE V-SNAP ()
	 <TELL "Perhaps it's your mind that has snapped." CR>>

<ROUTINE V-SPUT-ON ()
    <V-FOO>>

<ROUTINE PRE-SPUT-ON ()
     <PERFORM ,V?PUT-ON ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SSHOW ()
    <V-FOO>>

<ROUTINE PRE-SSHOW ()
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-STAND ()
	 <COND (<EQUAL? ,P-PRSA-WORD ,W?HOLD> ;"for HOLD UP OBJECT"
		<WASTES>)
	       (<AND ,PRSO
		     <FSET? ,PRSO ,TAKEBIT>
		     <EQUAL? ,P-PRSA-WORD ,W?STAND> ;"for STAND UP OBJECT">
		<WASTES>)
	       (<AND <EQUAL? ,P-PRSA-WORD ,W?GET> ;"for GET UP ON OBJECT"
		     ,PRSO
		     <NOT <PRSO? ,ROOMS>>> ;"not GET UP"
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (<NOT <IN? ,PROTAGONIST ,HERE>>
		<PERFORM ,V?EXIT <LOC ,PROTAGONIST>>
		<RTRUE>)
	       (<AND <NOT <PRSO? ,ROOMS <>>>
		     <NOT <EQUAL? ,P-PRSA-WORD ,W?STAND>>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (T
		<TELL "You're already standing." CR>)>>

<ROUTINE V-STAND-ON ()
	 <COND (<AND <FSET? ,PRSO ,VEHBIT>
             <FSET? ,PRSO ,SURFACEBIT>>
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (T
	 	<WASTES>)>>

<ROUTINE V-STELL ()
	 <PERFORM ,V?TELL ,PRSI>
	 <RTRUE>>

<ROUTINE V-STHROW ()
    <V-FOO>>

<ROUTINE PRE-STHROW ()
	 <COND (<PRSI? ,INTDIR>
		<PERFORM ,V?THROW ,PRSO ,PRSI>)
	       (T
	 	<PERFORM ,V?THROW-TO ,PRSI ,PRSO>)>
	 <RTRUE>>

<ROUTINE V-SUCK-ON ()
	 <PERFORM ,V?TASTE ,PRSO>
	 <RTRUE>>

<ROUTINE V-SUCK-WITH ()
	 <PERFORM ,V?DRINK ,PRSO ,PRSI>
	 <RTRUE>>

<ROUTINE V-SWAT ()
	 <COND (,PRSI
		<TELL "Sorry, but" A ,PRSI " makes a poor ">)
	       (T
		<TELL "You don't have a ">)>
	<TELL D ,PRSO "swatter." CR>>

<ROUTINE V-SWIM ("AUX" X)
	 <COND (,PRSO
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (<SET X <FIND-WATER>>
		<PERFORM ,V?ENTER .X>
		<RTRUE>)
	       (T
		<TELL "Your head must be swimming." CR>)>>

<ROUTINE V-SWING ()
	<TELL "\"Whoosh.\"" CR>>

;"called from syntaxes that switch the prso and prsi"
;<ROUTINE PRE-SWITCH ()
	<SETG OBJ-SWAP T>
	<RFALSE>>

;<ROUTINE PRE-SWITCH ("AUX" I O IA OA)
	 <SET O <NP-NAME <GET-NP ,PRSO>>>
	 <SET I <NP-NAME <GET-NP ,PRSI>>>
	 <SET OA <GET <NP-ADJS <GET-NP ,PRSO>> 1>>
	 <SET IA <GET <NP-ADJS <GET-NP ,PRSI>> 1>>
	 <NP-NAME <GET-NP ,PRSO> .I>
	 <NP-NAME <GET-NP ,PRSI> .O>
	 <PUT <NP-ADJS <GET-NP ,PRSO>> 1 .IA>
	 <PUT <NP-ADJS <GET-NP ,PRSO>> 1 .OA> 
	 <RFALSE>>		

<ROUTINE V-SWRAP ()
    <V-FOO>>

<ROUTINE PRE-SWRAP ()
	 <PERFORM ,V?WRAP ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE PRE-TAKE ()
	 <COND (<AND <NOT <FSET? ,PRSO ,PARTBIT>>
		     <PRE-LOOK>>
		<RTRUE>)
	       (<IN? ,PROTAGONIST ,PRSO>		     
		<TELL "You're ">
		<COND (<FSET? ,PRSO ,INBIT>
		       <TELL "i">)
		      (T
		       <TELL "o">)>
		<TELL "n it!" CR>)
	       (<AND <ULTIMATELY-IN? ,PRSO>
		     ,PRSI
		     <IN? ,PRSI ,ROOMS>> ;"such as TAKE PLATTER IN SCULLERY"
		<V-WALK-AROUND>)
	       (<UNTOUCHABLE? ,PRSO>
		<COND (T
		       <CANT-REACH ,PRSO>)>)
	       (<NOT ,PRSI>
		<RFALSE>)
	       (<PRSI? ,ME>
		<PERFORM ,V?DROP ,PRSI>
		<RTRUE>)
	       (<AND <PRSO? ,WATER>
		     <EQUAL? ,P-PRSA-WORD ,W?REMOVE>
		     ;<OR <AND <PRSI? ,LARGE-VIAL>
			      <G? ,LARGE-VIAL-WATER 0>>
			 <AND <PRSI? ,SMALL-VIAL>
			      <G? ,SMALL-VIAL-WATER 0>>>>
		<PERFORM ,V?EMPTY-FROM ,PRSO ,PRSI>
		<RTRUE>)
	       (<AND <NOT <IN? ,PRSO ,PRSI>>
		     <NOT <EQUAL? ,PRSI <GETP ,PRSO ,P?OWNER>>>>
		<NOT-IN>)
	       (,PRSI
		<SETG PRSI <>>
		<RFALSE>)>>

<ROUTINE V-TAKE ("AUX" (L <LOC ,PRSO>))
	 <COND (<NOT <EQUAL? <ITAKE T> ,M-FATAL>>
		<COND (<OR <EQUAL? .L ,HERE>
			   <EQUAL? .L <LOC ,PROTAGONIST>>>
		       <TELL "You pick up" TR ,PRSO>)
		      (T
		       <TELL "You take" T ,PRSO " from" TR .L>)>
		<SCORE-OBJ ,PRSO>)>>

<ROUTINE V-TAKE-OFF ("AUX" (VEHICLE <LOC ,PROTAGONIST>))
	 <COND (<PRSO? ,ROOMS>
		<COND (<FSET? .VEHICLE ,VEHBIT>
		       <PERFORM ,V?EXIT .VEHICLE>
		       <RTRUE>)
		      (T
		       <TELL "You're not ">
		       <COND (<EQUAL? <PARSE-PARTICLE1 ,PARSE-RESULT> ,W?OUT>
			      <TELL "i">)
			     (T ;"get off"
			      <TELL "o">)>
		       <TELL "n anything." CR>)>)
	       (<FSET? ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,WORNBIT>
		<THIS-IS-IT ,PRSO>
		<TELL "You remove" TR ,PRSO>)
	       (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?EXIT ,PRSO>
		<RTRUE>)
	       (T
		<TELL "You aren't wearing" TR ,PRSO>)>>

<ROUTINE V-TAKE-WITH ()
	 <COND (<NOT <ULTIMATELY-IN? ,PRSI>>
		<TELL ,YNH TR ,PRSI>)
	       (T
		<TELL "Sorry," T-IS-ARE ,PRSI "no help in getting" TR ,PRSO>)>>

<ROUTINE V-TASTE ()
	 <SENSE-OBJECT "taste">>

<ROUTINE PRE-TELL ()
	 <COND (<OR <VERB? SING SING-TO SAY>
		    <NOT ,PRSO>> ;"for example, V-YELL"
		<RFALSE>)
	       ;(<AND <FSET? ,PRSO ,PLANTBIT>
		     ,PLANT-TALKER>
		<COND (<PRSO? ,SPENSEWEED ,LITTLE-FUNGUS ,FLOWER>
		       ;"must handle here before MAIN-LOOP can call PRSO's
			LOC/container with M-END"
		       <PLANT-STUNNED ,PRSO>)
		      (T
		       <RFALSE>)>)
	       ;(<AND <OR <PRSO? ,OTHER-J-NAMES>
			 <AND <PRSO? ,MID-NAME>
			      <NOUN-USED? ,MID-NAME
					 <GET ,MID-NAME-WORDS ,MID-NAME-NUM>>>>
		     <VISIBLE? ,JESTER>>
		<PERFORM-PRSA ,JESTER>
		<RTRUE>)
	       ;(<PRSO? ,OTHER-J-NAMES ,MID-NAME>
		<TELL ,BY-THAT-NAME>
		<STOP>)
	       ;(<AND <PRSO? ,LITTLE-FUNGUS>
		     <IN? ,LITTLE-FUNGUS ,GLOBAL-OBJECTS>>
		<COND (<EQUAL? ,HERE ,ON-TOP-OF-THE-WORLD>
		       <PERFORM ,V?CALL ,PRSO>)
		      (T
		       <TELL ,BY-THAT-NAME>)>
		<STOP>)
	       (<AND <NOT <FSET? ,PRSO ,ACTORBIT>>
	             <NOT <PRSO? ,ME ,INTQUOTE>>>
		<V-TELL>
		<STOP>)>>

<ROUTINE V-TELL ()
	 <COND (<OR <FSET? ,PRSO ,ACTORBIT>
		    <PRSO? ,SAILOR>>
		<COND (<OR ,P-CONT
			   <PRSO? ,SAILOR>>
		       <SETG WINNER ,PRSO>
		       <SETG CLOCK-WAIT T>
		       <RTRUE>)
		      (T
		       <TELL
"Hmmm..." T ,PRSO " looks at you expectantly,
as if you seemed to be about to talk." CR>)>)
	       (T
		<TELL
"It's a well-known fact that only schizophrenics talk to" AR ,PRSO>
	        <STOP>)>>

<ROUTINE V-TELL-ABOUT ()
	 <COND (<PRSO? ,ME>
		<TELL
"[Maybe you could find an encyclopedia to look that up in.]" CR>)
	       (T
		<PERFORM ,V?SHOW ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE V-THANK ()
	 <COND (<NOT ,PRSO>
		<TELL "[Just doing my job.]" CR>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<TELL HE-V ,PRSO "seem" " unmoved by your politeness." CR>)
	       (T
		<IMPOSSIBLES>)>>

<ROUTINE V-THROW ()
	 <COND (<NOT <SPECIAL-DROP ,PRSO>>
	 	<COND (T
		       <MOVE ,PRSO ,HERE>)>
		<COND (<AND ,PRSI
			    <NOT <PRSI? ,GROUND ,INTDIR>>>
		       <TELL "You missed." CR>)
		      (T
		       <THIS-IS-IT ,PRSO>
		       <TELL "Thrown." CR>)>)>>

<ROUTINE V-THROW-OVER ()
	 <WASTES>>

<ROUTINE V-THROW-FROM ()
	 <IMPOSSIBLES>>

<ROUTINE V-THROW-OVERBOARD ()
	<TELL "You generally have to be on a boat to do that." CR>>

<ROUTINE V-THROW-TO ()
	 <COND (<FSET? ,PRSI ,ACTORBIT>
		<PERFORM ,V?GIVE ,PRSO ,PRSI>
		<RTRUE>)
	       (T
		<PERFORM ,V?THROW ,PRSO ,PRSI>
		<RTRUE>)>>

<ROUTINE V-TIE ()
	 <TELL ,YOU-CANT "tie" TR ,PRSO>>

<ROUTINE V-TIME ()
	 <TELL "It is daytime. You have taken " N ,MOVES " turn">
	 <COND (<NOT <1? ,MOVES>>
		<TELL "s">)>
	 <COND (<G? ,MOVES 1000>
		<TELL
". (The day really seems to be dragging, doesn't it?)" CR>)
	       (T
		<TELL ,PERIOD-CR>)>>

<ROUTINE V-TIP ()
	<TELL HE-V ,PRSO "do" "n't seem too interested." CR>>

<ROUTINE V-TIP-OVER ()
	 <WASTES>>

<ROUTINE PRE-TOUCH ()
	 <COND (<UNTOUCHABLE? ,PRSO>
		<CANT-REACH ,PRSO>
		<RTRUE>)>>

<ROUTINE V-STOUCH ()
    <V-FOO>>

<ROUTINE PRE-STOUCH ()
	 <PERFORM ,V?TOUCH ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-TOUCH ()
	 <COND (<LOC-CLOSED ,PRSO>
		<RTRUE>)
	       (T
		<HACK-HACK "Fiddling with">)>>

<ROUTINE V-UNLOCK ()
	 <COND (<FSET? ,PRSO ,LOCKEDBIT>
		<PRINT "Unfortunately,">
		<TELL T ,PRSI " do">
		<COND (<NOT <FSET? ,PRSI ,PLURALBIT>>
		       <TELL "es">)>
		<TELL "n't unlock" TR ,PRSO>)
	       (T
		<TELL "But" T ,PRSO " isn't locked." CR>)>>

<ROUTINE V-UNTIE ()
	 <IMPOSSIBLES>>

<ROUTINE V-USE ()
	 <TELL
,YOULL-HAVE-TO "be more specific about how you want to use" TR ,PRSO>>

;<ROUTINE V-USE-QUOTES ()
	 <COND ;(<IN? ,HAREM-GUARD ,HERE>
		<PICK-WIFE ,PRSO>)
	       (T
	        <TELL
"[You need quotes to say something \"out loud.\" See the instruction manual
section entitled \"Communicating With Infocom's Interactive Fiction.\"]" CR>)>>

<ROUTINE V-WALK ("AUX" (AV <LOC ,PROTAGONIST>) VEHICLE PT PTS STR OBJ RM)
	 <COND (<NOT ,P-WALK-DIR>
		<USE-PREPOSITIONS "WALK " "TO" "THROUGH" "AROUND">)
           (<AND <PRSO? ,P?OUT>
		     <FSET? .AV ,DROPBIT>>
		<IF-P-IMAGES <RETURN-FROM-MAP>>
		<PERFORM ,V?EXIT .AV>
		<RTRUE>)	        
	       (<AND <PRSO? ,P?IN>
		     <NOT <GETPT ,HERE ,P?IN>>
		     <SET VEHICLE <FIND-IN ,HERE ,VEHBIT>>
		     <NOT <ULTIMATELY-IN? .VEHICLE>>>
		<IF-P-IMAGES <RETURN-FROM-MAP>>
		<COND (<EQUAL? ,P-PRSA-WORD ,W?ENTER>
		       <TELL "[">
		       <COND (<NOT <FSET? .VEHICLE ,NARTICLEBIT>>
			      <TELL "the ">)>
		       <TELL D .VEHICLE "]" CR>)>
		<PERFORM ,V?ENTER .VEHICLE>
		<RTRUE>)
	       ;(<AND <PRSO? ,P?DOWN>
		     <IN? ,PROTAGONIST ,YACHT>>
		<GOTO ,HOLD>)
	       ;(,UNDER-TABLE
		<RETURN-FROM-MAP>
		<DO-FIRST "get out from under the table">)
	       (<AND <FSET? .AV ,VEHBIT>
		     ;<NOT <AND <EQUAL? .AV ,LADDER>
			       <PRSO? ,P?UP>>>
		     ;<NOT <AND <EQUAL? .AV ,CAMEL>
			       <FSET? ,CAMEL ,ANIMATEDBIT>>>>
		<COND ;(<AND <EQUAL? .AV ,DB>
			    <PRSO? ,P?UP>
			    <NOT <EQUAL? ,HERE ,HOLD>>>
		       <PERFORM ,V?RAISE ,LEVER>
		       <RTRUE>)
		      ;(<AND <EQUAL? .AV ,DB>
			    <PRSO? ,P?DOWN>
			    <NOT <EQUAL? ,HERE ,LAKE-BOTTOM>>>
		       <PERFORM ,V?LOWER ,LEVER>
		       <RTRUE>)>
		<IF-P-IMAGES <RETURN-FROM-MAP>>
		<TELL "You're not going anywhere until you get ">
		<COND (<FSET? .AV ,INBIT>
		       <TELL "out of">)
		      (T
		       <TELL "off">)>
		<SETG P-CONT -1> ;<RFATAL>
		<TELL TR .AV>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<EQUAL? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<EQUAL? .PTS ,NEXIT>
		       <IF-P-IMAGES <RETURN-FROM-MAP>>
		       <SETG P-CONT -1> ;<RFATAL>
		       <TELL <GET .PT ,NEXITSTR> CR>)
		      (<EQUAL? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <COND (<NOT <EQUAL? .RM ,PSEUDO-OBJECT>>
				     <GOTO .RM>)>)
			     (T
			      <SETG P-CONT -1> ;<RFATAL>)>)
		      (<EQUAL? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <SETG P-CONT -1> ;<RFATAL>
			      <IF-P-IMAGES <RETURN-FROM-MAP>>
			      <TELL .STR CR>)
			     (T
			      <SETG P-CONT -1> ;<RFATAL>
			      <CANT-GO>)>)
		      (<EQUAL? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GET .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,DEXITRM>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <IF-P-IMAGES <RETURN-FROM-MAP>>
			      <THIS-IS-IT .OBJ>
			      <SETG P-CONT -1> ;<RFATAL>
			      <TELL .STR CR>)
			     (T
			      <IF-P-IMAGES <RETURN-FROM-MAP>>
			      <THIS-IS-IT .OBJ>
			      <SETG P-CONT -1> ;<RFATAL>
			      <DO-FIRST "open" .OBJ>)>)>)
	       (T
		<COND (<PRSO? ,P?OUT ,P?IN>
		       <V-WALK-AROUND>)
		      (T
		       <CANT-GO>)>
		<SETG P-CONT -1> ;<RFATAL>)>>

<ROUTINE CANT-GO ()
	 <COND (<AND <NOT ,LIT>
		     ;<NOT <EQUAL? <LOC ,PROTAGONIST> ,DB ,HOLD>>
		     ;<NOT ,TIME-STOPPED>
		     <PROB 75>>
		<IF-P-IMAGES <RETURN-FROM-MAP>>
		;<DARK-DEATH>)
	       (T
		<BEEP-OR-CANT-GO>)>>

<ROUTINE BEEP-OR-CANT-GO ()
	 <COND ;(<EQUAL? ,CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>
		<SOUND 1>)
	       (T
		<TELL "You can't go that way." CR>)>>

<ROUTINE V-WALK-AROUND ()
	 <TELL "Please use compass directions to move around." CR>>

<ROUTINE V-WALK-TO ()
	 <COND (<OR <IN? ,PRSO ,HERE>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL HS ,PRSO " here!" CR>)
	       (T
		<V-WALK-AROUND>)>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 <TELL "Time ">
	 <COND ;(,TIME-STOPPED
		<TELL "doesn't pass">)
	       (T
		<TELL "passes">)>
	 <TELL "..." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0>
			<RETURN>)
		       (<CLOCKER>
			<RETURN>)>>
	 <COND (<AND <SET NUM <LOC ,WINNER>>
		     <NOT <IN? .NUM ,ROOMS>>
		     ;<FSET? .NUM ,VEHBIT>>
		<IFFLAG (P-DEBUGGING-PARSER
			 <SET NUM <D-APPLY "M-END" <GETP .NUM ,P?ACTION> ,M-END>>)
			(T
			 <SET NUM <ZAPPLY <GETP .NUM ,P?ACTION> ,M-END>>)>)>
	 <IFFLAG (P-DEBUGGING-PARSER
		  <SET NUM <D-APPLY "M-END" <GETP ,HERE ,P?ACTION> ,M-END>>)
		 (T
		  <SET NUM <ZAPPLY <GETP ,HERE ,P?ACTION> ,M-END>>)>
	 <COND (<EQUAL? ,M-FATAL .NUM>
		<SETG P-CONT -1>)>
	 <SETG CLOCK-WAIT T>>

<ROUTINE V-WAIT-FOR ()
	 <COND (<VISIBLE? ,PRSO>
		<V-FOLLOW>)
	       (T
	 	<TELL "You may be waiting quite a while." CR>)>>

;<ROUTINE V-WAVE ()
	 <COND (<AND ,PRSI
		     <NOT ,IN-FRONT-FLAG>>
		<RECOGNIZE>)
	       (<ULTIMATELY-IN? ,PRSO>
		<WASTES>)	       	       
	       (T
		<TELL ,YNH TR ,PRSO>)>>

<ROUTINE V-WEAR ()
         <COND (<NOT <FSET? ,PRSO ,WEARBIT>>
		<CANT-VERB-A-PRSO "wear">)
	       (T
		<TELL "You're ">
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "already">)
		      (T
		       <MOVE ,PRSO ,PROTAGONIST>
		       <FSET ,PRSO ,WORNBIT>
		       <TELL "now">)>
		<TELL " wearing" TR ,PRSO>)>>

<ROUTINE V-WRAP ()
	 <WASTES>>

<ROUTINE V-YAWN ()
	<SETG AWAITING-REPLY 1>
	<QUEUE I-REPLY 2>
	<TELL "[Is the game boring you?]" CR>>

<ROUTINE V-YELL ()
	 <COND (<PRSO? ,INTQUOTE>
		<V-SAY>)
	       (T
	 	<TELL "Aaaarrrggghhhh!" CR>
	 	<STOP>)>>

<ROUTINE I-REPLY ()
	 <SETG AWAITING-REPLY <>>
	 <RFALSE>>

<GLOBAL AWAITING-REPLY <>>

<ROUTINE V-YES ()
	 <COND (<EQUAL? ,AWAITING-REPLY 1> 
	        <TELL "That was just a rhetorical question." CR>)
	       (T
	 	<YOU-SOUND "posit">)>>

<ROUTINE YOU-SOUND (STRING)
	 <TELL "You sound rather " .STRING "ive." CR>>

<ROUTINE YES-WORD (WRD)
	 <COND (<OR <EQUAL? .WRD ,W?YES ,W?Y ,W?YUP>
		    <EQUAL? .WRD ,W?OK ,W?OKAY ,W?SURE>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-ZAP ()
	 <COND (,PRSI
		<PERFORM ,V?POINT ,PRSI ,PRSO>
		<RTRUE>)
	       (T
		<TELL "You have neither a magical wand nor a ray gun." CR>)>>

;"subtitle object manipulation"

<ROUTINE ITAKE ("OPTIONAL" (VB T) (OBJ 0))
	 <COND (<ZERO? .OBJ>
		<SET OBJ ,PRSO>)>
	 <COND (<FSET? .OBJ ,INTEGRALBIT>
		<COND (.VB
		       <PART-OF>)>
		<RFATAL>)
	       (<NOT <FSET? .OBJ ,TAKEBIT>>
		<COND (.VB
		       <YUKS>)>
		<RFATAL>)
           (<LOC-CLOSED .OBJ .VB>
		<RFATAL>)
	       (<UNTOUCHABLE? .OBJ>
		<COND (.VB
		       <CANT-REACH .OBJ>)>
		<RFATAL>)
	       (<G? <CCOUNT ,PROTAGONIST> 10>
		<COND (.VB
		       <TELL
"You're already juggling as many items as you could possibly carry." CR>)>
		<RFATAL>)
	       (<AND <NOT <ULTIMATELY-IN? .OBJ>>
		     <G? <+ <WEIGHT .OBJ> <WEIGHT ,PROTAGONIST>> 100>>
		<COND (.VB
		       <TELL HS ,PRSO "too heavy">
		       <COND (<FIRST? ,PROTAGONIST>
			      <TELL ", considering your current load">)>
		       <TELL ,PERIOD-CR>)>
		<RFATAL>)>
	 <FSET .OBJ ,TOUCHBIT>
	 <FCLEAR .OBJ ,NDESCBIT>
	 <COND (<IN? ,PROTAGONIST .OBJ>
		<RFALSE> ;"Hope this is right -- pdl 4/22/86")>
	 <COND (<NOT .VB> ;"called by PARSER for implicit take"
		<TELL "[taking" T .OBJ " first]" CR>
		<SCORE-OBJ .OBJ>)>
	 <MOVE .OBJ ,PROTAGONIST>>

;"IDROP is called by PRE-GIVE and PRE-PUT.
  IDROP acts directly as PRE-DROP, PRE-THROW and PRE-PUT-THROUGH."
<ROUTINE IDROP ()
	 <COND (<PRSO? ,ROOMS> ;"input was LET GO"
		<TELL "You're not hanging onto anything." CR>)
	       (<PRSO? ,HANDS>
		<COND (<VERB? DROP THROW GIVE>
		       <IMPOSSIBLES>)
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? THROW>
		     <PRSO? ,EYES>>
		<COND (<NOT ,PRSI>
		       <V-LOOK>
		       <RTRUE>)>
		;<PRE-SWITCH>
		<PERFORM ,V?EXAMINE ,PRSI ,EYES>
		<RTRUE>)
	       (<AND <PRSO? ,ME>
		     <VERB? PUT>
		     <FSET? ,PRSI ,ACTORBIT>>
		<PERFORM ,V?ENTER ,PRSI>
		<RTRUE>)
	       (<AND <PRSI? ,ME>
		     <VERB? PUT>
		     <FSET? ,PRSO ,ACTORBIT>>
		<PERFORM ,V?ENTER ,PRSO>
		<RTRUE>)
	       (<NOT <ULTIMATELY-IN? ,PRSO>>
		<COND (<OR <PRSO? ,ME>
			   <FSET? ,PRSO ,PARTBIT>>
		       <IMPOSSIBLES>)
		      (T
		       <TELL
"That's easy for you to say since you don't even have" TR ,PRSO>)>
		<RFATAL>)
	       (<FSET? ,PRSO ,INTEGRALBIT>
		<PART-OF>)
	       (<AND <NOT <IN? ,PRSO ,PROTAGONIST>>
		     <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<DO-FIRST "open" <LOC ,PRSO>>)
	       (<FSET? ,PRSO ,WORNBIT>
		<DO-FIRST "remove" ,PRSO>)
	       (T
		<RFALSE>)>>

<ROUTINE CCOUNT	(OBJ "OPTIONAL" (DESCRIBED-ITEMS-ONLY <>) "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<AND .DESCRIBED-ITEMS-ONLY
				    <FSET? .X ,NDESCBIT>>
			       T)
			      (<NOT <FSET? .X ,WORNBIT>>
			       <SET CNT <+ .CNT 1>>)>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

;"Gets SIZE of supplied object, recursing to nth level."
<ROUTINE WEIGHT (OBJ "AUX" CONT (WT 0))
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<NOT <FSET? .CONT ,WORNBIT>>
			       <SET WT <+ .WT <WEIGHT .CONT>>>)>
			<COND (<NOT <SET CONT <NEXT? .CONT>>>
			       <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

;"subtitle describers"

<ROUTINE D-ROOM ("OPTIONAL" (VERB-IS-LOOK <>) "AUX" (FIRST-VISIT <>) PIC)
	 <COND (<NOT ,LIT>
		<TELL ,TOO-DARK>
		;<GRUE-PIT-WARNING>
		<RFALSE>)
	       (<OR <NOT <FSET? ,HERE ,TOUCHBIT>>
		    <FSET? ,HERE ,REDESCBIT>>
		<SET FIRST-VISIT T>)>
	 <HLIGHT ,H-BOLD>
	 <SAY-HERE>
	 <HLIGHT ,H-NORMAL>
	 <CRLF>
	 <COND (<OR .VERB-IS-LOOK
		    <EQUAL? ,VERBOSITY 2>
		    <AND .FIRST-VISIT
			 <EQUAL? ,VERBOSITY 1>>>
		<IF-P-IMAGES
        <COND (<SET PIC <GETP ,HERE ,P?ICON>>
		       <MARGINAL-PIC .PIC>)
		      (T
		       <TELL "  ">)>>
        <IFN-P-IMAGES <TELL "  ">>
		<COND (<NOT <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <TELL <GETP ,HERE ,P?LDESC>>)>
		<CRLF>)>
	 <FCLEAR ,HERE ,REDESCBIT>
	 <FSET ,HERE ,TOUCHBIT>
	 ;<COND (<EQUAL? ,HERE ,CONSTRUCTION ,PLAIN ,FR-OFFICES ,OFFICES-NORTH
			      ,OFFICES-SOUTH ,OFFICES-EAST ,OFFICES-WEST>
		<FSET ,HERE ,REDESCBIT>)>
	 <RTRUE>>

;"Print FDESCs, then DESCFCNs and LDESCs, then everything else. DESCFCNs
must handle M-OBJDESC? by RTRUEing (but not printing) if the DESCFCN would
like to handle printing the object's description. RFALSE otherwise. DESCFCNs
are responsible for doing the beginning-of-paragraph indentation."

<ROUTINE D-OBJECTS ("AUX" O STR (1ST? T) (AV <LOC ,PROTAGONIST>))
	 <SET O <FIRST? ,HERE>>
	 <COND (<NOT .O>
		<RFALSE>)>
	 <REPEAT () ;"FDESCS and MISC."
		 <COND (<NOT .O>
			<RETURN>)
		       (<AND <DESCRIBABLE? .O>
			     <NOT <FSET? .O ,TOUCHBIT>>
			     <SET STR <GETP .O ,P?FDESC>>>
			<TELL "  " .STR>
			<COND (<FSET? .O ,CONTBIT>
			       <D-CONTENTS .O T <+ ,D-ALL? ,D-PARA?>>)>
			<CRLF>)>
		 <SET O <NEXT? .O>>>
	 <SET O <FIRST? ,HERE>>
	 <SET 1ST? T>
	 <REPEAT () ;"DESCFCNS"
		 <COND (<NOT .O>
			<RETURN>)
		       (<OR <NOT <DESCRIBABLE? .O>>
			    <AND <GETP .O ,P?FDESC>
				 <NOT <FSET? .O ,TOUCHBIT>>>>
			T)
		       (<AND <SET STR <GETP .O ,P?DESCFCN>>
			     <SET STR <APPLY .STR ,M-OBJDESC>>>
			;" *** make sure descfcns rtrue, after printing!"
			<COND (<AND <FSET? .O ,CONTBIT>
				    <N==? .STR ,M-FATAL>>
			       <D-CONTENTS .O T <+ ,D-ALL? ,D-PARA?>>)>
			<CRLF>)
		       (<SET STR <GETP .O ,P?LDESC>>
			<TELL "  " .STR>
			<COND (<FSET? .O ,CONTBIT>
			       <D-CONTENTS .O T <+ ,D-ALL? ,D-PARA?>>)>
			<CRLF>)>
		 <SET O <NEXT? .O>>>
	 <D-CONTENTS ,HERE <> 0>
	 <COND (<AND .AV <NOT <EQUAL? ,HERE .AV>>>
		<D-CONTENTS .AV <> ,D-ALL? ;"was 0">)>>

<CONSTANT D-ALL? 1> ;"print everything?"
<CONSTANT D-PARA? 2> ;"started paragraph?"

"<D-CONTENTS ,OBJECT-WHOSE-CONTENTS-YOU-WANT-DESCRIBED
		    level: -1 means only top level
			    0 means top-level (include crlf)
			    1 for all other levels
			    or string to print
		    all?: t if not being called from room-desc >"

;<ROUTINE ORDER-GRAVEL (OBJ)
	 <COND (<IN? ,EVEN-MORE-GRAVEL .OBJ>
		<MOVE ,EVEN-MORE-GRAVEL .OBJ>)>
	 <COND (<IN? ,MORE-GRAVEL .OBJ>
		<MOVE ,MORE-GRAVEL .OBJ>)>
	 <COND (<IN? ,GRAVEL .OBJ>
		<MOVE ,GRAVEL .OBJ>)>>

;<ROUTINE ORDER-FLIES (OBJ)
	 <COND (<IN? ,LARGEST-FLY .OBJ>
		<MOVE ,LARGEST-FLY .OBJ>)>
	 <COND (<IN? ,EVEN-LARGER-FLY .OBJ>
		<MOVE ,EVEN-LARGER-FLY .OBJ>)>
	 <COND (<IN? ,LARGER-FLY .OBJ>
		<MOVE ,LARGER-FLY .OBJ>)>
	 <COND (<IN? ,LARGE-FLY .OBJ>
		<MOVE ,LARGE-FLY .OBJ>)>>

<ROUTINE D-CONTENTS (OBJ "OPTIONAL" (LEVEL -1) (ALL? ,D-ALL?)
  "AUX" (F <>) N (1ST? T) (IT? <>) DB (START? <>) (TWO? <>) (PARA? <>))
  ;<ORDER-FLIES .OBJ>
  ;<ORDER-GRAVEL .OBJ>
  <COND (<EQUAL? .LEVEL 2>
	 <SET LEVEL T>
	 <SET PARA? T>
	 <SET START? T>)
	(<BTST .ALL? ,D-PARA?>
	 <SET PARA? T>)>
  <SET N <FIRST? .OBJ>>
  <COND (<OR .START?
	     <IN? .OBJ ,ROOMS>
	     <FSET? .OBJ ,ACTORBIT>
	     <EQUAL? .OBJ ,PROTAGONIST>
	     <AND <FSET? .OBJ ,CONTBIT>
		  <OR <FSET? .OBJ ,OPENBIT>
		      <FSET? .OBJ ,TRANSBIT>>
		  <FSET? .OBJ ,SEARCHBIT>
		  .N>>
	 <REPEAT ()
	  <COND (<OR <NOT .N>
		     <AND <DESCRIBABLE? .N>
			  <OR <BTST .ALL? ,D-ALL?>
			      <SIMPLE-DESC? .N>>>>
		 <COND
		  (.F
		   <COND
		    (.1ST?
		     <SET 1ST? <>>
		     <COND (<EQUAL? .LEVEL <> T>
			    <COND (<NOT .START?>
				   <COND (<NOT .PARA?>
					  <COND (<NOT <EQUAL? .OBJ
							      ,PROTAGONIST>>
						 <TELL "  ">)>
					  <SET PARA? T>)
					 (<EQUAL? .LEVEL T>
					  <TELL " ">)>
				   <COND (<EQUAL? .OBJ ,HERE>
					  <TELL ,YOU-SEE>)
					 (<EQUAL? .OBJ ,PROTAGONIST>
					  <COND (<EQUAL? ,D-BIT ,WORNBIT>
						 <TELL " You are wearing">)
						(T
						 <TELL "You are carrying">)>)
					 ;(<EQUAL? .OBJ ,YACHT>
					  <TELL
"Sitting on the deck of the royal yacht">
					  <COND (<AND
						  <EQUAL? <CCOUNT .OBJ T> 1>
						  <NOT <FSET? <FIRST? .OBJ>
							      ,PLURALBIT>>>
						 <TELL " is">)
					        (T
						 <TELL " are">)>)
					 (<FSET? .OBJ ,SURFACEBIT>
					  <TELL "Sitting on" T .OBJ>
					  <COND (<AND
						  <EQUAL? <CCOUNT .OBJ T> 1>
						  <NOT <FSET? <FIRST? .OBJ>
							      ,PLURALBIT>>>
						 <TELL " is">)
					        (T
						 <TELL " are">)>)
					 (T
					  <TELL ,IT-SEEMS-THAT T .OBJ>
					  <COND (<FSET? .OBJ ,ACTORBIT>
						 <TELL " has">)
						(T
						 <TELL " contains">)>)>)>)
			   (<NOT <EQUAL? .LEVEL -1>>
			    <TELL .LEVEL>)>)
		    (.N
		     <TELL ",">)
		    (T
		     <TELL " and">)>
		   <TELL A .F>
		   <COND (<FSET? .F ,ONBIT>
			  <TELL " (providing light)">)>
		   <COND (<AND <NOT .IT?> <NOT .TWO?>>
			  <SET IT? .F>)
			 (T
			  <SET TWO? T>
			  <SET IT? <>>)>)>
		 <SET F .N>)>
	  <COND (.N
		 <SET N <NEXT? .N>>)>
	  <COND (<AND <NOT .F>
		      <NOT .N>>
		 <COND (<AND .IT?
			     <NOT .TWO?>>
			<THIS-IS-IT .IT?>)>
		 <COND (<AND .1ST? .START?>
			;<SET 1ST? <>>
			<TELL " nothing">
			<RFALSE>)>
		 <COND (<AND <NOT .1ST?>
			     <EQUAL? .LEVEL <> T>>
			<COND (<EQUAL? .OBJ ,HERE>
			       <TELL " here">)>
			<TELL ".">)>
		 <RETURN>)>>
	 <COND (<EQUAL? .LEVEL <> T>
		<SET F <FIRST? .OBJ>>
		<REPEAT ()
		 <COND (<NOT .F>
			<RETURN>)
		       
		       (<AND <FSET? .F ,CONTBIT>
			     <DESCRIBABLE? .F T>
			     <OR <BTST .ALL? ,D-ALL?>
				 <SIMPLE-DESC? .F>>>
			<SET DB ,D-BIT>
			<SETG D-BIT <>>
			<COND (<D-CONTENTS .F T
						  <COND (.PARA?
							 <+ ,D-ALL? ,D-PARA?>)
							(T
							 ,D-ALL?)>>
			       <SET 1ST? <>>
			       <SET PARA? T>)>
			<SETG D-BIT .DB>)>
		 <SET F <NEXT? .F>>>)>
	 <COND (<AND <NOT .1ST?>
		     <EQUAL? .LEVEL <> T>
		     <EQUAL? .OBJ ,HERE <LOC ,WINNER>>>
		<CRLF>)>
	 <NOT .1ST?>)>>

<GLOBAL D-BIT <>> ;"bit to screen objects"

<ROUTINE DESCRIBABLE? (OBJ "OPT" (CONT? <>))
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<EQUAL? .OBJ ,WINNER>
		<RFALSE>)
	       (<AND <EQUAL? .OBJ <LOC ,WINNER>>
		     <NOT <EQUAL? ,HERE <LOC ,WINNER>>>>
		<RFALSE>)
	       (<AND <NOT .CONT?>
		     <FSET? .OBJ ,NDESCBIT>>
		<RFALSE>)
	       (,D-BIT
		<COND (<G? ,D-BIT 0>
		       <COND (<FSET? .OBJ ,D-BIT>
			      <RTRUE>)
			     (T
			      <RFALSE>)>)
		      (<NOT <FSET? .OBJ <- ,D-BIT>>>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (T
		<RTRUE>)>>

<ROUTINE SIMPLE-DESC? (OBJ "AUX" STR)
	 <COND (<AND <GETP .OBJ ,P?FDESC>
		     <NOT <FSET? .OBJ ,TOUCHBIT>>>
		<RFALSE>)
	       (<AND <SET STR <GETP .OBJ ,P?DESCFCN>>
		     <APPLY .STR ,M-OBJDESC?>>
		<RFALSE>)
	       (<GETP .OBJ ,P?LDESC>
		<RFALSE>)
	       (T
		<RTRUE>)>>

<ROUTINE D-VEHICLE () ;"for LOOK AT/IN vehicle when you're in it"
	 <TELL "Other than yourself, you can see"> 
	 <COND (<NOT <D-NOTHING>>
		<COND (<FSET? ,PRSO ,INBIT>
		       <TELL " in">)
		      (T
		       <TELL " on">)>
		<TELL TR ,PRSO>)>
	 <RTRUE>>

<ROUTINE D-NOTHING ()
	 <COND (<D-CONTENTS ,PRSO 2>
	 	<COND (<NOT <IN? ,PROTAGONIST ,PRSO>>
		       <CRLF>)>
		<RTRUE>)
	       (T ;"nothing"
		<RFALSE>)>>

;"subtitle movement and death"

;"<CONSTANT REXIT 0>
<CONSTANT UEXIT 1 ;2>
<CONSTANT NEXIT 2 ;3>
<CONSTANT FEXIT 3 ;4>
<CONSTANT CEXIT 4 ;5>
<CONSTANT DEXIT 5 ;6>

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1 ;4>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 0 ;1>
<CONSTANT DEXITSTR 1 ;2>
<CONSTANT DEXITRM 5>"

<GLOBAL CURRENT-BORDER <>> ;"set to CASTLE-BORDER in GO"

<ROUTINE GOTO (NEW-LOC "AUX" OHERE OLIT BORDER X)
	 ;<SETG JUMP-X 99>
	 ;<SETG JUMP-Y 99>
	 <SET OLIT <LIT? ,HERE>>
	 <SET OHERE ,HERE>
	 <COND (T
	 	<MOVE ,PROTAGONIST .NEW-LOC>)>
	 <COND (<IN? .NEW-LOC ,ROOMS>
		<SETG HERE .NEW-LOC>)
	       (T
		<SETG HERE <LOC .NEW-LOC>>)>
	 <IF-P-IMAGES
     <SETG COMPASS-CHANGED T>
	 <SETG LIT <LIT? ,HERE>>
	 <SET BORDER <SET-BORDER>>
	 <COND (<NOT <EQUAL? .BORDER ,CURRENT-BORDER>>
		<SETG CURRENT-BORDER .BORDER>
		<COND (<AND ,BORDER-ON
			    <NOT <EQUAL? ,CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>>>
		       <CLEAR-BORDER>
		       <INIT-SL-WITH-SPLIT ,TEXT-WINDOW-PIC-LOC T>)>)>>
	 <COND (<NOT ,LIT>
		<IF-P-IMAGES <RETURN-FROM-MAP>>
		<COND (.OLIT
		       <TELL "You have moved into a dark place.">
		       ;<GRUE-PIT-WARNING>)
		      ;(<AND ;<NOT <EQUAL? <LOC ,PROTAGONIST>
					 ,DB ,HOLD ,PIT-BOMB-LOC>>
			    ;<NOT ,TIME-STOPPED>
			    <PROB 75>>
		       <DARK-DEATH>)
		      (T
		       <TELL ,TOO-DARK>
		       ;<GRUE-PIT-WARNING>)>)
	       (T
	 	<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	 	<IF-P-IMAGES
        <COND (<AND <EQUAL? ,CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>
			    <NOT <FSET? ,HERE ,TOUCHBIT>>>
		       <RETURN-FROM-MAP>)>
		<COND (<AND <NOT <EQUAL? ,CURRENT-SPLIT ,MAP-TOP-LEFT-LOC>>
			    <D-ROOM>
			    <NOT <EQUAL? ,VERBOSITY 0>>>
		       <D-OBJECTS>)>>)>
	 <COND (<AND <GLOBAL-IN? ,WATER ,HERE>
		     <SET X <FIND-WATER>>>
		;"so you can say GET WATER FROM OASIS, or whatever"
		<PUTP ,WATER ,P?OWNER .X>)>
	 <SCORE-OBJ ,HERE>
	 <RTRUE>>

<ROUTINE JIGS-UP (DESC)
	 <TELL .DESC>
	 <TELL CR CR CR CR
"      ****  You have died  ****" CR CR CR>
	 <FINISH>>

;"subtitle useful utility routines"

<ROUTINE ACCESSIBLE? (OBJ "AUX" L) ;"revised 2/18/86 by SEM"
	 <COND (<NOT .OBJ>
		<RFALSE>)>
	 <SET L <LOC .OBJ>>
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .OBJ ,PSEUDO-OBJECT>
		<COND (<EQUAL? ,LAST-PSEUDO-LOC ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<RTRUE>)
	       (<AND <EQUAL? .L ,LOCAL-GLOBALS>
		     <GLOBAL-IN? .OBJ ,HERE>>
		<RTRUE>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE ,PROTAGONIST>
		<RTRUE>)
	       (<AND <OR <FSET? .L ,OPENBIT>
			 <IN? ,PROTAGONIST .L> ;"you can be in closed sphere">
		     <ACCESSIBLE? .L>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE VISIBLE? (OBJ "AUX" L) ;"revised 5/2/84 by SEM and SWG"
	 <COND (<NOT .OBJ>
		<RFALSE>)>
	 <SET L <LOC .OBJ>>
	 <COND (<ACCESSIBLE? .OBJ>
		<RTRUE>)
	       (<AND <SEE-INSIDE? .L>
		     <VISIBLE? .L>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE UNTOUCHABLE? (OBJ)
;"figures out whether, due to vehicle-related locations, object is touchable"
	 <COND (<NOT .OBJ>
		<RFALSE>)
	       ;(<ULTIMATELY-IN? .OBJ ,SNAKE-PIT>
		<RTRUE>)
	       (<IN? ,PROTAGONIST ,HERE>
		<RFALSE>)
	       (<OR <ULTIMATELY-IN? .OBJ <LOC ,PROTAGONIST>>
		    <EQUAL? .OBJ <LOC ,PROTAGONIST>>
		    <IN? .OBJ ,GLOBAL-OBJECTS> ;"me, hands, etc.">
		<RFALSE>)
	       (T
		<RTRUE>)>>

;<ROUTINE META-LOC (OBJ)
	 <REPEAT ()
		 <COND (<NOT .OBJ>
			<RFALSE>)
		       (<IN? .OBJ ,GLOBAL-OBJECTS>
			<RETURN ,GLOBAL-OBJECTS>)>
		 <COND (<IN? .OBJ ,ROOMS>
			<RETURN .OBJ>)
		       (T
			<SET OBJ <LOC .OBJ>>)>>>

<ROUTINE OTHER-SIDE (DOBJ "AUX" (P 0) TEE) ;"finds room on other side of door"
	 <REPEAT ()
		 <COND (<L? <SET P <NEXTP ,HERE .P>> ,LOW-DIRECTION>
			<RETURN <>>)
		       (T
			<SET TEE <GETPT ,HERE .P>>
			<COND (<AND <EQUAL? <PTSIZE .TEE> ,DEXIT>
				    <EQUAL? <GET .TEE ,DEXITOBJ> .DOBJ>>
			       <RETURN .P>)>)>>>

<ROUTINE HELD? (X Y) <ULTIMATELY-IN? .X .Y>>

<ROUTINE ULTIMATELY-IN? (OBJ "OPTIONAL" (CONT <>)) ;"formerly HELD?"
	 <COND (<NOT .CONT>
		<SET CONT ,PROTAGONIST>)>
	 <COND (<NOT .OBJ>
		<RFALSE>)
	       ;(<AND <VERB? EMPTY>
		     <EQUAL? .OBJ ,WATER>
		     <NOUN-USED? ,WATER ,W?GLOOP ,W?GLOOPS>
		     <OR <AND <ULTIMATELY-IN? ,LARGE-VIAL>
			      <G? ,LARGE-VIAL-GLOOPS 0>>
			 <AND <ULTIMATELY-IN? ,SMALL-VIAL>
			      <G? ,SMALL-VIAL-GLOOPS 0>>>>
		<RTRUE>)
	       ;'(<AND <EQUAL? .OBJ ,WATER>
		     <VERB? POUR>
		     <OR <ULTIMATELY-IN? ,LARGE-VIAL-WATER>
			 <ULTIMATELY-IN? ,SMALL-VIAL-WATER>>>
		<RTRUE>)
	       (<IN? .OBJ .CONT>
		<RTRUE>)
	       (<IN? .OBJ ,ROOMS>
		<RFALSE>)
	       ;(<IN? .OBJ ,GLOBAL-OBJECTS>
		<RFALSE>)
	       (T
		<ULTIMATELY-IN? <LOC .OBJ> .CONT>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <COND (<AND .OBJ
		     <NOT <FSET? .OBJ ,INVISIBLE>>
		     <OR <FSET? .OBJ ,TRANSBIT>
			 <FSET? .OBJ ,OPENBIT>>>
		<RTRUE>)>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TEE)
	 <COND (<SET TEE <GETPT .OBJ2 ,P?GLOBAL>>
		<INTBL? .OBJ1 .TEE </ <PTSIZE .TEE> 2>>)>>

<ROUTINE FIND-IN (WHERE FLAG-IN-QUESTION
		  "OPTIONAL" (STRING <>) "AUX" OBJ RECURSIVE-OBJ)
	 <SET OBJ <FIRST? .WHERE>>
	 <COND (<NOT .OBJ>
		<RFALSE>)>
	 <REPEAT ()
		 <COND (<AND <FSET? .OBJ .FLAG-IN-QUESTION>
			     <NOT <FSET? .OBJ ,INVISIBLE>>>
			<COND (.STRING
			       <TELL "[" .STRING T .OBJ "]" CR>)>
			<RETURN .OBJ>)
		       (<SET RECURSIVE-OBJ
			     <FIND-IN .OBJ .FLAG-IN-QUESTION .STRING>>
			<RETURN .RECURSIVE-OBJ>)
		       (<NOT <SET OBJ <NEXT? .OBJ>>>
			<RETURN <>>)>>>

<ROUTINE WITHIN? (TL-X TL-Y BR-X BR-Y) ;"mouse click in rectangle?"
	 ;<COND (,DEBUG
		<TELL CR
"[Calling WITHIN? with X = " N ,MOUSE-LOC-X ", Y = " N ,MOUSE-LOC-Y
"; top-left is " N .TL-X "," N .TL-Y
" and bottom-right is " N .BR-X "," N .BR-Y ".]" CR>)>
	 <COND (<AND <NOT <L? ,MOUSE-LOC-X .TL-X>>
		     <NOT <G? ,MOUSE-LOC-X .BR-X>>
		     <NOT <L? ,MOUSE-LOC-Y .TL-Y>>
		     <NOT <G? ,MOUSE-LOC-Y .BR-Y>>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

;<ROUTINE DIRECTION? (OBJ)
	 <COND (<OR <EQUAL? .OBJ ,P?NORTH ,P?SOUTH ,P?EAST>
		    <EQUAL? .OBJ ,P?WEST ,P?NE ,P?NW>
		    <EQUAL? .OBJ ,P?SE ,P?SW>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE NOW-DARK? ()
	 <COND (<AND ,LIT
		     <NOT <LIT? ,HERE>>>
		<SETG LIT <>>
		<IF-P-IMAGES <SETG COMPASS-CHANGED T>>
		<TELL "  It is now too dark to see.">
		<CRLF>)>
	 <RTRUE>>

<ROUTINE NOW-LIT? ()
	 <COND (<AND <NOT ,LIT>
		     <LIT? ,HERE>>
		<SETG LIT T>
		<IF-P-IMAGES <SETG COMPASS-CHANGED T>>
		<CRLF>
		<V-LOOK>)>>

<ROUTINE LOC-CLOSED (OBJ "OPTIONAL" (VB T) "AUX" (L <LOC .OBJ>))
	 <COND (<AND <FSET? .L ,CONTBIT>
		     <NOT <FSET? .L ,OPENBIT>>
		     <FSET? .OBJ ,TAKEBIT>
		     <NOT <IN? ,PROTAGONIST .L>> ;"bathysphere, for example">
		<COND (.VB
		       <DO-FIRST "open" .L>)>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>
	 <RTRUE>>

<ROUTINE STOP ()
	 <SETG P-CONT -1>
	 <RFATAL>>

<ROUTINE ROB (WHO "OPT" (WHERE <>) (EXCLUDE-WORN-ITEM <>)
	      	  "AUX" (TAKER <>) N X)
      <SET X <FIRST? .WHO>>
      <REPEAT ()
	   <COND (<ZERO? .X>
		  <RETURN>)>
	   <SET N <NEXT? .X>>
	   <COND (<AND .EXCLUDE-WORN-ITEM
		       <FSET? .X ,WORNBIT>>
		  T)
		 (.WHERE
		  <FCLEAR .X ,WORNBIT>
		  <COND (<OR .TAKER
			     <AND <IN? .WHERE ,ROOMS>
				  ;<OR <SET TAKER <FIND-IN .WHERE ,BLACKBIT>>
				      <SET TAKER <FIND-IN .WHERE ,WHITEBIT>>>>>
			 <COND ;(<EQUAL? .X ,PIGEON>
				<SET TOOK-PIGEON T>)>
			 <MOVE .X .TAKER>)
			(<NOT <SPECIAL-DROP .X T>>
			 <MOVE .X .WHERE>)>)
		 (T
		  <FCLEAR .X ,WORNBIT>
		  <REMOVE .X>)>
	   <SET X .N>>
      <COND (.TAKER
	     <COND (<VISIBLE? .TAKER>
	     	    <TELL
" The " D .TAKER " is only too happy to pick it all up">)>)>
      <RTRUE>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR T ,PRSO>
	 <HO-HUM>>

<ROUTINE HO-HUM ()
	 <TELL <PICK-NEXT ,HO-HUM-LIST> CR>>

<CONSTANT HO-HUM-LIST
	<LTABLE
	 0 
	 " doesn't do anything."
	 " accomplishes nothing."
	 " has no desirable effect.">>		 

<ROUTINE YUKS ()
	 <TELL <PICK-NEXT ,YUK-LIST> CR>>

<CONSTANT YUK-LIST
	<LTABLE
	 0 
	 "What a concept!"
	 "Not bloody likely."
	 "A valiant attempt."
     "Nice try."
	 "You can't be serious.">>

<ROUTINE IMPOSSIBLES ()
	 <TELL <PICK-NEXT ,IMPOSSIBLE-LIST> CR>>

<CONSTANT IMPOSSIBLE-LIST
	<LTABLE
	 0
	 "Fat chance."
	 "Dream on."
	 "Why me? Why the crazy person?"
	 "You've got to be kidding."
	 "Out of the question.">>

<ROUTINE WASTES ()
	 <TELL <PICK-NEXT ,WASTE-LIST> CR>>

<CONSTANT WASTE-LIST
	<LTABLE
	 0
	 "That would be a waste of time."
	 "There's no point in doing that."
	 "There's another turn down the drain."
	 "Why bother?">>

;<END-SEGMENT>