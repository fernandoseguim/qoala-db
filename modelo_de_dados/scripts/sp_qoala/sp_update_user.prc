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
