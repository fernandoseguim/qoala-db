clear screen
set serveroutput on;
alter session set current_schema = QOALA;

create or replace procedure sp_post_log(
    log in post_logs.log%TYPE,
    post_id in post_logs.post_id%TYPE)
    is
      pragma autonomous_transaction;
begin
  insert into post_logs(log, post_id, created_at)
        values(log, post_id, SYSDATE);
commit; --deve haver commit em uma transação autonoma
end sp_post_log;
/
show errors
/
    
create or replace procedure insert_post(
    title in posts.title%TYPE,
    content in posts.content%TYPE,
    id_user in posts.id_user%TYPE,
    out_id_post out posts.ID_POST%TYPE)
is 
begin
    begin
    insert into posts(id_post, title, content, created_at, updated_at, id_user)
        values(seq_posts.nextval, title, content, SYSDATE, null, id_user)
        returning ID_POST into out_id_post;
        sp_post_log('insert_post: OK! ' || title, out_id_post);
exception when others then
    sp_post_log('insert_post error: ' || sqlerrm, out_id_post);
end;
        
end insert_post;
/
show errors
/     
create or replace procedure sp_update_post(
    pid in posts.id_post%TYPE,
    ptitle in posts.title%TYPE,
    pcontent in posts.content%TYPE,
    pid_user in posts.id_user%TYPE,
    rowcount out NUMBER)
is 
begin
    begin
    update posts
        set title = ptitle, content = pcontent, updated_at = SYSDATE, id_user = pid_user
        where id_post = pid;
rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
        sp_post_log('Post updated' || ptitle || pcontent || pid_user, pid);
end if;
    exception when others then
    sp_post_log('update_post error: ' || sqlerrm, pid);
end;
end update_post;
/
show errors
/


create or replace procedure sp_delete_post(id in posts.id_post%TYPE, rowcount out NUMBER)
is 
begin
    begin
    update posts set deleted_at = SYSDATE where id_post = id;
rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
        sp_post_log('Post deleted', id);
end if;
    exception when others then
    sp_post_log('delete_post error: ' || sqlerrm, id);
end;
end delete_post;
/
show errors
/

create or replace procedure sp_publish_post(id in posts.id_post%TYPE, rowcount out NUMBER)
is
begin
    begin
    update posts set published_at = SYSDATE where id_post = id;
rowcount := sql%ROWCOUNT;
    if rowcount > 0 then
        sp_post_log('Post published', id);
end if;
    exception when others then
    sp_post_log('publish_post error: ' || sqlerrm, id);
end;
end publish_post;    
/
show errors
/
