import oracledb

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
