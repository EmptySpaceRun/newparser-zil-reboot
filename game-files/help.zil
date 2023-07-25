"HELP for
        NEW-PARSER GAME
    by Max Fog (using the new parser)
    
    *** ONLY WHEN WITHOUT IMAGES. IF YOU ARE USING IMAGES DO NOT USE THIS FILE ***"

<FILE-FLAGS CLEAN-STACK?>

<GLOBAL HINT-WARNING <>>

<GLOBAL HINTS-OFF <>>

<CONSTANT MAC-DOWN-ARROW <ASCII !\/>>
<CONSTANT MAC-UP-ARROW <ASCII !\\>>
<CONSTANT ALL-DONE-HINTS "|[That's all.]|">
<CONSTANT UP-ARROW 129>
<CONSTANT DOWN-ARROW 130>
<CONSTANT ESCAPE-KEY 27>

<ROUTINE V-HINT ("AUX" CHR MAXC (C <>) Q WHO)
    <SETG CLOCK-WAIT T>
	<COND (,HINTS-OFF
	       <TELL
"[Hints have been disallowed for the session. Cheeky!]" CR>
	       <RFATAL>)
	      (<NOT ,HINT-WARNING>
		   <SETG AWAITING-REPLY 6>
	       <SETG HINT-WARNING T>
	       <TELL
"[Warning: It is recognized that the temptation for help may at times be
so exceedingly strong that you might fetch hints prematurely. Therefore,
if you would like to disallow yourself to have hints from now on, then you
may type HINTS OFF. If you still want a hint now, indicate HINT.]" CR>
			<RFATAL>)>
       	<SET MAXC <GET ,HINTS 0>>
	<INIT-HINT-SCREEN>
	<CURSET 5 1>
	<PUT-UP-CHAPTERS>
	<SETG CUR-POS <- ,CHAPT-NUM 1>>
	<NEW-CURSOR>
	<REPEAT ()
		<SET CHR <INPUT 1>>
		<COND (<EQUAL? .CHR %<ASCII !\Q> %<ASCII !\q>>
		       <SET Q T>
		       <RETURN>)
			  (<EQUAL? .CHR ,ESCAPE-KEY>
			   <CONTINUE-STORY-HINTS>)
		      (<EQUAL? .CHR %<ASCII !\N> %<ASCII !\n> ,DOWN-ARROW ,MAC-DOWN-ARROW>
		       <ERASE-CURSOR>
		       <COND (<EQUAL? ,CHAPT-NUM .MAXC>
			      <SETG CUR-POS 0>
			      <SETG CHAPT-NUM 1>
			      <SETG QUEST-NUM 1>)
			     (T 
			      <SETG CUR-POS <+ ,CUR-POS 1>>
			      <SETG CHAPT-NUM <+ ,CHAPT-NUM 1>>
			      <SETG QUEST-NUM 1>)>
		       <NEW-CURSOR>)
		      (<EQUAL? .CHR %<ASCII !\P> %<ASCII !\p> ,UP-ARROW ,MAC-UP-ARROW>
		       <ERASE-CURSOR>
		       <COND (<EQUAL? ,CHAPT-NUM 1>
			      <SETG CHAPT-NUM .MAXC>
			      <SETG CUR-POS <- ,CHAPT-NUM 1>>
			      <SETG QUEST-NUM 1>)
			     (T
			      <SETG CUR-POS <- ,CUR-POS 1>>
			      <SETG CHAPT-NUM <- ,CHAPT-NUM 1>>
			      <SETG QUEST-NUM 1>)>
		       <NEW-CURSOR>)
		      (<EQUAL? .CHR 13 10>
		       <PICK-QUESTION>
		       <RETURN>)>>
	<COND (<NOT .Q>
	       <AGAIN>	;"AGAIN does whole routine?")>
	<CONTINUE-STORY-HINTS>>

<ROUTINE CONTINUE-STORY-HINTS ()
	<CLEAR -1>
	<INIT-STATUS-LINE>
	;<SETG P-CONT 0>
	<TELL CR "Back to the story..." CR CR>
	<V-LOOK>
	<MAIN-LOOP>>

<ROUTINE PICK-QUESTION ("AUX" CHR MAXQ (Q <>))
	<INIT-HINT-SCREEN <>>
	<LEFT-LINE 3 " RETURN = See hint">
	<RIGHT-LINE 3 "Q = Main menu" %<LENGTH "Q = Main menu">>
	<SET MAXQ <- <GET <GET ,HINTS ,CHAPT-NUM> 0> 1>>
	<CURSET 5 1>
	<PUT-UP-QUESTIONS>
	<SETG CUR-POS <- ,QUEST-NUM 1>>
	<NEW-CURSOR>
	<REPEAT ()
		<SET CHR <INPUT 1>>
		<COND (<EQUAL? .CHR %<ASCII !\Q> %<ASCII !\q>>
		       <SET Q T>
		       <RETURN>)
			  (<EQUAL? .CHR ,ESCAPE-KEY>
			   <CONTINUE-STORY-HINTS>)
		      (<EQUAL? .CHR %<ASCII !\N> %<ASCII !\n> ,DOWN-ARROW ,MAC-DOWN-ARROW>
		       <ERASE-CURSOR>
		       <COND (<EQUAL? ,QUEST-NUM .MAXQ>
			      <SETG CUR-POS 0>
			      <SETG QUEST-NUM 1>)
			     (T
			      <SETG CUR-POS <+ ,CUR-POS 1>>
			      <SETG QUEST-NUM <+ ,QUEST-NUM 1>>)>
		       <NEW-CURSOR>)
		      (<EQUAL? .CHR %<ASCII !\P> %<ASCII !\p> ,UP-ARROW ,MAC-UP-ARROW>
		       <ERASE-CURSOR>
		       <COND (<EQUAL? ,QUEST-NUM 1>
			      <SETG QUEST-NUM .MAXQ>
			      <SETG CUR-POS <- ,QUEST-NUM 1>>)
			     (T
			      <SETG CUR-POS <- ,CUR-POS 1>> 
			      <SETG QUEST-NUM <- ,QUEST-NUM 1>>)>
		       <NEW-CURSOR>)
		      (<EQUAL? .CHR 13 10>
		       <DISPLAY-HINT>
		       <RETURN>)>>
	<COND (<NOT .Q>
	       <AGAIN>)>>

;"zeroth (first) element is 5"
<GLOBAL LINE-TABLE
	<PTABLE
	  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22>>

;"zeroth (first) element is 4"
<GLOBAL COLUMN-TABLE
	<PTABLE
	  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4  4>>

<GLOBAL CUR-POS 0>	;"determines where to place the highlight cursor
			  Can go up to 17 Questions"

<GLOBAL QUEST-NUM 1>	;"shows in HINT-TBL ltable which QUESTION it's on"

<GLOBAL CHAPT-NUM 1>	;"shows in HINT-TBL ltable which CHAPTER it's on"

<ROUTINE ERASE-CURSOR ()
	<CURSET <GET ,LINE-TABLE ,CUR-POS>
		<- <GET ,COLUMN-TABLE ,CUR-POS> 2 ;1>>
	<TELL " ">	;"erase previous highlight cursor">

;"go back 2 spaces from question text, print cursor and flash is between
the cursor and text"

<ROUTINE NEW-CURSOR ()
	<CURSET <GET ,LINE-TABLE ,CUR-POS>
		    <- <GET ,COLUMN-TABLE ,CUR-POS> 2 ;1>>
	<TELL ">">	;"print the new cursor">

<ROUTINE INVERSE-LINE ("AUX" (CENTER-HALF <>)) 
	<HLIGHT ,H-INVERSE>
	<PRINT-SPACES <LOWCORE SCRH>>
	<HLIGHT ,H-NORMAL>>

;"cnt (3) is where in table answers begin. (2) in table is # of hints-seen"
<ROUTINE DISPLAY-HINT ("AUX" H MX MXC MXA (CNT 2) CHR (FLG T) N)
	;<SPLIT 0>
	<CLEAR -1>
	<SPLIT 3>
	<SCREEN ,S-WINDOW>
	<CURSET 1 1>
	<INVERSE-LINE>
	<CENTER-LINE 1 "INVISICLUES (tm)" %<LENGTH "INVISICLUES (tm)">>
	<CURSET 3 1>
	<INVERSE-LINE>
	<LEFT-LINE 3 " RETURN = See hint">
	<RIGHT-LINE 3 "Q = See hint menu" %<LENGTH "Q = See hint menu">>
	<CURSET 2 1>
	<INVERSE-LINE>
	<HLIGHT ,H-BOLD>
	<SET H <GET <GET ,HINTS ,CHAPT-NUM> <+ ,QUEST-NUM 1>>>
	<CENTER-LINE 2 <GET .H 2>>
	<HLIGHT ,H-NORMAL>
	<SET MX <GET .H 0>>
	<SET MXC <GET ,HINTS 0>>
	<SET MXA <- .MXC 1>>
	<SCREEN ,S-TEXT>
	<CRLF>
	<REPEAT ()
     <COND (<EQUAL? .CNT <GET .H 1>>
  	        <RETURN>)
  	       (T
            <COND (<NOT <EQUAL? .CNT 2>>
                   <HINTS-LEFT <+ <- .MX .CNT> 1> .FLG .MXC .MXA>)>
  	        <TELL <GET .H .CNT> CR ;CR>
  	        <SET CNT <+ .CNT 1>>)>>
    <SET N <+ <- .MX .CNT> 1>>
    <COND (<0? .N>
           <SET FLG <>>
           <TELL ,ALL-DONE-HINTS>)
          (ELSE
           <HINTS-LEFT .N .FLG .MXC .MXA>)>
	<REPEAT ()
     <SET CHR <INPUT 1>>
     <COND (<EQUAL? .CHR %<ASCII !\Q> %<ASCII !\q>>
   	        <PUT .H 1 .CNT>
   	        <RETURN>)
   		   (<EQUAL? .CHR ,ESCAPE-KEY>
   		    <CONTINUE-STORY-HINTS>)
   	       (<AND .FLG <EQUAL? .CHR 13 10>>
   	        <COND (<NOT <G? .CNT .MX>>
   		           <SET FLG T>	;".cnt starts as 3" 
   		           <TELL <GET .H .CNT>>
   		           ;<CRLF> ;"extra CRLF removed by GARY"
   		           <CRLF>
   		           <SET CNT <+ .CNT 1>>
   		           <COND (<G? .CNT <+ .MX 1>>
   		   	              <SET FLG <>>
   		   	              <TELL ,ALL-DONE-HINTS>)>)>)
           (ELSE
            <SOUND 1>
            <AGAIN>)>
     <COND (<AND .FLG <G? .CNT .MX>>
   	        <SET FLG <>>
   	        <TELL ,ALL-DONE-HINTS>)
           (.FLG
   	        <SET N <+ <- .MX .CNT> 1>> ;"added +1 - Jeff"
            <HINTS-LEFT .N .FLG .MXC .MXA>
   	        ;<SET FLG <>>)>>>

<ROUTINE HINTS-LEFT (N FLG MXC MXA)
    <COND (<NOT <EQUAL? ,CHAPT-NUM .MXC .MXA>> ;"add cond-GARY" 
   	       <TELL N .N>)
          (ELSE
           <TELL !\->)>
    <TELL "> ">
    <COND (<AND <NOT <EQUAL? ,CHAPT-NUM .MXC .MXA>>
                <L? .N 10>
                .FLG>
   	       <TELL !\ >)> ;"Added spaces to keep everything even - MAXXY">

<ROUTINE PUT-UP-QUESTIONS ("AUX" (ST 1) MXQ MXL)
	<SET MXQ <- <GET <GET ,HINTS ,CHAPT-NUM> 0> 1>>
	<SET MXL <- <LOWCORE SCRV> 1>>
	<REPEAT ()
	 <COND (<G? .ST .MXQ>
	        <RETURN>)
	       (T                        ;"zeroth"
	        <CURSET <GET ,LINE-TABLE <- .ST 1>>
	 	       <- <GET ,COLUMN-TABLE <- .ST 1>> 1>>)>
	 <TELL " " <GET <GET <GET ,HINTS ,CHAPT-NUM> <+ .ST 1>> 2>>
	 <SET ST <+ .ST 1>>>>

<ROUTINE PUT-UP-CHAPTERS ("AUX" (ST 1) MXC MXL)
	<SET MXC <GET ,HINTS 0>>
	<SET MXL <- <LOWCORE SCRV> 1>>
	<REPEAT ()
	 <COND (<G? .ST .MXC>
	        <RETURN>)
	       (T                        ;"zeroth"
	        <CURSET <GET ,LINE-TABLE <- .ST 1>>
	 	       <- <GET ,COLUMN-TABLE <- .ST 1>> 1>>)>
	 <TELL " " <GET <GET ,HINTS .ST> 1>>
	 <SET ST <+ .ST 1>>>>

<ROUTINE INIT-HINT-SCREEN ("OPTIONAL" (THIRD T))
	;<SPLIT 0>
	<CLEAR -1>
	<SPLIT <- <GETB 0 32> 1>>
	<SCREEN ,S-WINDOW>
	<CURSET 1 1>
	<INVERSE-LINE>
	<CURSET 2 1>
	<INVERSE-LINE>
	<CURSET 3 1>
	<INVERSE-LINE>
	<CENTER-LINE 1 "INVISICLUES" %<LENGTH "INVISICLUES">>
	<LEFT-LINE 2 " N = Next">
	<RIGHT-LINE 2 "P = Previous" %<LENGTH "P = Previous">>
	<COND (<T? .THIRD>
	      <LEFT-LINE 3 " RETURN = See topics">
	      <RIGHT-LINE 3 "Q = Resume story" %<LENGTH "Q = Resume story">>)>>

<ROUTINE CENTER-LINE (LN STR "OPTIONAL" (LEN 0) (INV T))
	<COND (<ZERO? .LEN>
	       <DIROUT ,D-TABLE-ON ,DIROUT-TBL>
	       <TELL .STR>
	       <DIROUT ,D-TABLE-OFF>
	       <SET LEN <GET ,DIROUT-TBL 0>>)>
	<CURSET .LN <+ </ <- <LOWCORE SCRH> .LEN> 2> 1>>
	<COND (.INV
	       <HLIGHT ,H-INVERSE>)>
	<TELL .STR>
	<COND (.INV
	       <HLIGHT ,H-NORMAL>)>>

<ROUTINE LEFT-LINE (LN STR "OPTIONAL" (INV T))
	<CURSET .LN 1>
	<COND (.INV
	       <HLIGHT ,H-INVERSE>)>
	<TELL .STR>
	<COND (.INV
	       <HLIGHT ,H-NORMAL>)>>

<ROUTINE RIGHT-LINE (LN STR "OPTIONAL" (LEN 0) (INV T))
	<COND (<ZERO? .LEN>
	       <DIROUT 3 ,DIROUT-TBL>
	       <TELL .STR>
	       <DIROUT -3>
	       <SET LEN <GET ,DIROUT-TBL 0>>)>
	<CURSET .LN <- <LOWCORE SCRH> .LEN>>
	<COND (.INV
	       <HLIGHT ,H-INVERSE>)>
	<TELL .STR>
	<COND (.INV
	       <HLIGHT ,H-NORMAL>)>>

<GLOBAL DIROUT-TBL
	<TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 >>

<GLOBAL HINTS
    <PLTABLE
	    <PLTABLE
            "YOUR HOUSE: 2012"
            <LTABLE 3
                "saving Dimwit from the evil witch"
	    	    "Don't go on until you've read the enchanted fairy tale book."
	    	    "First you must get to the parapet area."
	    	    "Then say DIMWIT, DIMWIT, LET DOWN YOUR GOLDEN HAIR."
	    	    "There is no evil witch. There is no enchanted fairy tale
book. And there is no reason that you should be reading this hint, unless
you want to ruin the game for yourself by looking at hints you don't need!">>

	    <PLTABLE
            "TOWER AND CO: 2013"
            <LTABLE 3
                "opening the portcullis"
	    	    "Ring the bell."
	    	    "Answer the jester's riddle!"
	    	    "ANSWER \"TIME\"">>
    
	    <PLTABLE 
            "AS A LAST RESORT"
            <LTABLE 3
                "read this note first"
	    	    "Use this section as a last resort if you can't find the
information you need anywhere else in the hints. The first part is a list
of the 24 items you need, and where to find them. The second and third parts
are a list of how all 1000 points are scored.">>

	    <PLTABLE 
            "FOR YOUR AMUSEMENT"
            <LTABLE 3
                "read this note first"
	    	    "These are for your amusement after you have completed the game.
We recommend against looking at these before finishing, since many of them give
away the answers to various puzzles.">>>>