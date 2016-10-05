create or replace procedure sp_approve_comment(pid in comments.id_comment%TYPE, rowcount out NUMBER)
is
begin
   begin
    update comments set updated_at = SYSDATE, approved_at = SYSDATE where id_comment = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_comment_log('Comment Approved', pid);
    end if;
  exception when others then
    sp_comment_log('approve_comment error: ' || sqlerrm, pid);  
  end;
end sp_approve_comment;
/
