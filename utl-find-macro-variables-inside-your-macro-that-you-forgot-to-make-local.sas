%let pgm=utl-find-macro-variables-inside-your-macro-that-you-forgot-to-make-local;

%stop_submission;

Find macro vaiables inside your macro that you forgot to make local

PREP (make Allans macros available)

/*---- download and make available Allans macros ---*/
filename mc url "https://raw.githubusercontent.com/sasjs/core/main/all.sas";
data _null_;
  infile mc;
  file  "c:/utl/allans_macros _20250819.sas";
  input;
  put _infile_;
run;quit;

%inc "c:/utl/allans_macros _20250819.sas";


CONTENTS

  1 the probelem forgot %local;
    Allan Macros
    https://core.sasjs.io/mp__assertscope_8sas.html

  2 the fix  %local x

github
https://tinyurl.com/5ytxmbfy
https://github.com/rogerjdeangelis/utl-find-macro-variables-inside-your-macro-that-you-forgot-to-make-local


/**************************************************************************************************************************/
/* INPUT                            | PROCESS                             | OUTPUT GLOBAL X is overrwitten by MKEVAR X    */
/* =====                            | =======                             | ======                                        */
/* * only if rerun;                 | 1 THE PROBELEM FORGOT %LOCAL        | WORK.TEST_RESULTS                             */
/* proc datasets lib=work           | ============================        |                                               */
/*  nolist nodetails;               |                                     |                  TEST_                        */
/*  delete test_results;            | %macro mkevar;                      | TEST_DESCRIPTION RESULT TEST_COMMENTS         */
/* run;quit;                        |                                     | ---------------- ------ --------------------- */
/*                                  |  %local y;                          | Macro changes    FAIL   Mod:(X) Add:() Del:() */
/* %symdel x / nowarn;              |  %let y=local;                      |                                               */
/*                                  |                                     | %* over write previous global x=outside;      */
/* * x is global;                   |  %let x=inside;                     |                                               */
/* %let x=outside;                  |  %put &=x;                          | %put &=x;                                     */
/*                                  |                                     | %* X=inside;                                  */
/* *take a snapshot macro vars;     |  %* SCOPE     NAME ;                |                                               */
/* %mp_assertscope(SNAPSHOT)        |  %* MKEVAR     Y   ;                | The global x=outside was overwritten          */
/*                                  |  %* GLOBAL     X   ;                | to inside (x=inside is now global)            */
/*----------------------------------|                                     |                                               */
/*                                  |  %mp_assertscope(COMPARE,           |  SCOPE     NAME                               */
/* %put _user_;                     |   desc=Global macro changes)        |  MKEVAR     Y   REMAINS LOCAL AND DISSAPPEARS */
/* * GLOBAL X outside;              |                                     |  GLOBAL     X   HAS VALUE FROM MKEVAR MACRO   */
/*                                  | %mend mkevar;                       |                                               */
/* ALL USER MACRO ASSIGNMENTS       |                                     |                                               */
/*                                  | %mkevar;                            |                                               */
/*  WORK.MP_ASSERTSCOPE(SNAPSHOT)   |                                     |                                               */
/*                                  | %* over write x=outside;            |                                               */
/*  NAME              VALUE         | %put &=x;                           |                                               */
/*  GLOBAL X          outside       |                                     |                                               */
/*                                  | %* X=inside;                        |                                               */
/*  GLOBAL STATES50   AL AK AZ..    |                                     |                                               */
/*  GLOBAL STATES50Q  "AL","AK..    | proc print data=test_results;       |                                               */
/*  GLOBAL NUMBER      1234567..    | run;quit;                           |                                               */
/*  GLOBAL NUMBERS    1 2 3 4..     |                                     |                                               */
/*  GLOBAL LETTER     ABCDEFGH..    |                                     |                                               */
/*  GLOBAL LETTERS    A B C D ..    |                                     |                                               */
/*  GLOBAL LETTERSQ   "A","B",..    |                                     |                                               */
/*                                  |                                     |                                               */
/*------------------------------------------------------------------------------------------------------------------------*/
/* * you need to run this           | 2 THE FIX (JUST MAKE X LOCAL        | WORK.TEST_RESULTS                             */
/* proc datasets lib=work           | ===========================         |                                               */
/*  nolist nodetails;               |                                     |                  TEST_                        */
/*  delete test_results;            | proc datasets lib=work              | TEST_DESCRIPTION RESULT TEST_COMMENTS         */
/* run;quit;                        |  nolist nodetails;                  | ---------------- -----  -------------         */
/*                                  |  delete test_results;               | Macro changes    PASS   GLOBAL Unmodified     */
/* %symdel x / nowarn;              | run;quit;                           |                                               */
/*                                  |                                     | %* GLOBAL X NOT OVERWRITTEN;                  */
/* * x is global;                   | %macro mkevar;                      |                                               */
/* %let x=outside;                  |                                     | %put &=x;                                     */
/*                                  |  %local x y;                        |                                               */
/* *take a snapshot macro vars;     |  %let y=local;                      | X=outside                                     */
/* %mp_assertscope(SNAPSHOT)        |                                     |                                               */
/*                                  |  %let x=inside;                     |                                               */
/*                                  |  %put &=x;                          |                                               */
/*                                  |                                     |                                               */
/* %put _user_;                     |  %* SCOPE     NAME ;                |                                               */
/* * GLOBAL X outside;              |  %* MKEVAR     Y   ;                |                                               */
/*                                  |  %* GLOBAL     X   ;                |                                               */
/* ---------------------------------|                                     |                                               */
/* SAME AS ABOVE                    |  %mp_assertscope(COMPARE,           |                                               */
/*                                  |   desc=Global macro changes)        |                                               */
/*                                  |                                     |                                               */
/*                                  | %mend mkevar;                       |                                               */
/*                                  |                                     |                                               */
/*                                  | %mkevar;                            |                                               */
/*                                  |                                     |                                               */
/*                                  | proc print data=test_results;       |                                               */
/*                                  | run;quit;                           |                                               */
/*                                  |                                     |                                               */
/*                                  | %* global x NOT Overwritten         |                                               */
/*                                  | %put &=x;                           |                                               */
/**************************************************************************************************************************/


/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

proc datasets lib=work
 nolist nodetails;
 delete test_results;
run;quit;

%symdel x / nowarn;

* x is global;
%let x=outside;

*take a snapshot macro vars;
%mp_assertscope(SNAPSHOT)

/**************************************************************************************************************************/
/*  %put _user_;                                                                                                          */
/*                                                                                                                        */
/* All current user macro assignments                                                                                     */
/*                                                                                                                        */
/*  WORK.MP_ASSERTSCOPE(SNAPSHOT)                                                                                         */
/*                                                                                                                        */
/*  NAME              VALUE                                                                                               */
/*  GLOBAL X          outside                                                                                             */
/*                                                                                                                        */
/*  GLOBAL STATES50   AL AK AZ..                                                                                          */
/*  GLOBAL STATES50Q  "AL","AK..                                                                                          */
/*  GLOBAL NUMBER      1234567..                                                                                          */
/*  GLOBAL NUMBERS    1 2 3 4..                                                                                           */
/*  GLOBAL LETTER     ABCDEFGH..                                                                                          */
/*  GLOBAL LETTERS    A B C D ..                                                                                          */
/*  GLOBAL LETTERSQ   "A","B",..                                                                                          */
/**************************************************************************************************************************/

/*                   _     _                   __                       _    _                 _
/ |  _ __  _ __ ___ | |__ | | ___ _ __ ___    / _| ___  _ __ __ _  ___ | |_ | | ___   ___ __ _| |
| | | `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \  | |_ / _ \| `__/ _` |/ _ \| __|| |/ _ \ / __/ _` | |
| | | |_) | | | (_) | |_) | |  __/ | | | | | |  _| (_) | | | (_| | (_) | |_ | | (_) | (_| (_| | |
|_| | .__/|_|  \___/|_.__/|_|\___|_| |_| |_| |_|  \___/|_|  \__, |\___/ \__||_|\___/ \___\__,_|_|
    |_|                                                     |___/
*/

%macro mkevar;

 %local y;
 %let y=local;

 %let x=inside;
 %put &=x;

 %* SCOPE     NAME ;
 %* MKEVAR     Y   ;
 %* GLOBAL     X   ;

 %mp_assertscope(COMPARE,
  desc=Global macro changes)

%mend mkevar;

%mkevar;

%* over write x=outside;
%put &=x;

%* X=inside;

proc print data=test_results;
run;quit;

/**************************************************************************************************************************/
/*|  WORK.TEST_RESULTS total obs=1                                                                                        */
/*|                                 test_                                                                                 */
/*|  Obs      test_description      result        test_comments                                                           */
/*|                                                                                                                       */
/*|   1     Global macro changes     FAIL     Mod:(X) Add:() Del:()                                                       */
/**************************************************************************************************************************/

/*___    _   _             __ _        _                 _
|___ \  | |_| |__   ___   / _(_)_  __ | | ___   ___ __ _| | __  __
  __) | | __| `_ \ / _ \ | |_| \ \/ / | |/ _ \ / __/ _` | | \ \/ /
 / __/  | |_| | | |  __/ |  _| |>  <  | | (_) | (_| (_| | |  >  <
|_____|  \__|_| |_|\___| |_| |_/_/\_\ |_|\___/ \___\__,_|_| /_/\_\
                             _                   _
 _ __ ___ _ __ _   _ _ __   (_)_ __   ___  _   _| |_
| `__/ _ \ `__| | | | `_ \  | | `_ \| `_ \| | | | __|
| | |  __/ |  | |_| | | | | | | | | | |_) | |_| | |_
|_|  \___|_|   \__,_|_| |_| |_|_| |_| .__/ \__,_|\__|
                                    |_|
*/

proc datasets lib=work
 nolist nodetails;
 delete test_results;
run;quit;

%symdel x / nowarn;

* x is global;
%let x=outside;

*take a snapshot macro vars;
%mp_assertscope(SNAPSHOT)

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%macro mkevar;

 %local x y;
 %let y=local;

 %let x=inside;
 %put &=x;

 %* SCOPE     NAME ;
 %* MKEVAR     Y   ;
 %* GLOBAL     X   ;

 %mp_assertscope(COMPARE,
  desc=Global macro changes)

%mend mkevar;

%mkevar;

%* over write x=outside;
%put &=x;

proc print data=test_results;
run;quit;

/**************************************************************************************************************************/
/*                          test_                                                                                         */
/*    test_description      result           test_comments                                                                */
/*                                                                                                                        */
/*  Global macro changes     PASS     GLOBAL Variables Unmodified                                                         */
/*                                                                                                                        */
/*  %* GLOBAL X NOT OVERWRITTEN;                                                                                          */
/*                                                                                                                        */
/*  %put &=x;                                                                                                             */
/*                                                                                                                        */
/*  X=outside                                                                                                             */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
