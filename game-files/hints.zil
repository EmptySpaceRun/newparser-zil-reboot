"HELP for
        NEW-PARSER GAME
    by Max Fog (using the new parser)
    
    *** ONLY WHEN USING IMAGES. IF YOU ARE NOT USING IMAGES DO NOT USE THIS FILE ***"

<BEGIN-SEGMENT HINTS>

<GLOBAL HINTS-OFF:NUMBER -1>

<GLOBAL HINT-COUNTER 0>

<ROUTINE V-HINT ()
  <COND (<EQUAL? ,HINTS-OFF -1>
	 <SETG HINTS-OFF 0>
	 <TELL
"Warning: We strongly recommend that you not use hints unless you're definitely
stuck. Peeking at hints prematurely will invariably make you enjoy
the story less. If you want to avoid reading any hints for the rest of this
session, you may at any time during the story type HINTS OFF. Do you still
want a hint? (Y or N) >">
	 <COND (<NOT <Y?>>
		<RFATAL>)>)
	(,HINTS-OFF
	 <PERFORM ,V?HINTS-NO ,ROOMS>
	 <RFATAL>)>
  <SETG HINT-COUNTER <+ ,HINT-COUNTER 1>>
  <COND (<AND <G? ,HINT-COUNTER 0>
	      <EQUAL? <MOD ,HINT-COUNTER 5> 0>>
	 <TELL "You're looking at the hints ">
	 <HLIGHT ,H-BOLD>
	 <TELL "again">
	 <HLIGHT ,H-NORMAL>
	 <TELL
"?!! Even Lord Dimwit Flathead would consider that excessive!
Do you really want to be such a wimp? (Y or N) >">
	 <COND (<NOT <Y?>>
		<RFATAL>)>)>
  <DO-HINTS>>

<REPLACE-DEFINITION INIT-HINT-SCREEN
<ROUTINE INIT-HINT-SCREEN ()
  <CLEAR -1>
  <SCREEN ,S-FULL>
  <COND (<AND ,BORDER-ON
	      <NOT <EQUAL? <LOWCORE INTID> ,APPLE-2E ,APPLE-2C ,APPLE-2GS>>>
	 <DISPLAY-BORDER ,HINT-BORDER>)>
  <SPLIT-BY-PICTURE ,TEXT-WINDOW-PIC-LOC>
  <SCREEN ,S-TEXT>
  ,S-WINDOW>>

<BEGIN-SEGMENT "HINTS">

;"Longest hint topic and longest question can be one line, unless it shares
a line with another such in the other column. Each question can have up to
16 answers."

<CONSTANT HINTS
  <CONSTRUCT-HINTS HINT-COUNTS ;"Put topics in Quotes - followed by PLTABLEs
				 of Questions and Answers in quotes"
	;"17 character wide"
	;"this set of quotes is 36 chars. wide"
	"YOUR HOUSE: 2012"
	"TWELVE"
	<PLTABLE "saving Dimwit from the evil witch"
		 "Don't go on until you've read the enchanted fairy tale book."
		 "First you must get to the parapet area."
		 "Then say DIMWIT, DIMWIT, LET DOWN YOUR GOLDEN HAIR."
		 "There is no evil witch. There is no enchanted fairy tale
book. And there is no reason that you should be reading this hint, unless
you want to ruin the game for yourself by looking at hints you don't need!">
	"TOWER AND CO: 2013"
	"TOWER"
	<PLTABLE "opening the portcullis"
		 "Ring the bell."
		 "Answer the jester's riddle!"
		 "ANSWER \"TIME\"">
	 "AS A LAST RESORT"
	 "TOWER"
	 <PLTABLE "read this note first"
		  "Use this section as a last resort if you can't find the
information you need anywhere else in the hints. The first part is a list
of the 24 items you need, and where to find them. The second and third parts
are a list of how all 1000 points are scored.">
	 "FOR YOUR AMUSEMENT"
	 "TOWER"
	 <PLTABLE "read this note first"
		  "These are for your amusement after you have completed Zork
Zero. We recommend against looking at these before finishing, since many of
them give away the answers to various puzzles.">>>

<END-SEGMENT>