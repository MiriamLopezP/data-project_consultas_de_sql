-- Thepower DataProject SQL
-- Alumna: Miriam López
-- Base de datos: bbdd_proyecto
-- Motor: PostgreSQL


-- ============================================
-- EJERCICIO 1. Crea el esquema de la BBDD. - Explicado en el archivo Readme
-- ============================================

-- ============================================
-- EJERCICIO 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'.
--He comprobado si estaba escrito en mayusculas/minusculas del contenido de las tablas, porque si no las comparaciones podrian no darme match por diferencias de mayusculas/minusuculas. tambien puedo usar alguna funcion para poner todo en minuscula mas adelante la utilizaré.
-- ============================================
select f.title
from film f
where f.rating = 'R';

-- ============================================
-- EJERCICIO 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
-- ============================================
select first_name, last_name
from actor
where actor_id between 30 and 40;
select count(original_language_id) from film;

-- ============================================
-- EJERCICIO 4. Obtén las películas cuyo idioma coincide con el idioma original.
-- ============================================
--Intente compararlos para verificar que siempre coinciden, pero me dio error porque original_language_id parece ser null en algunas filas (interpreto que en estos casos es el mismo por eso no se popula este campo).. por lo que creo codigo para comprobar si original languaes es null o si son iguales si no es null.
select title
from film
where (original_language_id is null and language_id is not null)
    or original_language_id = language_id;
--Por curiosidad compruebo si alguna tiene un idioma diferente pero parece que no.
select title
from film
where original_language_id  is not null;
--Me devuelve 0, parece que no hay ninguna pelicula cuyo idioma sea diferente al original. voy a hacer otra comprobacion
select count(original_language_id) from film;
--Sigue devolviendo 0, no hay pelicula con un valro diferente para este campo.. podriamos decir que no hay ninguna pelicula con diferente language al nativo.

-- ============================================
-- EJERCICIO 5. Ordena las películas por duración de forma ascendente.
-- ============================================
select title
from film
order by length asc;

-- ============================================
-- EJERCICIO 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
-- ============================================
--Los string de last name o first name estan en mayusculas, LIKE es case sensitive, por lo que meto ALLEN en mayuscula. Tambien podria usar lower() para ponerlo todo en minuscula
select first_name, last_name
from actor
where last_name like '%ALLEN%';
-- ============================================
-- EJERCICIO 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
-- ============================================
select rating, count(*) as suma_peliculas
from film
group by rating;
-- ============================================
-- EJERCICIO 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
-- ============================================
select title
from film
where rating = 'PG-13' or length > 180;

-- ============================================
-- EJERCICIO 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
-- ============================================
--Calculamos la variabilidad del coste de reemplazo de las películas usando la función VARIANCE aplicada a la columna replacement_cost de la tabla film
select variance(replacement_cost) as variabilidad_reemplazo
from film;

-- ============================================
-- EJERCICIO 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
-- ============================================
select  MAX(length) as duracion_max, MIN(length) as duracion_min
from film;

-- ============================================
-- EJERCICIO 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
-- ============================================
--Para sacar el anepenultimo alquier necesito usar order by, limit y offset y linkear las tablas payment y rental
select b.amount
from rental a
JOIN payment b on a.rental_id = b.rental_id
oder by a.rental_date 
 desc limit 1 
 offset 2;
-- esto me ha dado un 0.. Voy a hacer unas comprobaciones parte por partee, compruebo el rental id asociado al antepenultimo ordenado por fecha.
select rental_id 
from rental a
order by a.rental_date 
 desc limit 1 
 offset 2;
--esto me devuelve un id el cual voy  usar para sacar la fila de payments asociado a ese rental id
select *
from payment
where payment.rental_id = 11676;
--Basicamente no hay un amount asociado a este registro, el valor es enefecto 0.
-- ============================================
-- EJERCICIO 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
-- ============================================
select title
from film
where rating not in ('NC-17','G');
-- ============================================
-- EJERCICIO 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- ============================================
select rating,
    AVG(length) as duracion_media
from film
group by rating;

-- ============================================
-- EJERCICIO 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
-- ============================================
select title 
from film 
where length >180;

-- ============================================
-- EJERCICIO 15. ¿Cuánto dinero ha generado en total la empresa?
-- ============================================
select sum(amount)
from payment;

-- ============================================
-- EJERCICIO 16. Muestra los 10 clientes con mayor valor de id.
-- ============================================
select customer_id, first_name , last_name 
from customer
order 
 by customer_id
 desc limit 10;

-- ============================================
-- EJERCICIO 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
-- ============================================
select a.first_name , a.last_name 
from actor a
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id = f.film_id  where f.title='EGG IGBY';

-- ============================================
-- EJERCICIO 18. Selecciona todos los nombres de las películas únicos.
-- ============================================
select distinct title
from film;

-- ============================================
-- EJERCICIO 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
-- ============================================
select distinct title
from film f join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id =c.category_id 
where f.length > 180 and c.name ='Comedy';

-- ============================================
-- EJERCICIO 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- ============================================
-- Importante que el filtro es sobre el promevio por lo que usaremos Having y no Where
select c.name as categoria, AVG(f.length) as duracion_media
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name
having avg(f.length) > 110;

-- ============================================
-- EJERCICIO 21. ¿Cuál es la media de duración del alquiler de las películas?
-- ============================================
select avg(rental_duration ) as media_duracion_alquiler
from film;

-- ============================================
-- EJERCICIO 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
-- ============================================
select concat(a.first_name, ' ', a.last_name )
from actor a;

-- ============================================
-- EJERCICIO 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
-- si lo hago tomando la fecha tal cual me salen las horas, tengo que usar date para quedarme solo con la fecha.
-- ============================================
select date(r.rental_date) as fecha, count(*) AS sum_alq_dia
from rental r
group by fecha
order by sum_dia desc;


-- ============================================
-- EJERCICIO 24. Encuentra las películas con una duración superior al promedio.
-- ============================================
select title
from film f
where f.length > (select avg (length) from film);

-- ============================================
-- EJERCICIO 25. Averigua el número de alquileres registrados por mes.
-- ============================================
select extract (month from (r.rental_date)) as month, count(*) as sum_alq_mes
from rental r
group by extract(month from r.rental_date);

-- ============================================
-- EJERCICIO 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
-- ============================================
select stddev (p.amount) as desviacion_estandar_pagado, variance (p.amount) as varianza_pagado, avg (p.amount) as promedio
from payment p;

-- ============================================
-- EJERCICIO 27. ¿Qué películas se alquilan por encima del precio medio?
-- ============================================
select f.title, p.amount as precio 
from film f
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
join payment p on r.rental_id = p.rental_id
where p.amount > (select avg(amount) from payment);

-- ============================================
-- EJERCICIO 28. Muestra el id de los actores que hayan participado en más de 40 películas.
-- ============================================
select a.first_name, a.last_name, count(*) as total_peliculas
from actor a
join film_actor fa on a.actor_id =fa.actor_id
group by a.first_name, a.last_name
having count(*) > 40;

-- ============================================
-- EJERCICIO 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
-- ============================================
--Si esta en el inventario, mantenerla aunque sea 0 las disponibles.
select f.title, count (i.inventory_id) as cantidad
from film f 
left join inventory i on f.film_id =i.film_id
group by f.film_id ;


-- ============================================
-- EJERCICIO 30. Obtener los actores y el número de películas en las que ha actuado.
-- ============================================
select a.first_name , a.last_name, count(*) as numero_de_peliculas
from actor a
join film_actor fa on fa.actor_id = a.actor_id 
group by a.actor_id;

-- ============================================
-- EJERCICIO 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
-- ============================================
select f.title as titulo_pelicula, a.first_name, a.last_name 
from film f
left join film_actor fa on fa.film_id = f.film_id 
left join actor a on a.actor_id = fa.actor_id
order by f.title;

-- ============================================
-- EJERCICIO 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
-- ============================================
select f.title, a.first_name, a.last_name 
from film f
right join film_actor fa on fa.film_id = f.film_id 
right join actor a on a.actor_id = fa.actor_id
order by  a.first_name, a.last_name;



-- ============================================
-- EJERCICIO 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
-- ============================================
select f.title, r.rental_id 
from film f
left join inventory i on i.film_id = f.film_id 
left join rental r on r.inventory_id =i.inventory_id;


-- ============================================
-- EJERCICIO 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
-- ============================================
select c.first_name, c.last_name, sum(p.amount) as dinero_total_gastado
from customer c
join payment p on c.customer_id =p.customer_id 
group by c.customer_id, c.first_name, c.last_name
order by sum(p.amount) desc limit 5;

-- ============================================
-- EJERCICIO 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
-- ============================================
select a.first_name, a.last_name 
from actor a
where a.first_name = 'JOHNNY';

-- ============================================
-- EJERCICIO 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
-- ============================================
select a.first_name  as Nombre, a.last_name  as Apellido
from actor a;



-- ============================================
-- EJERCICIO 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
-- ============================================
select max(actor_id) as max_actor_id , min(actor_id) as min_actor_id
from actor;

-- ============================================
-- EJERCICIO 38. Cuenta cuántos actores hay en la tabla “actor”.
-- ============================================
--actor_id es una primary key por lo que no puede estar repetida y deberia identificar un único actor.
select count(actor_id)
from actor; 

-- ============================================
-- EJERCICIO 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
-- ============================================
select a.first_name , a.last_name 
from actor a
order by a.last_name asc;

-- ============================================
-- EJERCICIO 40. Selecciona las primeras 5 películas de la tabla “film”.
-- ============================================
select f.title
from film f
order by f.film_id asc
limit 5;

-- ============================================
-- EJERCICIO 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
-- ============================================
select a.first_name as nombre , count(*) as cuenta_por_nombre
from actor a
group by a.first_name
order by cuenta_por_nombre desc
limit 1;



-- ============================================
-- EJERCICIO 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
-- ============================================
select r.rental_id , c.first_name , c.last_name 
from rental r
join customer c on r.customer_id =c.customer_id ;

-- ============================================
-- EJERCICIO 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
-- ============================================
--lo he ordenado para verificar de una estacada que me ah creado mas de una fila para cada cliente con mas de un alquiler.
select c.first_name , c.last_name, count(r.rental_id) as suma_alquileres_cliente
from customer c
left join rental r on c.customer_id =r.customer_id
group by c.first_name, c.last_name
order by suma_alquileres_cliente desc;




-- ============================================
-- EJERCICIO 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
-- ============================================
select *
from film f 
cross join category c;

-- ============================================
-- EJERCICIO 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
-- ============================================
select distinct a.first_name, a.last_name , a.actor_id
from actor a
join film_actor fa on fa.actor_id = a.actor_id 
join film f on f.film_id =fa.film_id 
join film_category ca on ca.film_id = f.film_id 
join category c on c.category_id  = ca.category_id 
where c."name"  = 'Action'
order by a.actor_id ;

-- ============================================
-- EJERCICIO 46. Encuentra todos los actores que no han participado en películas.
-- ============================================
select a.first_name, a.last_name , a.actor_id
from actor a
left join film_actor fa on fa.actor_id = a.actor_id
where fa.actor_id is null;


-- ============================================
-- EJERCICIO 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
-- ============================================
select a.first_name as nombre, a.last_name  as apellido , count(fa.film_id) as peliculas_por_actor
from actor a
left join film_actor fa on fa.actor_id = a.actor_id 
group by a.first_name, a.last_name
order by a.first_name ;


-- ============================================
-- EJERCICIO 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
-- ============================================
-- meintras hacia el ejercicio he tenido algun problema porque no me sobreescribia automaticamente la vista que me habia creado inicialmente: usart create or replace para solucionar este problema.
create or replace view actor_num_peliculas as
select a.first_name as nombre, a.last_name  as apellido , count(fa.film_id) as peliculas_por_actor
from actor a
left join film_actor fa on fa.actor_id = a.actor_id 
group by a.first_name, a.last_name
order by a.first_name;


-- ============================================
-- EJERCICIO 49. Calcula el número total de alquileres realizados por cada cliente.
-- ============================================
select c.customer_id, c.first_name , c.last_name , count(rental_id) as total_alquileres_por_cliente
from rental r
right join customer c on c.customer_id = r.customer_id 
group by c.customer_id 
order by c.customer_id asc;

-- ============================================
-- EJERCICIO 50. Calcula la duración total de las películas en la categoría 'Action'.
-- ============================================
select sum(f.length) as duracion_total_peliculas
from film f
join film_category ca on ca.film_id = f.film_id 
join category c on c.category_id  = ca.category_id 
where c."name"  = 'Action';

-- ============================================
-- EJERCICIO 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
-- ============================================
with cliente_rentas_temporal as ( 
select c.first_name , c.last_name, r.customer_id, count(*) as total_alquileres
from rental r 
join customer c on c.customer_id = r.customer_id 
group by r.customer_id, c.first_name , c.last_name )
select * from cliente_rentas_temporal;


-- ============================================
-- EJERCICIO 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
-- ============================================
with peliculas_alquiladas as (
select f.film_id, f.title, count(*) as num_veces_alquilada
from rental r
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id 
group by f.film_id , f.title
having count(*) >= 10 )
select * 
from peliculas_alquiladas;



-- ============================================
-- EJERCICIO 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
-- ============================================
--Nota: Comprobado al inicio de la práctica  el estilo de lo nombres almacenados en la tabla, y está todo en mayuscula. Aún así, tambien voy a usar lower() para forzar a que sea minscula y en otras bbdd sin dato estandarizados, no hubiese confusiones por que las letras estuviesen en upper/lower case.

select f.title 
from customer c
join rental r on r.customer_id  = c.customer_id 
join inventory i on i.inventory_id  = r.inventory_id 
join film f on f.film_id = i.film_id 
where lower(c.first_name) = 'tammy' and lower(c.last_name) = 'sanders'
order by f.title asc;

-- ============================================
-- EJERCICIO 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
-- ============================================
select distinct a.first_name, a.last_name , a.actor_id
from actor a
join film_actor fa on fa.actor_id = a.actor_id 
join film f on f.film_id =fa.film_id 
join film_category ca on ca.film_id = f.film_id 
join category c on c.category_id  = ca.category_id 
where lower(c."name")  = 'sci-fi'
order by a.last_name  ;

-- ============================================
-- EJERCICIO 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
-- ============================================
select distinct a.first_name, a.last_name
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
where r.rental_date > (
        select min(r2.rental_date)
        from film f2
        join inventory i2 on f2.film_id = i2.film_id
        join rental r2 on i2.inventory_id = r2.inventory_id
        where lower(f2.title) = 'spartacus cheaper')
order by a.last_name asc;

-- ============================================
-- EJERCICIO 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
-- ============================================
select a.first_name, a.last_name
from actor a
where not exists (
select 1
from film_actor fa
join film_category fc on fc.film_id = fa.film_id 
join category c on c.category_id  = fc.category_id 
where fa.actor_id = a.actor_id 
and lower(c."name") = 'music' )
order by a.last_name  ;

-- ============================================
-- EJERCICIO 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
-- ============================================
select f.title
from rental r
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id 
where r.return_date is not null
  and (r.return_date - r.rental_date) > interval '8 days';

-- ============================================
-- EJERCICIO 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
-- ============================================
select f.title 
from film f
join film_category ca on ca.film_id = f.film_id 
join category c on c.category_id  = ca.category_id 
where lower(c."name")  = 'animation';

-- ============================================
-- EJERCICIO 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
-- ============================================
select f.title
from film f
where f.length =
    (select ff.length
    from film ff
    where lower(ff.title) = 'dancing fever') and lower(f.title) <> 'dancing fever'
order by f.title;

-- ============================================
-- EJERCICIO 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
-- ============================================
select c.first_name, c.last_name, c.customer_id 
from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id, c.first_name, c.last_name
having count(distinct i.film_id) >= 7
order by c.last_name;


-- ============================================
-- EJERCICIO 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- ============================================
select c.name, count(*) as recuento_alquileres
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by c.category_id, c.name
order by recuento_alquileres desc, c.name;


-- ============================================
-- EJERCICIO 62. Encuentra el número de películas por categoría estrenadas en 2006.
-- ============================================
select c.category_id, c.name, COUNT(*) as peliculas_estrenadas_2006
FROM category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
where f.release_year = 2006
group by  c.category_id, c.name
order by c.category_id ;


-- ============================================
-- EJERCICIO 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
-- ============================================
select s.staff_id , s2.store_id 
from staff s 
cross join store s2;

-- ============================================
-- EJERCICIO 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- ============================================
select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as total_peliculas_alquiladas
from customer c join rental r on c.customer_id = r.customer_id
group by  c.customer_id, c.first_name, c.last_name
order by c.customer_id ;



