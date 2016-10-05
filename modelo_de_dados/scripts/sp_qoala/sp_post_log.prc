create or replace procedure sp_post_log(
        log in post_logs.log%TYPE, 
        post_id in post_logs.post_id%TYPE)
    is
      pragma autonomous_transaction;
    begin
      insert into post_logs(log, post_id, created_at) 
        values (log, post_id, SYSDATE);
      commit; --deve haver commit em uma transação autonoma
    end sp_post_log;
/
