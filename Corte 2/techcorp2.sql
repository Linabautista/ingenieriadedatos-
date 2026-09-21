/* crear base de datos */
create database techcorp2;

/* habilitar base de datos */
use techcorp2;


/* crear tabla departamento2 */
create table departamento2(
idDepartamento int primary key,
nombreDepartamento varchar(50) not null
);

/* crear tabla empleado2 */
create table empleado2(
idEmpleado int primary key,
nombreEmpleado varchar(50) not null,
edad int not null,
salario decimal(10,2) not null,
fechaContratacion date not null,
idDepartamentoFK int,
constraint fkempleadodepartamento foreign key (idDepartamentoFK) references departamento2(idDepartamento)
);


/* insertar datos en departamento2 */
insert into departamento2 values
(1,'Ventas'),
(2,'IT'),
(3,'Recursos Humanos'),
(4,'Finanzas'),
(5,'Marketing');


/* insertar datos en empleado2 */
insert into empleado2 values
(1,'Juan',28,3500,'2022-03-15',1),
(2,'Sara',35,4500,'2019-06-20',2),
(3,'Mafe',32,4200,'2021-08-10',1),
(4,'Carlos',40,5000,'2018-01-25',4),
(5,'Freddy',29,3800,'2023-05-12',2),
(6,'Lukkaew',37,4100,'2020-09-18',3),
(7,'Camila',45,5500,'2017-11-30',4),
(8,'Nasser',31,3900,'2022-07-04',5),
(9,'Andrés',26,3200,'2024-02-14',1),
(10,'Emily',34,4600,'2021-04-22',2),
(11,'Emilio',30,3700,'2023-09-10',3),
(12,'Lina',38,4800,'2020-05-16',5),
(13,'Tatiana',27,3600,'2022-11-08',1),
(14,'Cindy',33,4300,'2021-06-25',4);


/* mostrar las tablas */
select * from departamento2;

select * from empleado2;


/* 1. lista de empleados */
/* obtener nombres, edades y salarios de todos los empleados */
select nombreEmpleado, edad, salario from empleado2;


/* 2. altos ingresos */
/* empleados que ganan mas de 4000 */
select nombreEmpleado, salario from empleado2 where salario > 4000;


/* 3. fuerza de ventas */
/* empleados que trabajan en el departamento de ventas */
select nombreEmpleado, nombreDepartamento from empleado2 inner join departamento2 on idDepartamentoFK = idDepartamento where nombreDepartamento = 'Ventas';


/* 4. rango de edad */
/* empleados que tienen entre 30 y 40 años */
select nombreEmpleado, edad from empleado2 where edad between 30 and 40;


/* 5. nuevas contrataciones */
/* empleados contratados despues del año 2020 */
select nombreEmpleado, fechaContratacion from empleado2 where fechaContratacion > '2020-12-31';


/* 6. distribucion de empleados */
/* cantidad de empleados que hay en cada departamento */
select nombreDepartamento, count(idEmpleado) as cantidadEmpleados from departamento2 left join empleado2 on idDepartamento = idDepartamentoFK group by nombreDepartamento;


/* 7. analisis salarial */
/* salario promedio de todos los empleados */
select avg(salario) as salarioPromedio from empleado2;


/* 8. nombres selectivos */
/* empleados cuyos nombres comienzan con A o C */
select nombreEmpleado from empleado2 where nombreEmpleado like 'A%' or nombreEmpleado like 'C%';


/* 9. departamentos especificos */
/* empleados que no pertenecen al departamento de IT */
select nombreEmpleado, nombreDepartamento from empleado2 inner join departamento2 on idDepartamentoFK = idDepartamento where nombreDepartamento <> 'IT';


/* 10. el mejor pagado */
/* ordenar los salarios de mayor a menor y mostrar el primero */
select nombreEmpleado, salario from empleado2 order by salario desc limit 1;
