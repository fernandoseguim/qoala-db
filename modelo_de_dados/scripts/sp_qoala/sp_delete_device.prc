create or replace procedure sp_delete_device(pid in devices.id_device%TYPE, rowcount out NUMBER)
is 
begin
  begin
    update devices set deleted_at = SYSDATE where id_device = pid;
    rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
      sp_device_log('Device deleted', pid);
    end if;
  exception when others then
    sp_device_log('delete_device error: ' || sqlerrm, pid);  
  end;
end sp_delete_device;
/
