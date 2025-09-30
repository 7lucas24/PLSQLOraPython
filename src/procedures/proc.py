from db.conexion import conectar_bd
import oracledb
def add_usr(conn):
    try:
        user_name = input("Nombre del usuario: ")
        user_email = input("Email del usuario: ")
        
        cursor = conn.cursor()
        cursor.callproc("add_user", [user_name, user_email])
        conn.commit()
        print("Usuario agregado exitosamente!")
        
    except Exception as e:
        print(f"Error al agregar usuario: {e}")

def add_art(conn):
    try:
        art_title = input("Dame el nombre del articulo: ")
        content = input("De que trata el articulo.\n")
        name = input("Dame el nombre del autor: ")

        cursor = conn.cursor()
        cursor.callproc("new_art", [art_title, content, name])
        conn.commit()
        print("Articulo agregado correctamente!")

    except Exception as e:
        print(f"Error al agregar el articulo: {e}")

def add_tag(conn):
    try:
        nombre = input("Dame el tag a agregar: ")
        cursor = conn.cursor()
        cursor.callproc("add_tag", [nombre])
        conn.commit()
        print("Tag agregado correctamente.")

    except Exception as e:
        print(f"Error al agregar el tag: {e}")

def all_tags(conn):
    try:
        cursor = conn.cursor()
        result_cursor = cursor.callfunc("all_tags", oracledb.CURSOR)
        
        print("\n=== TODOS LOS TAGS ===")
        for tag_name, in result_cursor:
            print(f"- {tag_name}")
        print("======================")
        
    except Exception as error:
        print(f"Error al obtener tags: {error}")

def tag_art(conn):
    try:
        art_id = int(input("ID del artículo: "))
        
        cursor = conn.cursor()
        result_cursor = cursor.callfunc("tags_art", oracledb.CURSOR, [art_id])
        
        print(f"\n=== TAGS DEL ARTÍCULO {art_id} ===")
        tags_encontrados = False
        for tag_name, in result_cursor:
            print(f"- {tag_name}")
            tags_encontrados = True
        
        if not tags_encontrados:
            print("No se encontraron tags para este artículo")
        print("=================================")
        
    except Exception as error:
        print(f"Error al obtener tags del artículo: {error}")
    except ValueError:
        print("Error: El ID debe ser un número entero")

def add_cat(conn):
    try:
        nombre = input("Dame ls categoria ha agregar: ")
        cursor = conn.cursor()
        cursor.callproc("add_cat", [nombre])
        conn.commit()
        print("Categoria agregada correctamente.")

    except Exception as e:
        print(f"Error al agregar la categoria: {e}")

def all_cat(conn):
    try:
        cursor = conn.cursor()
        result_cursor = cursor.callfunc("all_cat", oracledb.CURSOR)
        
        print("\n=== TODOS LAS CATEGORIAS ===")
        for cat_name, in result_cursor:
            print(f"- {cat_name}")
        print("======================")    
    except oracledb.Error as error:
        print(f"Error al obtener tags: {error}")

def cat_art(conn):
    try:
        art_id = int(input("ID del artículo: "))
        
        cursor = conn.cursor()
        result_cursor = cursor.callfunc("categories_art", oracledb.CURSOR, [art_id])
        
        print(f"\n=== CATEGORIAS DEL ARTÍCULO {art_id} ===")
        tags_encontrados = False
        for tag_name in result_cursor:
            print(f"- {tag_name}")
            tags_encontrados = True
        
        if not tags_encontrados:
            print("No se encontraron tags para este artículo")
        print("=================================")
        
    except Exception as error:
        print(f"Error al obtener tags del artículo: {error}")
    except ValueError:
        print("Error: El ID debe ser un número entero")

def comm(conn):
    try:
        art_id = int(input("ID del artículo: "))
        
        cursor = conn.cursor()
        result_cursor = cursor.callfunc("see_com", oracledb.CURSOR, [art_id])
        
        print(f"\n=== COMENTARIOS DEL ARTÍCULO {art_id} ===")
        comm_f = False
        for comm, usr in result_cursor:
            print(f"{usr}: {comm}")
            comm_f = True
        
        if not comm_f:
            print("No se encontraron tags para este artículo")
        print("=================================")
        
    except Exception as error:
        print(f"Error al obtener tags del artículo: {error}")
    except ValueError:
        print("Error: El ID debe ser un número entero")

def add_comm(conn):
    try:
        id_art = input("Dame el url del articulo: ")
        content = input("Texto.\n")
        name = input("Dame el nombre del usuario: ")

        cursor = conn.cursor()
        cursor.callproc("com_art", [name, content, id_art])
        conn.commit()
        print("Articulo agregado correctamente!")
        
    except Exception as e:
        print(f"Error al agregar el comentario: {e}")
  
