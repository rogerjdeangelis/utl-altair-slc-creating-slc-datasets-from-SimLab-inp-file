/* Normal form via the repo's %slc_untranspose macro
   (utl-altair-slc-...-SimLab-inp-file.sas, authors Tabachneck/Svolba/Matise/Kastin).
   The repo calls %slc_untranspose(data=workx.sections(drop=str),by=key,var=node1-node4)
   to untranspose the parsed SimLab sections from wide to long. This bundle keeps the
   macro verbatim and drives it with a small self-contained `sections` input built the
   same way, using the repo's own invocation form. */

/* small wide input in the shape the repo untransposes (key + node1-node4) */
data sections;
  input key $ node1 node2 node3 node4;
datalines;
*NODE          1 0 0 0
*NODE          2 1 0 0
*ELEMENT_SHELL 100 1 2 3
*MAT_LAW51     1 210000 0.3 1
*PROP_SHELL    1 1 0 0
;
run;

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

/* the repo's own invocation form: wide -> long by key, over node1-node4 */
%slc_untranspose(data=sections, out=want, by=key, var=node1-node4)

proc print data=want;
 format _value_ e9.;
run;quit;
