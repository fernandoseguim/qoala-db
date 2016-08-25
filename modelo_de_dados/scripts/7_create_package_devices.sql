clear screen
set serveroutput on
alter session set current_schema=QOALA;

CREATE OR REPLACE PACKAGE pkg_device AS
   PROCEDURE insert_device(
     alias in devices.alias%TYPE, 
     color in devices.color%TYPE,
     frequency_update in devices.frequency_update%TYPE,
     user_id in devices.user_id%TYPE,
     out_id_device out devices.id_device%TYPE
   );
   PROCEDURE update_device(
     id in devices.id_device%TYPE,
     alias in devices.alias%TYPE, 
     color in devices.color%TYPE,
     frequency_update in devices.frequency_update%TYPE,
     user_id in devices.user_id%TYPE,
     rowcount out NUMBER
   );
   PROCEDURE update_last_location(
     id in devices.id_device%TYPE, 
     last_longitude in devices.last_longitude%TYPE,
     last_latitude in devices.last_latitude%TYPE,  
     rowcount out NUMBER
    );
    PROCEDURE turn_alarm(
      id in devices.id_device%TYPE, 
      alarm in devices.alarm%TYPE,
      rowcount out NUMBER
    );
   PROCEDURE delete_device(id in devices.id_device%TYPE, rowcount out NUMBER);
END pkg_device;
/
show errors
/

CREATE OR REPLACE PACKAGE BODY pkg_device AS
    --private
    procedure sp_device_log(
        log in device_logs.log%TYPE, 
        device_id in device_logs.device_id%TYPE)
    is
      pragma autonomous_transaction;
    begin
      insert into device_logs(log, device_id, created_at) 
        values (log, device_id, SYSDATE);
      commit; --deve haver commit em uma transação autonoma
    end sp_device_log;
    PROCEDURE insert_device(
    alias in devices.alias%TYPE, 
     color in devices.color%TYPE,
     frequency_update in devices.frequency_update%TYPE,
     user_id in devices.user_id%TYPE,
     out_id_device out devices.id_device%TYPE)
    is 
    begin
      begin
        insert into devices(id_device, alias, color, frequency_update, user_id, created_at) 
          values(seq_devices.nextval, alias, color, frequency_update, user_id, SYSDATE)
          returning ID_DEVICE into out_id_device;
          sp_device_log('insert_device: OK! ' || alias, out_id_device);
      exception when others then
        sp_device_log('insert_device error: ' || sqlerrm, out_id_device);
      end;
    end insert_device;
    
    procedure update_device(
      id in devices.id_device%TYPE,
      alias in devices.alias%TYPE, 
      color in devices.color%TYPE,
      frequency_update in devices.frequency_update%TYPE,
      user_id in devices.user_id%TYPE,
      rowcount out NUMBER
    )
    is 
    begin
      begin
        update devices set 
          alias = alias, 
          color = color, 
          frequency_update = frequency_update, 
          user_id = user_id, 
          updated_at = SYSDATE
        where id_device = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_device_log('Device updated', id);
        end if;
      exception when others then
        sp_device_log('update_device error: ' || sqlerrm, id);  
      end;
    end update_device;

    procedure delete_device(id in devices.id_device%TYPE, rowcount out NUMBER)
    is 
    begin
      begin
        update devices set deleted_at = SYSDATE where id_device = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_device_log('Device deleted', id);
        end if;
      exception when others then
        sp_device_log('delete_device error: ' || sqlerrm, id);  
      end;
    end delete_device;
    
    procedure turn_alarm(
      id in devices.id_device%TYPE, 
      alarm in  devices.alarm%TYPE,
      rowcount out NUMBER)
    is 
    begin
      begin
        update devices set alarm = alarm, updated_at = SYSDATE where id_device = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_device_log('Alarm update to ' || alarm , id);
        end if;
      exception when others then
        sp_device_log('turn_alarm error: ' || sqlerrm, id);  
      end;
    end turn_alarm;
    
    procedure update_last_location(
     id in devices.id_device%TYPE, 
     last_longitude in devices.last_longitude%TYPE,
     last_latitude in devices.last_latitude%TYPE,  
     rowcount out NUMBER)
    is 
    begin
      begin
        update devices set 
          last_longitude = last_longitude, 
          last_latitude = last_latitude, 
          updated_at = SYSDATE 
        where id_device = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_device_log('Last location updated', id);
        end if;
      exception when others then
        sp_device_log('update_last_location error: ' || sqlerrm, id);  
      end;
    end update_last_location;
    
END pkg_device;
/
show errors
/