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
    end sp_publish_post;    
/
