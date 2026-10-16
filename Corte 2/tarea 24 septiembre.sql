CREATE DATABASE tienda_mascota1;


/* crear tabla cliente */
create table cliente1 (
    cedula int primary key,
    nombres varchar(50) not null,
    apellidos varchar(50) not null,
    direccion varchar(100),
    telefono varchar(20)
);

/* crear tabla mascota1 */
create table mascota1 (
    codigoMascota int primary key,
    nombreMascota varchar(50) not null,
    tipoMascota varchar(30),
    generoMascota varchar(20),
    razaMascota varchar(50),
    cedulaClienteFK int,
    constraint fk_mascota1_cliente1
    foreign key (cedulaClienteFK)
    references cliente1(cedula)
);

/* crear tabla producto1 */
create table producto1 (
    codigoBarras varchar(30) primary key,
    nombreProducto varchar(100) not null,
    marca varchar(50),
    precio decimal(10,2)
);

/* crear tabla vacuna1 */
create table vacuna1 (
    codigoVacuna int primary key,
    nombreVacuna varchar(50) not null,
    dosis varchar(30),
    enfermedad varchar(100)
);

/* crear tabla compra1 */
create table compra1 (
    idCompra int primary key,
    cedulaClienteFK int,
    codigoBarrasFK varchar(30),
    constraint fk_compra1_cliente1
    foreign key (cedulaClienteFK)
    references cliente1(cedula),
    constraint fk_compra1_producto1
    foreign key (codigoBarrasFK)
    references producto1(codigoBarras)
);

/* crear tabla aplicacionVacuna1 */
create table aplicacionVacuna1 (
    idAplicacion int primary key,
    codigoMascotaFK int,
    codigoVacunaFK int,
    constraint fk_aplicacion1_mascota1
    foreign key (codigoMascotaFK)
    references mascota1(codigoMascota),
    constraint fk_aplicacion1_vacuna1
    foreign key (codigoVacunaFK)
    references vacuna1(codigoVacuna)
);

/* crear index para precio de producto1 */
create index index_precio_producto1
on producto1(precio);


/* insertar 10 registros en cliente1 */
insert into cliente1 (cedula, nombres, apellidos, direccion, telefono) values
(10011, 'Ana', 'Lopez', 'Calle 10', '3001111111'),
(10021, 'Laura', 'Gomez', 'Calle 20', '3002222222'),
(10031, 'Carlos', 'Perez', 'Carrera 5', '3003333333'),
(10041, 'Sofia', 'Torres', 'Calle 30', '3004444444'),
(10051, 'Daniel', 'Ruiz', 'Carrera 10', '3005555555'),
(10061, 'Maria', 'Diaz', 'Calle 40', '3006666666'),
(10071, 'Andres', 'Rojas', 'Carrera 15', '3007777777'),
(10081, 'Paula', 'Castro', 'Calle 50', '3008888888'),
(10091, 'Juan', 'Martinez', 'Carrera 20', '3009999999'),
(10101, 'Camila', 'Vargas', 'Calle 60', '3011111111');


/* insertar 10 registros en producto1 */
insert into producto1 (codigoBarras, nombreProducto, marca, precio) values
('P001', 'Concentrado perro', 'Canino', 45000),
('P002', 'Concentrado gato', 'Felino', 40000),
('P003', 'Collar', 'PetLife', 15000),
('P004', 'Correa', 'PetLife', 20000),
('P005', 'Pelota', 'Mascotoys', 10000),
('P006', 'Plato comida', 'PetHome', 18000),
('P007', 'Shampoo', 'PetClean', 25000),
('P008', 'Cepillo', 'PetClean', 12000),
('P009', 'Cama mascota', 'PetHome', 60000),
('P010', 'Juguete hueso', 'Mascotoys', 14000);


/* insertar 10 registros en vacuna1 */
insert into vacuna1 (codigoVacuna, nombreVacuna, dosis, enfermedad) values
(1, 'Vacuna A', '1 dosis', 'Enfermedad A'),
(2, 'Vacuna B', '1 dosis', 'Enfermedad B'),
(3, 'Vacuna C', '2 dosis', 'Enfermedad C'),
(4, 'Vacuna D', '1 dosis', 'Enfermedad D'),
(5, 'Vacuna E', '2 dosis', 'Enfermedad E'),
(6, 'Vacuna F', '1 dosis', 'Enfermedad F'),
(7, 'Vacuna G', '2 dosis', 'Enfermedad G'),
(8, 'Vacuna H', '1 dosis', 'Enfermedad H'),
(9, 'Vacuna I', '2 dosis', 'Enfermedad I'),
(10, 'Vacuna J', '1 dosis', 'Enfermedad J');


/* insertar 10 registros en mascota1 */
insert into mascota1
(codigoMascota, nombreMascota, tipoMascota, generoMascota, razaMascota, cedulaClienteFK) values
(1, 'Luna', 'Perro', 'Hembra', 'Labrador', 1001),
(2, 'Max', 'Perro', 'Macho', 'Beagle', 1002),
(3, 'Milo', 'Gato', 'Macho', 'Siames', 1003),
(4, 'Nala', 'Gato', 'Hembra', 'Persa', 1004),
(5, 'Toby', 'Perro', 'Macho', 'Pug', 1005),
(6, 'Kira', 'Perro', 'Hembra', 'Husky', 1006),
(7, 'Simba', 'Gato', 'Macho', 'Criollo', 1007),
(8, 'Rocky', 'Perro', 'Macho', 'Bulldog', 1008),
(9, 'Mia', 'Gato', 'Hembra', 'Angora', 1009),
(10, 'Coco', 'Perro', 'Macho', 'Criollo', 1010);


/* insertar 10 registros en compra1 */
insert into compra1 (idCompra, cedulaClienteFK, codigoBarrasFK) values
(1, 1001, 'P001'),
(2, 1002, 'P002'),
(3, 1003, 'P003'),
(4, 1004, 'P004'),
(5, 1005, 'P005'),
(6, 1006, 'P006'),
(7, 1007, 'P007'),
(8, 1008, 'P008'),
(9, 1009, 'P009'),
(10, 1010, 'P010');


/* insertar 10 registros en aplicacionVacuna1 */
insert into aplicacionVacuna1
(idAplicacion, codigoMascotaFK, codigoVacunaFK) values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);


/* consultar cliente1 */
select * from cliente1;

/* consultar mascota1 */
select * from mascota1;

/* consultar producto1 */
select * from producto1;

/* consultar vacuna1 */
select * from vacuna1;

/* consultar compra1 */
select * from compra1;

/* consultar aplicacionVacuna1 */
select * from aplicacionVacuna1;

/* sentencia select */
select codigoMascota from mascota1;

/* consultar con alias usara el as 'nombredealias' */
select codigoMascota as codigo, nombreMascota as nombre, tipoMascota as tipo, razaMascota as raza
from mascota1;

/* consultas con ordenamiento para nombrar de a a z y de z a a asc desc */
select * from mascota1 order by nombreMascota asc;
select * from mascota1 order by nombreMascota desc;

/* consulta una sola categoria ejemplo las mascotas que sean perros */
select * from mascota1 where tipoMascota = 'Perro';

/* consultar mascotas con dos condiciones */
select * from mascota1 where tipoMascota = 'Perro' and codigoMascota <= 3;
select * from mascota1 where tipoMascota = 'Gato' and codigoMascota <= 3;

/* select between in is null is not null */
select codigoMascota as codigo, nombreMascota, tipoMascota, generoMascota, razaMascota from mascota1 where codigoMascota between 1 and 5;
select codigoMascota as codigo, nombreMascota, tipoMascota, generoMascota, razaMascota from mascota1 where tipoMascota in ('Perro', 'Gato');
select codigoMascota as codigo, nombreMascota, tipoMascota, generoMascota, razaMascota from mascota1 where razaMascota is null;
select codigoMascota as codigo, nombreMascota, tipoMascota, generoMascota, razaMascota from mascota1 where razaMascota is not null;

select codigoMascota as codigo, nombreMascota, tipoMascota, generoMascota, razaMascota
from mascota1
where codigoMascota between 1 and 10
and tipoMascota in ('Perro','Gato')
and razaMascota is not null;


/* expresiones condicionales case when colesce */

/* expresiones condicionales case when y coalesce */
select nombreMascota, tipoMascota,
coalesce(razaMascota, 'Sin raza registrada') as raza,
case
    when codigoMascota <= 3 then 'Grupo 1'
    when codigoMascota between 4 and 7 then 'Grupo 2'
    else 'Grupo 3'
end as grupoMascota
from mascota1;

/* consultas de coincidencia patron like like % cero o mas caracteres _ exactamente 1 caracter xxxx% inicia %xxxx final %xxxx% contiene */
select * from mascota1 where nombreMascota like 'Lu%';
select * from mascota1 where nombreMascota like '%na';
select * from mascota1 where nombreMascota like '%un%';


/* expresiones regulares */
select * from mascota1 where nombreMascota ~ '^(Luna|Max)';


/* limit offset */
select * from mascota1 order by nombreMascota asc limit 3 offset 0;

/* funciones calculadas */

select codigoMascota, nombreMascota, (codigoMascota * 2) as codigoCalculado from mascota1;
select max(codigoMascota) from mascota1;
select min(codigoMascota) from mascota1;
select count(nombreMascota) as cantidadMascota from mascota1;
select avg(codigoMascota) as codigoPromedio from mascota1;
select sum(codigoMascota) as sumaCodigo from mascota1;


/* funciones matematicas 3 tipo entero y tres tipo string */

select abs(codigoMascota) as valorAbsoluto from mascota1;
select round(codigoMascota) as valorRedondeado from mascota1;
select sqrt(codigoMascota) as raizCuadrada from mascota1;
select trim(nombreMascota) as quitarEspacios from mascota1;
select lower(nombreMascota) as minuscula from mascota1;
select length(nombreMascota) as longitudTexto from mascota1;

/* insertar 10 registros en mascota1 */

insert into mascota1
(codigoMascota, nombreMascota, tipoMascota, generoMascota, razaMascota, cedulaClienteFK) values
(1, 'Luna', 'Perro', 'Hembra', 'Labrador', 10011),
(2, 'Max', 'Perro', 'Macho', 'Beagle', 10021),
(3, 'Milo', 'Gato', 'Macho', 'Siames', 10031),
(4, 'Nala', 'Gato', 'Hembra', 'Persa', 10041),
(5, 'Toby', 'Perro', 'Macho', 'Pug', 10051),
(6, 'Kira', 'Perro', 'Hembra', 'Husky', 10061),
(7, 'Simba', 'Gato', 'Macho', 'Criollo', 10071),
(8, 'Rocky', 'Perro', 'Macho', 'Bulldog', 10081),
(9, 'Mia', 'Gato', 'Hembra', 'Angora', 10091),
(10, 'Coco', 'Perro', 'Macho', 'Criollo', 10101);


/* insertar 10 registros en compra1 */

insert into compra1 (idCompra, cedulaClienteFK, codigoBarrasFK) values
(1, 10011, 'P001'),
(2, 10021, 'P002'),
(3, 10031, 'P003'),
(4, 10041, 'P004'),
(5, 10051, 'P005'),
(6, 10061, 'P006'),
(7, 10071, 'P007'),
(8, 10081, 'P008'),
(9, 10091, 'P009'),
(10, 10101, 'P010');

/* =========================================================
   CONSULTAS MULTITABLA, SUBCONSULTAS Y FUNCIONES
   TIENDA MASCOTA
   ========================================================= */


/* INNER JOIN
   mostrar cada cliente con su mascota */

select c.nombres, c.apellidos, m.nombreMascota
from cliente1 c
inner join mascota1 m on m.cedulaClienteFK = c.cedula
order by c.cedula;


/* LEFT JOIN
   mostrar todos los clientes y sus mascotas
   aunque un cliente no tenga mascota */

select c.nombres, c.apellidos, m.nombreMascota
from cliente1 c
left join mascota1 m on m.cedulaClienteFK = c.cedula
order by c.cedula;


/* LEFT JOIN
   mostrar clientes que no tienen mascota */

select c.nombres, c.apellidos
from cliente1 c
left join mascota1 m on m.cedulaClienteFK = c.cedula
where m.codigoMascota is null;


/* INNER JOIN
   mostrar que producto compro cada cliente */

select c.nombres as cliente,
co.idCompra as compra,
p.nombreProducto as producto,
p.precio
from cliente1 c
join compra1 co on co.cedulaClienteFK = c.cedula
join producto1 p on p.codigoBarras = co.codigoBarrasFK
order by co.idCompra;


/* LEFT JOIN
   mostrar todos los clientes y sus compras */

select c.nombres,
co.idCompra,
p.nombreProducto
from cliente1 c
left join compra1 co on co.cedulaClienteFK = c.cedula
left join producto1 p on p.codigoBarras = co.codigoBarrasFK
order by c.cedula;


/* clientes que nunca han comprado */

select c.nombres, c.apellidos
from cliente1 c
left join compra1 co on co.cedulaClienteFK = c.cedula
where co.idCompra is null;


/* contar cuantas compras tiene cada cliente */

select c.nombres,
count(co.idCompra) as cantidadCompras
from cliente1 c
left join compra1 co on co.cedulaClienteFK = c.cedula
group by c.cedula, c.nombres
order by cantidadCompras desc;


/* cliente que tiene mas compras */

select c.nombres,
count(co.idCompra) as cantidadCompras
from cliente1 c
left join compra1 co on co.cedulaClienteFK = c.cedula
group by c.cedula, c.nombres
order by cantidadCompras desc
limit 1;


/* MULTIPLES JOIN
   mostrar cliente, mascota y vacuna */

select c.nombres as cliente,
m.nombreMascota as mascota,
v.nombreVacuna as vacuna
from cliente1 c
join mascota1 m on m.cedulaClienteFK = c.cedula
join aplicacionVacuna1 a on a.codigoMascotaFK = m.codigoMascota
join vacuna1 v on v.codigoVacuna = a.codigoVacunaFK
order by c.cedula;


/* mostrar cada mascota y la vacuna aplicada */

select m.nombreMascota as mascota,
v.nombreVacuna as vacuna,
v.dosis,
v.enfermedad
from mascota1 m
join aplicacionVacuna1 a on a.codigoMascotaFK = m.codigoMascota
join vacuna1 v on v.codigoVacuna = a.codigoVacunaFK
order by m.codigoMascota;


/* RIGHT JOIN
   mostrar todas las vacunas aunque alguna no tenga aplicacion */

select m.nombreMascota,
v.nombreVacuna
from aplicacionVacuna1 a
right join vacuna1 v on v.codigoVacuna = a.codigoVacunaFK
left join mascota1 m on m.codigoMascota = a.codigoMascotaFK
order by v.codigoVacuna;


/* promedio del precio de los productos */

select avg(precio) as precioPromedio
from producto1;


/* SUBCONSULTA
   productos que cuestan mas que el promedio */

select nombreProducto, precio
from producto1
where precio > (
select avg(precio)
from producto1
);


/* producto mas costoso */

select max(precio) as precioMayor
from producto1;


/* producto mas economico */

select min(precio) as precioMenor
from producto1;


/* suma de los precios de los productos comprados */

select sum(p.precio) as totalVendido
from compra1 co
join producto1 p on p.codigoBarras = co.codigoBarrasFK;


/* SUBCONSULTA CON IN
   clientes que han realizado una compra */

select nombres, apellidos
from cliente1
where cedula in (
select cedulaClienteFK
from compra1
);


/* SUBCONSULTA
   clientes que no han realizado una compra */

select nombres, apellidos
from cliente1
where cedula not in (
select cedulaClienteFK
from compra1
);


/* comprobar las tablas */

describe cliente1;
describe mascota1;
describe producto1;
describe vacuna1;
describe compra1;
describe aplicacionVacuna1;




