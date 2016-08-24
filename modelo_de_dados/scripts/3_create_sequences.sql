alter session set current_schema = qoala;

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
drop sequence seq_net_accounts;
CREATE SEQUENCE seq_net_accounts
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
