
-- ======================================================================
-- GUIA COMPLETA DE ESTRUCTURAS SQL
-- ======================================================================



-- ======================================================================
-- 01. DIFERENCIA ENTRE DDL, DML Y CONSULTAS
-- ======================================================================

-- DDL = DATA DEFINITION LANGUAGE
-- Sirve para crear, cambiar o eliminar la ESTRUCTURA.

-- CREATE TABLE  -> crea una tabla.
-- ALTER TABLE   -> cambia la estructura de una tabla.
-- DROP TABLE    -> elimina la tabla completa.
-- TRUNCATE      -> vacia una tabla y conserva su estructura.


-- DML = DATA MANIPULATION LANGUAGE
-- Sirve para trabajar con los REGISTROS.

-- INSERT -> agrega registros.
-- UPDATE -> modifica registros.
-- DELETE -> elimina registros.


-- DQL = DATA QUERY LANGUAGE
-- SELECT -> consulta y muestra informacion.


-- DIFERENCIA IMPORTANTE:

-- DELETE:
-- Elimina filas, pero la tabla sigue existiendo.

delete from clientes
where id_cliente = 5;

-- Resultado:
-- El cliente 5 desaparece, pero la tabla clientes sigue existiendo.
-- ATENCION: solo ejecutarlo cuando realmente quiera borrar ese dato.


-- DROP TABLE:
-- Elimina la tabla completa con sus datos y estructura.

-- drop table clientes;

-- Resultado:
-- La tabla clientes deja de existir.
-- Lo dejo comentado para no eliminar mi tabla.


-- TRUNCATE:
-- Elimina todas las filas y conserva la tabla.

-- truncate table clientes;

-- Resultado:
-- La tabla queda vacia.
-- En MySQL normalmente reinicia el AUTO_INCREMENT.
-- No puedo hacer ROLLBACK normal de TRUNCATE porque es DDL.


-- ======================================================================
-- 02. CUANDO UTILIZO COMILLAS SIMPLES ' '
-- ======================================================================

-- LAS COMILLAS SIMPLES VAN EN VALORES DE TEXTO.

select *
from clientes
where tipo = 'HOSPITAL';

-- 'HOSPITAL' lleva comillas porque es un valor de texto.
-- tipo no lleva comillas porque es el nombre de una columna.


-- FECHAS: tambien escribo el valor entre comillas.

select *
from entregas
where fecha_programada >= '2026-09-01';


-- NUMEROS: normalmente no llevan comillas.

select *
from drones
where horas_vuelo > 500;


-- NULL: nunca va entre comillas.

select *
from clientes
where telefono is null;

-- NULL = ausencia de valor.
-- 'NULL' = texto que dice NULL. No significan lo mismo.


-- CON CONCAT:
-- Uso ' ' para poner un espacio literal entre dos columnas.

select concat(nombres, ' ', apellidos)
from pilotos;

-- Ejemplo de resultado: Mateo Zapata Vélez


-- OTRAS SEPARACIONES EN CONCAT:

select concat(nombres, ' - ', apellidos)
from pilotos;

-- Resultado ilustrativo: Mateo - Zapata Vélez


select concat(nombre, ' <', email, '>')
from clientes;

-- Resultado ilustrativo:
-- Hospital Ejemplo <contacto@hospital.com>


-- REGLA:
-- nombre          -> columna, sin comillas.
-- 'nombre'        -> texto literal, con comillas.
-- 500             -> numero, sin comillas.
-- 'ACTIVO'        -> texto, con comillas.
-- NULL            -> valor nulo, sin comillas.
-- ' '             -> espacio literal.
-- '_'             -> un guion bajo literal si se usa fuera de LIKE.
-- '%'             -> signo porcentaje literal fuera de LIKE.


-- ======================================================================
-- 03. CREATE DATABASE Y CREATE TABLE
-- ======================================================================

-- CUANDO SE USA:
-- Cuando me pidan crear una base de datos o una tabla.


-- ESTRUCTURA:

-- create database nombre_base;
-- use nombre_base;

-- create table nombre_tabla (
--     id int auto_increment primary key,
--     nombre varchar(80) not null
-- );


-- EJEMPLO:

create database if not exists practica_sql;
use practica_sql;

create table if not exists categorias (
    id_categoria int auto_increment primary key,
    nombre varchar(80) not null
);

-- Cree una tabla de categorias.
-- AUTO_INCREMENT genera el ID automaticamente.
-- PRIMARY KEY identifica cada registro.
-- NOT NULL obliga a registrar un nombre.

-- Resultado:
-- Se crea la tabla categorias con dos columnas.


-- ======================================================================
-- 04. TIPOS DE DATOS
-- ======================================================================

-- INT:
-- Para identificadores y cantidades enteras.

-- id_cliente int
-- unidades int


-- VARCHAR(n):
-- Para texto de longitud variable.
-- n indica la longitud maxima.

-- nombre varchar(80)
-- telefono varchar(15)

-- Uso VARCHAR para telefono porque no voy a sumarlo
-- y puede necesitar conservar ceros iniciales.


-- CHAR(n):
-- Para textos de longitud fija.

-- licencia char(1)

-- Ejemplo: 'A', 'B' o 'C'.


-- DECIMAL(total, decimales):
-- Para valores numericos que requieren precision.

-- precio decimal(10,2)
-- peso decimal(6,2)

-- DECIMAL(10,2) permite hasta 10 digitos en total,
-- de los cuales 2 van despues del punto decimal.


-- DATE:
-- Fecha sin hora.

-- fecha_registro date

-- Ejemplo: '2026-10-22'


-- DATETIME:
-- Fecha con hora.

-- fecha_programada datetime

-- Ejemplo: '2026-10-22 08:30:00'


-- BOOLEAN:
-- Verdadero o falso.
-- En MySQL funciona como un tipo equivalente a TINYINT(1).

-- requiere_frio boolean


-- ======================================================================
-- 05. PRIMARY KEY
-- ======================================================================

-- QUE HACE:
-- Identifica de manera unica cada fila.
-- No permite valores NULL ni repetidos.


-- ESTRUCTURA 1: EN LA MISMA COLUMNA

-- id int auto_increment primary key


-- EJEMPLO:

create table if not exists productos (
    id_producto int auto_increment primary key,
    nombre varchar(80) not null,
    precio decimal(10,2) not null
);

-- Cree id_producto como PRIMARY KEY porque cada producto
-- necesita un identificador unico.

-- Resultado:
-- Los productos se pueden identificar por su ID.


-- ESTRUCTURA 2: PRIMARY KEY AL FINAL

-- create table tabla (
--     id int not null,
--     nombre varchar(80),
--     primary key (id)
-- );


-- ======================================================================
-- 06. PRIMARY KEY COMPUESTA
-- ======================================================================

-- CUANDO SE USA:
-- Cuando necesito combinar DOS O MAS columnas
-- para identificar una fila.

-- Es frecuente en una TABLA INTERMEDIA.


-- ESTRUCTURA:

-- primary key (id_tabla1, id_tabla2)


-- EJEMPLO:

create table if not exists estudiantes (
    id_estudiante int auto_increment primary key,
    nombre varchar(80) not null
);

create table if not exists cursos (
    id_curso int auto_increment primary key,
    nombre varchar(80) not null
);

create table if not exists inscripciones (
    id_estudiante int not null,
    id_curso int not null,
    fecha_inscripcion date not null,

    primary key (id_estudiante, id_curso),

    foreign key (id_estudiante)
    references estudiantes(id_estudiante),

    foreign key (id_curso)
    references cursos(id_curso)
);

-- Cree inscripciones como tabla intermedia porque
-- un estudiante puede tener varios cursos
-- y un curso puede tener varios estudiantes.

-- Use PRIMARY KEY COMPUESTA para que el mismo estudiante
-- no quede inscrito dos veces en el mismo curso.

-- Resultado:
-- (1,2) y (1,3) son combinaciones diferentes.
-- Repetir (1,2) genera error de clave duplicada.


-- ======================================================================
-- 07. FOREIGN KEY
-- ======================================================================

-- QUE HACE:
-- Relaciona una tabla con otra.
-- La FK normalmente se coloca en el lado MUCHOS (N).


-- ESTRUCTURA:

-- foreign key (columna_hija)
-- references tabla_padre(columna_pk);


-- EJEMPLO:

create table if not exists pedidos_ejemplo (
    id_pedido int auto_increment primary key,
    id_cliente int not null,
    fecha date not null,

    foreign key (id_cliente)
    references clientes(id_cliente)
);

-- Puse id_cliente como FOREIGN KEY porque cada pedido
-- pertenece a un cliente ya registrado.

-- Resultado:
-- No permite registrar un id_cliente que no exista
-- en la tabla clientes.


-- ======================================================================
-- 08. CONSTRAINT
-- ======================================================================

-- QUE ES:
-- CONSTRAINT sirve para darle un NOMBRE a una restriccion.

-- No siempre es obligatorio escribir CONSTRAINT,
-- pero ayuda a reconocer errores y restricciones.

-- Puede utilizarse con:
-- PRIMARY KEY
-- FOREIGN KEY
-- UNIQUE
-- CHECK


-- ESTRUCTURA CON CHECK:

-- constraint nombre_restriccion
-- check (condicion)


-- EJEMPLO:

create table if not exists inventario_ejemplo (
    id_producto int auto_increment primary key,
    cantidad int not null,

    constraint chk_cantidad
    check (cantidad >= 0)
);

-- Use CHECK porque no quiero cantidades negativas.
-- Le puse el nombre chk_cantidad para identificar la regla.

-- Resultado:
-- cantidad = 5  -> permitido.
-- cantidad = -2 -> error.


-- ESTRUCTURA CON FOREIGN KEY:

-- constraint nombre_restriccion
-- foreign key (columna_hija)
-- references tabla_padre(columna_pk);


-- EJEMPLO:

create table if not exists pedidos_fk_ejemplo (
    id_pedido int auto_increment primary key,
    id_cliente int not null,

    constraint fk_pedidos_cliente
    foreign key (id_cliente)
    references clientes(id_cliente)
);

-- Use CONSTRAINT para darle nombre a la FK.
-- La regla garantiza que el cliente exista.


-- CONSTRAINT CON PRIMARY KEY:

-- constraint pk_nombre
-- primary key (id);


-- EJEMPLO:

create table if not exists zonas_ejemplo (
    id_zona int not null,
    nombre varchar(50),

    constraint pk_zonas
    primary key (id_zona)
);


-- CONSTRAINT CON PRIMARY KEY COMPUESTA:

-- constraint pk_relacion
-- primary key (id_a, id_b);


-- CONSTRAINT CON UNIQUE:

-- constraint uq_correo
-- unique (email);

-- UNIQUE evita duplicados en los valores no nulos.
-- MySQL permite varios NULL en una columna UNIQUE.


-- ======================================================================
-- 09. NOT NULL, UNIQUE, DEFAULT Y CHECK
-- ======================================================================

-- NOT NULL:
-- Obliga a registrar un valor.

-- nombre varchar(80) not null


-- UNIQUE:
-- No permite repetir un valor no nulo.

-- email varchar(100) unique


-- DEFAULT:
-- Asigna un valor automaticamente cuando se omite la columna.

-- estado varchar(20) default 'ACTIVO'


-- CHECK:
-- Comprueba una regla.

-- check (precio > 0)
-- check (edad >= 18)
-- check (estado in ('ACTIVO','INACTIVO'))


-- EJEMPLO COMPLETO:

create table if not exists equipos_ejemplo (
    id_equipo int auto_increment primary key,
    codigo varchar(20) not null unique,
    estado varchar(15) not null default 'ACTIVO',
    capacidad decimal(5,2) not null,

    constraint chk_equipo_capacidad
    check (capacidad > 0),

    constraint chk_equipo_estado
    check (estado in ('ACTIVO','INACTIVO'))
);

-- Cree estas restricciones para evitar datos invalidos.

-- Resultado:
-- No acepta capacidad negativa.
-- No acepta estados diferentes a ACTIVO e INACTIVO.
-- No acepta codigos duplicados.


-- ======================================================================
-- 10. ALTER TABLE
-- ======================================================================

-- CUANDO SE USA:
-- Cuando la tabla ya existe y debo cambiar su estructura.


-- AGREGAR COLUMNA:

-- alter table tabla
-- add column nueva_columna tipo;


-- EJEMPLO:

alter table categorias
add column descripcion varchar(150);

-- Agregue una columna nueva sin eliminar la tabla.
-- Resultado: ahora categorias tiene descripcion.


-- CAMBIAR TIPO O TAMAÑO:

-- alter table tabla
-- modify column columna nuevo_tipo;


-- EJEMPLO:

alter table categorias
modify column nombre varchar(120) not null;

-- Amplie el nombre de 80 a 120 caracteres.
-- Conserve NOT NULL porque seguia siendo obligatorio.


-- ELIMINAR COLUMNA:

-- alter table tabla
-- drop column columna;


-- AGREGAR CONSTRAINT CHECK:

-- alter table tabla
-- add constraint nombre
-- check (condicion);


-- EJEMPLO:

alter table productos
add constraint chk_productos_precio
check (precio > 0);

-- Agregue la regla despues de crear la tabla.
-- Resultado: no permite precios de cero o negativos.


-- AGREGAR FOREIGN KEY CON CONSTRAINT:

-- alter table tabla_hija
-- add constraint fk_nombre
-- foreign key (id_padre)
-- references tabla_padre(id_padre);


-- EJEMPLO ILUSTRATIVO:

-- alter table entregas
-- add constraint fk_entregas_cliente
-- foreign key (id_cliente)
-- references clientes(id_cliente);

-- La dejo comentada porque en el simulacro
-- esa FK ya se creo y duplicarla seria innecesario.


-- AGREGAR PRIMARY KEY CON CONSTRAINT:

-- alter table tabla
-- add constraint pk_nombre
-- primary key (id);

-- Si la tabla ya tiene PRIMARY KEY, no agrego otra.


-- AGREGAR UNIQUE:

-- alter table tabla
-- add constraint uq_nombre
-- unique (columna);


-- ELIMINAR RESTRICCION CHECK:

-- alter table tabla
-- drop check chk_nombre;


-- ELIMINAR FOREIGN KEY:

-- alter table tabla
-- drop foreign key fk_nombre;


-- ======================================================================
-- 11. INSERT INTO
-- ======================================================================

-- CUANDO SE USA:
-- Cuando necesito AGREGAR filas.


-- ESTRUCTURA:

-- insert into tabla (columna1, columna2)
-- values (valor1, valor2);


-- EJEMPLO:

insert into categorias (nombre, descripcion)
values ('Medicamentos', 'Productos de salud');

-- Agregue una categoria.
-- Resultado: se crea una fila nueva.


-- INSERTAR VARIAS FILAS:

insert into categorias (nombre, descripcion)
values
('Vacunas', 'Requieren control'),
('Documentos', 'Papeleria'),
('Repuestos', 'Partes de equipos');

-- Use un INSERT con varias filas para ahorrar instrucciones.
-- Resultado: agrega tres categorias.


-- ======================================================================
-- 12. UPDATE
-- ======================================================================

-- CUANDO SE USA:
-- Cuando quiero CAMBIAR datos existentes.


-- ESTRUCTURA:

-- update tabla
-- set columna = nuevo_valor
-- where condicion;


-- EJEMPLO:

update categorias
set descripcion = 'Productos farmaceuticos'
where nombre = 'Medicamentos';

-- Cambie la descripcion de una categoria.
-- WHERE selecciona la fila que voy a actualizar.


-- IMPORTANTE:
-- UPDATE sin WHERE puede modificar TODAS las filas.


-- ======================================================================
-- 13. DELETE
-- ======================================================================

-- CUANDO SE USA:
-- Cuando necesito ELIMINAR registros.


-- ESTRUCTURA:

-- delete from tabla
-- where condicion;


-- EJEMPLO:

delete from categorias
where nombre = 'Documentos';

-- Elimine solamente la categoria Documentos.
-- La tabla categorias sigue existiendo.


-- DIFERENCIA:
-- DELETE  -> elimina filas.
-- DROP    -> elimina la tabla.
-- TRUNCATE -> elimina todas las filas y conserva la tabla.


-- ======================================================================
-- 14. SELECT BASICO
-- ======================================================================

-- CUANDO SE USA:
-- Cuando quiero CONSULTAR datos.


-- TODAS LAS COLUMNAS:

select *
from drones;

-- * significa todas las columnas.


-- COLUMNAS ESPECIFICAS:

select codigo_serie, modelo, estado
from drones;

-- Muestra solamente esas tres columnas.


-- ALIAS CON AS:

select codigo_serie as codigo
from drones;

-- AS cambia el nombre mostrado en el resultado.
-- AS es opcional en muchos alias.

select codigo_serie codigo
from drones;

-- Produce el mismo alias "codigo".


-- ======================================================================
-- 15. WHERE Y OPERADORES
-- ======================================================================

-- WHERE sirve para FILTRAR FILAS.
-- Lo que viene despues es la condicion.


-- IGUAL:

select *
from drones
where estado = 'ACTIVO';


-- DIFERENTE:
-- <> y != significan DISTINTO DE.

select *
from drones
where estado <> 'RETIRADO';

select *
from drones
where estado != 'RETIRADO';

-- Ambas consultas buscan drones no retirados.


-- MAYOR QUE:

select *
from drones
where horas_vuelo > 500;


-- MENOR QUE:

select *
from drones
where horas_vuelo < 200;


-- MAYOR O IGUAL:

select *
from drones
where autonomia_km >= 60;


-- MENOR O IGUAL:

select *
from drones
where horas_vuelo <= 300;


-- AND:
-- Deben cumplirse TODAS las condiciones.

select *
from drones
where estado = 'ACTIVO'
and horas_vuelo < 300;


-- OR:
-- Basta con cumplir una condicion.

select *
from drones
where estado = 'ACTIVO'
or estado = 'MANTENIMIENTO';


-- PARENTESIS:
-- Agrupo condiciones para que se evalúen juntas.

select *
from drones
where estado = 'ACTIVO'
and (
    horas_vuelo < 200
    or autonomia_km > 80
);


-- NOT:
-- Niega una condicion.

select *
from pilotos
where not (licencia = 'A');


-- BETWEEN:
-- Incluye ambos limites.

select *
from drones
where horas_vuelo between 100 and 500;


-- IN:
-- Comprueba si un valor esta dentro de una lista.

select *
from entregas
where prioridad in ('URGENTE','VITAL');


-- NOT IN:
-- Comprueba si un valor NO esta en una lista.

select *
from entregas
where estado not in ('CANCELADA','FALLIDA');


-- IS NULL:
-- Busca valores ausentes.

select *
from clientes
where telefono is null;


-- IS NOT NULL:
-- Busca valores existentes.

select *
from clientes
where telefono is not null;


-- ======================================================================
-- 16. LIKE - TODOS LOS PATRONES IMPORTANTES
-- ======================================================================

-- LIKE sirve para buscar texto que cumpla un PATRON.

-- % = cero o mas caracteres.
-- _ = exactamente un caracter.


-- EMPIEZA POR "MAR":

select *
from clientes
where nombre like 'Mar%';

-- Encuentra nombres que empiecen por Mar.


-- TERMINA EN "ANA":

select *
from clientes
where nombre like '%ana';

-- Encuentra textos que terminen en ana.


-- CONTIENE "HOSPITAL":

select *
from clientes
where nombre like '%Hospital%';

-- La palabra puede aparecer en cualquier posicion.


-- SEGUNDA LETRA = A:

select *
from clientes
where nombre like '_a%';

-- _ ocupa exactamente el primer caracter.
-- a es la segunda letra.


-- EXACTAMENTE TRES CARACTERES:

-- where codigo like '___';


-- EMPIEZA CON A Y TERMINA CON Z:

-- where nombre like 'A%Z';


-- TERMINA CON @GMAIL.COM:

select *
from clientes
where email like '%@gmail.com';


-- NO TERMINA CON @GMAIL.COM:

select *
from clientes
where email not like '%@gmail.com';

-- Los NULL no cumplen normalmente esta condicion;
-- si quiero incluirlos, debo usar OR email IS NULL.


-- EJEMPLO DEL SIMULACRO:
-- Serie DA-CX + 1 caracter + - + 2 caracteres.

select codigo_serie
from drones
where codigo_serie like 'DA-CX_-__';


-- BUSCAR PORCENTAJE LITERAL:

-- En LIKE el % es comodin.
-- Si quiero buscar el simbolo % de verdad, lo escapo.

select '20%' like '20\\%' as coincide_porcentaje;

-- Resultado esperado: 1, si el patron se interpreta
-- con barra invertida como escape.
-- Para evitar diferencias por configuracion, puedo usar ESCAPE.


-- ======================================================================
-- 17. REGEXP - EXPRESIONES REGULARES
-- ======================================================================

-- REGEXP sirve para patrones mas complejos que LIKE.
-- No es lo mismo que LIKE.

-- ^  = inicio del texto.
-- $  = final del texto.
-- .  = cualquier caracter (segun configuracion).
-- *  = cero o mas repeticiones.
-- +  = una o mas repeticiones.
-- ?  = cero o una repeticion.
-- {n} = exactamente n repeticiones.
-- {n,m} = entre n y m repeticiones.
-- [abc] = uno de esos caracteres.
-- [0-9] = un digito.
-- [A-Z] = una mayuscula.
-- [^0-9] = caracter que NO sea digito.
-- | = alternativa: una cosa O la otra.
-- () = agrupar alternativas o partes del patron.


-- EMPIEZA POR A:

select *
from clientes
where nombre regexp '^A';


-- TERMINA EN Z:

select *
from clientes
where nombre regexp 'z$';


-- CONTIENE UNO O MAS DIGITOS:

select *
from clientes
where nit_documento regexp '[0-9]+';


-- TELEFONO CON EXACTAMENTE 10 DIGITOS:

select *
from clientes
where telefono regexp '^[0-9]{10}$';

-- ^ empieza.
-- [0-9] acepta solo digitos.
-- {10} exige diez.
-- $ termina.

-- Resultado:
-- Solo telefonos de diez digitos.


-- LETRA A, B O C:

select *
from pilotos
where licencia regexp '^[ABC]$';


-- EMPIEZA POR ANA O MARIA:

select *
from clientes
where nombre regexp '^(Ana|María)';


-- NO CONTIENE DIGITOS:

select *
from clientes
where nombre not regexp '[0-9]';


-- DIFERENCIA:
-- LIKE es facil para empieza, termina y contiene.
-- REGEXP es mejor para formatos, cantidad de repeticiones,
-- alternativas y conjuntos de caracteres.


-- ======================================================================
-- 18. FUNCIONES DE TEXTO
-- ======================================================================

-- UNA FUNCION recibe un valor, hace algo y devuelve un resultado.


-- UPPER:
-- Convierte un texto a mayusculas.

select upper('María') as resultado;

-- Resultado: MARÍA.


-- LOWER:
-- Convierte un texto a minusculas.

select lower('HOSPITAL') as resultado;

-- Resultado: hospital.


-- LENGTH:
-- Cuenta BYTES del texto.

select length('Maria') as resultado;

-- Resultado en UTF-8: 5.


-- CHAR_LENGTH:
-- Cuenta CARACTERES del texto.

select char_length('María') as resultado;

-- Resultado: 5.

select length('María') as resultado;

-- Resultado habitual en UTF-8: 6.
-- La í ocupa dos bytes en UTF-8.


-- CUANDO UTILIZO CADA UNA:
-- LENGTH -> cuando me piden longitud en bytes.
-- CHAR_LENGTH -> cuando me piden cantidad de caracteres.

-- Para validar telefonos de 10 caracteres:

select nombre, telefono
from clientes
where char_length(telefono) = 10;


-- TRIM:
-- Quita espacios al comienzo y al final.

select trim('   Ana   ') as resultado;

-- Resultado: Ana.


-- CONCAT:
-- Une textos y columnas.

select concat('Ana',' ','Pérez') as resultado;

-- Resultado: Ana Pérez.


-- COALESCE:
-- Reemplaza un NULL con otro valor.

select coalesce(null,'SIN TELEFONO') as resultado;

-- Resultado: SIN TELEFONO.


-- CON DATOS REALES:

select
    nombre,
    coalesce(telefono,'SIN TELEFONO') as telefono
from clientes;

-- Si no hay telefono, muestra el texto SIN TELEFONO.


-- ======================================================================
-- 19. FUNCIONES NUMERICAS
-- ======================================================================

-- ABS:
-- Convierte un numero negativo en positivo.

select abs(-15) as resultado;

-- Resultado: 15.


-- ROUND:
-- Redondea a una cantidad de decimales.

select round(15.678,2) as resultado;

-- Resultado: 15.68.


-- SQRT:
-- Calcula la raiz cuadrada.

select sqrt(81) as resultado;

-- Resultado: 9.


-- ======================================================================
-- 20. FUNCIONES DE AGREGACION
-- ======================================================================

-- COUNT(*) -> cuenta filas.
-- COUNT(columna) -> cuenta valores NO NULL.
-- SUM(columna) -> suma cantidades.
-- AVG(columna) -> calcula un promedio.
-- MAX(columna) -> devuelve el mayor valor.
-- MIN(columna) -> devuelve el menor valor.


-- CONTAR ENTREGAS:

select count(*)
from entregas;

-- Resultado: un numero con la cantidad total de entregas.


-- SUMAR COSTOS:

select sum(costo)
from mantenimientos;

-- Resultado: costo total.


-- PROMEDIO:

select avg(costo)
from mantenimientos;

-- Resultado: costo promedio.


-- MAXIMO:

select max(horas_vuelo)
from drones;

-- Resultado: las horas de vuelo mas altas.


-- MINIMO:

select min(horas_vuelo)
from drones;

-- Resultado: las horas de vuelo mas bajas.


-- COMBINAR FUNCIONES:

select round(avg(costo),2)
from mantenimientos;

-- Primero AVG calcula el promedio.
-- Luego ROUND lo redondea a dos decimales.


-- ======================================================================
-- 21. CASE WHEN
-- ======================================================================

-- QUE ES:
-- CASE sirve para CLASIFICAR o PRODUCIR un resultado
-- dependiendo de una condicion.

-- LO PIENSO ASI:
-- SI SE CUMPLE UNA CONDICION, MUESTRO UN RESULTADO.
-- SI NO SE CUMPLE, REVISO OTRA CONDICION.
-- SI NINGUNA SE CUMPLE, MUESTRO EL ELSE.


-- ESTRUCTURA:

-- case
--     when condicion then resultado
--     when otra_condicion then otro_resultado
--     else resultado_final
-- end


-- EJEMPLO:

select
    codigo_serie,
    horas_vuelo,
    case
        when horas_vuelo > 500 then 'ALTO'
        when horas_vuelo >= 200 then 'MEDIO'
        else 'BAJO'
    end as nivel_uso
from drones;

-- Si tiene mas de 500 horas, muestra ALTO.
-- Si tiene entre 200 y 500, muestra MEDIO.
-- Si tiene menos de 200, muestra BAJO.

-- CASE no modifica los datos de la tabla.
-- Solo crea una clasificacion en el resultado del SELECT.


-- EJEMPLO CON CALCULO:

select
    id_entrega,
    prioridad,
    case
        when prioridad = 'URGENTE' then 1.20
        else 1.00
    end as factor_recargo
from entregas;

-- URGENTE -> 1.20
-- Otras prioridades -> 1.00


-- ======================================================================
-- 22. GROUP BY
-- ======================================================================

-- QUE HACE:
-- GROUP BY junta registros que comparten un valor.

-- MI FORMA DE RECORDARLO:
-- "POR QUE QUIERO SEPARAR EL RESULTADO".

-- Si dice:
-- cantidad de clientes POR municipio
-- agrupo por municipio.

-- Si dice:
-- entregas POR estado
-- agrupo por estado.

-- Si dice:
-- promedio de costos POR dron
-- agrupo por id_dron.


-- ESTRUCTURA:

-- select columna_grupo, funcion_agregada(columna)
-- from tabla
-- group by columna_grupo;


-- EJEMPLO CON COUNT:

select estado, count(*)
from entregas
group by estado;

-- Agrupe por estado para saber cuantas entregas
-- hay en cada uno.

-- Resultado ilustrativo:
-- ENTREGADA  -> 12
-- CANCELADA  -> 3
-- PROGRAMADA -> 2


-- EJEMPLO CON SUM:

select id_dron, sum(costo)
from mantenimientos
group by id_dron;

-- Agrupe por dron y sume sus costos de mantenimiento.


-- ======================================================================
-- 23. WHERE + GROUP BY
-- ======================================================================

-- WHERE filtra FILAS ANTES de agrupar.

-- LO UTILIZO CUANDO:
-- Quiero agrupar solamente los registros
-- que cumplan una condicion.


-- ESTRUCTURA:

-- select columna_grupo, count(*)
-- from tabla
-- where condicion
-- group by columna_grupo;


-- EJEMPLO:

select id_piloto, count(*)
from entregas
where estado = 'ENTREGADA'
group by id_piloto;

-- Primero deje solo las entregas ENTREGADA.
-- Despues conte cuantas hizo cada piloto.

-- Resultado:
-- Una fila por piloto con su cantidad de entregas realizadas.


-- ======================================================================
-- 24. GROUP BY + HAVING
-- ======================================================================

-- HAVING FILTRA GRUPOS DESPUES de agrupar.

-- LO UTILIZO CUANDO:
-- Quiero dejar solamente los grupos cuyo conteo,
-- suma, promedio, maximo o minimo cumpla una condicion.


-- ESTRUCTURA:

-- select columna_grupo, count(*)
-- from tabla
-- group by columna_grupo
-- having count(*) > numero;


-- EJEMPLO:

select id_piloto, count(*)
from entregas
group by id_piloto
having count(*) >= 3;

-- Primero conte entregas por piloto.
-- Luego deje solamente pilotos que tienen 3 o mas entregas.


-- DIFERENCIA QUE DEBO RECORDAR:

-- GROUP BY:
-- Separo por grupos.

-- WHERE + GROUP BY:
-- Primero filtro filas y luego agrupo.

-- GROUP BY + HAVING:
-- Primero agrupo y luego filtro grupos.


-- ======================================================================
-- 25. WHERE + GROUP BY + HAVING
-- ======================================================================

-- LO UTILIZO CUANDO:
-- Necesito filtrar filas, agruparlas
-- y luego filtrar los grupos que cumplen un calculo.


-- EJEMPLO:

select
    id_cliente,
    count(*) as total_entregas
from entregas
where estado = 'ENTREGADA'
group by id_cliente
having count(*) >= 2;

-- WHERE:
-- Primero dejo solo entregas realizadas.

-- GROUP BY:
-- Las separo por cliente.

-- HAVING:
-- Dejo los clientes con 2 o mas entregas realizadas.

-- Resultado:
-- Una fila por cada cliente que cumpla el minimo.


-- ======================================================================
-- 26. ORDER BY, DISTINCT, LIMIT Y OFFSET
-- ======================================================================

-- ORDER BY ASC -> orden ascendente.
-- ORDER BY DESC -> orden descendente.

select codigo_serie, horas_vuelo
from drones
order by horas_vuelo desc;

-- Muestra primero las horas de vuelo mayores.


-- DISTINCT:
-- Elimina valores repetidos del resultado.

select distinct municipio
from clientes;

-- Muestra una sola vez cada municipio.


-- LIMIT:
-- Limita la cantidad de filas mostradas.

select *
from drones
limit 3;

-- Muestra maximo tres filas.


-- OFFSET:
-- Salta una cantidad de filas.

select *
from drones
order by id_dron
limit 3 offset 2;

-- Salta las primeras dos filas
-- y muestra las tres siguientes.


-- ======================================================================
-- 27. INNER JOIN
-- ======================================================================

-- QUE HACE:
-- Une dos tablas mediante una columna relacionada.
-- Muestra solamente las filas que tienen coincidencia
-- entre ambas tablas.

-- LO UTILIZO CUANDO:
-- El resultado necesita columnas de diferentes tablas.


-- ESTRUCTURA:

-- select a.columna, b.columna
-- from tabla1 a
-- inner join tabla2 b
--     on a.pk = b.fk;

-- Tambien puede escribirse:
-- on a.fk = b.pk;


-- EJEMPLO:

select
    e.codigo,
    c.nombre
from entregas e
inner join clientes c
    on e.id_cliente = c.id_cliente;

-- Use INNER JOIN porque codigo esta en entregas
-- y nombre del cliente esta en clientes.
-- Relacione las tablas por id_cliente.

-- Resultado:
-- Muestra el codigo de la entrega junto al cliente.


-- ======================================================================
-- 28. INNER JOIN CON TRES TABLAS
-- ======================================================================

-- ESTRUCTURA:

-- select a.columna, b.columna, c.columna
-- from tabla1 a
-- inner join tabla2 b on a.fk = b.pk
-- inner join tabla3 c on a.otra_fk = c.pk;


-- EJEMPLO:

select
    e.codigo,
    c.nombre,
    d.codigo_serie
from entregas e
inner join clientes c
    on e.id_cliente = c.id_cliente
inner join drones d
    on e.id_dron = d.id_dron;

-- Necesitaba datos de tres tablas.
-- Relacione entregas con clientes y con drones.

-- Resultado:
-- codigo de entrega, nombre del cliente y serie del dron.


-- ======================================================================
-- 29. INNER JOIN CON CUATRO TABLAS
-- ======================================================================

select
    e.codigo,
    c.nombre,
    d.codigo_serie,
    p.nombres
from entregas e
inner join clientes c
    on e.id_cliente = c.id_cliente
inner join drones d
    on e.id_dron = d.id_dron
inner join pilotos p
    on e.id_piloto = p.id_piloto;

-- Cada JOIN agrega otra tabla relacionada.
-- Resultado:
-- entrega, cliente, dron y piloto.


-- ======================================================================
-- 30. LEFT JOIN
-- ======================================================================

-- QUE HACE:
-- Muestra TODOS los registros de la tabla izquierda
-- aunque no tengan relacion en la tabla derecha.

-- LO UTILIZO CUANDO DIGA:
-- "Mostrar todos, incluso los que no tengan...".


-- ESTRUCTURA:

-- select a.columna, b.columna
-- from tabla1 a
-- left join tabla2 b
--     on a.pk = b.fk;


-- EJEMPLO:

select
    c.nombre,
    e.codigo
from clientes c
left join entregas e
    on c.id_cliente = e.id_cliente;

-- Use LEFT JOIN porque quiero mostrar TODOS los clientes,
-- incluyendo los que no tienen entregas.

-- Resultado:
-- Los clientes sin entregas aparecen con codigo NULL.


-- ======================================================================
-- 31. LEFT JOIN + IS NULL
-- ======================================================================

-- LO UTILIZO CUANDO:
-- Quiero encontrar los registros SIN relacion.


-- EJEMPLO:

select c.nombre
from clientes c
left join entregas e
    on c.id_cliente = e.id_cliente
where e.id_entrega is null;

-- Use LEFT JOIN para conservar todos los clientes.
-- Use IS NULL para dejar solamente los que no tienen entregas.

-- Resultado:
-- Clientes que nunca han tenido entregas.


-- ======================================================================
-- 32. SELF JOIN
-- ======================================================================

-- QUE ES:
-- Una tabla unida consigo misma.

-- LO UTILIZO CUANDO:
-- Un registro depende de otro registro de la misma tabla.
-- Ejemplo: piloto y supervisor.


-- ESTRUCTURA:

-- select a.nombre, b.nombre
-- from tabla a
-- left join tabla b
--     on a.id_supervisor = b.id;


-- EJEMPLO:

select
    concat(p.nombres,' ',p.apellidos) as piloto,
    concat(s.nombres,' ',s.apellidos) as supervisor
from pilotos p
left join pilotos s
    on p.id_supervisor = s.id_piloto;

-- Use dos alias porque ambos datos salen de pilotos.
-- p representa al piloto.
-- s representa al supervisor.

-- Resultado:
-- Muestra piloto y supervisor.
-- Si no tiene supervisor, aparece NULL.


-- ======================================================================
-- 33. JOIN CON TABLA INTERMEDIA N:M
-- ======================================================================

-- CUANDO SE USA:
-- Cuando tengo una relacion muchos a muchos.

-- Ejemplo DronAndes:
-- entregas -> carga_entrega -> tipos_carga


select
    e.codigo,
    t.nombre,
    ce.peso_kg
from entregas e
inner join carga_entrega ce
    on e.id_entrega = ce.id_entrega
inner join tipos_carga t
    on ce.id_tipo = t.id_tipo;

-- Primero uno entregas con carga_entrega.
-- Luego uno carga_entrega con tipos_carga.

-- Resultado:
-- Muestra cada entrega, tipo de carga y peso.
-- Una entrega puede aparecer en varias filas si tiene
-- varios tipos de carga.


-- ======================================================================
-- 34. SUBCONSULTAS: EXPLICACION GENERAL
-- ======================================================================

-- QUE ES:
-- Una consulta SELECT dentro de otra consulta.

-- MI FORMA DE ENTENDERLO:
-- Primero necesito averiguar ALGO con un SELECT.
-- Despues utilizo ese resultado en otro SELECT.

-- Normalmente la subconsulta va entre parentesis.


-- OPERADORES POSIBLES:
-- >
-- <
-- =
-- >=
-- <=
-- <>
-- IN
-- NOT IN
-- EXISTS
-- NOT EXISTS

-- La eleccion depende de lo que diga el enunciado.


-- ======================================================================
-- 35. SUBCONSULTA ESCALAR
-- ======================================================================

-- ESCALAR = devuelve UN SOLO VALOR.

-- EJEMPLOS DE FUNCIONES QUE PUEDO USAR:
-- AVG -> promedio.
-- SUM -> suma.
-- COUNT -> cantidad.
-- MAX -> mayor valor.
-- MIN -> menor valor.

-- NO SIGNIFICA QUE SIEMPRE DEBA USAR ESAS FUNCIONES.
-- Solo necesito que la subconsulta devuelva un valor.


-- ESTRUCTURA:

-- select columnas
-- from tabla
-- where columna operador (
--     select calculo_o_columna
--     from tabla
-- );


-- EJEMPLO CON AVG:

select codigo_serie, horas_vuelo
from drones
where horas_vuelo > (
    select avg(horas_vuelo)
    from drones
);

-- Primero calculo el promedio general de horas.
-- Despues muestro los drones superiores al promedio.


-- EJEMPLO CON MAX:

select codigo_serie, horas_vuelo
from drones
where horas_vuelo = (
    select max(horas_vuelo)
    from drones
);

-- Primero busco el maximo.
-- Despues muestro los drones que tengan ese valor.


-- EJEMPLO CON MIN:

select codigo_serie, horas_vuelo
from drones
where horas_vuelo < (
    select min(horas_vuelo)
    from drones
);

-- Esta consulta normalmente no devuelve registros:
-- ningun valor puede ser menor que el minimo de ese
-- mismo conjunto.


-- ======================================================================
-- 36. SUBCONSULTA CON IN
-- ======================================================================

-- IN pregunta:
-- "Este valor aparece dentro de los resultados?"

-- NO SIEMPRE SE USA CON IDENTIFICADORES.
-- Puedo comparar ciudades, categorias, nombres u otros valores.


-- ESTRUCTURA:

-- select columnas
-- from tabla1
-- where columna in (
--     select columna
--     from tabla2
-- );


-- EJEMPLO:

select nombre
from clientes
where id_cliente in (
    select id_cliente
    from entregas
);

-- Primero busco los IDs de clientes que aparecen en entregas.
-- Despues muestro los clientes que estan en esa lista.

-- Resultado:
-- Clientes que tienen por lo menos una entrega.


-- ======================================================================
-- 37. SUBCONSULTA CON NOT IN
-- ======================================================================

-- NOT IN pregunta:
-- "Este valor NO aparece en los resultados?"

-- IMPORTANTE:
-- Si la subconsulta puede devolver NULL,
-- NOT IN puede producir resultados inesperados.
-- En esos casos prefiero NOT EXISTS.


-- EJEMPLO:

select nombre
from clientes
where id_cliente not in (
    select id_cliente
    from entregas
);

-- Use NOT IN para excluir los IDs presentes en entregas.

-- Resultado:
-- Clientes que nunca han tenido una entrega.


-- ======================================================================
-- 38. EXISTS
-- ======================================================================

-- EXISTS pregunta:
-- "Existe al menos una fila relacionada?"

-- SELECT 1:
-- No importa el valor que devuelva.
-- EXISTS solo comprueba si existe una fila.


-- ESTRUCTURA:

-- select columnas
-- from tabla1 a
-- where exists (
--     select 1
--     from tabla2 b
--     where b.fk = a.pk
-- );


-- EJEMPLO:

select c.nombre
from clientes c
where exists (
    select 1
    from entregas e
    where e.id_cliente = c.id_cliente
);

-- Para cada cliente busco si tiene alguna entrega.
-- Si encuentro por lo menos una, lo muestro.

-- Resultado:
-- Clientes con entregas registradas.


-- ======================================================================
-- 39. NOT EXISTS
-- ======================================================================

-- NOT EXISTS pregunta:
-- "No existe ninguna fila relacionada?"

-- LO UTILIZO CUANDO DIGA:
-- "Nunca ha tenido..."
-- "Sin registros asociados..."
-- "No tiene..."


-- EJEMPLO:

select d.codigo_serie
from drones d
where not exists (
    select 1
    from mantenimientos m
    where m.id_dron = d.id_dron
);

-- Para cada dron busco mantenimientos.
-- Si no encuentra ninguno, muestra el dron.

-- Resultado:
-- Drones que nunca han tenido mantenimientos.


-- ======================================================================
-- 40. SUBCONSULTA CORRELACIONADA
-- ======================================================================

-- QUE ES:
-- Una subconsulta que utiliza un dato de la consulta externa.

-- MI FORMA DE RECORDARLO:
-- No quiero un promedio GENERAL.
-- Quiero un promedio que corresponda a CADA GRUPO.

-- EJEMPLO:
-- Drones con mas horas que el promedio de SU MISMA BASE.


select
    d.codigo_serie,
    d.horas_vuelo
from drones d
where d.horas_vuelo > (
    select avg(d2.horas_vuelo)
    from drones d2
    where d2.id_base = d.id_base
);

-- d = dron de afuera.
-- d2 = drones utilizados para el promedio.

-- La parte:
-- d2.id_base = d.id_base
-- hace que compare con su misma base.

-- Resultado:
-- Drones que superan el promedio de su propia base.


-- DIFERENCIA:

-- ESCALAR GENERAL:
-- Comparo contra un unico promedio general.

-- CORRELACIONADA:
-- El calculo depende de cada registro de afuera.

-- UNA SUBCONSULTA PUEDE SER CORRELACIONADA Y ESCALAR
-- AL MISMO TIEMPO.


-- ======================================================================
-- 41. VIEW
-- ======================================================================

-- QUE ES:
-- Una vista que guarda la DEFINICION de una consulta.

-- LO UTILIZO CUANDO:
-- Quiero consultar frecuentemente el mismo resultado.


-- ESTRUCTURA:

-- create view nombre_vista as
-- select columnas
-- from tabla
-- where condicion;


-- EJEMPLO:

create or replace view vw_drones_activos as
select codigo_serie, modelo, horas_vuelo
from drones
where estado = 'ACTIVO';

-- Cree una vista para consultar facilmente drones activos.


-- CONSULTAR VISTA:

select *
from vw_drones_activos;

-- Resultado:
-- Muestra los drones activos segun los datos actuales.

-- Una vista normal no almacena una copia independiente
-- de todos los registros: consulta las tablas de origen.


-- ======================================================================
-- 42. INDEX
-- ======================================================================

-- QUE ES:
-- Es una estructura que puede acelerar algunas busquedas.

-- LO UTILIZO CUANDO:
-- El sistema consulta con mucha frecuencia determinadas
-- columnas, especialmente en WHERE y JOIN.


-- ESTRUCTURA:

-- create index idx_nombre
-- on tabla(columna);


-- EJEMPLO:

create index idx_drones_estado
on drones(estado);

-- Cree el indice porque consulto frecuentemente
-- los drones por estado.


-- INDICE COMPUESTO:

create index idx_entregas_estado_fecha_ejemplo
on entregas(estado, fecha_programada);

-- Lo cree para buscar entregas por estado
-- y fecha programada.


-- VER INDICES:

show index from drones;


-- ======================================================================
-- 43. PROCEDURE
-- ======================================================================

-- QUE ES:
-- Un conjunto de instrucciones SQL que guardo
-- para ejecutarlas despues con CALL.

-- LO UTILIZO CUANDO:
-- Me piden registrar, modificar, consultar o validar
-- informacion mediante un procedimiento.


-- DELIMITER:
-- Cambio temporalmente el separador porque dentro
-- del procedimiento utilizo varias sentencias con ;.


-- EJEMPLO SIN PARAMETROS:

delimiter //

create procedure mostrar_activos()
begin

    select *
    from drones
    where estado = 'ACTIVO';

end //

delimiter ;


-- EJECUTAR:

call mostrar_activos();

-- Resultado:
-- Muestra los drones activos.


-- ======================================================================
-- 44. PROCEDURE CON IN
-- ======================================================================

-- IN = RECIBE un dato.

-- LO UTILIZO CUANDO EL ENUNCIADO DICE:
-- "Reciba el identificador..."
-- "Reciba el estado..."
-- "Reciba una cantidad..."


-- ESTRUCTURA:

-- create procedure nombre (
--     in p_parametro tipo
-- )
-- begin
--     instrucciones;
-- end;


-- EJEMPLO:

delimiter //

create procedure buscar_dron(
    in p_id int
)
begin

    select *
    from drones
    where id_dron = p_id;

end //

delimiter ;


call buscar_dron(3);

-- El 3 entra en p_id.
-- Resultado:
-- Muestra los datos del dron 3.


-- ======================================================================
-- 45. PROCEDURE CON OUT
-- ======================================================================

-- OUT = DEVUELVE un valor mediante un parametro.

-- NO SIEMPRE DEBE UTILIZAR COUNT, SUM, AVG, MAX O MIN.

-- DESPUES DE SELECT PONGO LO QUE QUIERO OBTENER.
-- Puede ser una columna o un calculo.


-- ESTRUCTURA:

-- delimiter //
--
-- create procedure nombre(
--     out p_resultado tipo
-- )
-- begin
--     select columna_o_calculo
--     into p_resultado
--     from tabla
--     where condicion;
-- end //
--
-- delimiter ;


-- EJEMPLO CON COUNT:

delimiter //

create procedure contar_drones(
    out p_total int
)
begin

    select count(*)
    into p_total
    from drones;

end //

delimiter ;


call contar_drones(@resultado);

select @resultado;

-- COUNT cuenta drones.
-- INTO guarda el resultado en p_total.
-- OUT permite obtenerlo mediante @resultado.


-- EJEMPLO SIN FUNCION DE AGREGACION:

delimiter //

create procedure estado_dron(
    in p_id int,
    out p_estado varchar(15)
)
begin

    select estado
    into p_estado
    from drones
    where id_dron = p_id;

end //

delimiter ;


call estado_dron(3, @estado);

select @estado;

-- Aqui no calcule SUM ni AVG.
-- Simplemente devolvi el estado de un dron.


-- ======================================================================
-- 46. PROCEDURE CON INOUT
-- ======================================================================

-- INOUT = RECIBE Y DEVUELVE MODIFICADO EL MISMO VALOR.

-- LO UTILIZO CUANDO DIGA:
-- "Reciba una cantidad, aumentela y devuelvala".


-- EJEMPLO:

delimiter //

create procedure aumentar_cantidad(
    inout p_cantidad int
)
begin

    set p_cantidad = p_cantidad + 5;

end //

delimiter ;


set @cantidad = 10;

call aumentar_cantidad(@cantidad);

select @cantidad;

-- Recibio 10, sumo 5 y devolvio 15.


-- DIFERENCIA:

-- IN -> recibe.
-- OUT -> devuelve.
-- INOUT -> recibe y devuelve modificado.


-- ======================================================================
-- 47. SELECT ... INTO
-- ======================================================================

-- QUE HACE:
-- BUSCA UN DATO Y LO GUARDA EN UNA VARIABLE.

-- LO UTILIZO PRINCIPALMENTE EN:
-- PROCEDURE y FUNCTION.

-- NO LO UTILIZO SI SOLO QUIERO MOSTRAR UNA CONSULTA.


-- ESTRUCTURA CORRECTA:

-- select columna_o_calculo
-- into variable
-- from tabla
-- where condicion;


-- EJEMPLO CON VARIABLE LOCAL:

-- declare v_horas decimal(7,1);
--
-- select horas_vuelo
-- into v_horas
-- from drones
-- where id_dron = p_id;


-- QUE HACE CADA PARTE:

-- SELECT horas_vuelo:
-- busco las horas.

-- INTO v_horas:
-- guardo el resultado.

-- FROM drones:
-- indico de donde sale.

-- WHERE id_dron = p_id:
-- selecciono el dron que me interesa.


-- EJEMPLO DE DOS COLUMNAS:

-- select estado, autonomia_km
-- into v_estado, v_autonomia
-- from drones
-- where id_dron = p_id;

-- Guardo dos datos en dos variables diferentes.

-- IMPORTANTE:
-- SELECT INTO debe devolver como maximo una fila.
-- Si devuelve varias, puede generar error.
-- Si no encuentra ninguna, la variable puede quedar
-- con su valor anterior o inicial y aparece una advertencia.


-- ======================================================================
-- 48. DECLARE Y SET
-- ======================================================================

-- DECLARE:
-- Crea una variable local dentro de BEGIN ... END.

-- declare v_total decimal(10,2);


-- SET:
-- Asigna un valor a una variable.

-- set v_total = 100;


-- EJEMPLO:

-- declare v_precio decimal(10,2);
-- set v_precio = 5000;

-- Resultado:
-- v_precio guarda 5000.


-- ======================================================================
-- 49. FUNCTION ALMACENADA
-- ======================================================================

-- QUE ES:
-- Una funcion que recibe datos y devuelve un valor
-- mediante RETURN.

-- LO UTILIZO CUANDO:
-- El enunciado pide CREAR UNA FUNCION que calcule
-- o devuelva un resultado.


-- RETURNS:
-- Indica el TIPO del resultado.

-- RETURN:
-- Devuelve el resultado.


-- EJEMPLO:

delimiter //

create function calcular_doble(
    p_numero int
)
returns int
deterministic
begin

    return p_numero * 2;

end //

delimiter ;


select calcular_doble(8);

-- Resultado: 16.

-- p_numero recibe 8.
-- RETURN devuelve 8 * 2.


-- EJEMPLO CON TABLA:

delimiter //

create function consultar_horas(
    p_id int
)
returns decimal(7,1)
reads sql data
begin

    declare v_horas decimal(7,1);

    select horas_vuelo
    into v_horas
    from drones
    where id_dron = p_id;

    return v_horas;

end //

delimiter ;


select consultar_horas(3);

-- Busque las horas con SELECT INTO.
-- Luego devolvi el resultado con RETURN.


-- ======================================================================
-- 50. IF, ELSEIF Y ELSE
-- ======================================================================

-- IF sirve para ejecutar instrucciones si una condicion
-- es verdadera.

-- ESTRUCTURA:

-- if condicion then
--     instrucciones;
-- elseif otra_condicion then
--     otras_instrucciones;
-- else
--     instrucciones_finales;
-- end if;


-- EJEMPLO DE LOGICA:

-- if v_estado = 'ACTIVO' then
--     set v_mensaje = 'Puede operar';
-- else
--     set v_mensaje = 'No puede operar';
-- end if;


-- DIFERENCIA ENTRE IF Y CASE:

-- CASE en SELECT:
-- produce un valor para mostrar o calcular.

-- IF dentro de procedimiento:
-- decide que instrucciones ejecutar.


-- ======================================================================
-- 51. SIGNAL
-- ======================================================================

-- QUE ES:
-- Genera un ERROR PERSONALIZADO.

-- LO UTILIZO CUANDO EL ENUNCIADO DIGA:
-- "No permitir..."
-- "Rechazar..."
-- "Detener la operacion..."
-- "Generar error si..."


-- ESTRUCTURA:

-- if condicion then
--     signal sqlstate '45000'
--     set message_text = 'Mensaje de error';
-- end if;


-- EJEMPLO:

-- if v_estado <> 'ACTIVO' then
--     signal sqlstate '45000'
--     set message_text = 'El dron no esta activo';
-- end if;

-- Si se cumple la condicion, detiene la operacion.
-- El mensaje explica el motivo.


-- ======================================================================
-- 52. TRIGGER
-- ======================================================================

-- QUE ES:
-- Una instruccion que se ejecuta automaticamente
-- cuando ocurre INSERT, UPDATE o DELETE en una tabla.

-- LO UTILIZO CUANDO:
-- El enunciado pide auditoria, validacion automatica
-- o acciones ante cambios en una tabla.


-- BEFORE:
-- Antes de realizar la operacion.

-- AFTER:
-- Despues de realizar la operacion.

-- INSERT:
-- Cuando se agrega una fila.

-- UPDATE:
-- Cuando se modifica una fila.

-- DELETE:
-- Cuando se elimina una fila.


-- ESTRUCTURA:

-- delimiter //
--
-- create trigger nombre_trigger
-- before update on tabla
-- for each row
-- begin
--     instrucciones;
-- end //
--
-- delimiter ;


-- EJEMPLO CON AUDITORIA:

-- NOTA:
-- Uso nombres distintos a los del simulacro
-- para que este ejemplo no duplique su trigger.

delimiter //

create trigger trg_auditoria_ejemplo
before update on entregas
for each row
begin

    if old.estado <> new.estado then

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

-- OLD.estado:
-- valor antes del cambio.

-- NEW.estado:
-- valor despues del cambio.

-- Si cambia el estado, guardo el historial.
-- Si no cambia, no registro nada.


-- IMPORTANTE:
-- Si ya tengo el trigger de auditoria del simulacro,
-- no creo este segundo trigger porque duplicaria registros.


-- ======================================================================
-- 53. TRANSACCIONES
-- ======================================================================

-- QUE SON:
-- Varias operaciones que manejo como una unidad.


-- START TRANSACTION:
-- Inicia la transaccion.

-- COMMIT:
-- Confirma y guarda los cambios.

-- ROLLBACK:
-- Deshace los cambios no confirmados.

-- SAVEPOINT:
-- Marca un punto al que puedo regresar.


-- ESTRUCTURA:

-- start transaction;
-- instrucciones DML;
-- commit;


-- EJEMPLO:

start transaction;

update drones
set horas_vuelo = horas_vuelo + 2
where id_dron = 3;

commit;

-- Actualice las horas y confirme el cambio.
-- Resultado:
-- Las horas del dron 3 aumentan en dos.


-- EJEMPLO CON ROLLBACK:

start transaction;

update drones
set horas_vuelo = horas_vuelo + 100
where id_dron = 3;

rollback;

-- Deshice el incremento de 100 horas.
-- Resultado:
-- El UPDATE no queda guardado.


-- ======================================================================
-- 54. SAVEPOINT
-- ======================================================================

-- LO UTILIZO CUANDO:
-- Quiero deshacer solo una parte de la transaccion.


-- ESTRUCTURA:

-- start transaction;
-- operacion1;
-- savepoint punto1;
-- operacion2;
-- rollback to savepoint punto1;
-- commit;


-- EJEMPLO:

start transaction;

update drones
set horas_vuelo = horas_vuelo + 1
where id_dron = 1;

savepoint punto1;

update drones
set horas_vuelo = horas_vuelo + 10
where id_dron = 2;

rollback to savepoint punto1;

commit;

-- Conserve el primer UPDATE.
-- Deshice el segundo UPDATE.
-- Luego confirme con COMMIT.


-- ======================================================================
-- 55. RESUMEN RAPIDO PARA IDENTIFICAR ENUNCIADOS
-- ======================================================================

-- "Cree una tabla"
-- -> CREATE TABLE

-- "Agregue una nueva columna"
-- -> ALTER TABLE ADD COLUMN

-- "Amplie el VARCHAR"
-- -> ALTER TABLE MODIFY COLUMN

-- "Agregue una restriccion"
-- -> ALTER TABLE ADD CONSTRAINT

-- "No permita valores negativos"
-- -> CHECK

-- "Debe existir en otra tabla"
-- -> FOREIGN KEY

-- "No se debe repetir"
-- -> UNIQUE

-- "Muchos estudiantes tienen muchos cursos"
-- -> TABLA INTERMEDIA N:M

-- "Identificador unico"
-- -> PRIMARY KEY

-- "Registre nuevos datos"
-- -> INSERT

-- "Cambie el estado"
-- -> UPDATE

-- "Elimine registros"
-- -> DELETE

-- "Elimine la tabla"
-- -> DROP TABLE

-- "Muestre"
-- -> SELECT

-- "Solo los que cumplan..."
-- -> WHERE

-- "Que empiece, termine o contenga..."
-- -> LIKE

-- "Patron exacto de digitos o letras"
-- -> REGEXP

-- "Cantidad de..."
-- -> COUNT

-- "Total de..."
-- -> SUM

-- "Promedio de..."
-- -> AVG

-- "Mayor valor..."
-- -> MAX

-- "Menor valor..."
-- -> MIN

-- "Por cada cliente, ciudad, estado..."
-- -> GROUP BY

-- "Solo registros de cierto estado y luego por cliente..."
-- -> WHERE + GROUP BY

-- "Grupos con mas de 3 registros..."
-- -> GROUP BY + HAVING

-- "Informacion de dos o mas tablas"
-- -> JOIN

-- "Solamente coincidencias"
-- -> INNER JOIN

-- "Todos, incluso los que no tengan..."
-- -> LEFT JOIN

-- "Empleado y su jefe / piloto y supervisor"
-- -> SELF JOIN

-- "Mayor que el promedio..."
-- -> SUBCONSULTA ESCALAR

-- "Que aparezcan en otra tabla..."
-- -> IN

-- "Que no aparezcan en otra tabla..."
-- -> NOT IN

-- "Que tengan al menos un registro relacionado..."
-- -> EXISTS

-- "Que nunca hayan tenido..."
-- -> NOT EXISTS

-- "Promedio de su misma categoria/base..."
-- -> SUBCONSULTA CORRELACIONADA

-- "Guarde una consulta frecuente"
-- -> VIEW

-- "Optimice una busqueda"
-- -> INDEX

-- "Cree un procedimiento"
-- -> PROCEDURE

-- "Reciba un valor"
-- -> IN

-- "Devuelva un valor por parametro"
-- -> OUT

-- "Reciba y devuelva modificado"
-- -> INOUT

-- "Guarde el resultado de un SELECT"
-- -> SELECT INTO

-- "Cree una funcion que devuelva un valor"
-- -> FUNCTION + RETURN

-- "No permita registrar si..."
-- -> IF + SIGNAL

-- "Registre automaticamente los cambios"
-- -> TRIGGER

-- "Confirme las operaciones"
-- -> COMMIT

-- "Deshaga los cambios"
-- -> ROLLBACK

-- "Regrese a un punto anterior"
-- -> SAVEPOINT


-- ======================================================================
-- FIN DE LA GUIA
-- ======================================================================
