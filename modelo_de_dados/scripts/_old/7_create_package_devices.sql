clear screen
set serveroutput on
alter session set current_schema=QOALA;

create or replace procedure sp_device_log(
    plog in device_logs.log%TYPE, 
    pdevice_id in device_logs.device_id%TYPE)
is
  pragma autonomous_transaction;
begin
  insert into device_logs(log, device_id, created_at) 
    values (plog, pdevice_id, SYSDATE);
  commit; --deve haver commit em uma transação autonoma
end sp_device_log;
/
show errors
/
    create or replace PROCEDURE sp_insert_device(
    palias in devices.alias%TYPE, 
     pcolor in devices.color%TYPE,
     pfrequency_update in devices.frequency_update%TYPE,
     pid_user in devices.id_user%TYPE,
     out_id_device out devices.id_device%TYPE)
    is 
    begin
      begin
        insert into devices(id_device, alias, color, frequency_update, id_user, created_at) 
          values(seq_devices.nextval, palias, pcolor, pfrequency_update, pid_user, SYSDATE)
          returning ID_DEVICE into out_id_device;
          sp_device_log('insert_device: OK! ' || palias || pcolor || pfrequency_update || pid_user, out_id_device);
      exception when others then
        sp_device_log('insert_device error: ' || sqlerrm, out_id_device);
      end;
    end sp_insert_device;
/
show errors
/
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
show errors
/
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
show errors
/   
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
show errors
/    
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
show errors
/