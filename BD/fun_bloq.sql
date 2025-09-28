--Procedimiento para agregar tags a un articulo
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
--Ver los comentarios de un usuario en que articulos
--Agregar comentario a un articulo
--Hacer nuevos articulos
--Agregar usuarios