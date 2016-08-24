alter session set current_schema = qoala;

CREATE OR REPLACE PACKAGE pkg_net_account AS
   PROCEDURE insert_net_account(
     token_id in net_accounts.access_token_id%TYPE, 
     user_id in net_accounts.user_id%TYPE,
     identifier in net_accounts.identifier%TYPE,
     provider in net_accounts.provider%TYPE,
     out_token out net_accounts.access_token_id%TYPE
   );
END pkg_net_account;
/

CREATE OR REPLACE PACKAGE BODY pkg_net_account AS 
    procedure insert_net_account(
     token_id in net_accounts.access_token_id%TYPE, 
     user_id in net_accounts.user_id%TYPE,
     identifier in net_accounts.identifier%TYPE,
     provider in net_accounts.provider%TYPE,
     out_token out net_accounts.access_token_id%TYPE)
    is 
    begin
      begin
        insert into net_accounts(access_token_id, user_id, identifier, provider) 
          values(token_id, user_id, identifier, provider)
          returning access_token_id into out_token;
      end;
    end insert_net_account;    
END pkg_net_account;
