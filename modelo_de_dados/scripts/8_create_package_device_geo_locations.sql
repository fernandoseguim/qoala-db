CREATE OR REPLACE PACKAGE pkg_device_geo_location AS
   PROCEDURE insert_device_geo_location(
     device_id in device_geo_locations.device_id%TYPE, 
     verified_at in device_geo_locations.verified_at%TYPE,
     latitude in device_geo_locations.latitude%TYPE,
     longitude in device_geo_locations.longitude%TYPE,
     out_id_geo out device_geo_locations.id_device_geo_location%TYPE
   );
   PROCEDURE sp_device_geo_location_log(
    log in device_geo_location_logs.log%TYPE, 
    device_geo_location_id in device_geo_location_logs.device_geo_location_id%TYPE
  );
END pkg_device_geo_location;
/

CREATE OR REPLACE PACKAGE BODY pkg_device_geo_location AS 
    procedure insert_device_geo_location(
     device_id in device_geo_locations.device_id%TYPE, 
     verified_at in device_geo_locations.verified_at%TYPE,
     latitude in device_geo_locations.latitude%TYPE,
     longitude in device_geo_locations.longitude%TYPE,
     out_id_geo out device_geo_locations.id_device_geo_location%TYPE)
    is 
    begin
      begin
        insert into device_geo_locations(id_device_geo_location, device_id, verified_at, latitude, longitude) 
          values(seq_device_geo_locations.nextval, device_id, SYSDATE, latitude, longitude)
          returning id_device_geo_location into out_id_geo;
          sp_device_geo_location_log('insert_device_geo_location: OK! ', out_id_geo);
      exception when others then
        sp_device_geo_location_log('insert_device_geo_location error: ' || sqlerrm, out_id_geo);
      end;
    end insert_device_geo_location;
    
    --private
    procedure sp_device_geo_location_log(
        log in device_geo_location_logs.log%TYPE, 
        device_geo_location_id in device_geo_location_logs.device_geo_location_id%TYPE)
    is
      pragma autonomous_transaction;
    begin
      insert into device_geo_location_logs(log, device_geo_location_id, created_at) 
        values (log, device_geo_location_id, SYSDATE);
      commit; --deve haver commit em uma transação autonoma
    end sp_device_geo_location_log;
    
END pkg_device_geo_location;
