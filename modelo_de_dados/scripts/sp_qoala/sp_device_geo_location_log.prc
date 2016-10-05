create or replace procedure sp_device_geo_location_log(
    plog in device_geo_location_logs.log%TYPE, 
    pdevice_geo_location_id in device_geo_location_logs.device_geo_location_id%TYPE)
is
  pragma autonomous_transaction;
begin
  insert into device_geo_location_logs(log, device_geo_location_id, created_at) 
    values (plog, pdevice_geo_location_id, SYSDATE);
  commit; --deve haver commit em uma transação autonoma
end sp_device_geo_location_log;
/
