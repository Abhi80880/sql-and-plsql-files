create table abya_log (val1 varchar2(4000));

create table a_log (val1 varchar2(4000));


create table abhi_log
(      log_id        number  NOT NULL,
       created_in    timestamp with local time zone,
       created_by    varchar2(1000),
       errorcode     integer,
       callstack     varchar2(4000),
       errorstack    varchar2(4000),
       backtrace     varchar2(4000),
       error_info    varchar2(4000)
       );    
       

ALTER TABLE abhi_log ADD (
  CONSTRAINT log_pk_abhi PRIMARY KEY (log_id));
  
  commit;

CREATE SEQUENCE error_seq_abhi;


CREATE OR REPLACE TRIGGER error_tr_abhi 
BEFORE INSERT ON abhi_log
FOR EACH ROW
BEGIN
 select error_seq_abhi.nextval into :new.log_id from dual;
END;

/


   

create or replace package abhi_error_msg
is
       failure_in_forall exception;
       
       pragma exception_init (failure_in_forall, -24444);
       
       procedure abhi_error_log(app_info_in in varchar2);
end;   

/

create or replace package body abhi_error_msg
is
       procedure abhi_error_log (app_info_in in varchar2)
         is
                 pragma autonomous_transaction;
                 /*cannot call this function directly in sql*/
                 c_code constant integer:= sqlcode;
         begin
                 insert into abhi_log(created_in,
                                            created_by,
                                            errorcode,
                                            callstack,
                                            errorstack,
                                            backtrace,
                                            error_info)
                              values(systimestamp,
                                     user,
                                     c_code,
                                     dbms_utility.format_call_stack,
                                     dbms_utility.format_error_stack,
                                     dbms_utility.format_error_backtrace,
                                     app_info_in);
                  commit;
          end;
        end;
                          
