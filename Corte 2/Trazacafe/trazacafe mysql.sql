/*RETO N2 */

/* 1.crear la base de datos */ 
Create database trazacafe; 
Use trazacafe; 


/*2. Crear tablas */ 
Create table fincas (
IdentificacionFinca int auto_increment primary key,
nombreFinca varchar (80) not null, 
caficultor  varchar (80) not null, 
municipio varchar (80) not null, 
departamento  varchar (80) not null, 
altitud int not null 
); 

Create table clientes( 
identificacionCliente int auto_increment primary key,
nombreCliente varchar(120 ) not null, 
Correo varchar (120) not null 
); 

Create table lotes ( 
IdentificacionLote int auto_increment primary key ,
codigoLote varchar (20) not null, 
variedad varchar (20) not null, 
proceso enum('lavado','honey','natural') not null,
fechaCosecha date not null,
Kilos decimal (7,2) not null, 
identificacionFincaFK int not null, 

Constraint fklotefinca 
foreign key (identificacionFincaFK) References fincas (identificacionFinca) 
); 

create table cataciones(
identificacionCatacion int auto_increment primary key,
identificacionLoteFK int not null,
nombreCatador varchar(120) not null,
puntajeSCA decimal(5,2) not null,
fechaCatacion date not null,
foreign key (identificacionLoteFK) references lotes(identificacionLote)
);

Create table tostiones ( 
IdentificacionTostion int auto_increment primary key, 
identificacionLoteFk int not null, 
fechaTostion date not null, 
kilosEntrada decimal (7,2) not null, 
kilosSalida decimal (7,2) not null, 
Perfil varchar (30) not null, 
Constraint fktostionlote
Foreign key (identificacionLoteFK) references lotes (identificacionLote) 
);

Create table pedidos (
IdentificacionPedido int auto_increment primary key, 
identificacionClienteFK int not null, 
fechaPedido date not null, 
estado varchar (30) not null,

constraint fkpedidocliente 
foreign key (identificacionClienteFk)references clientes (identificacionCliente)
);

 

drop table if exists lienasPedido;

create table lineasPedido (
identificacionLineaP int auto_increment primary key, 
identificacionPedidoFk int not null,
identificacionTostionFK int not null,
kilos decimal (7,2)  not null,
precio decimal (10,2) not null,

constraint fklineapedido 
foreign key (identificacionPedidoFK) references pedidos (identificacionPedido),
foreign key (identificacionTostionFk) references tostiones (identificacionTostion)
);

/* refelexion reto 2 
La tabla lotes no se puede crear antes que la de fincas ya que la tabla de lotes depende de finca debido a que lleva identificacionFincaFK */




/RETO N3/

/* 14 :  altitud entre 800 y 2500*/
Alter table fincas 
Add constraint chkAltitud 
Check (altitud between 800 and 2500);

/*14:  puntaje SCA entre 0 y 100*/
Alter table cataciones 
Add check (puntajeSCA between 0 and 100);





/*código de lote único */

Alter table lotes 
add constraint unCodigoLote
unique (codigoLote);





/* los kilos de salida no pueden ser mayor a klos de entrada */
Alter table tostiones 
Add constraint chkkilosTostion 
Check (kilosSalida <= kilosEntrada);

/* establecer estado del pedido */
Alter table pedidos 
modify estado varchar (30) not null default 'pendiente';



/*reflexión: las restricciones check nos permiten comprobar por ejemplo que la altitud este entre 800y 2500, pero si necesitaramos consultar inormacion de otras tabalas o comparar multiples registros ya no podríamos solo poner check */

/RETO N4/
alter table clientes 
add país varchar (50) not null default  'Colombia' ;

/*agregar huella de carbono a tostiones puede quedar vacia y no puede ser negativa */

alter table tostiones 
add huellaCarbono decimal (10,2) null;

alter table tostiones 
add check (huellaCarbono >=0);

/* aplicar la precisión de los kilos  de decimal */
alter table lotes 
modify kilos decimal (10,2) not null;

/* Tabla certifica*/
create table certificaciones (
identificacionFincaCertifiacacion int auto_increment primary key, 
nombreCertificacion varchar (120)not null 
);

create table fincaCertificacion (
identificacionFincaCertificacion int auto_increment primary key,
identificacionFincaFK int,
identificacionCertificacionFK int,

foreign key (identificacionFincaFK)
references fincas(identificacionFinca),

foreign key (identificacionCertificacionFK)
references certificaciones(identificacionFincaCertifiacacion)
);



/*reflexion: puede ser pekligroso eliminar una tabla por que despues de eliminada no se puede volver arecuperar, y eliminar una columnba y volverla a crear podemos perder la informacion por eso es mejor usar modify o alter table*/

/*RETO N 5*/
insert into fincas (nombreFinca, caficultor, municipio, departamento, altitud)
values ('La Compañia','Juan Morgue','Pitalito','Huila',1750),
('Caicu','Juan Bautista','Salento','Quindio',1900),
('Brisa del Mar','Mafe Alfonso','Buesaco','Nariño',2100),
('Caballos del Valle','Lina Bautista','Jardin','Antioquia',1850);

select * from fincas;



insert into lotes(codigoLote,variedad,proceso,fechaCosecha,kilos,identificacionFincaFK)
values
('HUI-2026-01','Castillo','lavado','2026-01-15',500.00,1),
('HUI-2026-02','Caturra','honey','2026-02-10',420.00,1),
('QUI-2026-01','Caturra','lavado','2026-02-20',350.00,2),
('QUI-2026-02','Geisha','natural','2026-03-05',180.00,2),
('NAR-2026-01','Castillo','lavado','2026-03-15',480.00,3),
('NAR-2026-02','Bourbon','honey','2026-04-02',300.00,3),
('ANT-2026-01','Caturra','natural','2026-04-18',390.00,4),
('ANT-2026-02','Geisha','lavado','2026-05-01',160.00,4);

select * from lotes;

/*insertar 10 cataciones*/
select * from lotes;

insert into cataciones(identificacionLoteFK,nombreCatador,puntajeSCA,fechaCatacion)
values
(1,'Camila Osorio',86.50,'2026-01-25'),
(1,'Juan Bautista',87.00,'2026-01-26'),
(2,'Camila Osorio',84.50,'2026-02-18'),
(2,'Mafe Alfonso',85.00,'2026-02-19'),
(3,'Juan Morgue',83.50,'2026-03-01'),
(4,'Camila Osorio',91.50,'2026-03-15'),
(4,'Lina Bautista',92.00,'2026-03-16'),
(5,'Mafe Alfonso',86.00,'2026-03-25'),
(6,'Juan Bautista',88.50,'2026-04-12'),
(7,'Lina Bautista',84.00,'2026-04-28'),
(8,'Camila Osorio',93.00,'2026-05-10');


/*insertar 5 tostiones*/
insert into tostiones(identificacionLoteFK,fechaTostion,kilosEntrada,kilosSalida,perfil,huellaCarbono)
values
(1,'2026-02-01',100.00,85.00,'medio',12.50),
(2,'2026-02-25',80.00,68.00,'claro',10.20),
(4,'2026-03-25',60.00,51.00,'claro',8.40),
(6,'2026-04-20',90.00,76.00,'medio',11.30),
(8,'2026-05-20',50.00,42.00,'claro',7.80);


/* insertar 3 clientesuno es de Alemania */

insert into clientes(nombreCliente,correo,país )
values
('La Compañia','contacto@lacompania.com','Colombia'),
('Caicu','contacto@caicu.com','Colombia'),
('Brisa del Mar','contacto@brisadelmar.de','Alemania');

select * from clientes;


/* insertar 4 pedidos */

insert into pedidos(identificacionClienteFK,fechaPedido)
select identificacionCliente,'2026-06-01'
from clientes
where nombreCliente = 'La Compañia';

insert into pedidos(identificacionClienteFK,fechaPedido)
select identificacionCliente,'2026-06-03'
from clientes
where nombreCliente = 'Caicu';

insert into pedidos(identificacionClienteFK,fechaPedido)
select identificacionCliente,'2026-06-05'
from clientes
where nombreCliente = 'Brisa del Mar';

insert into pedidos(identificacionClienteFK,fechaPedido)
select identificacionCliente,'2026-06-10'
from clientes
where nombreCliente = 'Brisa del Mar';

select * from pedidos;

insert into certificaciones(nombreCertificacion)
values
('Organico'),
('Fair Trade'),
('Rainforest Alliance');

describe certificaciones;

/* relacionar las fincas con las certificaciones */

insert into fincaCertificacion(identificacionFincaFK,identificacionCertificacionFK)
values
(1,1),
(1,2),
(2,3),
(3,1),
(4,2);

select * from fincaCertificacion;


/* insertar las lineas de los pedidos */

insert into lineasPedido(identificacionPedidoFK,identificacionTostionFK,kilos,precio)
values
(1,1,10.00,45000.00),
(1,2,8.00,50000.00),
(2,3,5.00,85000.00),
(2,4,12.00,55000.00),
(3,5,6.00,120000.00),
(4,3,4.00,85000.00),
(4,1,7.00,45000.00);

select * from lineasPedido;


/* crear la tabla de lotes de especialidad */

create table lotes_especialidad(
identificacionLote int primary key,
codigoLote varchar(20) not null,
variedad varchar(20) not null,
promedioSCA decimal(5,2) not null
);


/* insertar los lotes de especialidad */

insert into lotes_especialidad(identificacionLote,codigoLote,variedad,promedioSCA)
values
(1,'HUI-2026-01','Castillo',86.75),
(4,'QUI-2026-02','Geisha',91.75),
(5,'NAR-2026-01','Castillo',86.00),
(6,'NAR-2026-02','Bourbon',88.50),
(8,'ANT-2026-02','Geisha',93.00);

select * from lotes_especialidad;


/*RETO N 6*/ 
/* crera precio_referencia  con variedad como clave primaria, precio_kg y actualizado_en (fecha y hora actual) */ 

Create table precios_referencia(
Variedad varchar(50 ) primary key,
Precio_kg decimal (10, 2) not null,
actualizadoEn timestamp default current_timestamp
); 
/*1.	Carga la lista de la semana 1: Castillo 32.000, Caturra 35.500, Geisha 120.000.*/
 insert into precios_referencia( variedad, precio_kg) 
 values 
('Castillo',32000.00),
('Caturra',35500.00),
('Geisha',120000.00),
('Bourbon',41000.00);

/* 3.	Carga la semana 2 con un upsert: Caturra 36.800, Geisha 118.000, Bourbon 41.000. */
insert into precios_referencia (variedad, precio_kg)
values ('caturra', 36800.00)
on duplicate key update
precio_kg=36800.00,
actualizadoEn= current_timestamp;
/*4.	Verifica que quedaron 4 variedades y que actualizado_en cambió en las modificadas.*/
select* from precios_referencia;

/* RETO N 7*/

/*1.	Resta 1,5 puntos a todas las cataciones de ese catador (elige uno de tus datos). Ningún puntaje puede quedar por debajo de 0.*/
update cataciones
set puntajeSCA =puntajeSCA -1.5
where puntajeSCA >=1.5;

/* verificar las lineas de pedido del cliente*/
select * from lineasPedido;

Select lineasPedido.* from lineasPedido
join pedidos on lineasPedido. IdentificacionPedidoFK = pedidos.identificacionPedido 
join clientes on pedidos.identificacionClienteFK= clientes.identificacionCliente
where clientes.país = 'Alemania';

/*aplicar descunto del 10%*/
Update lineasPedido 
join pedidos on lineasPedido.identificacionPedidoFK = pedidos.identificacionPedido
join clientes on pedidos.identificacionClienteFk = clientes.identificacionCliente
set lineasPedido.precio = lineasPedido.precio * 0.90
where clientes.país = 'Alemania'



/* si se ejecuta dos veces el update descuento se aplicara nuevamente el 10% sobre el precio que ya tenia el descuento */



/RETO N8 / 

/* 34. Intentar eliminar una finca que tenga lotes vendidos */ 
delete  from fincas where identificacionFinca =1; 

/* 35. Realizar una baja lógica */ 
alter table fincas add activa boolean default true; 

Select * from fincas where identificacionFinca = 1;

Update fincas set activa = 0 where identificacionFinca = 1; 

Select * from fincas where identificacionFinca = 1; 


/*36. Borrar las cataciones de un lote de prueba usando el código del lote */ 

Select cataciones. *from cataciones 
Join lotes on cataciones.identificacionLoteFK = lotes.identificacionLote
Where lotes.codigoLote = 'HUÍ-206-02'; 

delete cataciones from cataciones 
join lotes on cataciones.identificacionLoteFK = lotes.identificacionLote 
where lotes.codigoLote= 'HUI-2026-02'; 

show tables;
/* 37. Vaciar y elminar lotes_especialidad*/ 
truncate table lotes_especialidad ; 

drop table lotes_especialidad; 

/* reflexión : delete elimina filas y permite usar where. Truncate vacía toda la tabala y drop elimina la tabla completa. Delet es DML y truncate y drop son DDL*/ 


/* RETO N9 */

/* 38. Agregar kilos disponibles y evitar valores negativos */

alter table tostiones
add kilosDisponibles decimal(10,2);

update tostiones
set kilosDisponibles = kilosSalida;

alter table tostiones
modify column kilosDisponibles decimal(10,2) not null;

alter table tostiones
add constraint chk_kilos_disponibles
check (kilosDisponibles >= 0);

select * from tostiones;


/* 39. Registrar un pedido de dos líneas y descontar el inventario */

start transaction;

insert into pedidos (identificacionClienteFK, fechaPedido)
values (1, '2026-09-20');

set @nuevoPedido = last_insert_id();

insert into lineasPedido
(identificacionPedidoFK, identificacionTostionFK, kilos, precio)
values
(@nuevoPedido, 1, 5, 45000),
(@nuevoPedido, 2, 2, 50000);

update tostiones
set kilosDisponibles = kilosDisponibles - 5
where identificacionTostion = 1;

update tostiones
set kilosDisponibles = kilosDisponibles - 2
where identificacionTostion = 2;

commit;

select * from pedidos
where identificacionPedido = @nuevoPedido;

select * from lineasPedido
where identificacionPedidoFK = @nuevoPedido;

select * from tostiones;


/* 40. Pedir más kilos de los disponibles y hacer rollback */
start transaction;

insert into pedidos (identificacionClienteFK, fechaPedido)
values (1, '2026-09-21');

set @pedidoFallido = last_insert_id();

select @pedidoFallido;

insert into lineasPedido
(identificacionPedidoFK, identificacionTostionFK, kilos, precio)
values (@pedidoFallido, 1, 1000, 45000);

update tostiones
set kilosDisponibles = kilosDisponibles - 1000
where identificacionTostion = 1;

rollback;

select * from pedidos 
where identificacionPedido = @pedidoFallido;



/* 41. Usar SAVEPOINT para deshacer solamente la segunda línea */

start transaction;

insert into pedidos (identificacionClienteFK, fechaPedido)
values (2, '2026-09-22');

set @pedidoSavepoint = last_insert_id();

insert into lineasPedido
(identificacionPedidoFK, identificacionTostionFK, kilos, precio)
values (@pedidoSavepoint, 1, 2, 45000);

update tostiones
set kilosDisponibles = kilosDisponibles - 2
where identificacionTostion = 1;

savepoint primeraLinea;

insert into lineasPedido
(identificacionPedidoFK, identificacionTostionFK, kilos, precio)
values (@pedidoSavepoint, 2, 2, 50000);

update tostiones
set kilosDisponibles = kilosDisponibles - 2
where identificacionTostion = 2;

rollback to savepoint primeraLinea;

commit;

select * from lineasPedido
where identificacionPedidoFK = @pedidoSavepoint;


/* 42. Crear una tabla dentro de una transacción y hacer rollback */

drop table if exists prueba;

start transaction;

create table prueba (
    id int primary key
);

rollback;

show tables;

/* reflexión: en my sql create table hace un commit implícito, por eso la tabla sigue existiendo después del rollback. Esto puede generar problema es una migración . */ 

/* RETO N10 */
/* Agregar campo creativo: nota de sabor */

/* Eliminar la vista si ya existe */
drop view if exists v_trazabilidad;


/* Crear la vista de trazabilidad */
create view v_trazabilidad as
select
    pedidos.identificacionPedido,
    lineasPedido.identificacionLineaP,
    clientes.nombreCliente,
    clientes.país,
    fincas.nombreFinca,
    fincas.caficultor,
    fincas.municipio,
    fincas.altitud,
    lotes.variedad,
    lotes.proceso,

    (
        select round(avg(c.puntajeSCA), 2)
        from cataciones c
        where c.identificacionLoteFK = lotes.identificacionLote
    ) as puntajePromedio,

    tostiones.fechaTostion,
    tostiones.perfil,

    concat(
        lotes.variedad,
        ' ',
        lotes.proceso,
        ' de finca ',
        fincas.nombreFinca,
        ', ',
        fincas.municipio,
        ' (',
        fincas.altitud,
        ' m). Puntaje ',
        (
            select round(avg(c2.puntajeSCA), 2)
            from cataciones c2
            where c2.identificacionLoteFK = lotes.identificacionLote
        ),
        '. Tostado ',
        tostiones.perfil,
        ' el ',
        tostiones.fechaTostion,
        '.'
    ) as texto_qr,

    concat(
        fincas.nombreFinca,
        ' - ',
        lotes.variedad,
        ' - ',
        lotes.proceso
    ) as descripcionOrigen

from lineasPedido

join pedidos
on lineasPedido.identificacionPedidoFK = pedidos.identificacionPedido

join clientes
on pedidos.identificacionClienteFK = clientes.identificacionCliente

join tostiones
on lineasPedido.identificacionTostionFK = tostiones.identificacionTostion

join lotes
on tostiones.identificacionLoteFK = lotes.identificacionLote

join fincas
on lotes.identificacionFincaFK = fincas.identificacionFinca;


/* Consultar toda la vista */
select * from v_trazabilidad;


/* 45. Consultar la vista para un pedido */
select * from v_trazabilidad
where identificacionPedido = 1;



/* reflexión: una vista no guarda una copia de los datos, sino que muestra el resultado de una consulta. Así la trazabilidad se mantiene actualizada con las tablas originales..*/

