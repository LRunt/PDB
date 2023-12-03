import psycopg2
from config import config


def connection():
    try:
        params = config()
        print("Connecting to the postgreSQL database ...")
        connect = psycopg2.connect(**params)

        cursor = connect.cursor()
        print("PostgreSQL database version: ")
        cursor.execute("SELECT version()")
        db_version = cursor.fetchall()
        print(db_version)
    except(Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if connect is not None:
            connect.close()


if __name__ == "__main__":
    connection = psycopg2.connect(host="localhost", port="5432", database="test", user="postgres", password="kolokolo")
    cursor = connection.cursor()
    print("PostgreSQL database version: ")
    cursor.execute("SELECT version()")
    db_version = cursor.fetchall()
    print(db_version)
    connection.close()
