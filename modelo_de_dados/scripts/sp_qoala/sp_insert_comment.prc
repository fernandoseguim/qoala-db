create or replace procedure sp_insert_comment(
    pcontent in comments.content%TYPE, 
    pid_user in comments.id_user%TYPE, 
    pid_post in comments.id_post%TYPE, 
    out_id_comment out comments.ID_comment%TYPE)
is 
begin
  begin
    insert into comments(id_comment, content, created_at, id_user, id_post, approved_at) 
      values(seq_comments.nextval, pcontent, SYSDATE, pid_user, pid_post, SYSDATE)
      returning ID_COMMENT into out_id_comment;
      sp_comment_log('insert_comment: OK! ' || pcontent, out_id_comment);
  exception when others then
    sp_comment_log('insert_comment error: ' || sqlerrm, out_id_comment);
  end;
end sp_insert_comment;
/
