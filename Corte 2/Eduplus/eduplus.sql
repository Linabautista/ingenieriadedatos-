create database eduplus;
use eduplus;

-- Crear tabla instructores
create table instructores (
id int auto_increment primary key,
nombre varchar(100) not null,
email varchar(100) not null unique
);

-- Crear tabla cursos
create table cursos (
id int auto_increment primary key,
titulo varchar(100) not null,
area varchar(50) not null,
precio decimal(10,2) not null,
instructor_id int not null,

constraint fk_cursos_instructor
foreign key (instructor_id)
references instructores(id)
);

-- Crear tabla estudiantes
create table estudiantes (
id int auto_increment primary key,
nombre varchar(50) not null,
apellido varchar(50) not null,
ciudad varchar(50) not null
);

-- Crear tabla inscripciones
create table inscripciones (
id int auto_increment primary key,
estudiante_id int not null,
curso_id int not null,
fecha_inscripcion date not null,
valor_pagado decimal(10,2) not null,
nota_final decimal(3,1) null,

constraint fk_insc_estudiante
foreign key (estudiante_id)
references estudiantes(id),

constraint fk_insc_curso
foreign key (curso_id)
references cursos(id)
);

-- Insertar instructores
insert into instructores(nombre,email)
values
('Juan Emilio Monge','juan.monge@eduplus.co'),
('Camila Sun','camila.sun@eduplus.co'),
('Lina Bautista','lina.bautista@eduplus.co');

-- Insertar cursos
insert into cursos(titulo,area,precio,instructor_id)
values
('SQL para principiantes','Bases de datos',210000.00,1),
('Python para datos','Programación',360000.00,2),
('Git y control de versiones','Herramientas',130000.00,1),
('React profesional','Programación',460000.00,2),
('Docker práctico','Herramientas',310000.00,3);

-- Insertar estudiantes
insert into estudiantes(nombre,apellido,ciudad)
values
('Juan','Bautista','Bogotá'),
('Mafe','Salazar','Medellín'),
('Sara','Mejía','Cali'),
('Nicolás','Torres','Bogotá'),
('Daniela','Rojas','Pereira'),
('Mateo','Gómez','Cali');

-- Insertar inscripciones
insert into inscripciones
(estudiante_id,curso_id,fecha_inscripcion,valor_pagado,nota_final)
values
(1,1,'2026-06-01',210000.00,4.5),
(1,2,'2026-06-10',360000.00,4.0),
(2,1,'2026-06-05',190000.00,3.8),
(2,4,'2026-07-01',460000.00,null),
(3,2,'2026-07-15',320000.00,4.8),
(3,3,'2026-07-20',130000.00,4.2),
(4,1,'2026-08-01',210000.00,null),
(4,3,'2026-08-03',130000.00,3.5),
(4,4,'2026-08-10',460000.00,null);

-- Punto 1 INNER JOIN
select
c.titulo,
c.area,
c.precio,
i.nombre as instructor
from cursos c
inner join instructores i
on i.id = c.instructor_id
order by i.nombre,c.titulo;

-- Punto 2 LEFT JOIN
select
e.nombre,
e.apellido,
e.ciudad
from estudiantes e
left join inscripciones ins
on ins.estudiante_id = e.id
where ins.id is null;

-- Punto 3 consulta de varias tablas
select
concat(e.nombre,' ',e.apellido) as estudiante,
c.titulo as curso,
i.nombre as instructor,
ins.fecha_inscripcion,
ins.valor_pagado
from inscripciones ins
join estudiantes e
on e.id = ins.estudiante_id
join cursos c
on c.id = ins.curso_id
join instructores i
on i.id = c.instructor_id
order by ins.fecha_inscripcion;

-- Punto 4 funciones de agregación
select
c.titulo,
count(ins.id) as inscritos,
coalesce(sum(ins.valor_pagado),0) as ingresos,
round(avg(ins.nota_final),1) as nota_promedio
from cursos c
left join inscripciones ins
on ins.curso_id = c.id
group by c.id,c.titulo
order by ingresos desc;

-- Punto 5 cursos que nadie ha comprado
select c.titulo
from cursos c
where not exists (
select 1
from inscripciones ins
where ins.curso_id = c.id
);

-- Punto 6 notas mayores al promedio
select
concat(e.nombre,' ',e.apellido) as estudiante,
c.titulo as curso,
ins.nota_final
from inscripciones ins
join estudiantes e
on e.id = ins.estudiante_id
join cursos c
on c.id = ins.curso_id
where ins.nota_final > (
select avg(nota_final)
from inscripciones
)
order by ins.nota_final desc;

-- Punto 7 estudiantes que gastaron más que el promedio
select
upper(concat(e.nombre,' ',e.apellido)) as estudiante,
count(ins.id) as cursos_tomados,
sum(ins.valor_pagado) as total_pagado
from estudiantes e
join inscripciones ins
on ins.estudiante_id = e.id
group by e.id,e.nombre,e.apellido
having sum(ins.valor_pagado) > (
select avg(total)
from (
select
sum(valor_pagado) as total
from inscripciones
group by estudiante_id
) as gastos
);

-- Crear vista
create or replace view v_ingresos_por_curso as
select
c.id as curso_id,
c.titulo,
count(ins.id) as inscritos,
coalesce(sum(ins.valor_pagado),0) as ingresos,
round(avg(ins.nota_final),1) as nota_promedio
from cursos c
left join inscripciones ins
on ins.curso_id = c.id
group by c.id,c.titulo;

-- Consultar vista
select *
from v_ingresos_por_curso
order by ingresos desc;

-- Crear procedimiento almacenado
drop procedure if exists sp_inscribir_estudiante;

delimiter //

create procedure sp_inscribir_estudiante(
in p_estudiante_id int,
in p_curso_id int,
in p_valor_pagado decimal(10,2),
out p_inscripcion_id int
)
begin

if not exists (
select 1
from estudiantes
where id = p_estudiante_id
) then

signal sqlstate '45000'
set message_text = 'El estudiante no existe';

end if;

if not exists (
select 1
from cursos
where id = p_curso_id
) then

signal sqlstate '45000'
set message_text = 'El curso no existe';

end if;

insert into inscripciones
(estudiante_id,curso_id,fecha_inscripcion,valor_pagado,nota_final)
values
(p_estudiante_id,p_curso_id,current_date,p_valor_pagado,null);

set p_inscripcion_id = last_insert_id();

end //

delimiter ;

-- Probar procedimiento
call sp_inscribir_estudiante(5,1,210000,@id);

select @id as nueva_inscripcion;

-- Crear tabla auditoria
create table auditoria (
id int auto_increment primary key,
tabla varchar(50) not null,
operacion varchar(20) not null,
registro_id int not null,
valor_anterior decimal(12,2),
valor_nuevo decimal(12,2),
usuario varchar(100) not null,
fecha timestamp default current_timestamp
);

-- Trigger para cambios de precio
drop trigger if exists trg_cursos_auditar_precio;

delimiter //

create trigger trg_cursos_auditar_precio
after update on cursos
for each row
begin

if old.precio <> new.precio then

insert into auditoria
(tabla,operacion,registro_id,valor_anterior,valor_nuevo,usuario)
values
('cursos','UPDATE',new.id,old.precio,new.precio,current_user());

end if;

end //

delimiter ;

-- Probar trigger
select * from cursos;

update cursos
set precio = 420000
where id = 1;

select * from auditoria;

-- Trigger para convertir correo a minúscula
drop trigger if exists trg_instructores_before_insert;

delimiter //

create trigger trg_instructores_before_insert
before insert on instructores
for each row
begin

set new.email = lower(new.email);

end //

delimiter ;

-- Probar trigger
insert into instructores(nombre,email)
values
('Mariana Meche','MARIANA.MECHE@EDUPLUS.CO');

select *
from instructores
where nombre = 'Mariana Meche';

-- Pregunta 1
-- Si usamos INNER JOIN en el punto 2 no aparecerían los estudiantes
-- que no tienen inscripciones, porque INNER JOIN solo muestra coincidencias.

-- Pregunta 2
-- React profesional tiene nota promedio NULL porque sus inscripciones
-- todavía pueden estar en progreso y la nota_final está en NULL.
-- No es un error.

-- Pregunta 3
-- AVG no tiene en cuenta los valores NULL.
-- Se puede comprobar comparando COUNT(*) con COUNT(nota_final).

-- Pregunta 4
-- NOT IN funciona correctamente aquí porque curso_id no contiene NULL.
-- Si la subconsulta devuelve NULL, NOT IN puede producir resultados inesperados.

-- Pregunta 5
-- En PostgreSQL cambiarían AUTO_INCREMENT, los procedimientos,
-- los triggers y algunas funciones propias de MySQL.