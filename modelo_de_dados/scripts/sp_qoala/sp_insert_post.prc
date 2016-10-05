create or replace procedure sp_insert_post(
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
        
    end sp_insert_post;
/
