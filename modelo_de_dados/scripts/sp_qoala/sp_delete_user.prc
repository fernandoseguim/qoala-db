create or replace procedure sp_delete_user(id in users.id_user%TYPE, rowcount out NUMBER)
is 
begin
  begin
    rowcount:=0;
    update users set deleted_at = SYSDATE where id_user = id;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_user_log('User deleted', id);
    end if;
  exception when others then
    sp_user_log('delete_user error: ' || sqlerrm, id);  
  end;
end sp_delete_user;
/
