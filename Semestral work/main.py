import psycopg2
from config import config
import geopandas as gpd
from sqlalchemy import create_engine
import matplotlib
matplotlib.use("tkagg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


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


def get_geometry_from_database():
    try:
        connection = psycopg2.connect(host="localhost", port="5432", database="test", user="postgres", password="kolokolo")
        cursor = connection.cursor()
        print("Triangular data: ")
        query = "SELECT geom FROM public.benesov_exported ORDER BY gid ASC"
        cursor.execute(query)
        triangles = cursor.fetchall()
        print(triangles)
        cursor.close()
        connection.close()
    except (Exception, psycopg2.Error) as error:
        print("Error while creating a table", error)


def show_plot(gdf):
    fig, ax = plt.subplots()
    gdf.plot(ax=ax, facecolor='none', edgecolor='red')

    # Customize the plot as needed
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_title('Triangle Visualization')

    plt.show()

if __name__ == "__main__":
    engine = create_engine('postgresql://postgres:kolokolo@localhost:5432/test')
    query = "SELECT * FROM benesov_exported;"
    gdf = gpd.read_postgis(query, engine, geom_col='geom')

    # Extract the x, y coordinates from the geometry
    gdf['x'] = gdf['geom'].apply(lambda geometry: geometry.centroid.x)
    gdf['y'] = gdf['geom'].apply(lambda geometry: geometry.centroid.y)

    # Plot the 2D terrain
    fig, ax = plt.subplots()
    gdf.plot(ax=ax, facecolor='none', edgecolor='red', marker='o', markersize=5)

    # Customize the plot as needed
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_title('2D Terrain Model Visualization')

    # Set the x and y-axis limits to zoom in
    #ax.set_xlim(xmin=-727500, xmax=-725000)
    #ax.set_ylim(ymin=1e6 * - 1.06800, ymax=1e6 * - 1.06600)

    plt.show()