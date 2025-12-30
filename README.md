# data-project_consultas_de_sql
Proyecto: DataProject: Lógica. Consultas de SQL
README:


Comenzamos importando el script SQL (BBDD_Proyecto.sql) en PostgreSQL y luego nos conectamos con DBeaver.
 
1) Arrancamos PostgreSQL
brew services start postgresql@15
 
2) Creamos una base de datos vacía para importar el archivo
nombre bbdd_proyecto
createdb bbdd_proyecto
 
3) Importamos el archivo .sql dentro de esa base de datos
psql -d bbdd_proyecto -f "/Users/miriamlopez/Desktop/MASTER Analysis de Datos/Bases de Datos/Entregable SQL/BBDD_Proyecto.sql"

#Compruebo que hay tablas, etc
psql -d bbdd_proyecto -c "\dt"
 
5) Conectar desde DBeaver
En DBeaver > New Connection > PostgreSQL y uso:
•	Host: localhost; Port: 5432; Database: bbdd_proyecto y meto mi User y password y luego Test Connection > Finish.


Ahora puedo navegar, ver y familiarizarme con el esquema de mi base de datos. Hay 15 tablas.


1.Creo el esquema de la base de datos: Esquema BBDD - bbdd_proyecto

Dsde DBeaver bbdd_proyecto > Schemas > public - Clic derecho sobre public o directamente sobre Tables - View Diagram y ya puedo exportarlo- En la ventana del diagrama icono Export/Save  y lo guardo como png.


Ejercicios:
New SQL Script
TODO va en un solo archivo SQL: dataproject.sql
Aquí irán todas las consultas, una detrás de otra.

<img width="527" height="702" alt="image" src="https://github.com/user-attachments/assets/a7652aa6-4dbc-45a7-b9b1-5dfb33d4c3ec" />
