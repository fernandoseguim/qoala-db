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
    end sp_delete_post;
/
