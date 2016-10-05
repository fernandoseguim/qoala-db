clear screen
set serveroutput on
alter session set current_schema=QOALA;

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
show errors
/
create or replace procedure sp_insert_device_geo_location(
 pid_device in device_geo_locations.id_device%TYPE, 
 pverified_at in device_geo_locations.verified_at%TYPE,
 platitude in device_geo_locations.latitude%TYPE,
 plongitude in device_geo_locations.longitude%TYPE,
 out_id_geo out device_geo_locations.id_device_geo_location%TYPE)
is 
begin
  begin
    insert into device_geo_locations(id_device_geo_location, id_device, verified_at, latitude, longitude) 
      values(seq_device_geo_locations.nextval, pid_device, SYSDATE, platitude, plongitude)
      returning id_device_geo_location into out_id_geo;
      sp_device_geo_location_log('insert_device_geo_location: OK! ', out_id_geo);
  exception when others then
    sp_device_geo_location_log('insert_device_geo_location error: ' || sqlerrm, out_id_geo);
  end;
end sp_insert_device_geo_location;
/
show errors
/