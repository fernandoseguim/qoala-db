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
create or replace procedure sp_insert_user(name in users.name%TYPE,
                                           password    in users.password%TYPE,
                                           email       in users.email%TYPE,
                                           permission  in users.permission%TYPE,
                                           address     in users.address%TYPE default null,
                                           district    in users.district%TYPE default null,
                                           city        in users.city%TYPE default null,
                                           state       in users.state%TYPE default null,
                                           zipcode     in users.zipcode%TYPE default null,
                                           out_id_user out users.id_user%type) is
begin
  begin
    sp_user_log(name || ', ' || password || ', ' || email || ', ' || permission || ',' || 
                     address || ',' || district || ',' || city || ',' || state || ',' || 
                     zipcode || '.',0);
    insert into users
      (id_user,
       name,
       password,
       email,
       permission,
       created_at,
       address,
       district,
       city,
       state,
       zipcode)
    values
      (seq_users.nextval,
       name,
       password,
       email,
       nvl(permission, 1),
       SYSDATE,
       address,
       district,
       city,
       state,
       zipcode)
    returning ID_USER into out_id_user;
    commit;
    sp_user_log('insert_user: OK! ' || email, out_id_user);
  exception
    when others then
      sp_user_log('insert_user error: ' || sqlerrm, out_id_user);
  end;
end sp_insert_user;
/
show errors
/

create or replace procedure sp_update_user(
    pid in users.id_user%TYPE, 
    pname in users.name%TYPE, 
    ppassword in users.password%TYPE, 
    pemail in users.email%TYPE, 
    ppermission in users.permission%TYPE,
    paddress     in users.address%TYPE,
    pdistrict    in users.district%TYPE,
    pcity        in users.city%TYPE,
    pstate       in users.state%TYPE,
    pzipcode     in users.zipcode%TYPE,
    prowcount out NUMBER)
is 
begin
  begin
    prowcount:=0;
    update users 
      set name = pname, password = ppassword, email = pemail, permission = ppermission, 
                 address = paddress, district = pdistrict, city = pcity, state = pstate, zipcode = pzipcode, updated_at = SYSDATE
      where id_user = pid;
    sp_user_log('User update: ID:'||pid||', rowcount: '||sql%ROWCOUNT||'.', pid);
    prowcount := sql%ROWCOUNT;
    if prowcount > 0 then
      sp_user_log('User update: ' || pname || ', password = ' || ppassword || ', email = ' || pemail|| ', permission = ' || ppermission ||
                  ', address = '|| paddress ||', district = ' || pdistrict || ', city = ' || pcity || ', state = ' || pstate || ', zipcode = ' ||pzipcode ||
                  ', id_user = ' || pid, pid);
    end if;
  exception when others then
    sp_user_log('update_user error: ' || sqlerrm, pid);  
  end;
end sp_update_user;
/
show errors
/

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
show errors
/
