create or replace procedure sp_insert_device_geo_location(
 pid_device in device_geo_locations.id_device%TYPE, 
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
