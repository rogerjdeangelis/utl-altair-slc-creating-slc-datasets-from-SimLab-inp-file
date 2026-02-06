%let pgm=utl-altair-slc-creating-slc-datasets-from-SimLab-inp-file;

%stop_submission;

Too long to post here, see github

github
https://github.com/rogerjdeangelis/utl-altair-slc-creating-slc-datasets-from-SimLab-inp-file

Altair slc creating slc dataset from a SimLab inp file

  CONTENTS

      1 De-normalised form
      2 Normal form
      3 utl_untranspose macro (also in repo)
        AUTHORS: Arthur Tabachneck, Gerhard Svolba, Joe Matise and Matt Kastin


I decided not to output the first and last record because this form is
more easily summarized.
Even more useful is the normalised form.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
data _null_;
 file "d:/txt/sample1.inp" ;
 input;
 put _infile_;
 putlog _infile_;
cards4;
*KEYWORD
*NODE
       1        0.0        0.0        0.0
       2        1.0        0.0        0.0
       3        0.0        1.0        0.0
       4        1.0        1.0        0.0
       5        2.0        0.5        0.1
*ELEMENT_SHELL
     100       1       2       3       1
     101       2       4       3       1
     102       2       4       5       1
*MAT_LAW51
      1     210000.0     0.3    7.85E-9
*PROP_SHELL

      1         1.0         0.0         0.0
*END
;;;;
run;quit;

/*   ____                                              _ _              _   __
/ | |  _ \  ___       _ __   ___  _ __ _ __ ___   __ _| (_)___  ___  __| | / _| ___  _ __ _ __ ___
| | | | | |/ _ \_____| `_ \ / _ \| `__| `_ ` _ \ / _` | | / __|/ _ \/ _` || |_ / _ \| `__| `_ ` _ \
| | | |_| |  __/_____| | | | (_) | |  | | | | | | (_| | | \__ \  __/ (_| ||  _| (_) | |  | | | | | |
|_| |____/ \___|     |_| |_|\___/|_|  |_| |_| |_|\__,_|_|_|___/\___|\__,_||_|  \___/|_|  |_| |_| |_|

*/

data workx.sections(where=(strip(key) ne strip(str)));
  retain key '123456789012345678';
  length str $255;
  infile 'd:/txt/sample1.inp' ;
  input;
  str=strip(compbl(_infile_));
  if input(scan(str,1,' '),?? best12.)=. then do;
     key=str;
  end;
  else do;
     node1=input(scan(str,1,' '),e9.);
     node2=input(scan(str,2,' '),e9.);
     node3=input(scan(str,3,' '),e9.);
     node4=input(scan(str,4,' '),e9.);
  end;
run;quit;

proc print data=workx.sections;
format _numeric_  e9.;
run;quit;


/*************************************************************************************************************************/
/*WORKX.SECTIONS total obs=10                                                                                            */
/* KEY               STR                         NODE1         NODE2         NODE3         NODE4                         */
/*                                                                                                                       */
/* *NODE             1 0.0 0.0 0.0              1.00E+00     0.00E+00     0.00E+00     0.00E+00                          */
/* *NODE             2 1.0 0.0 0.0              2.00E+00     1.00E+00     0.00E+00     0.00E+00                          */
/* *NODE             3 0.0 1.0 0.0              3.00E+00     0.00E+00     1.00E+00     0.00E+00                          */
/* *NODE             4 1.0 1.0 0.0              4.00E+00     1.00E+00     1.00E+00     0.00E+00                          */
/* *NODE             5 2.0 0.5 0.1              5.00E+00     2.00E+00     5.00E-01     1.00E-01                          */
/* *ELEMENT_SHELL    100 1 2 3 1                1.00E+02     1.00E+00     2.00E+00     3.00E+00                          */
/* *ELEMENT_SHELL    101 2 4 3 1                1.01E+02     2.00E+00     4.00E+00     3.00E+00                          */
/* *ELEMENT_SHELL    102 2 4 5 1                1.02E+02     2.00E+00     4.00E+00     5.00E+00                          */
/* *MAT_LAW51        1 210000.0 0.3 7.85E-9     1.00E+00     2.10E+05     3.00E-01     7.85E-09                          */
/* *PROP_SHELL       1 1.0 0.0 0.0              1.00E+00     1.00E+00     0.00E+00     0.00E+00                          */
/*************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC     17:07 Thursday, February  5, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp

NOTE: Library worksas assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\worksas

NOTE: Library workwpd assigned as follows:
      Engine:        WPD
      Physical Name: d:\workwpd


LOG:  17:07:11
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.031
      cpu time  : 0.000


NOTE: AUTOEXEC processing completed

1
2         data sections(where=(strip(key) ne strip(str)));
3           retain key '123456789012345678';
4           length str $255;
5           infile 'd:/txt/sample1.inp' ;
6           input;
7           str=strip(compbl(_infile_));
8           if input(scan(str,1,' '),?? best12.)=. then do;
9              key=str;
10          end;
11          else do;
12             node1=input(scan(str,1,' '),e9.);
13             node2=input(scan(str,2,' '),e9.);
14             node3=input(scan(str,3,' '),e9.);
15             node4=input(scan(str,4,' '),e9.);
16          end;
17        run;

NOTE: The infile 'd:\txt\sample1.inp' is:
      Filename='d:\txt\sample1.inp',
      Owner Name=SLC\suzie,
      File size (bytes)=1312,
      Create Time=15:35:47 Feb 05 2026,
      Last Accessed=17:06:39 Feb 05 2026,
      Last Modified=16:13:08 Feb 05 2026,
      Lrecl=32767, Recfm=V

2                                                                                                                         Altair SLC


NOTE: 16 records were read from file 'd:\txt\sample1.inp'
      The minimum record length was 80
      The maximum record length was 80
NOTE: Data set "WORK.sections" has 10 observation(s) and 6 variable(s)
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


17      !     quit;
18
19        proc print data=sections;
20        format _numeric_  e9.;
21        run;quit;
NOTE: 10 observations were read from "WORK.sections"
NOTE: Procedure print step took :
      real time : 0.000
      cpu time  : 0.015


22
23        * fast traspose implicit sort with bells and whistles;;
24        %utl_untranspose(data=sections(drop=str),out=want,by=key, var=node1-node4)

NOTE: Data set "WORK.t_e_m_p" has 1 observation(s) and 4 variable(s)
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


NOTE: Procedure sql step took :
      real time : 0.094
      cpu time  : 0.156



NOTE: 1 observations were read from "WORK.sections"
NOTE: Data set "WORK.t_e_m_p" has 1 observation(s) and 4 variable(s)
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


NOTE: Data set "WORK.t_e_m_p" has 4 observation(s) and 6 variable(s)
NOTE: Procedure sql step took :
      real time : 0.031
      cpu time  : 0.015



NOTE: 4 observations were read from "WORK.t_e_m_p"
NOTE: Data set "WORK.t_e_m_p" has 4 observation(s) and 9 variable(s)
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.015


NOTE: Automatically set SORTSIZE to 10240MiB
NOTE: 4 observations were read from "WORK.t_e_m_p"
NOTE: Data set "WORK.t_e_m_p" has 4 observation(s) and 9 variable(s)
NOTE: Procedure sort step took :
      real time : 0.031

3                                                                                                                         Altair SLC

      cpu time  : 0.000



NOTE: 4 observations were read from "WORK.t_e_m_p"
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


NOTE: CALL EXECUTE generated line
25      +  data work.want
26      +  ( keep=key _name_ _value_ );
27      +  set work.sections (drop=str);
28      +  length _name_ $32 _value_ 8 ;
29      +  _name_="NODE1";
30      +  _value_=NODE1;
31      +  if not missing(NODE1) then do;
32      +  output;
33      +  end;
34      +  _name_="NODE2";
35      +  _value_=NODE2;
36      +  if not missing(NODE2) then do;
37      +  output;
38      +  end;
39      +  _name_="NODE3";
40      +  _value_=NODE3;
41      +  if not missing(NODE3) then do;
42      +  output;
43      +  end;
44      +  _name_="NODE4";
45      +  _value_=NODE4;
46      +  if not missing(NODE4) then do;
47      +  output;
48      +  end;
49      +  run;

NOTE: 10 observations were read from "WORK.sections"
NOTE: Data set "WORK.want" has 40 observation(s) and 3 variable(s)
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


NOTE: Deleting "WORK.T_E_M_P" (memtype="DATA")
NOTE: Procedure delete step took :
      real time : 0.015
      cpu time  : 0.000


50
51        proc print data=want;
52         format _value_ e9.;
53        run;
NOTE: 40 observations were read from "WORK.want"
NOTE: Procedure print step took :
      real time : 0.015
      cpu time  : 0.000


54
55
ERROR: Error printed on page 1

4                                                                                                                         Altair SLC


NOTE: Submitted statements took :
      real time : 0.342
      cpu time  : 0.296

/*___    _   _                            _ _              _   __
|___ \  | \ | | ___  _ __ _ __ ___   __ _| (_)___  ___  __| | / _| ___  _ __ _ __ ___
  __) | |  \| |/ _ \| `__| `_ ` _ \ / _` | | / __|/ _ \/ _` || |_ / _ \| `__| `_ ` _ \
 / __/  | |\  | (_) | |  | | | | | | (_| | | \__ \  __/ (_| ||  _| (_) | |  | | | | | |
|_____| |_| \_|\___/|_|  |_| |_| |_|\__,_|_|_|___/\___|\__,_||_|  \___/|_|  |_| |_| |_|


*/
* fast traspose implicit sort with bells and whistles;;
%slc_untranspose(data=workx.sections(drop=str),out=want,by=key, var=node1-node4)

proc print data=want;
 format _value_ e9.;
run;quit;

/**************************************************************************************************************************/
/* Altair SLC                                                                                                             */
/*                                                                                                                        */
/* Obs         KEY          _NAME_      _VALUE_                                                                           */
/*                                                                                                                        */
/*   1    *NODE             NODE1      1.00E+00                                                                           */
/*   2    *NODE             NODE2      0.00E+00                                                                           */
/*   3    *NODE             NODE3      0.00E+00                                                                           */
/*   4    *NODE             NODE4      0.00E+00                                                                           */
/*   5    *NODE             NODE1      2.00E+00                                                                           */
/*   6    *NODE             NODE2      1.00E+00                                                                           */
/*   7    *NODE             NODE3      0.00E+00                                                                           */
/*   8    *NODE             NODE4      0.00E+00                                                                           */
/*   9    *NODE             NODE1      3.00E+00                                                                           */
/*  10    *NODE             NODE2      0.00E+00                                                                           */
/*  11    *NODE             NODE3      1.00E+00                                                                           */
/*  12    *NODE             NODE4      0.00E+00                                                                           */
/*  13    *NODE             NODE1      4.00E+00                                                                           */
/*  14    *NODE             NODE2      1.00E+00                                                                           */
/*  15    *NODE             NODE3      1.00E+00                                                                           */
/*  16    *NODE             NODE4      0.00E+00                                                                           */
/*  17    *NODE             NODE1      5.00E+00                                                                           */
/*  18    *NODE             NODE2      2.00E+00                                                                           */
/*  19    *NODE             NODE3      5.00E-01                                                                           */
/*  20    *NODE             NODE4      1.00E-01                                                                           */
/*  21    *ELEMENT_SHELL    NODE1      1.00E+02                                                                           */
/*  22    *ELEMENT_SHELL    NODE2      1.00E+00                                                                           */
/*  23    *ELEMENT_SHELL    NODE3      2.00E+00                                                                           */
/*  24    *ELEMENT_SHELL    NODE4      3.00E+00                                                                           */
/*  25    *ELEMENT_SHELL    NODE1      1.01E+02                                                                           */
/*  26    *ELEMENT_SHELL    NODE2      2.00E+00                                                                           */
/*  27    *ELEMENT_SHELL    NODE3      4.00E+00                                                                           */
/*  28    *ELEMENT_SHELL    NODE4      3.00E+00                                                                           */
/*  29    *ELEMENT_SHELL    NODE1      1.02E+02                                                                           */
/*  30    *ELEMENT_SHELL    NODE2      2.00E+00                                                                           */
/*  31    *ELEMENT_SHELL    NODE3      4.00E+00                                                                           */
/*  32    *ELEMENT_SHELL    NODE4      5.00E+00                                                                           */
/*  33    *MAT_LAW51        NODE1      1.00E+00                                                                           */
/*  34    *MAT_LAW51        NODE2      2.10E+05                                                                           */
/*  35    *MAT_LAW51        NODE3      3.00E-01                                                                           */
/*  36    *MAT_LAW51        NODE4      7.85E-09                                                                           */
/*  37    *PROP_SHELL       NODE1      1.00E+00                                                                           */
/*  38    *PROP_SHELL       NODE2      1.00E+00                                                                           */
/*  39    *PROP_SHELL       NODE3      0.00E+00                                                                           */
/*  40    *PROP_SHELL       NODE4      0.00E+00                                                                           */
/**************************************************************************************************************************/
/*____               _
|___ /   _   _ _ __ | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___
  |_ \  | | | | `_ \| __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \
 ___) | | |_| | | | | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/
|____/   \__,_|_| |_|\__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|
                                            |_|

 _ __ ___   __ _  ___ _ __ ___
| `_ ` _ \ / _` |/ __| `__/ _ \
| | | | | | (_| | (__| | | (_) |
|_| |_| |_|\__,_|\___|_|  \___/

*/

data _null_;
 file "c:/wpsoto/slc_untranspose.sas";
 input;
 put _infile_;
cards4;
/** The %untranspose macro
  *
  * This macro untransposes wider SAS datasets back to either the less wide
  * state that existed before the file was transposed, or to a long file
  *
  * AUTHORS: Arthur Tabachneck, Gerhard Svolba, Joe Matise and Matt Kastin
  * CREATED: September 25, 2017
  * MODIFIED: September 10, 2018

  Parameter Descriptions:

  *libname_in* NOT REQUIRED - the parameter to which you can assign the name
   of the SAS library that contains the dataset you want to untranspose. If
   left null, and the data parameter is only assigned a one-level filename,
   the macro will set this parameter to equal WORK

  *libname_out* NOT REQUIRED - the parameter to which you can assign the name
   of the SAS library where you want the untransposed file written. If left
   null, and the out parameter only has a one-level filename assigned, the
   macro will set this parameter to equal WORK

  *data* REQUIRED - the parameter to which you would assign the name of the
   file that you want to untranspose.  Like with PROC TRANSPOSE, you can use
   either a one or two-level filename. If you assign a two-level file name,
   the first level will take precedence over the value set in the libname_in
   parameter.  If you assign a one-level filename, the libname in the
   libname_in parameter will be used. Additionally, as with PROC TRANSPOSE,
   the data parameter will also accept data step options. Thus, for example,
   if you had a dataset called 'have' and want to limit the untransposition
   to just the first 10 records, you could specify it as:
   data=have (obs=10).
   Any data step options accepted by a SAS data step can be included

  *out* REQUIRED - the parameter to which you would assign the name of the
   file that you want the macro to create. Like with PROC TRANSPOSE, you can
   use either a one or two-level filename. If you use assign a two-level file
   name, the first level will take precedence over the value set in the
   libname_out parameter. If you use a one-level filename, the libname in the
   libname_out parameter will be used

  *by* ONLY NECESSARY IF YOU HAVE A BY VARIABLE - the parameter to which you
   would assign the name of the dataset’s by variable(s). The by parameter is
   like the by statement used in PROC TRANSPOSE, namely the identification of
   the variable (if any) that had been used to form by groups. By groups
   define the record level of the wide file you want to untranspose

  *prefix* ONLY NECESSARY IF YOUR TRANSPOSED VARIABLE NAME(S) BEGIN WITH A
   PREFIX - This is the parameter to which you would assign the string (if
   any) that each transposed variable begins with

  *var* REQUIRED the parameter to which you would assign the name or names of
   the original variables that had been transposed

  *id* ONLY NECESSARY IF YOUR TRANSPOSED VARIABLE NAMES CONTAIN ID VALUES -
   the parameter to which you specify the variable name that was used as the
   ID variable when the transposed file was created.  Only one variable can
   be assigned

  *id_informat* ONLY NECESSARY IF 8. SHOULD NOT BE USED AS THE INFORMAT FOR
   EXTRACTING ID VALUES - the parameter to which you would assign the
   informat you want used for extracting the id variable's values

  *id_format* ONLY NECESSARY IF 8. SHOULD NOT BE ASSIGNED AS THE FORMAT FOR
   EXTRACTED ID VALUES - the parameter to which you would indicate the format
   you want assigned to the id variable

  *var_first* ONLY NECESSARY IF ID VALUES PRECEDE VARIABLE NAMES IN THE
   TRANSPOSED VARIABLE NAMES or IF THE TRANSPOSED VARIABLE NAME(S) DON'T
   INCLUDE THE VARIABLE NAME - the parameter that defines whether var names
   precede id values in the transposed variable names. Possible values are
   YES, NO or N/A and must be correctly assigned to reflect the way the
   transposed variables were formed

   YES=[prefix]var[delimiter]id[suffix]
   NO=[prefix]id[delimiter]var[suffix]
   N/A=[prefix]id[suffix] or [prefix]+var[suffix]

  *delimiter* ONLY NECESSARY IF YOUR TRANSPOSED VARIABLE NAME(S) CONTAIN A
   DELIMITER - the parameter to which you would assign the string (if any)
   that was used to separate var and ID values

  *suffix* ONLY NECESSARY IF YOUR TRANSPOSED VARIABLE NAME(S) END WITH A
   SUFFIX - the parameter to which you would assign a string (if any) that
   each transposed variable ends with

  *copy* ONLY NECESSARY IF YOUR WIDE FILE CONTAINS ONE OR MORE VARIABLES THAT
   SHOULD BE COPIED RATHER THAN UNTRANSPOSED - the parameter to which you
   would assign the name(s) of any variables that had been copied rather than
   transposed

  *missing* ONLY NECESSARY IF YOU WANT TO OUTPUT A RECORD EVEN IF THE ONLY
   NON-MISSING VARIABLES ARE BY, ID OR COPY VARIABLES - PROC TRANSPOSE will
   output untransposed records even if the only non-missing variables are the
   BY, ID and COPY variables. If you want the macro to behave similarly set
   this parameter to equal YES

  *metadata* NOT REQUIRED  - the parameter to which you would specify the one
   or two-level SAS dataset the you want created to reflect the variable
   names, labels, informats, formats and types of the untransposed
   variables

  *makelong* ONLY NECESSARY IF YOU WANT TO OUTPUT A SEPARATE RECORD FOR EACH
   BY VARIABLE, ID VALUE AND VARIABLE COMBINATION  - this parameter will
   automatically be set to YES if no ID variable is declared with the ID
   parameter. If you do declare an ID variable, set this parameter to YES
   if you want the macro to output a long file

  *max_length* (ONLY NECESSARY IF YOU WANT TO CONTROL THE LENGTH OF ALL
   UNTRANSPOSED VARIABLES) - This parameter is only applicable to those cases
   where you are untransposing a file from being wide to being long. If used
   it should be used cautiously as it could result in losing data

  *create_byvar* NOT REQUIRED - the parameter to which you would specify the
   variable name you want assigned to serve as the by variable in the event
   that you don't have a by variable and want the sequential record number
   to be assigned to that variable
*/

%macro slc_untranspose(libname_in=,
                   libname_out=,
                   data=,
                   out=,
                   by=,
                   prefix=,
                   var=,
                   id=,
                   id_informat=8.,
                   id_format=8.,
                   var_first=yes,
                   delimiter=,
                   suffix=,
                   copy=,
                   missing=NO,
                   metadata=,
                   makelong=,
                   max_length=,
                   create_byvar=);

  /*Check whether data and out parameters contain 1 or 2-level filenames*/
  /*and, if needed, separate libname and data from data set options */
  %let lp=%sysfunc(findc(%superq(data),%str(%()));
  %if &lp. %then %do;
   %let rp=%sysfunc(findc(%superq(data),%str(%)),b));
  /*for SAS
   %let dsoptions=%qsysfunc(substrn(%nrstr(%superq(data)),&lp+1,&rp-&lp-1));
   %let data=%sysfunc(substrn(%nrstr(%superq(data)),1,%eval(&lp-1)));
  */
  /*for WPS */
   %let dsoptions=%qsysfunc(substrn(%nrquote(%superq(data)),&lp+1,&rp-&lp-1));
   %let data=%sysfunc(substrn(%nrquote(%superq(data)),1,%eval(&lp-1)));
  %end;
  %else %let dsoptions=;

  %let lp=%sysfunc(findc(%superq(out),%str(%()));
  %if &lp. %then %do;
   %let rp=%sysfunc(findc(%superq(out),%str(%)),b));
   /*for SAS
   %let odsoptions=%qsysfunc(substrn(%nrstr(%superq(out)),&lp+1,&rp-&lp-1));
   %let out=%sysfunc(substrn(%nrstr(%superq(out)),1,%eval(&lp-1)));
   */
   /*for WPS */
   %let odsoptions=%qsysfunc(substrn(%nrquote(%superq(out)),&lp+1,&rp-&lp-1));
   %let out=%sysfunc(substrn(%nrquote(%superq(out)),1,%eval(&lp-1)));
  %end;
  %else %let odsoptions=;
  %if %sysfunc(countw(&data.)) eq 2 %then %do;
    %let libname_in=%scan(&data.,1);
    %let data=%scan(&data.,2);
  %end;
  %else %if %length(&libname_in.) eq 0 %then %do;
    %let libname_in=work;
  %end;

  %if %sysfunc(countw(&out.)) eq 2 %then %do;
    %let libname_out=%scan(&out.,1);
    %let out=%scan(&out.,2);
  %end;
  %else %if %length(&libname_out.) eq 0 %then %do;
    %let libname_out=work;
  %end;

  /*Create macro variable to contain a list of variables that were copied*/
  %let to_copy=;
  %if %length(&copy.) gt 0 %then %do;
    data t_e_m_p;
      set &libname_in..&data. (obs=1 keep=&copy.);
    run;

    proc sql noprint;
      select name
        into :to_copy separated by " "
          from dictionary.columns
            where libname="WORK" and
                  memname="T_E_M_P"
        ;
      quit;
  %end;

  data t_e_m_p;
    array vars(*) &var.;
    output;
  run;

  proc sql noprint;
    select catt("'",name,"'"),
           catt('(not missing(',name,'))')
       into :vars separated by ",",
            :check separated by " or "
          from dictionary.columns
            where libname="WORK" and
                  memname="T_E_M_P"
               order by length(name) descending
    ;

    select catt("'",name,"'")
       into :ordered_vars separated by ","
          from dictionary.columns
            where libname="WORK" and
                  memname="T_E_M_P"
               order by varnum
    ;
  quit;

  data t_e_m_p;
    set &libname_in..&data. (obs=1 &dsoptions.
    %if %length(&by.) gt 0 or %length(&copy) gt 0 %then drop=&by. &copy.;);
  run;

  proc sql noprint;
    create table t_e_m_p as
      select name,format,informat,label,length,type
         from dictionary.columns
           where libname="WORK" and
                 memname="T_E_M_P"
    ;
    select min(type), max(length)
      into :mintype,:maxlength
        from WORK.T_E_M_P
    ;
  quit;

  data t_e_m_p (drop=temp);
    set t_e_m_p;
    do var=&vars.;
      if %length(&id) gt 0 then do;
        if upcase("&var_first.") eq 'YES' then do;
          if catt(upcase("&prefix."),upcase(var))=:strip(upcase(name)) then do;
            id_value=substr(strip(name),%length(&prefix.)+length(strip(var))+
                %length(&delimiter)+1,
                length(strip(name))-%length(&prefix.)-length(strip(var))-
                %length(&delimiter)-%length(&suffix.));
            leave;
          end;
        end;
        else if upcase("&var_first.") eq 'N/A' then do;
          id_value=substr(strip(name),%length(&prefix.)+1,
                length(strip(name))-%length(&prefix.)-%length(&suffix.));
        end;
        else do;
          if strip(reverse(catt(upcase(var),upcase("&suffix.")))) =:
             strip(reverse(upcase(name))) then do;
            temp=reverse(substr(reverse(strip(name)),
                %length(&suffix)+length(strip(var))+%length(&delimiter)+1));
            id_value=substr(strip(temp),%length(&prefix.)+1);
            leave;
          end;
        end;
      end;
      else do;
        if catt(upcase("&prefix."),upcase(var),upcase("&suffix."))=:
            strip(upcase(name)) then do;
          id_value='1';
          leave;
        end;
      end;
    end;
    order=0;
    do temp=&ordered_vars.;
      order+1;
      if strip(upcase(var)) eq strip(upcase(temp)) then leave;
    end;
  run;

  proc sort data=t_e_m_p;
    by id_value order;
  run;

  %if %length(&by) lt 1 and %length(&create_byvar) gt 0 %then %do;
    %let by=&create_byvar;
  %end;

  data _null_;
    length forexec $255;
    set t_e_m_p end=lastone;
    by id_value;
    %if %length(&id) lt 1 %then %do;
      if _n_ eq 1 then do;
        call execute("data &libname_out..&out.");
        call execute("(&odsoptions. keep=&by. _name_ _value_ &copy.);");
        %if %length(&create_byvar) gt 0 %then %do;
          call execute("length &create_byvar. 8.;");
        %end;
        %if %length(%unquote(&dsoptions.)) gt 2 %then %do;
           call execute("set &libname_in..&data. (&dsoptions.);");
        %end;
        %else %do;
          call execute("set &libname_in..&data.;");
        %end;
        forexec="length _name_ $32 _value_ ";
        %if %length(&max_length) gt 0 %then %do;
          %if &mintype. eq char %then %do;
            forexec=catt(forexec,"$",&max_length.,";");
          %end;
          %else %do;
            forexec=catx(' ',forexec,&max_length.,";");
          %end;
        %end;
        %else %do;
          %if &mintype. eq char %then %do;
            forexec=catt(forexec,"$",&maxlength.,";");
          %end;
          %else %do;
            forexec=catx(' ',forexec,&maxlength.,";");
          %end;
        %end;
        call execute(forexec);
      end;
      forexec=catt('_name_="',var,'";');
      call execute(forexec);
      if type eq 'num' and "&mintype." eq "char" then
        forexec=catt('_value_=left(put(',name,',8.));');
      else forexec=catt('_value_=',name,';');
      call execute(forexec);
      %if %upcase(&missing.) eq NO %then %do;
        forexec=catt('if not missing(',name,') then do;');
        call execute(forexec);
      %end;
      %if %length(&create_byvar) gt 0 %then %do;
        call execute("&create_byvar. = _n_;");
      %end;
      call execute('output;');
      %if %upcase(&missing.) eq NO %then %do;
        call execute('end;');
      %end;
    %end;
    %else %if %upcase(&makelong.) eq YES %then %do;
      if _n_ eq 1 then do;
        call execute("data &libname_out..&out.");
        call execute("(&odsoptions. keep=&by. &id. _name_ _value_ &copy.);");
        %if %length(&create_byvar) gt 0 %then %do;
          call execute("length &create_byvar. 8.;");
        %end;
        %if %length(%unquote(&dsoptions.)) gt 2 %then %do;
           call execute("set &libname_in..&data. (&dsoptions.);");
        %end;
        %else %do;
          call execute("set &libname_in..&data.;");
        %end;
        forexec=catx(' ','informat',"&id.","&id_informat.",';');
        call execute(forexec);
        forexec=catx(' ','format',"&id.","&id_format.",';');
        call execute(forexec);
        forexec="length _name_ $32 _value_ ";
        %if %length(&max_length) gt 0 %then %do;
          %if &mintype. eq char %then %do;
            forexec=catt(forexec,"$",&max_length.,";");
          %end;
          %else %do;
            forexec=catx(' ',forexec,&max_length.,";");
          %end;
        %end;
        %else %do;
          %if &mintype. eq char %then %do;
            forexec=catt(forexec,"$",&maxlength.,";");
          %end;
          %else %do;
            forexec=catx(' ',forexec,&maxlength.,";");
          %end;
        %end;
        call execute(forexec);
      end;
      forexec=catt('_name_="',var,'";');
      call execute(forexec);
      if type eq 'num' and "&mintype." eq "char" then
        forexec=catt('_value_=left(put(',name,',8.));');
      else forexec=catt('_value_=',name,';');
      call execute(forexec);
      %if %upcase(&missing.) eq NO %then %do;
        forexec=catt('if not missing(',name,') then do;');
        call execute(forexec);
      %end;
      if first("&id_informat.") ne "$" then do;
        makeid=input(id_value,&id_informat.);
        forexec=catt("&id.",'=',makeid,';');
      end;
      else do;
        makeid=put(id_value,&id_informat.);
        forexec=catt("&id.",'="',makeid,'";');
      end;
      call execute(forexec);
      %if %length(&create_byvar) gt 0 %then %do;
        call execute("&create_byvar. = _n_;");
      %end;
      call execute('output;');
      %if %upcase(&missing.) eq NO %then %do;
        call execute('end;');
      %end;
    %end;
    %else %do;
      if _n_ eq 1 then do;
        call execute("data &libname_out..&out.");
        call execute("(&odsoptions. keep=&by. &id. &var. &copy.);");
        %if %length(&create_byvar) gt 0 %then %do;
          call execute("length &create_byvar. 8.;");
        %end;
        %if %length(%unquote(&dsoptions.)) gt 2 %then %do;
           call execute("set &libname_in..&data. (&dsoptions.);");
        %end;
        %else %do;
          call execute("set &libname_in..&data.;");
        %end;
        forexec=catx(' ','informat',"&id.","&id_informat.",';');
        call execute(forexec);
        forexec=catx(' ','format',"&id.","&id_format.",';');
        call execute(forexec);
        counter=1;
      end;
      if counter eq 1 then do;
        if not missing(label) then do;
          forexec=catx(' ','label',var,'=',label,';');
          call execute(forexec);
        end;
        if not missing(informat) then do;
          forexec=catx(' ','informat',var,informat,';');
          call execute(forexec);
        end;
        if not missing(format) then do;
          forexec=catx(' ','format',var,format,';');
          call execute(forexec);
        end;
        if not missing(length) then do;
          if type eq 'char' then forexec=catx(' ','length',var,'$',length,';');
          else forexec=catx(' ','length',var,length,';');
          call execute(forexec);
        end;
      end;
      forexec=catt(var,'=',name,';');
      call execute(forexec);
      if last.id_value then do;
        counter+1;
        %if %upcase(&missing.) eq NO %then  %do;
          forexec=catx(' ','if',"&check",'then do;');
          call execute(forexec);
        %end;
        if first("&id_informat.") ne "$" then do;
          makeid=input(id_value,&id_informat.);
          forexec=catt("&id.",'=',makeid,';');
        end;
        else do;
          makeid=put(id_value,&id_informat.);
          forexec=catt("&id.",'="',makeid,'";');
        end;
        call execute(forexec);

        %if %length(&create_byvar) gt 0 %then %do;
          call execute("&create_byvar. = _n_;");
        %end;

        call execute('output;');
        %if %upcase(&missing.) eq NO %then call execute('end;');;
      end;
    %end;
    if lastone then call execute('run;');
  run;

  %if %length(&metadata) gt 0 %then %do;
    proc sql noprint;
      create table &metadata. as
        select distinct var as _name_, format as _format_,
               informat as _informat_, label as _label_,
               length as _length_, type as _type_
          from t_e_m_p
            order by order
      ;
    quit;
  %end;

/*Delete all temporary files*/
   proc delete data=work.t_e_m_p;
   run;
%mend slc_untranspose;

/****************Examples**********************
*3 variables with the variable names formatted as var+id;
data have;
  input id income2015-income2017
           expenses2015-expenses2017
           (debt2015-debt2017) ($);
  cards;
1 70000 75500 80000 60000 70000 81000 no no yes
2 50000 52000 55000 42000 53000 60000 no yes yes
3 80000 90000 99000 70000 75000 85000 no  no  no
;

%untranspose(data=have, out=want, by=id, id=year,
 var=income expenses debt)

*3 variables with the variable names formatted as var+id, but only
untransposing the first obs;

%untranspose(data=have (obs=1), out=want, by=id, id=year,
 var=income expenses debt)

*3 variables with the variable names formatted as var+id, but only
 untransposing a specific id;

%untranspose(data=have (where=(id eq 2)), out=want, by=id, id=year,
 var=income expenses debt)

*3 variables with the variable names formatted as var+delimiter+id;
data have;
  input id income_2015-income_2017
           expenses_2015-expenses_2017
           (debt_2015-debt_2017) ($);
  cards;
1 70000 75500 80000 60000 70000 81000 no no yes
2 50000 52000 55000 42000 53000 60000 no yes yes
3 80000 90000 99000 70000 75000 85000 no  no  no
;

%untranspose(data=have, out=want, by=id, delimiter=_, id=year,
 var=income expenses debt)

*3 variables with the variable names formatted as var+delimiter+id, but
 changing the order of the variables output;
data have;
  input id income_2015-income_2017
           expenses_2015-expenses_2017
           (debt_2015-debt_2017) ($);
  cards;
1 70000 75500 80000 60000 70000 81000 no no yes
2 50000 52000 55000 42000 53000 60000 no yes yes
3 80000 90000 99000 70000 75000 85000 no  no  no
;
%untranspose(data=have, out=want, by=id, delimiter=_, id=year,
 var=debt income expenses)

*1 variable with the variable names formatted as: var+id;
data have;
  input weight1-weight3;
  cards;
77 79 83
;
%untranspose(data=have, out=want, id=time, var=weight)

*1 variable with the variable names formatted as:
 prefix+var+delimiter+id+suffix;
data have;
  input id _this_1_test _this_2_test _this_3_test;
  cards;
1 1 2 3
2 6 5 4
;
%untranspose(data=have, out=want, by=id, prefix=_, id=qtr, delimiter=_,
 var=this,suffix=_test)

*2 variables with the variable names formatted as:
 prefix+var+delimiter+id+suffix;
data have;
  input id _this_1_test _this_2_test _this_3_test
        _thiss_1_test _thiss_2_test _thiss_3_test;
  cards;
1 1 2 3 4 5 6
2 6 5 4 3 2 1
;

%untranspose(data=have, out=want, by=id, prefix=_, id=qtr, delimiter=_,
 var=this thiss,suffix=_test)

*2 variables with the variable names formatted as:
 prefix+id+delimiter+var+suffix;
data have;
  input id _1_this_test _2_this_test _3_this_test _1_thiss_test _2_thiss_test _3_thiss_test;
  cards;
1 1 2 3 4 5 6
2 6 5 4 3 2 1
;

%untranspose(data=have, out=want, by=id, prefix=_, id=qtr, delimiter=_,
 var_first=no,var=this thiss, suffix=_test)

*2 variables with the variable names formatted as:
 prefix+id+delimiter+var+suffix;
data have;
  input id thisA thisB thisC
        (thisislongerA thisislongerB thisislongerC) ($);
  label thisA='Shorter';
  label thisB='Shorter';
  label thisC='Shorter';
  label thisislongerA='Longer';
  label thisislongerB='Longer';
  label thisislongerC='Longer';
  cards;
1 1 2 3 D E F
2 6 5 4 C B A
;

%untranspose(data=have, out=want, by=id, id=section,
 var=this thisislonger, id_informat=$1.,id_format=$1.)

*or to only transpose one or some of the variables:

%untranspose(data=have(keep=id thisA--thisC), out=want, by=id, id=section,
 var=this, id_informat=$1.,id_format=$1.)

*1 variable with the variable names formatted as: prefix+id;
data have;
  informat customer 8.
    _0-_6 $12.;
  input customer (_0-_6) (&);
  cards;
1 herring  corned beef  olives  ham  turkey  bourbon  ice cream
2 corned beef  peppers  bourbon  crackers  chicken  ice cream  ice cream
;

%untranspose(data=have, out=want, id=time,prefix=_,var_first=n/a,
 var=product, id_informat=1.0,id_format=1.0,by=customer)

*6 variables with three formatted and the variable names formatted as: var;
proc format;
  value n
  1='AA'
  2='BB'
  3='CC'
  ;
  value $c
  'A'='11'
  'B'='22'
  ;
run;

data have;
  length subject 8;
  label var1='first var'
        var2='second var'
        var3='third var'
        var4='fourth var'
        var5='fifth var'
        var6='sixth var'
  ;
  format var2 n.
         var3 comma6.
         var4 $c.;

  input subject var1-var3 (var4-var6) ($);
  cards;
1 1 2 30000 A B this
2 3 2 10000 B A that
;

%untranspose(data=have, out=want, var=var1-var6, by=subject, metadata=meta, max_length=5)

*6 variables with three formatted and the variable names formatted as: prefix+var;
proc format;
  value n
  1='AA'
  2='BB'
  3='CC'
  ;
  value $c
  'A'='11'
  'B'='22'
  ;
run;

data have;
  length subject 8;
  label test_var1='first var'
        test_var2='second var'
        test_var3='third var'
        test_var4='fourth var'
        test_var5='fifth var'
        test_var6='sixth var'
  ;
  format test_var2 n.
         test_var3 comma6.
         test_var4 $c.;

  input subject test_var1-test_var3 (test_var4-test_var6) ($);
  cards;
1 1 2 30000 A B this
2 3 2 . B A that
;

%untranspose(data=have, out=want, var=var1-var6, by=subject, prefix=test_, missing=yes, metadata=meta, max_length=5)
********************************************************************/
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
