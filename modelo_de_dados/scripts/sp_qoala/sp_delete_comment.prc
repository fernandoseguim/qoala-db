create or replace procedure sp_delete_comment(pid in comments.id_comment%TYPE, rowcount out NUMBER)
is 
begin
  begin
    update comments set deleted_at = SYSDATE, updated_at = SYSDATE where id_comment = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_comment_log('Comment deleted', pid);
    end if;
  exception when others then
    sp_comment_log('delete_comment error: ' || sqlerrm, pid);  
  end;
end sp_delete_comment;
/
