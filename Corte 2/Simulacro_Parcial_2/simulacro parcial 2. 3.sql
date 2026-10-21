 
/* ============================================================
   SIMULACRO PARCIAL PRACTICO 2 - DRONANDES EXPRESS
   MYSQL - R1 A R13
   ============================================================ */


/* ============================================================
   R1. MODELO RELACIONAL
   ============================================================ */

/*
Relaciones:
bases 1:N drones
bases 1:N pilotos
pilotos 1:N pilotos (supervisor)
clientes 1:N entregas
drones 1:N entregas
pilotos 1:N entregas
entregas N:M tipos_carga
drones 1:N mantenimientos
entregas 1:N historial_entregas

Cree carga_entrega como tabla intermedia porque
una entrega puede tener varios tipos de carga.
Use PRIMARY KEY compuesta para evitar repetir
el mismo tipo de carga en una entrega.

1FN: separe las cargas que estaban en una sola celda.
2FN: peso y unidades dependen de los dos IDs.
3FN: guarde datos de clientes en su propia tabla.
*/


/* ============================================================
   R2. CREACION DE BASE DE DATOS
   ============================================================ */

/* Elimine la base anterior para ejecutar el simulacro
   nuevamente desde cero. */

drop database if exists dronandes;

create database dronandes;

use dronandes;


/* ============================================================
   R2. TABLA BASES
   ============================================================ */

/* Cree bases primero porque drones y pilotos
   necesitan relacionarse con ella.
   Use CHECK para impedir capacidad negativa o cero. */

create table bases (
    id_base int auto_increment primary key,
    nombre varchar(60) not null unique,
    municipio varchar(60) not null,
    departamento varchar(40) not null,
    capacidad_drones int not null,
    fecha_apertura date not null,

    constraint chk_bases_capacidad
    check (capacidad_drones > 0)
);


/* ============================================================
   R2. TABLA TIPOS_CARGA
   ============================================================ */

/* Use UNIQUE para no repetir nombres.
   Use DEFAULT FALSE porque normalmente no requiere frio. */

create table tipos_carga (
    id_tipo int auto_increment primary key,
    nombre varchar(40) not null unique,
    tarifa_kg decimal(10,2) not null,
    requiere_frio boolean not null default false,

    constraint chk_tipos_tarifa
    check (tarifa_kg > 0)
);


/* ============================================================
   R2. TABLA DRONES
   ============================================================ */

/* Use FOREIGN KEY para relacionar cada dron con su base.
   Use CHECK para validar estados, autonomia y horas.
   La restriccion de carga maxima la agrego en R3. */

create table drones (
    id_dron int auto_increment primary key,
    codigo_serie varchar(12) not null unique,
    modelo varchar(40) not null,
    carga_max_kg decimal(5,2) not null,
    autonomia_km decimal(5,1) not null,
    estado varchar(15) not null default 'ACTIVO',
    horas_vuelo decimal(7,1) not null default 0,
    fecha_adquisicion date not null,
    id_base int not null,

    constraint chk_drones_autonomia
    check (autonomia_km > 0),

    constraint chk_drones_horas
    check (horas_vuelo >= 0),

    constraint chk_drones_estado
    check (estado in ('ACTIVO','MANTENIMIENTO','RETIRADO')),

    constraint fk_drones_base
    foreign key (id_base)
    references bases(id_base)
);


/* ============================================================
   R2. TABLA PILOTOS
   ============================================================ */

/* Use CHAR(1) porque la licencia es una letra.
   Permiti NULL en id_supervisor porque algunos pilotos
   no tienen supervisor.
   La FOREIGN KEY del supervisor se agrega en R3. */

create table pilotos (
    id_piloto int auto_increment primary key,
    documento varchar(15) not null unique,
    nombres varchar(50) not null,
    apellidos varchar(50) not null,
    email varchar(80) not null unique,
    licencia char(1) not null,
    fecha_ingreso date not null,
    id_supervisor int,
    id_base int not null,

    constraint chk_pilotos_licencia
    check (licencia in ('A','B','C')),

    constraint fk_pilotos_base
    foreign key (id_base)
    references bases(id_base)
);


/* ============================================================
   R2. TABLA CLIENTES
   ============================================================ */

/* Use UNIQUE para evitar documentos repetidos.
   Permiti NULL en email y telefono porque son opcionales.
   Use DEFAULT para registrar la fecha actual. */

create table clientes (
    id_cliente int auto_increment primary key,
    tipo varchar(12) not null,
    nombre varchar(80) not null,
    nit_documento varchar(15) not null unique,
    email varchar(80) unique,
    telefono varchar(15),
    municipio varchar(60) not null,
    fecha_registro date not null default (current_date),

    constraint chk_clientes_tipo
    check (tipo in (
        'HOSPITAL',
        'FARMACIA',
        'COMERCIO',
        'ONG',
        'PERSONA'
    ))
);


/* ============================================================
   R2. TABLA ENTREGAS
   ============================================================ */

/* Relacione cada entrega con su cliente, dron y piloto.
   Use CHECK para validar distancia, prioridad y estado. */

create table entregas (
    id_entrega int auto_increment primary key,
    codigo varchar(10) not null unique,
    id_cliente int not null,
    id_dron int not null,
    id_piloto int not null,
    fecha_programada datetime not null,
    fecha_entrega datetime,
    municipio_destino varchar(60) not null,
    distancia_km decimal(5,1) not null,
    prioridad varchar(8) not null default 'NORMAL',
    estado varchar(12) not null default 'PROGRAMADA',
    calificacion smallint,

    constraint chk_entregas_distancia
    check (distancia_km > 0),

    constraint chk_entregas_prioridad
    check (prioridad in ('NORMAL','URGENTE','VITAL')),

    constraint chk_entregas_estado
    check (estado in (
        'PROGRAMADA',
        'EN_VUELO',
        'ENTREGADA',
        'CANCELADA',
        'FALLIDA'
    )),

    constraint chk_entregas_calificacion
    check (calificacion between 1 and 5),

    constraint chk_entregas_fecha
    check (
        fecha_entrega is null
        or estado = 'ENTREGADA'
    ),

    constraint fk_entregas_cliente
    foreign key (id_cliente)
    references clientes(id_cliente),

    constraint fk_entregas_dron
    foreign key (id_dron)
    references drones(id_dron),

    constraint fk_entregas_piloto
    foreign key (id_piloto)
    references pilotos(id_piloto)
);


/* ============================================================
   R2. TABLA INTERMEDIA CARGA_ENTREGA
   ============================================================ */

/* Cree la tabla intermedia porque la relacion es N:M.
   Use PRIMARY KEY compuesta para no repetir
   el mismo tipo de carga en una entrega. */

create table carga_entrega (
    id_entrega int not null,
    id_tipo int not null,
    peso_kg decimal(6,2) not null,
    unidades int not null default 1,

    primary key (id_entrega, id_tipo),

    constraint chk_carga_peso
    check (peso_kg > 0),

    constraint chk_carga_unidades
    check (unidades > 0),

    constraint fk_carga_entrega
    foreign key (id_entrega)
    references entregas(id_entrega),

    constraint fk_carga_tipo
    foreign key (id_tipo)
    references tipos_carga(id_tipo)
);


/* ============================================================
   R2. TABLA MANTENIMIENTOS
   ============================================================ */

/* Cree una FK porque cada mantenimiento
   corresponde a un dron existente. */

create table mantenimientos (
    id_mantenimiento int auto_increment primary key,
    id_dron int not null,
    fecha date not null,
    tipo varchar(12) not null,
    descripcion varchar(200),
    costo decimal(10,2) not null,

    constraint chk_mantenimiento_tipo
    check (tipo in ('PREVENTIVO','CORRECTIVO')),

    constraint chk_mantenimiento_costo
    check (costo >= 0),

    constraint fk_mantenimiento_dron
    foreign key (id_dron)
    references drones(id_dron)
);


/* ============================================================
   R2. TABLA HISTORIAL_ENTREGAS
   ============================================================ */

/* Cree historial_entregas para guardar
   los cambios de estado y permitir auditorias. */

create table historial_entregas (
    id_historial int auto_increment primary key,
    id_entrega int not null,
    estado_anterior varchar(12) not null,
    estado_nuevo varchar(12) not null,
    fecha_cambio datetime not null default current_timestamp,

    constraint fk_historial_entrega
    foreign key (id_entrega)
    references entregas(id_entrega)
);


/* Compruebo que las nueve tablas existen. */

show tables;

describe entregas;


/* ============================================================
   R2. DATOS INICIALES DEL SIMULACRO
   ============================================================ */

/* Inserte los registros originales del caso
   para realizar posteriormente las consultas. */

insert into bases
(id_base,nombre,municipio,departamento,capacidad_drones,fecha_apertura)
values
(1,'Base Cóndor','Rionegro','Antioquia',6,'2024-02-15'),
(2,'Base Colibrí','Guatapé','Antioquia',4,'2024-08-01'),
(3,'Base Frailejón','Tunja','Boyacá',5,'2025-01-20'),
(4,'Base Guadua','Salento','Quindío',3,'2026-07-01');


insert into tipos_carga
(id_tipo,nombre,tarifa_kg,requiere_frio)
values
(1,'Vacunas',12000,true),
(2,'Muestras de laboratorio',10000,true),
(3,'Medicamentos',8000,false),
(4,'Documentos',5000,false),
(5,'Repuestos',4500,false),
(6,'Alimentos',3500,false);


insert into drones
(id_dron,codigo_serie,modelo,carga_max_kg,autonomia_km,
estado,horas_vuelo,fecha_adquisicion,id_base)
values
(1,'DA-CX4-01','Cóndor X4',8.00,45.0,'ACTIVO',312.5,'2024-02-20',1),
(2,'DA-CX4-02','Cóndor X4',8.00,45.0,'ACTIVO',468.0,'2024-03-10',1),
(3,'DA-CX6-01','Cóndor X6',15.00,60.0,'ACTIVO',205.0,'2025-01-15',1),
(4,'DA-COL-01','Colibrí Mini',2.50,25.0,'ACTIVO',520.5,'2024-08-05',2),
(5,'DA-COL-02','Colibrí Mini',2.50,25.0,'MANTENIMIENTO',610.0,'2024-08-05',2),
(6,'DA-ALB-01','Albatros H8',25.00,90.0,'ACTIVO',98.0,'2025-02-01',3),
(7,'DA-CX6-02','Cóndor X6',15.00,60.0,'ACTIVO',150.5,'2025-03-12',3),
(8,'DA-ALB-02','Albatros H8',25.00,90.0,'RETIRADO',890.0,'2024-05-01',3);


insert into pilotos
(id_piloto,documento,nombres,apellidos,email,
licencia,fecha_ingreso,id_supervisor,id_base)
values
(1,'1036600111','Laura','Restrepo Gil',
'laura.restrepo@dronandes.co','C','2024-02-01',null,1),
(2,'1049600222','Camilo','Duarte Rojas',
'camilo.duarte@dronandes.co','C','2025-01-10',null,3),
(3,'1036600333','Mateo','Zapata Vélez',
'mateo.zapata@dronandes.co','B','2024-04-15',1,1),
(4,'1036600444','Sara','Montoya Ruiz',
'sara.montoya@dronandes.co','B','2024-08-10',1,2),
(5,'1036600555','Julián','Patiño Cruz',
'julian.patino@dronandes.co','A','2025-06-01',1,2),
(6,'1049600666','Daniela','Suárez León',
'daniela.suarez@dronandes.co','B','2025-02-01',2,3),
(7,'1049600777','Tomás','Becerra Niño',
'tomas.becerra@dronandes.co','A','2026-06-15',2,3);


insert into clientes
(id_cliente,tipo,nombre,nit_documento,email,telefono,
municipio,fecha_registro)
values
(1,'HOSPITAL','Hospital San Juan de Dios de Rionegro',
'890980000-1','compras@hsjdrionegro.org',
'6045310000','Rionegro','2024-03-01'),
(2,'FARMACIA','Droguería La Esperanza',
'71234567','esperanza.drogueria@gmail.com',
'3104567890','Guatapé','2024-09-12'),
(3,'HOSPITAL','E.S.E. Hospital San Rafael de Tunja',
'891800231-6','Logistica@HSRTunja.gov.co',
'6087405050','Tunja','2025-01-25'),
(4,'ONG','Fundación Alas para el Campo',
'900456789-2','contacto@alasparaelcampo.org',
null,'Marinilla','2024-11-03'),
(5,'COMERCIO','Repuestos Agrícolas El Arriero',
'900123456-7',null,'31245678',
'El Peñol','2025-04-18'),
(6,'PERSONA','Mariana Gómez Arango',
'1040123456','mariana.gomez@hotmail.com',
'3157778899','Guarne','2025-07-07'),
(7,'FARMACIA','Farmacia Botica del Páramo',
'900777888-1','boticaparamo@gmail.com',
'3209998877','Ventaquemada','2025-02-14'),
(8,'COMERCIO','Café de Altura Las Nubes',
'901222333-4','ventas@cafelasnubes.co',
'3001112233','Salento','2026-07-20'),
(9,'PERSONA','Jorge Iván Ríos',
'79888777',null,null,'Rionegro','2026-08-30'),
(10,'ONG','Corporación Montaña Viva',
'900999111-0','info@montanaviva.org',
'310555444','Sáchica','2025-09-01');


insert into entregas
(id_entrega,codigo,id_cliente,id_dron,id_piloto,
fecha_programada,fecha_entrega,municipio_destino,
distancia_km,prioridad,estado,calificacion)
values
(1,'ENT-0001',1,1,3,'2026-08-03 08:00:00',
'2026-08-03 08:42:00','San Vicente',18.5,'VITAL','ENTREGADA',5),
(2,'ENT-0002',1,3,1,'2026-08-05 09:30:00',
'2026-08-05 10:20:00','Concepción',32.0,'VITAL','ENTREGADA',4),
(3,'ENT-0003',2,4,4,'2026-08-07 14:00:00',
'2026-08-07 14:25:00','San Rafael',12.0,'NORMAL','ENTREGADA',5),
(4,'ENT-0004',4,2,3,'2026-08-10 07:45:00',
'2026-08-10 08:30:00','El Carmen de Viboral',22.4,'URGENTE','ENTREGADA',3),
(5,'ENT-0005',5,3,1,'2026-08-12 11:00:00',
null,'El Peñol',15.0,'NORMAL','CANCELADA',null),
(6,'ENT-0006',3,6,2,'2026-08-14 06:30:00',
'2026-08-14 07:40:00','Ramiriquí',48.0,'VITAL','ENTREGADA',5),
(7,'ENT-0007',10,7,6,'2026-08-18 10:00:00',
'2026-08-18 10:35:00','Samacá',20.5,'NORMAL','ENTREGADA',4),
(8,'ENT-0008',3,8,6,'2026-08-20 08:15:00',
null,'Chíquiza',35.0,'URGENTE','FALLIDA',null),
(9,'ENT-0009',6,4,5,'2026-08-22 16:00:00',
'2026-08-22 16:20:00','Guarne',9.5,'NORMAL','ENTREGADA',2),
(10,'ENT-0010',1,1,1,'2026-08-25 07:00:00',
'2026-08-25 07:50:00','Sonsón',41.0,'VITAL','ENTREGADA',5),
(11,'ENT-0011',10,6,2,'2026-08-27 09:00:00',
'2026-08-27 10:05:00','Sáchica',52.5,'URGENTE','ENTREGADA',null),
(12,'ENT-0012',2,5,4,'2026-08-29 13:00:00',
null,'Alejandría',14.0,'NORMAL','CANCELADA',null),
(13,'ENT-0013',4,2,1,'2026-09-01 08:00:00',
'2026-09-01 08:55:00','Granada',38.0,'URGENTE','ENTREGADA',4),
(14,'ENT-0014',1,3,1,'2026-09-03 10:30:00',
'2026-09-03 11:15:00','Abejorral',44.0,'VITAL','ENTREGADA',5),
(15,'ENT-0015',7,7,6,'2026-09-08 15:00:00',
'2026-09-08 15:30:00','Turmequé',17.0,'NORMAL','ENTREGADA',3),
(16,'ENT-0016',3,6,2,'2026-09-15 06:00:00',
'2026-09-15 07:10:00','Miraflores',58.0,'VITAL','ENTREGADA',4),
(17,'ENT-0017',6,2,3,'2026-09-21 17:00:00',
null,'Guarne',10.0,'NORMAL','CANCELADA',null),
(18,'ENT-0018',10,7,6,'2026-09-30 17:40:00',
null,'Villa de Leyva',26.0,'NORMAL','EN_VUELO',null),
(19,'ENT-0019',1,1,1,'2026-10-01 07:30:00',
null,'Nariño',47.0,'VITAL','PROGRAMADA',null),
(20,'ENT-0020',3,6,6,'2026-10-02 06:00:00',
null,'Pesca',39.0,'VITAL','PROGRAMADA',null);


insert into carga_entrega
(id_entrega,id_tipo,peso_kg,unidades)
values
(1,1,3.00,60),(1,3,2.00,15),
(2,2,1.50,30),(2,3,4.00,40),
(3,3,1.80,12),
(4,3,3.50,25),(4,4,0.50,3),
(5,5,6.00,4),
(6,1,5.00,100),(6,2,2.00,40),
(7,3,6.00,50),
(8,1,8.00,160),(8,3,4.00,30),
(9,4,0.80,5),
(10,1,4.00,80),(10,2,1.00,20),(10,3,2.50,20),
(11,3,7.00,60),(11,4,1.00,6),
(13,3,5.00,40),(13,5,2.00,2),
(14,1,6.00,120),(14,2,3.00,60),
(15,3,3.00,25),(15,4,0.30,2),
(16,1,10.00,200),(16,3,8.00,70),
(18,3,4.00,35),
(19,1,3.50,70),
(20,2,2.50,50),(20,1,6.00,120);


insert into mantenimientos
(id_mantenimiento,id_dron,fecha,tipo,descripcion,costo)
values
(1,2,'2026-03-15','PREVENTIVO','Cambio de hélices',350000),
(2,4,'2026-04-02','PREVENTIVO','Calibración de GPS',180000),
(3,5,'2026-09-25','CORRECTIVO','Falla en motor 3',1250000),
(4,8,'2026-08-21','CORRECTIVO',
'Impacto en aterrizaje, evaluación de daños',2800000),
(5,1,'2026-06-10','PREVENTIVO',
'Revisión general de 300 horas',420000),
(6,6,'2026-07-05','PREVENTIVO',null,260000),
(7,5,'2026-05-14','PREVENTIVO','Cambio de baterías',950000),
(8,2,'2026-09-12','CORRECTIVO',
'Sensor de altitud defectuoso',610000);


/* ============================================================
   R3. ALTER TABLE
   ============================================================ */

/* R3.a
   Use MODIFY para ampliar VARCHAR sin perder NOT NULL. */

alter table clientes
modify column nombre varchar(120) not null;


/* R3.b
   Agregue CHECK para permitir cargas entre 0.5 y 25 kg. */

alter table drones
add constraint chk_drones_carga
check (carga_max_kg between 0.5 and 25);


/* R3.c
   Agregue la FOREIGN KEY recursiva porque
   el supervisor tambien debe ser un piloto registrado. */

alter table pilotos
add constraint fk_pilotos_supervisor
foreign key (id_supervisor)
references pilotos(id_piloto);


/* ============================================================
   R4. OPERACIONES DML
   ============================================================ */

/* R4.a
   Use un solo INSERT con tres filas.
   No escribi id_cliente porque es AUTO_INCREMENT. */

insert into clientes
(tipo,nombre,nit_documento,email,telefono,
municipio,fecha_registro)
values
('FARMACIA','Droguería Santa Ana','900314159-2',
'santaana@gmail.com','3112223344','Marinilla','2026-09-28'),

('PERSONA','Esteban Mejía Toro','1036987654',
null,'3015556677','Rionegro','2026-09-29'),

('COMERCIO','Tienda Naturista Frailejón','901555666-3',
'tienda.frailejon@outlook.com','3209871234',
'Tunja','2026-09-30');


/* R4.b
   Use UPDATE para cambiar el estado de los drones
   activos que tienen mas de 500 horas de vuelo.
   Se espera actualizar un dron. */

update drones
set estado = 'MANTENIMIENTO'
where estado = 'ACTIVO'
and horas_vuelo > 500;


/* R4.c
   Use DELETE con NOT IN para eliminar entregas
   canceladas cuyos IDs no aparecen en carga_entrega.
   Se esperan eliminar dos entregas. */

delete from entregas
where estado = 'CANCELADA'
and id_entrega not in (
    select id_entrega
    from carga_entrega
);


/* R4.d
   Use COUNT en subconsultas para mostrar tres totales
   dentro de una misma consulta. */

select
    (select count(*) from clientes) as total_clientes,
    (select count(*) from entregas) as total_entregas,
    (select count(*)
     from drones
     where estado = 'MANTENIMIENTO') as drones_mantenimiento;


/* ============================================================
   R5. CONSULTAS CON CONDICIONES
   ============================================================ */

/* R5.a
   Use BETWEEN para incluir distancias de 20 a 45.
   Use IN porque acepto VITAL o URGENTE. */

select codigo, municipio_destino, distancia_km, prioridad
from entregas
where estado = 'ENTREGADA'
and distancia_km between 20 and 45
and prioridad in ('VITAL','URGENTE')
order by distancia_km desc;


/* R5.b.1
   Use NOT IN para excluir tres estados.
   Use IS NULL porque no deben tener fecha de entrega. */

select codigo, estado, fecha_programada
from entregas
where estado not in ('PROGRAMADA','EN_VUELO','ENTREGADA')
and fecha_entrega is null
order by codigo;


/* R5.b.2
   Use IS NOT NULL para encontrar entregas con fecha real
   e IS NULL para encontrar las que no tienen nota. */

select codigo, fecha_entrega
from entregas
where fecha_entrega is not null
and calificacion is null;


/* R5.c
   Use != para excluir drones retirados.
   Use parentesis para agrupar correctamente el OR. */

select codigo_serie, modelo, carga_max_kg,
       horas_vuelo, autonomia_km, estado
from drones
where estado != 'RETIRADO'
and (
    (carga_max_kg >= 8 and horas_vuelo < 400)
    or autonomia_km > 80
)
order by codigo_serie asc;


/* R5.d
   Use NOT para excluir pilotos con licencia A.
   Use <= para incluir el 1 de febrero de 2025. */

select nombres, apellidos, licencia, fecha_ingreso
from pilotos
where not (licencia = 'A')
and fecha_ingreso <= '2025-02-01'
order by fecha_ingreso asc;


/* ============================================================
   R6. FUNCIONES DE TEXTO Y NUMERICAS
   ============================================================ */

/* R6.a
   Use UPPER para mostrar los nombres en mayusculas.
   Use COALESCE para reemplazar telefonos NULL.
   Use LENGTH para contar la longitud del telefono. */

select
    upper(nombre) as cliente,
    municipio,
    coalesce(telefono,'SIN TELÉFONO') as telefono,
    length(telefono) as digitos
from clientes
where telefono is null
or length(telefono) <> 10
order by nombre asc;


/* R6.b
   Use NOT LIKE para excluir correos gratuitos.
   Use LOWER para mostrar el correo en minusculas.
   Use CONCAT para unir nombre y correo. */

select
    nombre,
    lower(email) as correo,
    concat(nombre,' <',lower(email),'>') as contacto
from clientes
where email is not null
and lower(email) not like '%@gmail.com'
and lower(email) not like '%@hotmail.com'
and lower(email) not like '%@outlook.com'
order by nombre;


/* R6.c
   Use LIKE con _ porque representa exactamente
   un caracter.
   Use ROUND para redondear el porcentaje. */

select
    codigo_serie,
    upper(modelo) as modelo,
    horas_vuelo,
    round(horas_vuelo / 1000 * 100,1) as pct_vida_util
from drones
where codigo_serie like 'DA-CX_-__'
order by horas_vuelo desc;


/* ============================================================
   R7. GROUP BY Y HAVING
   ============================================================ */

/* R7.a
   Use INNER JOIN para relacionar tres tablas.
   WHERE deja solamente entregas realizadas.
   GROUP BY separa el resultado por tipo de carga.
   COUNT cuenta, SUM suma, AVG promedia,
   MIN obtiene el menor y MAX el mayor. */

select
    t.nombre as tipo_carga,
    count(*) as num_entregas,
    sum(c.peso_kg) as kg_totales,
    round(avg(c.peso_kg),2) as kg_promedio,
    min(c.peso_kg) as kg_minimo,
    max(c.peso_kg) as kg_maximo
from tipos_carga t
inner join carga_entrega c
    on t.id_tipo = c.id_tipo
inner join entregas e
    on c.id_entrega = e.id_entrega
where e.estado = 'ENTREGADA'
group by t.id_tipo, t.nombre
order by kg_totales desc;

/* R7.b
   WHERE filtra filas antes de agrupar.
   GROUP BY separa por cliente.
   HAVING filtra grupos despues de calcular.
   COUNT cuenta las entregas aunque no tengan nota.
   AVG ignora las calificaciones NULL. */

select
    c.nombre as cliente,
    count(*) as entregas_realizadas,
    round(avg(e.calificacion),2) as calificacion_promedio
from clientes c
inner join entregas e
    on c.id_cliente = e.id_cliente
where e.estado = 'ENTREGADA'
group by c.id_cliente, c.nombre
having count(*) >= 2
and avg(e.calificacion) >= 4
order by calificacion_promedio desc, cliente asc;


/* ============================================================
   R8. CONSULTAS CON JOIN
   ============================================================ */

/* R8.a
   Use INNER JOIN porque necesito datos relacionados
   de entregas, clientes, pilotos, drones y bases.
   Use CONCAT para el nombre completo del piloto.
   Use TIMESTAMPDIFF para calcular los minutos. */

select
    e.codigo,
    c.nombre as cliente,
    concat(p.nombres,' ',p.apellidos) as piloto,
    d.codigo_serie as dron,
    b.nombre as base,
    timestampdiff(
        minute,
        e.fecha_programada,
        e.fecha_entrega
    ) as minutos_vuelo
from entregas e
inner join clientes c
    on e.id_cliente = c.id_cliente
inner join pilotos p
    on e.id_piloto = p.id_piloto
inner join drones d
    on e.id_dron = d.id_dron
inner join bases b
    on d.id_base = b.id_base
where e.prioridad = 'VITAL'
and e.estado = 'ENTREGADA'
order by e.fecha_programada asc;


/* R8.b
   Use LEFT JOIN porque quiero todos los pilotos,
   incluso los que no tienen entregas realizadas.
   Coloque la condicion ENTREGADA en ON para
   conservar los pilotos con cero entregas. */

select
    concat(p.nombres,' ',p.apellidos) as piloto,
    p.licencia,
    count(e.id_entrega) as entregas_realizadas
from pilotos p
left join entregas e
    on p.id_piloto = e.id_piloto
    and e.estado = 'ENTREGADA'
group by p.id_piloto, p.nombres, p.apellidos, p.licencia
order by entregas_realizadas desc, piloto asc;


/* R8.c
   Use SELF JOIN porque piloto y supervisor
   pertenecen a la misma tabla.
   Use COALESCE para reemplazar el supervisor NULL. */

select
    concat(p.nombres,' ',p.apellidos) as piloto,
    p.licencia,
    coalesce(
        concat(s.nombres,' ',s.apellidos),
        'DIRECCIÓN DE OPERACIONES'
    ) as supervisor
from pilotos p
left join pilotos s
    on p.id_supervisor = s.id_piloto
order by supervisor, piloto;


/* R8.d
   Use JOIN para obtener la autonomia del dron.
   Compare distancia con autonomia y calcule el exceso. */

select
    e.codigo,
    c.nombre as cliente,
    d.codigo_serie as dron,
    e.distancia_km,
    d.autonomia_km,
    e.distancia_km - d.autonomia_km as exceso_km
from entregas e
inner join clientes c
    on e.id_cliente = c.id_cliente
inner join drones d
    on e.id_dron = d.id_dron
where e.estado = 'PROGRAMADA'
and e.distancia_km > d.autonomia_km;


/* ============================================================
   R9. SUBCONSULTAS
   ============================================================ */

/* R9.a
   Use una subconsulta escalar porque AVG calcula
   un solo promedio para comparar las distancias. */

select codigo, municipio_destino, distancia_km
from entregas
where estado = 'ENTREGADA'
and distancia_km > (
    select avg(distancia_km)
    from entregas
    where estado = 'ENTREGADA'
)
order by distancia_km desc;


/* R9.b
   Use NOT IN porque necesito clientes que no aparecen
   en los IDs de la tabla entregas. */

select nombre, tipo, municipio, fecha_registro
from clientes
where id_cliente not in (
    select id_cliente
    from entregas
)
order by fecha_registro, nombre;


/* R9.c
   Use una subconsulta correlacionada porque
   necesito calcular el promedio de la misma base
   correspondiente a cada dron. */

select
    d.codigo_serie,
    b.nombre as base,
    d.horas_vuelo
from drones d
inner join bases b
    on d.id_base = b.id_base
where d.horas_vuelo > (
    select avg(d2.horas_vuelo)
    from drones d2
    where d2.id_base = d.id_base
)
order by base;


/* R9.d
   Use NOT EXISTS porque necesito comprobar
   que no exista ningun mantenimiento para el dron. */

select d.codigo_serie, d.modelo, d.estado
from drones d
where d.estado <> 'RETIRADO'
and not exists (
    select 1
    from mantenimientos m
    where m.id_dron = d.id_dron
)
order by d.codigo_serie;


/* ============================================================
   R10. VISTA E INDICES
   ============================================================ */

/* R10.a
   Cree una VIEW para guardar la consulta del tablero.
   Use LEFT JOIN porque deben aparecer entregas sin carga.
   Use COALESCE para mostrar cero cuando no hay peso.
   GROUP BY permite mostrar una fila por entrega. */

create or replace view vw_tablero_entregas as
select
    e.codigo,
    e.fecha_programada,
    c.nombre as cliente,
    c.tipo as tipo_cliente,
    e.municipio_destino,
    d.codigo_serie as dron,
    concat(p.nombres,' ',p.apellidos) as piloto,
    e.prioridad,
    e.estado,
    count(ce.id_tipo) as tipos_carga,
    coalesce(sum(ce.peso_kg),0) as peso_total_kg
from entregas e
inner join clientes c
    on e.id_cliente = c.id_cliente
inner join drones d
    on e.id_dron = d.id_dron
inner join pilotos p
    on e.id_piloto = p.id_piloto
left join carga_entrega ce
    on e.id_entrega = ce.id_entrega
group by
    e.id_entrega,
    e.codigo,
    e.fecha_programada,
    c.nombre,
    c.tipo,
    e.municipio_destino,
    d.codigo_serie,
    p.nombres,
    p.apellidos,
    e.prioridad,
    e.estado;


/* Consulto entregas PROGRAMADA o EN_VUELO. */

select *
from vw_tablero_entregas
where estado in ('PROGRAMADA','EN_VUELO')
order by fecha_programada;


/* R10.b
   Cree un indice compuesto para acelerar
   las busquedas por estado y fecha programada. */

create index idx_entregas_estado_fecha
on entregas(estado, fecha_programada);


/* Cree otro indice para consultar clientes
   por tipo y municipio. */

create index idx_clientes_tipo_municipio
on clientes(tipo, municipio);


/* Compruebo que los indices existen. */

show index from entregas;
show index from clientes;


/* ============================================================
   R11. FUNCION ALMACENADA
   ============================================================ */

/* Cree una FUNCTION porque necesito calcular
   y devolver el valor de una entrega.
   Use SELECT INTO para guardar resultados.
   Use RETURN para devolver el valor final. */

delimiter //

create function fn_valor_entrega(
    p_id_entrega int
)
returns decimal(12,2)
reads sql data
begin

    declare v_existe int default 0;
    declare v_distancia decimal(5,1);
    declare v_prioridad varchar(8);
    declare v_costo_carga decimal(12,2);
    declare v_total decimal(12,2);

    /* Verifico si la entrega existe. */

    select count(*)
    into v_existe
    from entregas
    where id_entrega = p_id_entrega;

    /* Si no existe, devuelvo NULL. */

    if v_existe = 0 then
        return null;
    end if;

    /* Guardo distancia y prioridad de la entrega. */

    select distancia_km, prioridad
    into v_distancia, v_prioridad
    from entregas
    where id_entrega = p_id_entrega;

    /* Calculo el costo de las cargas.
       COALESCE devuelve cero si no hay carga. */

    select coalesce(sum(c.peso_kg * t.tarifa_kg),0)
    into v_costo_carga
    from carga_entrega c
    inner join tipos_carga t
        on c.id_tipo = t.id_tipo
    where c.id_entrega = p_id_entrega;

    /* Sumo la carga y la distancia por 1200. */

    set v_total = v_costo_carga + v_distancia * 1200;

    /* Si es URGENTE, agrego el 20%. */

    if v_prioridad = 'URGENTE' then
        set v_total = v_total * 1.20;
    end if;

    return round(v_total,2);

end //

delimiter ;



/* R11.b.1
   Uso la funcion dentro de SELECT para obtener
   el valor de las entregas urgentes realizadas. */

select
    codigo,
    prioridad,
    fn_valor_entrega(id_entrega) as valor_cop
from entregas
where estado = 'ENTREGADA'
and prioridad = 'URGENTE'
order by valor_cop desc;


/* R11.b.2
   Pruebo un ID inexistente.
   Debe devolver NULL. */

select fn_valor_entrega(999) as valor_cop;


/* ============================================================
   R12. TRIGGER DE AUDITORIA
   ============================================================ */

/* Cree un TRIGGER BEFORE UPDATE porque necesito
   revisar el estado antes de guardar los cambios.
   OLD es el valor anterior y NEW el valor nuevo.
   Solo registro historial si el estado cambia. */

delimiter //

create trigger trg_entregas_estado
before update on entregas
for each row
begin

    if old.estado <> new.estado then

        /* Si la entrega termina y no tiene fecha,
           asigno la fecha actual. */

        if new.estado = 'ENTREGADA'
        and new.fecha_entrega is null then

            set new.fecha_entrega = now();

        end if;

        /* Guardo el estado anterior y el nuevo. */

        insert into historial_entregas (
            id_entrega,
            estado_anterior,
            estado_nuevo
        )
        values (
            old.id_entrega,
            old.estado,
            new.estado
        );

    end if;

end //

delimiter ;


/* R12. PRIMERA PRUEBA
   Cambio EN_VUELO a ENTREGADA. */

update entregas
set estado = 'ENTREGADA',
    calificacion = 5
where codigo = 'ENT-0018';


/* R12. SEGUNDA PRUEBA
   Cambio PROGRAMADA a CANCELADA. */

update entregas
set estado = 'CANCELADA'
where codigo = 'ENT-0019';


/* R12. TERCERA PRUEBA
   Cambio solamente la calificacion.
   No debe crear historial porque no cambia el estado. */

update entregas
set calificacion = 4
where codigo = 'ENT-0011';


/* Compruebo los registros de auditoria. */

select
    e.codigo,
    h.estado_anterior,
    h.estado_nuevo,
    h.fecha_cambio
from historial_entregas h
inner join entregas e
    on h.id_entrega = e.id_entrega
order by h.id_historial;


/* Consulto las tres entregas de prueba. */

select
    codigo,
    estado,
    fecha_entrega,
    calificacion
from entregas
where codigo in ('ENT-0018','ENT-0019','ENT-0011')
order by codigo;


/* ============================================================
   R13. PROCEDIMIENTO ALMACENADO
   ============================================================ */

/* Cree un PROCEDURE porque necesito recibir
   los datos para registrar entregas.
   Use IN porque todos los parametros son de entrada.
   Use SELECT INTO para guardar datos en variables.
   Use SIGNAL para detener la operacion si algo falla. */

delimiter //

create procedure sp_programar_entrega(

    in p_codigo varchar(10),
    in p_id_cliente int,
    in p_id_dron int,
    in p_id_piloto int,
    in p_fecha_programada datetime,
    in p_municipio_destino varchar(60),
    in p_distancia_km decimal(5,1),
    in p_prioridad varchar(8)

)
begin

    declare v_existe int;
    declare v_estado varchar(15);
    declare v_autonomia decimal(5,1);
    declare v_licencia char(1);

    /* Verifico que el dron exista. */

    select count(*)
    into v_existe
    from drones
    where id_dron = p_id_dron;

    if v_existe = 0 then

        signal sqlstate '45000'
        set message_text = 'El dron no existe';

    end if;


    /* Verifico que el piloto exista. */

    select count(*)
    into v_existe
    from pilotos
    where id_piloto = p_id_piloto;

    if v_existe = 0 then

        signal sqlstate '45000'
        set message_text = 'El piloto no existe';

    end if;


    /* Guardo estado y autonomia del dron. */

    select estado, autonomia_km
    into v_estado, v_autonomia
    from drones
    where id_dron = p_id_dron;


    /* Solo permito drones activos. */

    if v_estado <> 'ACTIVO' then

        signal sqlstate '45000'
        set message_text = 'El dron no esta ACTIVO';

    end if;


    /* La distancia no puede superar la autonomia. */

    if p_distancia_km > v_autonomia then

        signal sqlstate '45000'
        set message_text = 'La distancia supera la autonomia';

    end if;


    /* Guardo la licencia del piloto. */

    select licencia
    into v_licencia
    from pilotos
    where id_piloto = p_id_piloto;


    /* Licencia A permite hasta 20 km.
       Licencia B permite hasta 40 km.
       Licencia C no tiene limite de licencia. */

    if (
        v_licencia = 'A' and p_distancia_km > 20
    ) or (
        v_licencia = 'B' and p_distancia_km > 40
    ) then

        signal sqlstate '45000'
        set message_text = 'La licencia no permite esta distancia';

    end if;


    /* Si pasa todas las validaciones,
       registro la entrega.
       DEFAULT deja el estado en PROGRAMADA. */

    insert into entregas (
        codigo,
        id_cliente,
        id_dron,
        id_piloto,
        fecha_programada,
        municipio_destino,
        distancia_km,
        prioridad
    )
    values (
        p_codigo,
        p_id_cliente,
        p_id_dron,
        p_id_piloto,
        p_fecha_programada,
        p_municipio_destino,
        p_distancia_km,
        p_prioridad
    );


    /* Muestro el identificador generado. */

    select last_insert_id() as id_entrega_generada;

end //

delimiter ;


/* ============================================================
   R13. PRUEBAS
   ============================================================ */

/* PRUEBA 1
   Esta llamada debe funcionar porque el dron esta activo,
   tiene autonomia suficiente y la licencia lo permite. */

call sp_programar_entrega(
    'ENT-0021',
    11,
    3,
    3,
    '2026-10-03 10:00:00',
    'Marinilla',
    16.0,
    'URGENTE'
);


/* Verifico la nueva entrega en la vista. */

select *
from vw_tablero_entregas
where codigo = 'ENT-0021';


/* PRUEBA 2
   Esta llamada debe generar error porque el dron 4
   esta en MANTENIMIENTO.*/

call sp_programar_entrega(
    'ENT-0022',
    6,
    4,
    4,
    '2026-10-03 11:00:00',
    'Guarne',
    9.0,
    'NORMAL'
);

*/


/* PRUEBA 3
   Esta llamada debe generar error porque el piloto 7
   tiene licencia A y no puede volar 28 km */

call sp_programar_entrega(
    'ENT-0023',
    2,
    7,
    7,
    '2026-10-04 08:00:00',
    'Arcabuco',
    28.0,
    'NORMAL'
);

*/
