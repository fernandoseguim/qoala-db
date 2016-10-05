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
          set title = ptitle, content = pcontent, updated_at = SYSDATE, id_user= pid_user
          where id_post = pid;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_post_log('Post updated' || ptitle || pcontent || pid_user, pid);
        end if;
      exception when others then
        sp_post_log('update_post error: ' || sqlerrm, pid);  
      end;
    end sp_update_post;
/
