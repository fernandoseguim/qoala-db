create or replace procedure sp_turn_alarm(
  pid in devices.id_device%TYPE, 
  palarm in  devices.alarm%TYPE,
  rowcount out NUMBER)
is 
begin
  begin
    update devices set alarm = palarm, updated_at = SYSDATE where id_device = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_device_log('Alarm update to ' || palarm , pid);
    end if;
  exception when others then
    sp_device_log('turn_alarm error: ' || sqlerrm, pid);  
  end;
end sp_turn_alarm;
/
