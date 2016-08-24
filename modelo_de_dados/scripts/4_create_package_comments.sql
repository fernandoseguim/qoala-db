alter session set current_schema = qoala;
CREATE OR REPLACE PACKAGE pkg_comment AS
   PROCEDURE insert_comment (
     content in comments.content%TYPE, 
     user_id in comments.user_id%TYPE,
     post_id in comments.post_id%TYPE,
     out_id_comment out comments.ID_comment%TYPE
   );
   PROCEDURE update_comment(
     id in comments.id_comment%TYPE,
     content in comments.content%TYPE, 
     user_id in comments.user_id%TYPE,
     post_id in comments.post_id%TYPE,
     rowcount out NUMBER
   );
   PROCEDURE approve_comment (id in comments.id_comment%TYPE, rowcount out NUMBER);
   PROCEDURE delete_comment (id in comments.id_comment%TYPE, rowcount out NUMBER);
   PROCEDURE sp_comment_log(log in comment_logs.log%TYPE, comment_id in comment_logs.comments_id%TYPE);
END pkg_comment;
/
CREATE OR REPLACE PACKAGE BODY pkg_comment AS 
    procedure insert_comment(
        content in comments.content%TYPE, 
        user_id in comments.user_id%TYPE, 
        post_id in comments.post_id%TYPE, 
        out_id_comment out comments.ID_comment%TYPE)
    is 
    begin
      begin
        insert into comments(id_comment, content, created_at, user_id, post_id) 
          values(seq_comment.nextval, content, SYSDATE, user_id, post_id)
          returning ID_COMMENT into out_id_comment;
          sp_comment_log('insert_comment: OK! ' || content, out_id_comment);
      exception when others then
        sp_comment_log('insert_comment error: ' || sqlerrm, out_id_comment);
      end;
    end insert_comment;
    
    procedure update_comment(
        id in comments.id_comment%TYPE, 
        content in comments.content%TYPE, 
        user_id in comments.user_id%TYPE, 
        post_id in comments.post_id%TYPE,
        rowcount out NUMBER)
    is 
    begin
      begin
        update comments 
          set content = content, post_id = post_id, updated_at = SYSDATE, user_id = user_id 
          where id_comment = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_comment_log('Comment updated', id);
        end if;
      exception when others then
        sp_comment_log('update_comment error: ' || sqlerrm, id);  
      end;
    end update_comment;

    procedure delete_comment(id in comments.id_comment%TYPE, rowcount out NUMBER)
    is 
    begin
      begin
        update comments set deleted_at = SYSDATE where id_comment = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_comment_log('Comment deleted', id);
        end if;
      exception when others then
        sp_comment_log('delete_comment error: ' || sqlerrm, id);  
      end;
    end delete_comment;
     
    procedure approve_comment(id in comments.id_comment%TYPE, rowcount out NUMBER)
    is
    begin
       begin
        update comments set approved_at = SYSDATE where id_comment = id;
        rowcount := sql%ROWCOUNT;
        if rowcount > 0 then
          sp_comment_log('Comment Approved', id);
        end if;
      exception when others then
        sp_comment_log('approve_comment error: ' || sqlerrm, id);  
      end;
    end approve_comment;
    
    --private
    procedure sp_comment_log(
        log in comment_logs.log%TYPE, 
        comment_id in comment_logs.comments_id%TYPE)
    is
      pragma autonomous_transaction;
    begin
      insert into comment_logs(log, comments_id, created_at) 
        values (log, comment_id, SYSDATE);
      commit; --deve haver commit em uma transa��o autonoma
    end sp_comment_log;
    
END pkg_comment;