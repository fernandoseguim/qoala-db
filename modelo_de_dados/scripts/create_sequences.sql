alter session set current_schema = qoala;

drop sequence seq_post;
CREATE SEQUENCE seq_post
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;