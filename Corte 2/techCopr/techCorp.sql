/* crear base de datos */
create database techcorp3;

/* habilitar base de datos */
use techcorp3;


/* crear tabla departamento3 */
create table departamento3(
idDepartamento int primary key,
nombreDepartamento varchar(50) not null
);

/* crear tabla empleado3 */
create table empleado3(
idEmpleado int primary key,
nombreEmpleado varchar(50) not null,
edad int not null,
salario decimal(10,2) not null,
fechaContratacion date not null,
idDepartamentoFK int,
constraint fkempleadodepartamento3 foreign key (idDepartamentoFK) references departamento3(idDepartamento)
);


/* insertar datos en departamento3 */
insert into departamento3 values
(1,'Ventas'),
(2,'IT'),
(3,'Recursos Humanos'),
(4,'Finanzas'),
(5,'Marketing');


/* insertar datos en empleado3 */
insert into empleado3 values
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
select * from departamento3;
select * from empleado3;


/* 1. lista de empleados */

select nombreEmpleado, edad, salario from empleado3;


/* 2. altos ingresos */
/* empleados que ganan mas de 4000 */
select nombreEmpleado, salario from empleado3 where salario > 4000;


/* 3. fuerza de ventas */

select nombreEmpleado, idDepartamentoFK from empleado3 where idDepartamentoFK = 1;


/* 4. rango de edad */

select nombreEmpleado, edad from empleado3 where edad between 30 and 40;


/* 5. nuevas contrataciones */

select nombreEmpleado, fechaContratacion from empleado3 where fechaContratacion > '2020-12-31';


/* 6. distribucion de empleados */

select idDepartamentoFK, count(*) as cantidadEmpleados from empleado3 group by idDepartamentoFK;


/* 7. analisis salarial */

select avg(salario) as salarioPromedio from empleado3;


/* 8. nombres selectivos */

select nombreEmpleado from empleado3 where nombreEmpleado like 'A%' or nombreEmpleado like 'C%';


/* 9. departamentos especificos */

select nombreEmpleado, idDepartamentoFK from empleado3 where idDepartamentoFK <> 2;


/* 10. el mejor pagado */

select nombreEmpleado, salario from empleado3 where salario = (select max(salario) from empleado3);