"GRAM file: imitates old parser and worth an ounce of cure.
Copyright (C) 1988 Infocom, Inc.  All rights reserved."

<USE "lalr" "pstack" "reds">

;<IFFLAG (IN-ZILCH
	 <USE "ZILCH">)
	(T <USE "ZIL">)>

<INCLUDE "symbols" "basedefs" "lalrdefs">

"TERMINALS are defined in DEFS, so they'll be around for compiling
stuff.  This resets everything else, so we can regenerate the grammar."
<RESET-SYMBOLS ;"!-SYMBOLS!-PACKAGE">

<ADD-WORD END.OF.INPUT END-OF-INPUT>
<ADD-WORD "." END-OF-INPUT>
<ADD-WORD "?" END-OF-INPUT>
<ADD-WORD "!" END-OF-INPUT>
<ADD-WORD "THEN" END-OF-INPUT>

<ADD-WORD ONE NOUN>
<ADD-WORD BUT PREP>
;<ADD-WORD NOT PREP>
<ADD-WORD EXCEPT PREP>

<COMPILATION-FLAG-DEFAULT P-PS-COMMA <>>
<ADD-WORD AND	<IFFLAG (P-PS-COMMA COMMA) (T MISCWORD)>>
;<ADD-WORD OR	<IFFLAG (P-PS-COMMA COMMA) (T MISCWORD)>>
<ADD-WORD ","	<IFFLAG (P-PS-COMMA COMMA) (T MISCWORD)>>

<COMPILATION-FLAG-DEFAULT P-PS-APOSTR <>>
<ADD-WORD "'"	<IFFLAG (P-PS-APOSTR APOSTR) (T MISCWORD)>>

<COMPILATION-FLAG-DEFAULT P-PS-OFWORD <>>
<ADD-WORD OF	<IFFLAG (P-PS-OFWORD OFWORD) (T MISCWORD ;PREP)>>

<COMPILATION-FLAG-DEFAULT P-PS-THEWORD <>>
<ADD-WORD THE	<IFFLAG (P-PS-THEWORD ARTICLE) (T MISCWORD)>>

<ADD-WORD FROM PREP>
<ADD-WORD IN PREP>
<ADD-WORD ON PREP>

<IF-P-PS-ADV
	<ADD-WORD ONCE ADV>
	<ADD-WORD TWICE ADV>
	<ADD-WORD THRICE ADV>
	<ADD-WORD "DON'T" ADV>>

<IFFLAG (P-PS-ADV	<PRODUCTION RED-SP	SP 1	(?PERS S ?ADV)>)
	(T		<PRODUCTION RED-SP	SP 1	(?PERS S)>)>

<PRODUCTION RED-SV	S 2	(VP ?PARTICLE)>
;<PRODUCTION RED-SVPNN	S 2	(VP ?PARTICLE NPP NPP)>
;<PRODUCTION RED-SVNPN	S 2	(VP NPP ?PARTICLE NPP)>
<PRODUCTION RED-SVPNPN	S 2	(VP ?PARTICLE NPP ?PARTICLE NPP)>
;<PRODUCTION RED-SVNP	S 2	(VP NPP PARTICLE)>
<PRODUCTION RED-SVN	S 2	(VP ?PARTICLE NPP ?PARTICLE)>

<PRODUCTION RED-SD	S 2	(DIR)>
<PRODUCTION RED-SVD	S 2	(VP DIR)>

<IFFLAG (P-BE-VERB
	 <IFFLAG (P-PS-ADV
	 	<PRODUCTION RED-VP	VP 3	(?CANDO ?ADV VERB ?ADV)>)
		 (T
	 	<PRODUCTION RED-VP	VP 3	(?CANDO VERB)>)>

	 <PRODUCTION RED-CANDO	?CANDO 3	()
						(NP)
						(NP CANDO ?NOT) ;"I DON'T KNOW"
						(?QW1 CANDO NP ?NOT)
						(?QW1 CANDO NOT NP)>)
	(T
	 <IFFLAG (P-PS-ADV
	 	<PRODUCTION RED-VP	VP 3	(?ADV VERB ?ADV)>)
		 (T
	 	<PRODUCTION RED-VP	VP 3	(VERB)>)>)>

<IFFLAG (P-PS-OFWORD
	<PRODUCTION RED-PART	?PARTICLE 1	(PARTICLE OFWORD)
						(PARTICLE ?PARTICLE)
						()>)
	(T
	<PRODUCTION RED-PART	?PARTICLE 1	(PARTICLE MISCWORD ;"OF")
						(PARTICLE ?PARTICLE)
						()>)>

<IF-P-PS-ADV	<PRODUCTION RED-FCN	?ADV 1  (ADV) ()>>

<IFFLAG (P-PS-COMMA
	<PRODUCTION RED-NPP	NPP 4		(NPP COMMA NP)
						(NPP PP)
						(NP)>)
	(T
	<PRODUCTION RED-NPP	NPP 4		(NPP MISCWORD NP)
		    				(NPP PP)
						(NP)>)>

<COMPILATION-FLAG-DEFAULT P-PS-QUOTE <>>
<ADD-WORD \"	<IFFLAG (P-PS-QUOTE QUOTE) (T MISCWORD)>>
<IFFLAG (P-PS-QUOTE
	<PRODUCTION RED-QUOTE	NP 7	(QUOTE)>)
	(T
	<PRODUCTION RED-QUOTE	NP 7	(MISCWORD)>)>
<IFFLAG (P-PS-OFWORD	<PRODUCTION RED-OF	NP 5	(NP OFWORD NP)>)
	(T		<PRODUCTION RED-OF	NP 5	(NP MISCWORD NP)>)>
<PRODUCTION RED-QT	NP 7		(QUANT)>
<PRODUCTION RED-QN	NP 5		(QUANT NP)>
<IFFLAG (P-ARTHUR
	 <IFFLAG (P-PS-THEWORD
		  <PRODUCTION RED-NP	NP 6		(ADJS NOUN)
		     					(NOUN ARTICLE NOUN)>)
		 (T
		  <PRODUCTION RED-NP NP 6 (ADJS NOUN)
			      		  (NOUN MISCWORD NOUN)>)>)
	(T
	 <PRODUCTION RED-NP NP 6 (ADJS NOUN)>)>

<IFFLAG (P-PS-OFWORD
	<PRODUCTION RED-PP	PP 3		(PREP NPP)
						(PARTICLE NPP)
						(PREP OFWORD NPP)
						(PARTICLE OFWORD NPP)>)
	(T
	<PRODUCTION RED-PP	PP 3		(PREP NPP)
						(PARTICLE NPP)
						(PREP MISCWORD;"OF" NPP)
						(PARTICLE MISCWORD;"OF" NPP)>)>

<PRODUCTION RED-ADJ		ADJ* 8		(ADJ ADJ*)
						()>

<IFFLAG (P-PS-THEWORD
	;<PRODUCTION RED-ADJ	ADJ* 8		(POSSESSIVE ADJ*)
		    				()
						(ADJ ADJ*) ;"switched by SWG"
						(ARTICLE ADJ*)>
	<PRODUCTION RED-ADJS	ADJS 8		(POSSESSIVE ADJ*)
						(ADJ*)
						(ARTICLE ADJ*)>)
	(T
	;<PRODUCTION RED-ADJ	ADJ* 8		(POSSESSIVE ADJ*)
						()
						(ADJ ADJ*) ;"switched by SWG"
						(MISCWORD ADJ*)	;"article">
	<PRODUCTION RED-ADJS	ADJS 8		(POSSESSIVE ADJ*)
						(ADJ*)
						(MISCWORD ADJ*)	;"article">)>

<IFFLAG (P-PS-APOSTR
	<PRODUCTION RED-POSS	POSSESSIVE 8	(NP APOSTR MISCWORD) ;"FOO'S">)
	(T
	<PRODUCTION RED-POSS	POSSESSIVE 8	(NP MISCWORD MISCWORD) ;"FOO'S">)>

<IF-P-BE-VERB

<PRODUCTION RED-BE-FORM		BE-FORM 3	(TOBE)>

<PRODUCTION RED-SNBN	S 2	(NP BE-FORM ?NOT ?BE NPP)>
<PRODUCTION RED-SNBA	S 2	(NP BE-FORM ?NOT ?BE ADJ)>
<PRODUCTION RED-SNBP	S 2	(NP BE-FORM ?NOT ?BE PP)>
<PRODUCTION RED-SNBAP	S 2	(NP BE-FORM ?NOT ?BE ADJ PP)> "I AM MAD AT YOU"

<PRODUCTION RED-FCN	?QW1 3		() (QWORD)>

<PRODUCTION RED-SQBN	S 2	(QWORD BE-FORM NP)>
;<PRODUCTION RED-SQBA	S 2	(QWORD BE-FORM ADJ)>
;<PRODUCTION RED-SQBP	S 2	(QWORD BE-FORM PP)>

<PRODUCTION RED-SBNN	S 2	(?QW1 BE-FORM NP ?NOT ?BE NPP)
				(?QW1 BE-FORM  NOT NP ?BE NPP)>
<PRODUCTION RED-SBNA	S 2	(?QW1 BE-FORM NP ?NOT ?BE ADJ)
				(?QW1 BE-FORM  NOT NP ?BE ADJ)>
<PRODUCTION RED-SBNP	S 2	(?QW1 BE-FORM NP ?NOT ?BE PP)
				(?QW1 BE-FORM  NOT NP ?BE PP)>
;<PRODUCTION RED-SBNAP	S 2	(?QW1 BE-FORM NP ?NOT ?BE ADJ PP)
				(?QW1 BE-FORM  NOT NP ?BE ADJ PP)>

<ADD-WORD BE MISCWORD>
<PRODUCTION RED-BE	?BE 3		() (MISCWORD ;"BE")>

<ADD-WORD NOT MISCWORD>
<PRODUCTION RED-NOT	?NOT 3		() (MISCWORD ;"NOT")>
<PRODUCTION RED-NOT	NOT 3		(MISCWORD ;"NOT")>
>

<IFFLAG (P-PS-COMMA
	<PRODUCTION RED-PERS	?PERS 2	()
					(NPP COMMA)
					(ASKWORD NPP PARTICLE ;"TO")>)
	(T
	<PRODUCTION RED-PERS	?PERS 2	()
					(NPP MISCWORD)
					(ASKWORD NPP PARTICLE ;"TO")>)>

<PRODUCTION DO-ORPHAN-TEST	O? 2 ()>

<PROD-PRIORITY <1
<PRODUCTION RED-O-NP	S 1	(O? NP) ;"was NPP"
				(O? NP PP)>>
	       9>
<PROD-PRIORITY <1
<PRODUCTION RED-O-ADJ	S 1	(O? ADJS)>>
	       9>
<PROD-PRIORITY <1
<PRODUCTION RED-O-PP	S 1	(O? PP)
				(O? PARTICLE NP)>>
	       9>

<STARTING-SYMBOL SP>
<MAKE-TABLES <LALR>>
