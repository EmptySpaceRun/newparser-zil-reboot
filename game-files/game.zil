"MAIN GAME FILE for
        NEW-PARSER GAME
    by Max Fog (using the new parser)"

<CONSTANT RELEASEID 1>

<COMPILATION-FLAG P-IMAGES <>>     ;"DEPRECATED... If you get this working I'll eat my shoe"

<IFN-P-IMAGES
<VERSION XZIP>
<ZIP-OPTIONS UNDO MOUSE COLOR>>

<IF-P-IMAGES
<VERSION YZIP>
<ZIP-OPTIONS UNDO BIG MOUSE COLOR DISPLAY>>

<FREQUENT-WORDS?>
<LONG-WORDS?>
<ORDER-OBJECTS? ROOMS-FIRST>
<NEVER-ZAP-TO-SOURCE-DIRECTORY?>

<IF-P-IMAGES
<ASK-FOR-PICTURE-FILE?>>

<IF-P-IMAGES
<DEFINE-SEGMENT STARTUP T CASTLE>
<DEFINE-SEGMENT CASTLE <>>
<DEFINE-SEGMENT HINTS <>>
<DEFINE-SEGMENT SOFT <>>> ;"I dunno.. I ain't using it"

<SET REDEFINE T>
<SETG NEW-PARSER? T>
<SETG NEW-VOC? T>
<COMPILATION-FLAG ONE-BYTE-PARTS-OF-SPEECH T>

;<SETG L-SEARCH-PATH (["~interlogic/zillib/parser"] !,L-SEARCH-PATH)>
<INSERT-FILE "defs">
<INSERT-FILE "parser.moor">

<INSERT-FILE "misc">
<INSERT-FILE "input">
<INSERT-FILE "syntax">
<INSERT-FILE "verbs">
;<PUT-PURE-HERE>
<INSERT-FILE "globals">

<IF-P-IMAGES
<INSERT-FILE "pic">
<INSERT-FILE "picdef">>

<INSERT-FILE "places">

<INSERT-FILE "prare">

<COMPILATION-FLAG SPLIT-HINTS T>

<IF-P-IMAGES
<INSERT-FILE "clues">
<INSERT-FILE "hints">>

<IFN-P-IMAGES
<INSERT-FILE "help">>

<PROPDEF SIZE 5>
<PROPDEF CAPACITY 5>