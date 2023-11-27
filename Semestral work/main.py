import psycopg2

if __name__ == "__main__":
    connection = psycopg2.connect(host="localhost", port="5432", database="hehe", user="postgres", password="kolokolo")