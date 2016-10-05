CREATE OR REPLACE PROCEDURE sp_insert_device(
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
