"MISC for
        NEW-PARSER GAME
    by Max Fog (using the new parser)"

<BEGIN-SEGMENT 0>

<INCLUDE "pdefs">

;"macros"

<TELL-TOKENS 
    (CRLF CR)   <CRLF>
	;[D ,SIDEKICK <DPRINT-SIDEKICK>]
	D *	                   <DPRINT .X>
	A *	                   <APRINT .X>
	T ,PRSO 	           <TPRINT-PRSO>
	T ,PRSI	               <TPRINT-PRSI>
	T *	                   <TPRINT .X>
    CT *                   <TPRINT .X T>
	AR *	               <ARPRINT .X>
	TR *	               <TRPRINT .X>
	N *	                   <PRINTN .X>
	C *                    <PRINTC .X>
	T-IS-ARE *             <IS-ARE-PRINT .X>
    CHE-V * *:STRING       <HE-SHE-IT .X 1 .Y>
	CHE *		           <HE-SHE-IT .X 1>
	HE-V * *:STRING        <HE-SHE-IT .X 0 .Y>
	HE *		           <HE-SHE-IT .X>
	V * *:STRING	       <HE-SHE-IT .X -1 .Y>
	HIM *		           <HIM-HER-IT .X>
	HIS *		           <HIM-HER-IT .X 0 T>
	CHIS *		           <HIM-HER-IT .X 1 T>
    HS *                   <HESPRINT .X>>

<DEFMAC VERB? ("ARGS" ATMS)
	<MULTIFROB PRSA .ATMS>>

<DEFMAC PRSO? ("ARGS" ATMS)
	<MULTIFROB PRSO .ATMS>>

<DEFMAC PRSI? ("ARGS" ATMS)
	<MULTIFROB PRSI .ATMS>>

<DEFMAC ROOM? ("ARGS" ATMS)
	<MULTIFROB HERE .ATMS>>

<DEFINE MULTIFROB (X ATMS "AUX" (OO (OR)) (O .OO) (L ()) ATM) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .OO 1> <ERROR .X>)
				       (<LENGTH? .OO 2> <NTH .OO 2>)
				       (ELSE <CHTYPE .OO FORM>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L
			     (<COND (<TYPE? .ATM ATOM>
				     <CHTYPE <COND (<==? .X PRSA>
						    <PARSE
						     <STRING "V?"
							     <SPNAME .ATM>>>)
						   (ELSE .ATM)> GVAL>)
				    (ELSE .ATM)>
			      !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O <REST <PUTREST .O
				      (<FORM EQUAL? <CHTYPE .X GVAL> !.L>)>>>
		<SET L ()>>>

<DEFMAC BSET ('OBJ "ARGS" BITS)
	<MULTIBITS FSET .OBJ .BITS>>

<DEFMAC BCLEAR ('OBJ "ARGS" BITS)
	<MULTIBITS FCLEAR .OBJ .BITS>>

<DEFMAC BSET? ('OBJ "ARGS" BITS)
	<MULTIBITS FSET? .OBJ .BITS>>

<DEFINE MULTIBITS (X OBJ ATMS "AUX" (O ()) ATM) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1>
					<NTH .O 1>)
				       (<EQUAL? .X FSET?>
					<FORM OR !.O>)
				       (ELSE
					<FORM PROG () !.O>)>>)>
		<SET ATM <NTH .ATMS 1>>
		<SET ATMS <REST .ATMS>>
		<SET O
		     (<FORM .X
			    .OBJ
			    <COND (<TYPE? .ATM FORM> .ATM)
				  (ELSE <FORM GVAL .ATM>)>>
		      !.O)>>>

;<DEFMAC PROB ('BASE?)
	<FORM NOT <FORM L? .BASE? '<RANDOM 100>>>>

<ROUTINE PROB (NUM "AUX" X)
	 ;<SET X <TELL-RANDOM 100>>
	 <SET X <RANDOM 100>>
	 <COND (<G? .X .NUM>
		<RFALSE>)
	       (T
		<RTRUE>)>>

;<ROUTINE TELL-RANDOM (NUM "AUX" X)
	 <SET X <RANDOM .NUM>>
	 <COND (,DEBUG
		<TELL "[Random of " N .NUM " returning " N .X "]" CR>)>
	 <RETURN .X>>

;"PICK-NEXT expects an LTABLE of strings, with an initial element of 2."
;<ROUTINE PICK-NEXT (TBL "AUX" CNT STR)
	 <SET CNT <GET .TBL 1>>
       	 <SET STR <GET .TBL .CNT>>       
	 <INC CNT>
	 <COND (<G? .CNT <GET .TBL 0>>
		<SET CNT 2>)>
	 <PUT .TBL 1 .CNT>
	 <RETURN .STR>>

<ROUTINE PICK-ONE (TBL)
    <RETURN <GET .TBL <RANDOM <GETNIL .TBL>>>>>

<ROUTINE PICK-NEXT (TBL "AUX" LENGTH CNT RND MSG RFROB)
	 <SET LENGTH <GETNIL .TBL>>
	 <SET CNT <GET .TBL 1>>
	 <SET LENGTH <- .LENGTH 1>>
	 <SET TBL <REST .TBL 2>>
	 <SET RFROB <REST .TBL <* .CNT 2>>>
	 <SET RND <RANDOM <- .LENGTH .CNT>>>
	 <SET MSG <GET .RFROB .RND>>
	 <PUT .RFROB .RND <GET .RFROB 1>>
	 <PUT .RFROB 1 .MSG>
	 <SET CNT <+ .CNT 1>>
	 <COND (<==? .CNT .LENGTH> 
		<SET CNT 0>)>
	 <PUT .TBL 0 .CNT>
	 .MSG>

<ROUTINE GETNIL (TBL) ;"Assumes it's LTABLE"
    <RETURN <GET .TBL 0>>>

<ROUTINE DPRINT (OBJ)
	 <COND ;(<AND <GETP .OBJ ,P?INANIMATE-DESC>
		     <NOT <FSET? .OBJ ,ANIMATEDBIT>>>
		<TELL <GETP .OBJ ,P?INANIMATE-DESC>>)
	       (<GETP .OBJ ,P?SDESC>
	        <TELL <GETP .OBJ ,P?SDESC>>)
	       (T
	        <PRINTD .OBJ>)>>

<ROUTINE APRINT (OBJ "OPT" (NOSP <>) "AUX" LEN)
	 <COND (<NOT .NOSP>
		<TELL !\ >)>
	 <COND (<AND <SET LEN <GET-OWNER .OBJ>>
		     <NOT <EQUAL? .LEN <GETP .OBJ ,P?OWNER>>>>
		<COND (<EQUAL? .LEN ,PROTAGONIST>
		       <TELL "your ">)
		      (<NOT <EQUAL? .LEN .OBJ>>
		       <APRINT .LEN T>
		       <TELL "'s ">)>)
	       (<NOT <FSET? .OBJ ,NARTICLEBIT>>
		<COND (<FSET? .OBJ ,VOWELBIT>
		       <TELL "an ">)
		      (T
		       <TELL "a ">)>)>
	 <DPRINT .OBJ>>

<ROUTINE TPRINT (OBJ "OPT" (NOSP <>) "AUX" LEN)
	 <COND (<NOT .NOSP>
		    <TELL !\ >)>
	 <COND (<AND <SET LEN <GET-OWNER .OBJ>>
		         <NOT <EQUAL? .LEN <GETP .OBJ ,P?OWNER>>>>
		    <COND (<EQUAL? .LEN ,PROTAGONIST>
		           <COND (.NOSP <TELL "Y">) (T <TELL "y">)>
                   <TELL "our ">)
		          (<NOT <EQUAL? .LEN .OBJ>>
		           <TPRINT .LEN T>
		           <TELL "'s ">)>)
	           (<NOT <FSET? .OBJ ,NARTICLEBIT>>
		        <COND (.NOSP <TELL "T">) (T <TELL "t">)>
                <TELL "he ">)>
	 <DPRINT .OBJ>>

<ROUTINE TPRINT-PRSO ()
	 <TPRINT ,PRSO>>

<ROUTINE TPRINT-PRSI ()
	 <TPRINT ,PRSI>>

<ROUTINE ARPRINT (OBJ)
	 <APRINT .OBJ>
	 <TELL ,PERIOD-CR>>

<ROUTINE TRPRINT (OBJ)
	 <TPRINT .OBJ>
	 <TELL ,PERIOD-CR>>

<ROUTINE IS-ARE-PRINT (OBJ)
	 <COND (<FSET? .OBJ ,NARTICLEBIT>
		<TELL " ">)
	       (T
		<TELL " the ">)>
	 <DPRINT .OBJ>
	 <COND (<FSET? .OBJ ,PLURALBIT>
		<TELL " are ">)
	       (T
		<TELL " is ">)>>

<ROUTINE NO-PRONOUN? (OBJ "OPTIONAL" (CAP <>))
	<COND (<EQUAL? .OBJ ,PROTAGONIST ,ME>
	       <RFALSE>)
          (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<AND <EQUAL? .OBJ ,P-IT-OBJECT>
			   <FSET? ,IT ,TOUCHBIT>>
		      <RFALSE>)>)
	      ;(<EQUAL? .OBJ ,FIRST-CLASS-IDIOT ,BLUR>)
          ;(<FSET? .OBJ ,FEMALEBIT>
	       <COND (<AND <EQUAL? .OBJ ,P-HER-OBJECT>
			   <FSET? ,HER ,TOUCHBIT>>
		      <RFALSE>)>)
	      (<FSET? .OBJ ,PLURALBIT>
	       <COND (<AND <EQUAL? .OBJ ,P-THEM-OBJECT>
			   <FSET? ,THEM ,TOUCHBIT>>
		      <RFALSE>)>)
	      (T
	       <COND (<AND <EQUAL? .OBJ ,P-HIM-OBJECT>
			   <FSET? ,HIM ,TOUCHBIT>>
		      <RFALSE>)>)>
	<TPRINT .OBJ .CAP>
	<THIS-IS-IT .OBJ>
	<RTRUE>>

<ROUTINE HE-SHE-IT (OBJ "OPTIONAL" (CAP 0) (VERB <>))	;"He/he/+verb"
	<COND (<NO-PRONOUN? .OBJ .CAP>
	       T)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<ZERO? .CAP> <TELL "it">)
		     (<1? .CAP> <TELL "It">)>)
	      (<==? .OBJ ,ME>
	       <COND (<ZERO? .CAP> <TELL "you">)
		     (<1? .CAP> <TELL "You">)>)
	      (<FSET? .OBJ ,FEMALEBIT>
	       <COND (<ZERO? .CAP> <TELL "she">)
		     (<1? .CAP> <TELL "She">)>)
	      (<FSET? .OBJ ,PLURALBIT>
	       <COND (<ZERO? .CAP> <TELL "they">)
		     (<1? .CAP> <TELL "They">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL "he">)
		     (<1? .CAP> <TELL "He">)>)>
	<COND (<NOT <ZERO? .VERB>>
	       <PRINTC 32>
	       <COND (<OR <EQUAL? .OBJ ,PROTAGONIST ,ME>
			  ;<FSET? .OBJ ,PLURALBIT>>
		      <COND (<=? .VERB "is"> <TELL "are">)
			    (<=? .VERB "has"><TELL "have">)
			    (<=? .VERB "tri"><TELL "try">)
			    (<=? .VERB "empti"><TELL "empty">)
                (<=? .VERB "fli"><TELL "fly">)
			    (T <TELL .VERB>)>)
		     (T
		      <TELL .VERB>
		      <COND (<OR <EQUAL? .VERB "do" "kiss" "push">
				 <EQUAL? .VERB "tri" "empti">>
			     <TELL !\e>)>
		      <COND (<NOT <EQUAL? .VERB "is" "has">>
			     <TELL !\s>)>)>)>>

<ROUTINE HESPRINT (OBJ)
    <HE-SHE-IT .OBJ 1>
    <COND (<OR <FSET? .OBJ ,PLURALBIT>
               <EQUAL? .OBJ ,ME ,PROTAGONIST>>
		<TELL "'re ">)
	       (T
		<TELL "'s ">)>>

<ROUTINE HIM-HER-IT (OBJ "OPTIONAL" (CAP 0) (POSSESS? <>))	;"His/his/him"
 <COND (<EQUAL? .OBJ ,PROTAGONIST ,ME>
    <COND (<NOT <ZERO? .CAP>> <TELL "You">) (T <TELL " you">)>
    <COND (<NOT <ZERO? .POSSESS?>> <TELL !\r>)>)
       (<NO-PRONOUN? .OBJ .CAP>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL "'s">)>)
       (<NOT <FSET? .OBJ ,PERSONBIT>>
	<COND (<ZERO? .CAP> <TELL " it">) (T <TELL "It">)>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL !\s>)>)
       (<FSET? .OBJ ,PLURALBIT>
	<COND (<NOT <ZERO? .POSSESS?>>
	       <COND (<ZERO? .CAP> <TELL " their">)
		     (T <TELL "Their">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " them">)
		     (T <TELL "Them">)>)>)
       (<FSET? .OBJ ,FEMALEBIT>
	<COND (<ZERO? .CAP> <TELL " her">) (T <TELL "Her">)>)
       (T
	<COND (<NOT <ZERO? .POSSESS?>>
	       <COND (<ZERO? .CAP> <TELL " his">)
		     (T <TELL "His">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " him">)
		     (T <TELL "Him">)>)>)>
 <RTRUE>>



;<ROUTINE CLEAR-SCREEN ("AUX" (CNT 24))
	 <REPEAT ()
		 <CRLF>
		 <SET CNT <- .CNT 1>>
		 <COND (<0? .CNT>
			<RETURN>)>>>

<REPLACE-DEFINITION VERB-ALL-TEST
<ROUTINE VERB-ALL-TEST (OO II "AUX" (L <LOC .OO>))
	 ;"RTRUE if OO should be included in the ALL, otherwise RFALSE"
	 <COND (<EQUAL? .OO ,ROOMS ;,NOT-HERE-OBJECT>
		<SETG P-NOT-HERE <+ ,P-NOT-HERE 1>>
		<RFALSE>)
	       (<AND <VERB? TAKE> ;"TAKE prso FROM prsi and prso isn't in prsi"
		     <T? .II>
		     <NOT <IN? .OO .II>>>
		<RFALSE>)
	       (<AND <VERB? REMOVE>
		     <NOT <FSET? .OO ,WEARBIT>>
		     <IN? .OO ,WINNER>>
		; "Remove of things you're carrying but not wearing..."
		<RFALSE>)
	       ;(<NOT <ACCESSIBLE? .OO>> ;"can't get at object"
		<RFALSE>)
	       (T ;<EQUAL? ,P-GETFLAGS ,P-ALL> ;"cases for ALL"
		<COND (<AND .II
			    <PRSO? .II>>
		       <RFALSE>)
		      (<VERB? TAKE> 
		       ;"TAKE ALL and object not accessible or takeable"
		       <COND (<AND <NOT <FSET? .OO ,TAKEBIT>>
				   <NOT <FSET? .OO ,TRYTAKEBIT>>>
			      <RFALSE>)
			     (<FSET? .OO ,NALLBIT>
			      <RFALSE>)
			     ;(<AND <NOT <EQUAL? .L ,WINNER ,HERE .II>>
				   <NOT <EQUAL? .L <LOC ,WINNER>>>>
			      <COND (<AND <FSET? .L ,SURFACEBIT>
				     	  <NOT <FSET? .L ,TAKEBIT>>> ;"tray"
				     <RTRUE>)
				    (T
				     <RFALSE>)>)
			     (<AND <NOT .II>
				   <ULTIMATELY-IN? .OO>> ;"already have it"
			      <RFALSE>)
			     (T
			      <RTRUE>)>)
		      (<AND <VERB? DROP PUT PUT-ON GIVE SGIVE>
			    ;"VERB ALL, object not held"
			    <NOT <IN? .OO ,WINNER>>>
		       <RFALSE>)
		      (<AND <VERB? PUT PUT-ON> ;"PUT ALL IN X,obj already in x"
			    <NOT <IN? .OO ,WINNER>>
			    <ULTIMATELY-IN? .OO .II>>
		       <RFALSE>)
		      (<AND <VERB? WEAR>
			    <OR <FSET? .OO ,WORNBIT>
				<NOT <FSET? .OO ,WEARBIT>>>>
		       ;"try to wear only wearable-but-not-yet-worn objects"
		       <RFALSE>)
		      (<EQUAL? .OO .II>
		       ;"i.e. PUT ALL IN BOX shouldn't try to put box in box"
		       <RFALSE>)
		      (T
		       <RTRUE>)>)>>>

;<GLOBAL FIRST-BUFFER <ITABLE BYTE 100>>

;<ROUTINE SAVE-INPUT (TBL "AUX" (OFFS 0) CNT TMP)
	 <SET CNT <+ <GETB ,P-LEXV <SET TMP <* 4 ,P-INPUT-WORDS>>>
		     <GETB ,P-LEXV <+ .TMP 1>>>>
	 <COND (<EQUAL? .CNT 0> ;"failed"
		<RFALSE>)>
	 <SET CNT <- .CNT 1>>
	 <REPEAT ()
		 <COND (<EQUAL? .OFFS .CNT>
			<PUTB .TBL .OFFS 0>
			<RETURN>)
		       (T
			<PUTB .TBL .OFFS <GETB ,P-INBUF <+ .OFFS 1>>>)>
		 <SET OFFS <+ .OFFS 1>>>
	 <RTRUE>>

;<ROUTINE RESTORE-INPUT (TBL "AUX" CHR)
	 <REPEAT ()
		 <COND (<EQUAL? <SET CHR <GETB .TBL 0>> 0>
			<RETURN>)
		       (T
			<PRINTC .CHR>
			<SET TBL <REST .TBL>>)>>>

<ROUTINE THIS-IS-IT (OBJ)
	 <COND (<OR <AND <VERB? WALK>
			 <PRSO? .OBJ>> ;"PRSO is a direction"
		    <EQUAL? .OBJ <> ,ROOMS ;,NOT-HERE-OBJECT ,ME ,PROTAGONIST>>
		<RTRUE>)
	       ;(<DONT-IT .OBJ ,LOBSTER ,W?NUTCRACKER>
		;"or else FIND NUTCRACKER followed by TAKE IT returns
	          [But the lobster isn't here!]"
		<RTRUE>)                             ;"Kept cause it might help you" 
           (<FSET? .OBJ ,FEMALEBIT>
		<COND (<NOT <EQUAL? ,P-HER-OBJECT .OBJ>>
		       <FCLEAR ,HER ,TOUCHBIT>)>
		<SETG P-HER-OBJECT .OBJ>)
	       (<OR <FSET? .OBJ ,ACTORBIT>>
		<COND (<NOT <EQUAL? ,P-HIM-OBJECT .OBJ>>
		       <FCLEAR ,HIM ,TOUCHBIT>)>
		<SETG P-HIM-OBJECT .OBJ>
		<COND (T ;<NOT <EQUAL? .OBJ ,JESTER ,EXECUTIONER>>
		       ;"basically, animals"
		       <COND (<NOT <EQUAL? ,P-IT-OBJECT .OBJ>>
			      <FCLEAR ,IT ,TOUCHBIT>)>
		       <SETG P-IT-OBJECT .OBJ>)>)
	       (T
		<COND (<FSET? .OBJ ,PLURALBIT>
		       <COND (<N==? ,P-THEM-OBJECT .OBJ>
			      <FCLEAR ,THEM ,TOUCHBIT>)>
		       <SETG P-THEM-OBJECT .OBJ>)
		      (T
		       <SETG P-THEM-OBJECT <>>)>
		<COND (<NOT <EQUAL? ,P-IT-OBJECT .OBJ>>
		       <FCLEAR ,IT ,TOUCHBIT>)>
		<SETG P-IT-OBJECT .OBJ>)>>

<ROUTINE DONT-IT (OBJ1 OBJ2 WRD)
	 <COND (<AND <EQUAL? .OBJ1 .OBJ2>
		     <NOUN-USED? .OBJ2 .WRD>
		     ;<FSET? .OBJ2 ,ANIMATEDBIT>
		     <NOT <VISIBLE? .OBJ2>>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE DIR-TO-STRING (DIR)
	 <COND (<EQUAL? .DIR ,P?UP>
		<RETURN "up">)
	       (<EQUAL? .DIR ,P?DOWN>
		<RETURN "down">)
	       (<EQUAL? .DIR ,P?NORTH>
		<RETURN "north">)
	       (<EQUAL? .DIR ,P?NE>
		<RETURN "northeast">)
	       (<EQUAL? .DIR ,P?EAST>
		<RETURN "east">)
	       (<EQUAL? .DIR ,P?SE>
		<RETURN "southeast">)
	       (<EQUAL? .DIR ,P?SOUTH>
		<RETURN "south">)
	       (<EQUAL? .DIR ,P?SW>
		<RETURN "southwest">)
	       (<EQUAL? .DIR ,P?WEST>
		<RETURN "west">)
	       (<EQUAL? .DIR ,P?NW>
		<RETURN "northwest">)
	       (<EQUAL? .DIR ,P?IN>
		<RETURN "in">)
	       (<EQUAL? .DIR ,P?OUT>
		<RETURN "out">)>>






;"GENERICS"

<ROUTINE BEDROOM-G ()
    <COND (<INTBL? ,W?BEDROOM ,P-INBUF ,INBUF-LENGTH>
           <RETURN ,BEDROOM>)
          (ELSE
           <RFALSE>)>>

<ROUTINE DOOR-G ()
    <COND (<NOT <INTBL? ,W?DOOR ,P-INBUF ,INBUF-LENGTH>>
           <COND (<EQUAL? ,HERE ,BEDROOM>
                  <RETURN <BEDROOM-G>>)
                 (ELSE
                  <RFALSE>)>)>>








;<REPLACE-DEFINITION NUMBER?
;"from suspect"

<GLOBAL P-EXCHANGE 0>

<ROUTINE NUMBER? (PTR "AUX" CNT BPTR CHR (SUM 0) (TIM <>) (EXC <>))
	 <SET CNT <GETB <REST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <REST ,P-LEXV <* .PTR 2>> 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0>
			<RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<==? .CHR 58>
			       <COND (.EXC
				      <RFALSE>)>
			       <SET TIM .SUM>
			       <SET SUM 0>)
			      (<==? .CHR 45 !\/>
			       <COND (.TIM
				      <RFALSE>)>
			       <SET EXC .SUM>
			       <SET SUM 0>)
			      (<G? .SUM 9999>
			       <RFALSE>)
			      (<AND <L? .CHR 58>
				    <G? .CHR 47>>
			       <SET SUM <+ <* .SUM 10> <- .CHR 48>>>)
			      (T
			       <RFALSE>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <PUT ,P-LEXV .PTR ,W?NUMBER>
	 <COND (<G? .SUM 9999>
		<RFALSE>)
	       (.EXC
		<SETG P-EXCHANGE .EXC>)
	       (.TIM
		<SETG P-EXCHANGE 0>
		<COND (<G? .TIM 23>
		       <RFALSE>)
		      (<G? .TIM 19>
		       T)
		      (<G? .TIM 12>
		       <RFALSE>)
		      (<G? .TIM  7>
		       T)
		      (T
		       <SET TIM <+ 12 .TIM>>)>
		<SET SUM <+ .SUM <* .TIM 60>>>)
	       (T
		<SETG P-EXCHANGE 0>)>
	 <SETG P-NUMBER .SUM>
	 ,W?NUMBER>>

<GLOBAL P-NUMBER 0>

<ROUTINE PERFORM-PRSA ("OPTIONAL" (O <>) (I <>))
	 <PERFORM ,PRSA .O .I>
	 <RTRUE>>

;<ROUTINE CANT-USE (PTR "AUX" BUF)
	<TELL "[You used the word \"">
	<WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <REST ,P-LEXV .BUF> 3>>
	<TELL "\" in a way that I don't understand.]" CR>
	;<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>>

;"CLOCKER and related routines"

<IFFLAG (IN-ZILCH
	 <CONSTANT C-TABLE <ITABLE NONE 30>>)
	(T
	 <CONSTANT C-TABLE <ITABLE NONE 60>>)> ;"2x largest num of interrupts"

<GLOBAL CLOCK-WAIT <>>

<GLOBAL C-INTS 60> ;"2x largest number of concurrent of interrupts"

<GLOBAL C-MAXINTS 60> ;"2x largest number of concurrent of interrupts"

<GLOBAL CLOCK-HAND <>>

<CONSTANT C-TABLELEN 60>
<CONSTANT C-INTLEN 4>	;"length of an interrupt entry"
<CONSTANT C-RTN 0>	;"offset of routine name"
<CONSTANT C-TICK 1>	;"offset of count"

<ROUTINE DEQUEUE (RTN)
	 <COND (<SET RTN <QUEUED? .RTN>>
		<PUT .RTN ,C-RTN 0>)>>

<ROUTINE QUEUED? (RTN "AUX" C E)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<RFALSE>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN>
			<COND (<ZERO? <GET .C ,C-TICK>>
			       <RFALSE>)
			      (T
			       <RETURN .C>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<ROUTINE RUNNING? (RTN "AUX" (TBL <REST ,C-TABLE ,C-INTS>) ;"SWG 10-Mar-89"
			     (LEN </ <- ,C-TABLELEN ,C-INTS> ,C-INTLEN>))
	 <COND (<AND <NOT <ZERO? .LEN>>
		     <SET TBL <INTBL? .RTN .TBL .LEN <+ *200* ,C-INTLEN>>>>
		<COND (<OR <ZERO? <GET .TBL ,C-TICK>>
			   <G? <GET .TBL ,C-TICK> 1>>
		       <RFALSE>)
		      (T
		       <RTRUE>)>)>>

;<ROUTINE RUNNING? (RTN "AUX" C E)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<RFALSE>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN>
			<COND (<OR <ZERO? <GET .C ,C-TICK>>
				   <G? <GET .C ,C-TICK> 1>>
			       <RFALSE>)
			      (T
			       <RTRUE>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<ROUTINE QUEUE (RTN TICK "AUX" C E (INT <>)) ;"automatically enables as well"
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<EQUAL? .C .E>
			<COND (.INT
			       <SET C .INT>)
			      (T
			       <COND (<L? ,C-INTS ,C-INTLEN>
				      <TELL "**Too many ints!**" CR>)>
			       <SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			       <COND (<L? ,C-INTS ,C-MAXINTS>
				      <SETG C-MAXINTS ,C-INTS>)>
			       <SET INT <REST ,C-TABLE ,C-INTS>>)>
			<PUT .INT ,C-RTN .RTN>
			<RETURN>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN>
			<SET INT .C>
			<RETURN>)
		       (<ZERO? <GET .C ,C-RTN>>
			<SET INT .C>)>
		 <SET C <REST .C ,C-INTLEN>>>
	 <COND (<AND ,CLOCK-HAND
		     <IFFLAG (IN-ZILCH
			      <G? .INT ,CLOCK-HAND>)
			     (T
			      <L? <LENGTH .INT> <LENGTH ,CLOCK-HAND>>)>>
		<SET TICK <- <+ .TICK 3>>>)>
	 <PUT .INT ,C-TICK .TICK>
	 .INT>

<ROUTINE I-REPLY ()
    <SETG AWAITING-REPLY 0>>




"stuff for handling opcodes that want pixels"

<GLOBAL FONT-X 7>
<GLOBAL FONT-Y 10>

<CONSTANT PICINF-TBL
	  <TABLE 0 0>>

<ROUTINE C-PIXELS (X)
	 <+ <* <- .X 1> ,FONT-X> 1>>

<ROUTINE L-PIXELS (Y)
	 <+ <* <- .Y 1> ,FONT-Y> 1>>

;<ROUTINE PIXELS-C (X)
	 <+ </ <- .X 1> ,FONT-X> 1>>

;<ROUTINE PIXELS-L (Y)
	 <+ </ <- .Y 1> ,FONT-Y> 1>>

;<ROUTINE PIXELS-LR (Y)
	 </ <- <+ .Y ,FONT-Y> 1> ,FONT-Y>>

<ROUTINE CCURSET (Y X)
	 <CURSET <L-PIXELS .Y> <C-PIXELS .X>>>

;<ROUTINE CCURGET (TBL)
	 <CURGET .TBL>
	 <PUT .TBL 0 <PIXELS-L <GET .TBL 0>>>
	 <PUT .TBL 1 <PIXELS-C <GET .TBL 1>>>
	 .TBL>

;<ROUTINE CSPLIT (Y)
	 <SPLIT <* .Y ,FONT-Y>>>

;<ROUTINE CWINPOS (W Y X)
	 <WINPOS .W <L-PIXELS .Y> <C-PIXELS .X>>>

;<ROUTINE CWINSIZE (W Y X)
	 <WINSIZE .W <* .Y ,FONT-Y> <* .X ,FONT-X>>>

;<ROUTINE CMARGIN (L R)
	 <MARGIN <* .L ,FONT-X> <* .R ,FONT-X>>>

;<ROUTINE CPICINF (P TBL)
	 <PICINF .P .TBL>
	 <PUT .TBL 0 </ <GET .TBL 0> ,FONT-Y>>
	 <PUT .TBL 1 </ <GET .TBL 1> ,FONT-X>>>

;<ROUTINE CDISPLAY (P Y X)
	 <DISPLAY .P
		  <COND (<ZERO? .Y> 0)
			(ELSE <L-PIXELS .Y>)>
		  <COND (<ZERO? .X> 0)
			(ELSE <C-PIXELS .X>)>>>

;<ROUTINE CDCLEAR (P Y X)
	 <DCLEAR .P
		 <COND (<ZERO? .Y> 0)
		       (ELSE <L-PIXELS .Y>)>
		 <COND (<ZERO? .X> 0)
		       (ELSE <C-PIXELS .X>)>>>

;<ROUTINE CSCROLL (W Y)
	 <SCROLL .W <* .Y ,FONT-Y>>>

;<END-SEGMENT>