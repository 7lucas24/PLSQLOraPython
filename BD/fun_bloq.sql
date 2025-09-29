--Procedimiento para agregar tags a un articulo
CREATE OR REPLACE PROCEDURE tag_art(
    id_art IN NUMBER,
    id_tag IN Number
) IS 
    l_cursor SYS_REFCURSOR;
    v_tag_id tags.tag_name%TYPE;
    no_encontrado EXCEPTION;
    pragma exception_init(no_encontrado, -01403);
BEGIN
    OPEN l_cursor FOR
        SELECT tag_name
        FROM tags
        WHERE tag_id = id_tag;
    LOOP
        FETCH l_cursor INTO v_tag_id;
        EXIT WHEN l_cursor%NOTFOUND;
        INSERT INTO art_tag(art_id, tag_id) VALUES(id_art, v_tag_id);
    END LOOP;
    CLOSE l_cursor;
    COMMIT;
EXCEPTION
    WHEN no_encontrado THEN
        raise_application_error(-20204, 'Error: El tag no existe.');
    WHEN OTHERS THEN
        RAISE; 
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

--Funcion Agregar tags
CREATE OR REPLACE PROCEDURE add_tag(
    nom IN VARCHAR2
) 
IS
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
    IF instr(sqlerrm, 'TAG_NAME') > 0 THEN raise_application_error(-20201, 'Error: Debe agregar un tag.');
    END IF;
END;
exec add_tag('Mexico');
--Procedimiento para agregar catgorias a un articulo
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
CREATE OR REPLACE PROCEDURE cat_art(
    id_art IN NUMBER
) IS 
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
        SELECT c.cat_name
        FROM categories c
        JOIN art_cat ac ON c.cat_id = ac.cat_id
        WHERE ac.art_id = id_art;
    DBMS_SQL.RETURN_RESULT(l_cursor);
END;
--Agregar categorias
CREATE OR REPLACE PROCEDURE add_cat(
    nom IN VARCHAR2
) 
IS
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
exec add_cat('Noticias');
exec add_cat('Entretenimiento');
--Ver los comentarios de un articulo
CREATE OR REPLACE PROCEDURE ver_com(
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
--Ver los comentarios de un usuario en que articulos
CREATE OR REPLACE PROCEDURE ver_com(
    p_art_id IN NUMBER
) IS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
        SELECT u.user_name, ,p.article_id, c.comentary
        FROM comments c
        JOIN users u ON c.u_id = u.user_id
        JOIN articles p ON c.url = p.article_id
        WHERE c.url = p_art_id;
    DBMS_SQL.RETURN_RESULT(l_cursor);
END;
--Agregar comentario a un articulo
CREATE OR REPLACE PROCEDURE com_art(
    p_com_id IN NUMBER,
    p_user_id IN NUMBER,
    p_comment IN CLOB,
    p_art_id IN NUMBER
) IS
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    fk_exception EXCEPTION;
    opsql VARCHAR2(100);
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
    pragma exception_init(fk_exception, -02291);
BEGIN
    INSERT INTO COMMENTS (com_id, comentary, u_id, url) VALUES (p_com_id, p_comment, p_user_id, p_art_id);
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
--Hacer nuevos articulos
CREATE OR REPLACE PROCEDURE new_art(
    p_art_id IN NUMBER,
    p_title IN VARCHAR2,
    p_creation_date IN DATE,
    p_content IN CLOB,
    p_user_id IN NUMBER
) IS
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    fk_exception EXCEPTION;
    opsql VARCHAR2(100);
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
    pragma exception_init(fk_exception, -02291);
BEGIN
    INSERT INTO ARTICLES (article_id, tname, creation_date, user_id,text) VALUES (p_art_id, p_title, p_creation_date, p_user_id, p_content);
    COMMIT;
EXCEPTION
    WHEN un_exception THEN
    IF instr(sqlerrm, 'ART_PK') > 0 THEN
            raise_application_error(-20210, 'Error: El ID ya existe.');
        ELSE
            RAISE;
        END IF;
    WHEN nn_exception THEN
        IF instr(sqlerrm, 'ART_ID') > 0 THEN 
            raise_application_error(-20211, 'Error: Debe agregar un ID.');
        ELSIF instr(sqlerrm, 'TITLE') > 0 THEN 
            raise_application_error(-20212, 'Error: Debe agregar un titulo.');
        ELSIF instr(sqlerrm, 'CONTENT') > 0 THEN 
            raise_application_error(-20213, 'Error: Debe agregar contenido.');
        ELSIF instr(sqlerrm, 'USER_ID') > 0 THEN 
            raise_application_error(-20214, 'Error: Debe agregar un ID de usuario.');
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
--Agregar usuarios
CRETE OR REPLACE PROCEDURE add_user(
    p_user_id IN NUMBER,
    p_user_name IN VARCHAR2,
    p_user_email IN VARCHAR2,
)IS
    un_exception EXCEPTION;
    nn_exception EXCEPTION;
    opsql VARCHAR2(100);
    pragma exception_init(un_exception, -00001);
    pragma exception_init(nn_exception, -01400);
BEGIN
    INSERT INTO USERS (user_id, user_name, user_email) VALUES (p_user_id, p_user_name, p_user_email);
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