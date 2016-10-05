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
