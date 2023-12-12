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
    try:
        connection = psycopg2.connect(host="localhost", port="5432", database="test", user="postgres", password="kolokolo")
        cursor = connection.cursor()
        print("PostgreSQL database version: ")
        cursor.execute("SELECT version()")
        db_version = cursor.fetchall()
        # Create a table
        create_table_query = '''CREATE TABLE employee(
                                               ID SERIAL PRIMARY KEY,
                                               NAME TEXT NOT NULL,
                                               AGE INT NOT NULL,
                                         l()
        print(db_version)      ADDRESS CHAR(50));
                                       '''
        cursor.execute(create_table_query)
        connection.commit()
        print("Table created successfully")
        cursor.close()
        connection.close()
    except (Exception, psycopg2.Error) as error:
        print("Error while creating a table", error)
