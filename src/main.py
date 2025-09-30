import tkinter as tk
from tkinter import simpledialog, messagebox
from db.conexion import conectar_bd
from procedures import proc
import builtins
import io
import sys

def main():
    conn = conectar_bd()
    if not conn:
        messagebox.showerror("Error", "No se pudo conectar a la base de datos.")
        return

    root = tk.Tk()
    root.title("Gestión de Artículos")

    # === Función para envolver procedimientos con input/print ===
    def run_proc_with_inputs(func, inputs):
        try:
            iter_inputs = iter(inputs)
            builtins.input = lambda prompt='': next(iter_inputs)
            buffer = io.StringIO()
            sys.stdout = buffer
            func(conn)
            sys.stdout = sys.__stdout__
            messagebox.showinfo("Resultado", buffer.getvalue())
        except StopIteration:
            messagebox.showerror("Error", "Faltan datos para la función.")
        except Exception as e:
            messagebox.showerror("Error", str(e))

    # === Funciones de GUI para cada acción ===
    def add_usr_gui():
        nombre = simpledialog.askstring("Agregar Usuario", "Nombre del usuario:", parent=root)
        if not nombre: return
        email = simpledialog.askstring("Agregar Usuario", "Email del usuario:", parent=root)
        if not email: return
        run_proc_with_inputs(proc.add_usr, [nombre, email])

    def add_art_gui():
        title = simpledialog.askstring("Agregar Artículo", "Nombre del artículo:", parent=root)
        if not title: return
        content = simpledialog.askstring("Agregar Artículo", "Contenido del artículo:", parent=root)
        if not content: return
        author = simpledialog.askstring("Agregar Artículo", "Nombre del autor:", parent=root)
        if not author: return
        run_proc_with_inputs(proc.add_art, [title, content, author])

    def add_tag_gui():
        tag = simpledialog.askstring("Agregar Tag", "Nombre del tag:", parent=root)
        if not tag: return
        run_proc_with_inputs(proc.add_tag, [tag])

    def all_tags_gui():
        run_proc_with_inputs(proc.all_tags, [])

    def tag_art_gui():
        art_id = simpledialog.askstring("Tags de Artículo", "ID del artículo:", parent=root)
        if not art_id: return
        run_proc_with_inputs(proc.tag_art, [art_id])

    def add_cat_gui():
        cat = simpledialog.askstring("Agregar Categoría", "Nombre de la categoría:", parent=root)
        if not cat: return
        run_proc_with_inputs(proc.add_cat, [cat])

    def all_cat_gui():
        run_proc_with_inputs(proc.all_cat, [])

    def cat_art_gui():
        art_id = simpledialog.askstring("Categorías de Artículo", "ID del artículo:", parent=root)
        if not art_id: return
        run_proc_with_inputs(proc.cat_art, [art_id])

    def comm_gui():
        art_id = simpledialog.askstring("Comentarios", "ID del artículo:", parent=root)
        if not art_id: return
        run_proc_with_inputs(proc.comm, [art_id])

    def add_comm_gui():
        art_id = simpledialog.askstring("Agregar Comentario", "URL del artículo:", parent=root)
        if not art_id: return
        content = simpledialog.askstring("Agregar Comentario", "Contenido del comentario:", parent=root)
        if not content: return
        name = simpledialog.askstring("Agregar Comentario", "Nombre del usuario:", parent=root)
        if not name: return
        run_proc_with_inputs(proc.add_comm, [art_id, content, name])

    # === Botones ===
    tk.Label(root, text="MENU", font=("Arial", 16)).pack(pady=10)
    tk.Button(root, text="Agregar usuario", width=30, command=add_usr_gui).pack(pady=2)
    tk.Button(root, text="Agregar Articulo", width=30, command=add_art_gui).pack(pady=2)
    tk.Button(root, text="Agregar Tag", width=30, command=add_tag_gui).pack(pady=2)
    tk.Button(root, text="Ver todos los tags", width=30, command=all_tags_gui).pack(pady=2)
    tk.Button(root, text="Ver tags de un articulo", width=30, command=tag_art_gui).pack(pady=2)
    tk.Button(root, text="Agregar categoria", width=30, command=add_cat_gui).pack(pady=2)
    tk.Button(root, text="Ver todas las categorias", width=30, command=all_cat_gui).pack(pady=2)
    tk.Button(root, text="Ver categorias de un articulo", width=30, command=cat_art_gui).pack(pady=2)
    tk.Button(root, text="Ver comentarios de un articulo", width=30, command=comm_gui).pack(pady=2)
    tk.Button(root, text="Agregar comentario", width=30, command=add_comm_gui).pack(pady=2)
    tk.Button(root, text="Salir", width=30, command=root.destroy).pack(pady=10)

    root.mainloop()
    if conn:
        conn.close()

if __name__ == "__main__":
    main()
