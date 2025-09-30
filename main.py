import oracledb

def conectar_bd():
    try:
        conn = oracledb.connect(
            user="proone",
            password="abc",
            dsn="localhost:1521/XEPDB1"
        )

        return conn
    except Exception as e:
        print("ERROOOOOOOOR", e)
        return None

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
        cursor.callproc("add_tag", nombre)
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
        
    except oracledb.Error as error:
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
        cursor.callproc("add_cat", nombre)
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
  

def main():
    conn = conectar_bd()
    if not conn:
        print("No se pudo conectar a la base de datos. Saliendo...")
        return
    op = 1
    while(op!=0):
        print("="*40,"\nMENU""\n1.Agregar usuario\n2.Agregar Articulo\n3.Agregar Tag\n4.Ver todos los tags\n5.Ver tags de un articulo\n6.Agregar categoria\n7.Ver todas las categorias\n8.Ver catgeorias de un articulo\n9. Ver comentarios de un articulo\n10.Agregar comentario\n0.Exit\n","="*40)

        try:
            op = int(input("\nSeleccione una opción: "))
            if op == 1:
                add_usr(conn)
            elif op == 2:
                add_art(conn)
            elif op == 3:
                add_tag(conn)
            elif op == 4:
                all_tags(conn)
            elif op == 5:
                tag_art(conn)
            elif op == 6:
                add_cat(conn)
            elif op == 7:
                all_cat(conn)
            elif op == 8:
                cat_art(conn)
            elif op == 9:
                comm(conn)
            elif op == 10:
                add_comm(conn)
            elif op == 0:
                print("Saliendo del sistema...")
            else:
                print("Ingrese una opcion valida")
        except ValueError:
            print("Error: Debe ingresar un número válido")
        except KeyboardInterrupt:
            print("\nSaliendo del sistema...")
            break

    if conectar_bd:
        conn.close()
        print("Conexion terminada. Bye")

if __name__ == "__main__":
    main()

'''
try:
    # Conexión en modo thin
    conn = oracledb.connect(
        user="proone",
        password="abc",
        dsn="localhost:1521/XEPDB1"
    )

    cur = conn.cursor()

    # Llamamos a la función que devuelve SYS_REFCURSOR
    # En python-oracledb, el segundo parámetro de callfunc es el tipo de retorno
    # Para un cursor, se puede usar oracledb.DB_TYPE_CURSOR
    result_cursor = cur.callfunc('all_tags', oracledb.DB_TYPE_CURSOR)

    # Iteramos sobre el cursor devuelto
    for row in result_cursor:
        print(row)

except Exception as e:
    print("ERROR:", e)

finally:
    try:
        if result_cursor is not None:
            result_cursor.close()
    except Exception:
        pass
    try:
        cur.close()
    except Exception:
        pass
    try:
        conn.close()
    except Exception:
        pass



    '''