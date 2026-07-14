/* De-normalised form from utl-altair-slc-...-SimLab-inp-file.sas
   The repo reads a SimLab .inp file with `infile 'd:/txt/sample1.inp'` and
   parses each line into a KEY row plus NODE1-NODE4. This bundle keeps that
   parse logic verbatim (workx -> work; the hardcoded infile path rewritten
   to read the same sample inline via `infile datalines`). */
data sections(where=(strip(key) ne strip(str)));
  retain key '123456789012345678';
  length str $255;
  infile datalines truncover;
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
datalines;
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
;
run;quit;

proc print data=sections;
format _numeric_  e9.;
run;quit;
