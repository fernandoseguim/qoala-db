create or replace procedure sp_update_last_location(
 pid in devices.id_device%TYPE, 
 plast_longitude in devices.last_longitude%TYPE,
 plast_latitude in devices.last_latitude%TYPE,  
 rowcount out NUMBER)
is 
begin
  begin
    update devices set 
      last_longitude = plast_longitude, 
      last_latitude = plast_latitude, 
      updated_at = SYSDATE 
    where id_device = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_device_log('Last location updated ' || plast_longitude || plast_latitude, pid);
    end if;
  exception when others then
    sp_device_log('update_last_location error: ' || sqlerrm, pid);  
  end;
end sp_update_last_location;
/
