create or replace procedure sp_comment_log(
    plog in comment_logs.log%TYPE, 
    pcomment_id in comment_logs.comments_id%TYPE)
is
  pragma autonomous_transaction;
begin
  insert into comment_logs(log, comments_id, created_at) 
    values (plog, pcomment_id, SYSDATE);
  commit; --deve haver commit em uma transação autonoma
end sp_comment_log;
/
