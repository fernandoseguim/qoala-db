create or replace procedure sp_update_device(
  pid in devices.id_device%TYPE,
  palias in devices.alias%TYPE, 
  pcolor in devices.color%TYPE,
  pfrequency_update in devices.frequency_update%TYPE,
  pid_user in devices.id_user%TYPE,
  rowcount out NUMBER
)
is 
begin
  begin
    update devices set 
      alias = palias, 
      color = pcolor, 
      frequency_update = pfrequency_update, 
      id_user = pid_user, 
      updated_at = SYSDATE
    where id_device = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_device_log('Device updated ' || palias || pcolor || pfrequency_update || pid_user, pid);
    end if;
  exception when others then
    sp_device_log('update_device error: ' || sqlerrm, pid);  
  end;
end sp_update_device;
/
