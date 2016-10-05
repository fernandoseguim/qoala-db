create or replace procedure sp_user_log(
        log in user_logs.log%TYPE, 
        user_id in user_logs.user_id%TYPE)
is
  pragma autonomous_transaction;
begin
  begin
    insert into user_logs(log, user_id, created_at) 
      values (log, user_id, SYSDATE);
  exception when others then
    null;
  end;
  commit; --deve haver commit em uma transação autonoma
end sp_user_log;
/
