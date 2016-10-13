clear screen
set serveroutput on
alter session set current_schema=QOALA;

drop sequence seq_posts;
CREATE SEQUENCE seq_posts
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
drop sequence seq_comments;
CREATE SEQUENCE seq_comments
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
drop sequence seq_users;
CREATE SEQUENCE seq_users
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
drop sequence seq_devices;
CREATE SEQUENCE seq_devices
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
drop sequence seq_device_geo_locations;
CREATE SEQUENCE seq_device_geo_locations
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

drop sequence seq_plans;
CREATE SEQUENCE seq_plans
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/

drop sequence seq_sponsors;
CREATE SEQUENCE seq_sponsors
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/

drop sequence seq_rewards;
CREATE SEQUENCE seq_rewards
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
