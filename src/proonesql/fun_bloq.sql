-- =============================================
-- PROCEDIMIENTOS PARA USUARIOS
-- =============================================

CREATE OR REPLACE PROCEDURE add_user(
    user_name IN VARCHAR2,
    user_email IN VARCHAR2
) IS
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
BEGIN
    INSERT INTO USERS (u_name, u_mail) VALUES (user_name, user_email);
    COMMIT;
EXCEPTION
    WHEN un_exception THEN 
        IF instr(sqlerrm, 'USER_PK') > 0 THEN
            raise_application_error(-20205, 'Error: El ID ya existe.');
        ELSIF instr(sqlerrm, 'USER_EMAIL_UU') > 0 THEN
            raise_application_error(-20206, 'Error: El email ya existe.');
        ELSE
            RAISE;
        END IF;
    WHEN nn_exception THEN
        IF instr(sqlerrm, 'USER_ID') > 0 THEN 
            raise_application_error(-20207, 'Error: Debe agregar un ID.');
        ELSIF instr(sqlerrm, 'USER_NAME') > 0 THEN 
            raise_application_error(-20208, 'Error: Debe agregar un nombre.');
        ELSIF instr(sqlerrm, 'USER_EMAIL') > 0 THEN 
            raise_application_error(-20209, 'Error: Debe agregar un email.');
        ELSE
            RAISE;
        END IF;
    WHEN OTHERS THEN
        RAISE;
END;

-- =============================================
-- PROCEDIMIENTOS PARA ARTÍCULOS
-- =============================================

CREATE OR REPLACE PROCEDURE new_art(
    p_title IN VARCHAR2,
    p_content IN CLOB,
    user_name IN VARCHAR2
) IS
    usr_id NUMBER(5);
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    fk_exception EXCEPTION;
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
    pragma exception_init(fk_exception, -02291);
BEGIN
    SELECT u_id INTO usr_id
    FROM USERS
    WHERE u_name = user_name;
    INSERT INTO ARTICLES (tname, creation_date, user_id, text) VALUES (p_title, SYSDATE, usr_id, p_content);
    COMMIT;
EXCEPTION
    WHEN un_exception THEN
        IF instr(sqlerrm, 'ART_PK') > 0 THEN
            raise_application_error(-20210, 'Error: El ID ya existe.');
        ELSE
            RAISE;
        END IF;
    WHEN nn_exception THEN
        IF instr(sqlerrm, 'TITLE') > 0 THEN 
            raise_application_error(-20212, 'Error: Debe agregar un titulo.');
        ELSIF instr(sqlerrm, 'CONTENT') > 0 THEN 
            raise_application_error(-20213, 'Error: Debe agregar contenido.');
        ELSIF instr(sqlerrm, 'U_NAME') > 0 THEN 
            raise_application_error(-20214, 'Error: Debe agregar un usuario.');
        ELSE
            RAISE;
        END IF;
    WHEN fk_exception THEN
        IF instr(sqlerrm, 'ART_USER_FK') > 0 THEN
            raise_application_error(-20215, 'Error: El ID de usuario no existe.');
        ELSE
            RAISE;
        END IF;
    WHEN OTHERS THEN
        RAISE;
END;

-- =============================================
-- PROCEDIMIENTOS PARA TAGS
-- =============================================

CREATE OR REPLACE PROCEDURE add_tag(
    nom IN VARCHAR2
) IS
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
BEGIN
    INSERT INTO tags(tag_name) VALUES(nom);
    COMMIT;
EXCEPTION
    WHEN un_exception THEN
        IF instr(sqlerrm, 'TAG_N_UU') > 0 THEN
            raise_application_error(-20200, 'Error: El nombre ya existe.');
        END IF;
    WHEN nn_exception THEN
        IF instr(sqlerrm, 'TAG_NAME') > 0 THEN 
            raise_application_error(-20201, 'Error: Debe agregar un tag.');
        END IF;
END;

-- Funcion para ver tags de un articulo
CREATE OR REPLACE FUNCTION tags_art(idart INTEGER)
RETURN SYS_REFCURSOR
IS
    l_cursor SYS_REFCURSOR; 
BEGIN
    OPEN l_cursor FOR
        SELECT t.tag_name
        FROM tags t
        INNER JOIN art_tag tg ON t.tag_id = tg.id_tag 
        INNER JOIN articles a ON tg.id_tag = a.article_id 
        WHERE a.article_id = idart;
    RETURN l_cursor;
END;

--Funcion para ver tags de un articulo
CREATE OR REPLACE FUNCTION all_tags
RETURN SYS_REFCURSOR
IS
   l_cursor SYS_REFCURSOR;
BEGIN
   OPEN l_cursor FOR
      SELECT tag_name
      FROM tags;
   RETURN l_cursor;
END;

-- =============================================
-- PROCEDIMIENTOS PARA CATEGORÍAS
-- =============================================

--Funcion para ver todas las categorias
CREATE OR REPLACE FUNCTION all_cat
RETURN SYS_REFCURSOR
IS
   l_cursor SYS_REFCURSOR;
BEGIN
   OPEN l_cursor FOR
      SELECT cat_name
      FROM categories;
   RETURN l_cursor;
END;

--Procedimiento para ver categorias de un articulo
CREATE OR REPLACE FUNCTION categories_art(idart INTEGER)
RETURN SYS_REFCURSOR
IS
    l_cursor SYS_REFCURSOR; 
BEGIN
    OPEN l_cursor FOR
        SELECT c.cat_name
        FROM categories c
        INNER JOIN art_cat ac ON c.cat_id = ac.id_art
        INNER JOIN articles a ON ac.id_art = a.article_id 
        WHERE a.article_id = idart;
    RETURN l_cursor;
END;

--Agregar categorias
CREATE OR REPLACE PROCEDURE add_cat(
    nom IN VARCHAR2
) IS
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    opsql VARCHAR2(100);
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
BEGIN
    INSERT INTO CATEGORIES (cat_name) VALUES (nom);
    COMMIT;
EXCEPTION
    WHEN un_exception THEN
        IF instr(sqlerrm, 'CAT_N_UU') > 0 THEN
            raise_application_error(-20202, 'Error: El nombre ya existe.');
        ELSE
            RAISE;
        END IF;
    WHEN nn_exception THEN
        IF instr(sqlerrm, 'CAT_NAME') > 0 THEN 
            raise_application_error(-20203, 'Error: Debe agregar una categoria.');
        ELSE
            RAISE;
        END IF;
    WHEN OTHERS THEN
        RAISE;
END;

-- =============================================
-- PROCEDIMIENTOS PARA COMENTARIOS
-- =============================================

--Ver los comentarios de un articulo 
CREATE OR REPLACE FUNCTION see_com(artid INTEGER)
RETURN SYS_REFCURSOR
IS
   l_cursor SYS_REFCURSOR;
BEGIN
   OPEN l_cursor FOR
      SELECT c.commentary, u.u_name 
      FROM comments c
      JOIN users u ON c.u_id = u.u_id
      WHERE c.url = artid;
   RETURN l_cursor;
END;
/


/*CREATE OR REPLACE PROCEDURE ver_com(
    p_art_id IN NUMBER
) IS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
        SELECT u.user_name, c.comentary
        FROM comments c
        JOIN articles p ON c.url = p.article_id
        WHERE c.url = p_art_id;
    DBMS_SQL.RETURN_RESULT(l_cursor);
END;
*/
--Agregar comentario a un articulo 
CREATE OR REPLACE PROCEDURE com_art(
    usr_name IN VARCHAR2,
    p_comment IN VARCHAR2,
    p_art_id IN NUMBER
) IS
    usr_id INTEGER;
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    fk_exception EXCEPTION;
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
    pragma exception_init(fk_exception, -02291);
BEGIN
    SELECT u_id INTO usr_id
    FROM USERS
    WHERE u_name = usr_name;
    INSERT INTO COMMENTS (commentary, u_id, url) VALUES (p_comment, usr_id, p_art_id);
    COMMIT;
EXCEPTION
    WHEN un_exception THEN
        IF instr(sqlerrm, 'COM_PK') > 0 THEN
            raise_application_error(-20220, 'Error: El ID ya existe.');
        ELSE
            RAISE;
        END IF;
    WHEN nn_exception THEN
        IF instr(sqlerrm, 'COM_ID') > 0 THEN 
            raise_application_error(-20221, 'Error: Debe agregar un ID.');
        ELSIF instr(sqlerrm, 'COMENTARY') > 0 THEN 
            raise_application_error(-20222, 'Error: Debe agregar un comentario.');
        ELSIF instr(sqlerrm, 'U_ID') > 0 THEN 
            raise_application_error(-20223, 'Error: Debe agregar un ID de usuario.');
        ELSIF instr(sqlerrm, 'URL') > 0 THEN 
            raise_application_error(-20224, 'Error: Debe agregar un ID de articulo.');
        ELSE
            RAISE;
        END IF;
    WHEN fk_exception THEN
        IF instr(sqlerrm, 'COM_USER_FK') > 0 THEN
            raise_application_error(-20225, 'Error: El ID de usuario no existe.');
        ELSIF instr(sqlerrm, 'COM_ART_FK') > 0 THEN
            raise_application_error(-20226, 'Error: El ID de articulo no existe.');
        ELSE
            RAISE;
        END IF;
    WHEN OTHERS THEN
        RAISE;
END;