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
