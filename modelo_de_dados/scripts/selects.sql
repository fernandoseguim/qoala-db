grant dba to qoala;
revoke dba from qoala;

alter session set current_schema= QOALA;

select * from dba_objects a
where a.object_name like '%SQL%';


--sessoes ativas
select sesion.sid,
       sesion.username,
       optimizer_mode,
       hash_value,
       address,
       cpu_time,
       elapsed_time,
       sql_text
  from v$session sesion 
  join v$sqlarea sqlarea on   (sesion.sql_hash_value = sqlarea.hash_value and sesion.sql_address    = sqlarea.address)
 where sesion.username like '%QOALA';
 
 
 -- sessoes abertas
SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid,
       s.serial#,
       p.spid,
       s.lockwait,
       s.status,
       s.service_name,
       s.module,
       s.machine,
       s.program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time,
       s.last_call_et AS last_call_et_secs
FROM   v$session s,
       v$process p
WHERE  s.paddr = p.addr
and s.username like '%QOALA'
ORDER BY s.username, s.osuser
;
     
-- ultimas querys
select to_char(s.last_active_time, 'hh24:mi:ss') last_time, s.module, sql_text, s.executions
from v$sql s
join all_users u on u.user_id = s.parsing_user_id
where u.username like '%QOALA'
--and upper(sql_text) like '%USER%'
--and sql_text like '%DELETED%'
and module = 'vstest.executionengine.x86.exe'
order by s.LAST_ACTIVE_TIME desc;
 