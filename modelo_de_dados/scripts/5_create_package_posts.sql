alter session set current_schema = qoala;

/
CREATE OR REPLACE PACKAGE pkg_post AS
   PROCEDURE insert_post (
     title in posts.title%TYPE, 
     content in posts.content%TYPE, 
     user_id in posts.user_id%TYPE,
     out_id_post out posts.ID_POST%TYPE
   );
   PROCEDURE update_post (
     id in posts.id_post%TYPE,
     title in posts.title%TYPE, 
     content in posts.content%TYPE, 
     user_id in posts.user_id%TYPE,
     rowcount out NUMBER
   );
   PROCEDURE publish_post (id in posts.id_post%TYPE, rowcount out NUMBER);
   PROCEDURE delete_post (id in posts.id_post%TYPE, rowcount out NUMBER);
   PROCEDURE sp_post_log(log in post_logs.log%TYPE, post_id in post_logs.post_id%TYPE);
END pkg_post;
/

CREATE OR REPLACE PACKAGE BODY pkg_post AS
    
    procedure insert_post(
        title in posts.title%TYPE, 
        content in posts.content%TYPE, 
        user_id in posts.user_id%TYPE, 
        out_id_post out posts.ID_POST%TYPE)
    is 
    begin
      begin
        insert into posts(id_post, title, content, created_at, updated_at, user_id) 
          values(seq_posts.nextval, title, content, SYSDATE, null, user_id)
          returning ID_POST into out_id_post;
          sp_post_log('insert_post: OK! ' || title, out_id_post);
      exception when others then
        sp_post_log('insert_post error: ' || sqlerrm, out_id_post);
      end;
        
    end insert_post;
    
    procedure update_post(
        id in posts.id_post%TYPE, 
        title in posts.title%TYPE, 
        content in posts.content%TYPE, 
        user_id in posts.user_id%TYPE,
        rowcount out NUMBER)
    is 
    begin
      begin
        update posts
          set title = title, content = content, updated_at = SYSDATE, user_id = user_id 
          where id_post = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_post_log('Post updated', id);
        end if;
      exception when others then
        sp_post_log('update_post error: ' || sqlerrm, id);  
      end;
    end update_post;

    procedure delete_post(id in posts.id_post%TYPE, rowcount out NUMBER)
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
     
    procedure publish_post(id in posts.id_post%TYPE, rowcount out NUMBER)
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
    
    --private
    procedure sp_post_log(
        log in post_logs.log%TYPE, 
        post_id in post_logs.post_id%TYPE)
    is
      pragma autonomous_transaction;
    begin
      insert into post_logs(log, post_id, created_at) 
        values (log, post_id, SYSDATE);
      commit; --deve haver commit em uma transação autonoma
    end sp_post_log;
    
END pkg_post;
/