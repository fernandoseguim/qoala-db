CREATE PACKAGE p_post AS
   PROCEDURE insert_post (
     title post.title%TYPE, 
     content post.content%TYPE, 
     user_id post.user_id%TYPE
   );
   PROCEDURE publish_post (id post.id_post%TYPE);
   PROCEDURE update_post (
     id post.id_post%TYPE,
     title post.title%TYPE, 
     content post.content%TYPE, 
     user_id post.user_id%TYPE
   );
   PROCEDURE delete_post (id post.id_post%TYPE);
   PROCEDURE sp_post_log(log post_log.log%TYPE, post_id post_log.post_id%TYPE);
END p_post;


CREATE OR REPLACE PACKAGE BODY p_post AS
    procedure insert_post(title post.title%TYPE, content post.content%TYPE, user_id post.user_id%TYPE)
    is 
    begin
      insert into post(id_post, title, content, created_at, updated_at, user_id) 
        values(seq_post.nextval, title, content, SYSDATE, SYSDATE, user_id);
    end insert_post;
    
    procedure update_post(id post.id_post%TYPE, title post.title%TYPE, content post.content%TYPE, user_id post.user_id%TYPE)
    is 
    begin
      update post set title = title, content = content, updated_at = SYSDATE, user_id = user_id where id_post = id;
      if sql%ROWCOUNT > 0 then
        log_post('Post updated', id);
      else
        -- TODO use exceptions
        dbms_output.put_line('nada foi atualizado');
      end if;
    end update_post;

    procedure delete_post(id post.id_post%TYPE)
    is 
    begin
      update post set deleted_at = SYSDATE where id_post = id;
      if sql%ROWCOUNT > 0 then
        log_post('Post deleted', id);
      else
        -- TODO use exceptions
        dbms_output.put_line('nada foi deletado');
      end if;
    end delete_post;
    
    procedure sp_post_log(log post_log.log%TYPE, post_id post_log.post_id%TYPE)
    is
    begin
      insert into post_log(id_post_log, log, post_id, created_at) values (seq_post_log.nextval, log, post_id, SYSDATE);
      commit;
    end sp_post_log;
    
    procedure publish_post(id post.id_post%TYPE)
    is
    begin
      update post set published_at = SYSDATE where id_post = id;
    end publish_post;
END p_post;
