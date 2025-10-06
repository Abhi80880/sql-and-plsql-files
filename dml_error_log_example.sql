create table emp1 (empno number primary key,
ename varchar2(30),
doj date,
sal number
);

insert into emp1 values (7,'SELVA',SYSDATE,NULL);

commit;

select * from emp1;
select * from emp2;
create table emp2 (empno number primary key,
ename varchar2(7),
doj date  not null,
sal number(4) not null
);

begin
  dbms_errlog.create_error_log(dml_table_name => 'emp2');
  end;

insert into emp2 select *  from emp1
log errors into err$_emp2('') reject limit unlimited;

select * from err$_emp2;
truncate table err$_emp2;
