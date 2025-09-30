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
