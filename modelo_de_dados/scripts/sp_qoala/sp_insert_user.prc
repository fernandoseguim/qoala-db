create or replace procedure sp_insert_user(name        in users.name%TYPE,
                                                 password    in users.password%TYPE,
                                                 email       in users.email%TYPE,
                                                 permission  in users.permission%TYPE default 1,
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
       permission,
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
