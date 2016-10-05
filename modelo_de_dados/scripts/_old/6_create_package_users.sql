clear screen
set serveroutput on
alter session set current_schema=QOALA;

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
show errors
/

create or replace procedure sp_insert_user(
    name in users.name%TYPE, 
    password in users.password%TYPE, 
    email in users.email%TYPE, 
    permission in users.permission%TYPE,
    out_id_user in out USERS.ID_USER%type)
is
begin
  begin
    insert into users(id_user, name, password, email, permission, created_at) 
      values(seq_users.nextval, name, password, email, nvl(permission,1),  SYSDATE)
      returning ID_USER into out_id_user;
      commit;
      sp_user_log('insert_user: OK! ' || email, out_id_user);
  exception when others then
    sp_user_log('insert_user error: ' || sqlerrm, out_id_user);
  end;
end sp_insert_user;
/
show errors
/

create or replace procedure sp_update_user(
    id in users.id_user%TYPE, 
    name in users.name%TYPE, 
    password in users.password%TYPE, 
    email in users.email%TYPE, 
    permission in users.permission%TYPE, 
    rowcount out NUMBER)
is 
begin
  begin
    update users 
      set name = name, password = password, email = email, permission = permission, updated_at = SYSDATE
      where id_user = id;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_user_log('User updated', id);
    end if;
  exception when others then
    sp_user_log('update_user error: ' || sqlerrm, id);  
  end;
end update_user;
/
show errors
/

procedure delete_user(id in users.id_user%TYPE, rowcount out NUMBER)
is 
begin
  begin
    update users set deleted_at = SYSDATE where id_user = id;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_user_log('User deleted', id);
    end if;
  exception when others then
    sp_user_log('delete_user error: ' || sqlerrm, id);  
  end;
end delete_user;
/
show errors
/
