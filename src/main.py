from db.conexion import conectar_bd
from procedures import proc

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
                proc.add_usr(conn)
            elif op == 2:
                proc.add_art(conn)
            elif op == 3:
                proc.add_tag(conn)
            elif op == 4:
                proc.all_tags(conn)
            elif op == 5:
                proc.tag_art(conn)
            elif op == 6:
                proc.add_cat(conn)
            elif op == 7:
                proc.all_cat(conn)
            elif op == 8:
                proc.cat_art(conn)
            elif op == 9:
                proc.comm(conn)
            elif op == 10:
                proc.add_comm(conn)
            elif op == 0:
                proc.print("Saliendo del sistema...")
            else:
                print("Ingrese una opcion valida")
        except ValueError:
            print("Error: Debe ingresar un número válido")
        except KeyboardInterrupt:
            print("\nSaliendo del sistema...")
            break

    if conn:
        conn.close()
        print("Conexion terminada. Bye")

if __name__ == "__main__":
    main()
