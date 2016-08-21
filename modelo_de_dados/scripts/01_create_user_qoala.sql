-- connect masterqoala as dba

---
prompt Criando role RL_QOALA para novos usuários
create role RL_QOALA;

GRANT "CONNECT" TO RL_QOALA;
GRANT CREATE SESSION TO RL_QOALA;

--
prompt Criando usuario owner do sistema
CREATE USER qoala IDENTIFIED BY "Q41L1@2016"
  DEFAULT TABLESPACE "USERS"
  TEMPORARY TABLESPACE "TEMP";

GRANT "CONNECT" TO qoala WITH ADMIN OPTION;
GRANT CREATE SESSION TO qoala with admin option;
GRANT RL_QOALA to qoala with admin option;

---
prompt Criando usuario de servicos
CREATE USER qoala_user IDENTIFIED BY "Q41L1@2016"
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

grant RL_QOALA to qoala_user;

