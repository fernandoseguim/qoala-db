clear screen
set serveroutput on
alter session set current_schema=QOALA;

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
show errors
/   
create or replace procedure sp_insert_comment(
    pcontent in comments.content%TYPE, 
    pid_user in comments.id_user%TYPE, 
    pid_post in comments.id_post%TYPE, 
    out_id_comment out comments.ID_comment%TYPE)
is 
begin
  begin
    insert into comments(id_comment, content, created_at, id_user, id_post) 
      values(seq_comments.nextval, pcontent, SYSDATE, pid_user, pid_post)
      returning ID_COMMENT into out_id_comment;
      sp_comment_log('insert_comment: OK! ' || pcontent, out_id_comment);
  exception when others then
    sp_comment_log('insert_comment error: ' || sqlerrm, out_id_comment);
  end;
end sp_insert_comment;
/
show errors
/   
create or replace procedure sp_update_comment(
    pid in comments.id_comment%TYPE, 
    pcontent in comments.content%TYPE, 
    pid_user in comments.id_user%TYPE, 
    pid_post in comments.id_post%TYPE,
    rowcount out NUMBER)
is 
begin
  begin
    update comments 
      set content = pcontent, id_post = pid_post, updated_at = SYSDATE, id_user = pid_user
      where id_comment = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_comment_log('Comment updated ' || pcontent || pid_post || pid_user, pid);
    end if;
  exception when others then
    sp_comment_log('update_comment error: ' || sqlerrm, pid);  
  end;
end sp_update_comment;
/
show errors
/
create or replace procedure sp_delete_comment(pid in comments.id_comment%TYPE, rowcount out NUMBER)
is 
begin
  begin
    update comments set deleted_at = SYSDATE where id_comment = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_comment_log('Comment deleted', pid);
    end if;
  exception when others then
    sp_comment_log('delete_comment error: ' || sqlerrm, pid);  
  end;
end sp_delete_comment;
/
show errors
/     
create or replace procedure sp_approve_comment(pid in comments.id_comment%TYPE, rowcount out NUMBER)
is
begin
   begin
    update comments set approved_at = SYSDATE where id_comment = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_comment_log('Comment Approved', pid);
    end if;
  exception when others then
    sp_comment_log('approve_comment error: ' || sqlerrm, pid);  
  end;
end sp_approve_comment;
/
show errors
/