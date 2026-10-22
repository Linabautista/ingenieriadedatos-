/* GUIA COMPLETA SQL MYSQL - DBEAVER | CTRL + F
   PLANTILLAS: NO EJECUTAR TODO EL ARCHIVO. Elegir y adaptar cada bloque.
   INDICE: TIPOS DE DATOS | CREATE DATABASE | CREATE TABLE | PRIMARY KEY | FOREIGN KEY |
   TABLA INTERMEDIA | CHECK | UNIQUE | DEFAULT | ALTER ADD | MODIFY | RENAME |
   DROP COLUMN | DROP TABLE | TRUNCATE | INSERT | UPDATE | DELETE | SELECT |
   WHERE | BETWEEN | AND | OR | <> | IS NULL | IN | NOT IN | LIKE | REGEXP |
   ORDER BY | DISTINCT | LIMIT | COUNT | SUM | AVG | MAX | MIN | GROUP BY |
   HAVING | INNER JOIN | LEFT JOIN | SELF JOIN | SUBCONSULTA PROMEDIO |
   CLIENTES SIN DESPACHOS | EXISTS | NOT EXISTS | COALESCE | CONCAT | UPPER |
   LOWER | TRIM | LENGTH | ROUND | ABS | SQRT | CASE | DATEDIFF |
   TIMESTAMPDIFF | DATE_ADD | VIEW | INDEX | TRANSACTION | SAVEPOINT |
   PROCEDURE | OUT | FUNCTION | DECLARE | SELECT INTO | IF | SIGNAL |
   TRIGGER | HISTORIAL | UPSERT | DDL DML | ORDEN SELECT

   FRASES PARA ENCONTRAR:
   Entre dos valores -> BETWEEN; cumple ambas -> AND; una u otra -> OR;
   diferente de uno -> <>; excluir varios -> NOT IN; dato ausente -> IS NULL;
   que contenga letras -> LIKE; total por categoria -> GROUP BY;
   grupos con mas de tres -> HAVING; clientes sin pedidos -> CLIENTES SIN DESPACHOS;
   superior al promedio -> SUBCONSULTA PROMEDIO; todos aunque no tengan -> LEFT JOIN;
   informe reutilizable -> VIEW; automatizar al cambiar -> TRIGGER;
   realizar pasos con validaciones -> PROCEDURE; devolver calculo -> FUNCTION.
*/

/* TIPOS DE DATOS: INT IDs/unidades; BIGINT enteros enormes; VARCHAR nombres, placas,
   documentos, telefonos y correo; CHAR codigos fijos; TEXT descripciones largas;
   DECIMAL(10,2) dinero/peso exacto; FLOAT/DOUBLE aproximaciones; BOOLEAN si/no;
   DATE solo fecha; TIME solo hora; DATETIME fecha y hora; TIMESTAMP fecha/hora
   con conversion de zona horaria; YEAR año; BLOB datos binarios.
   NULL significa dato ausente; NOT NULL obligatorio; DEFAULT valor por omision.
   DECIMAL(10,2) tiene 10 digitos en total, 2 decimales.
   Los ejemplos usan tablas de RedLogistica y deben adaptarse a las columnas reales.
*/

/* 01 CREATE DATABASE | Crear una base nueva, empezar proyecto, elegir base. */
/* ESTRUCTURA */
CREATE DATABASE nombre_base;
USE nombre_base;
/* EJEMPLO */
CREATE DATABASE redlogistica;
USE redlogistica;

/* 02 CREATE TABLE | Crear entidad, guardar clientes, registrar vehiculos. */
/* ESTRUCTURA */
CREATE TABLE nombre_tabla (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(50) NOT NULL,
 cantidad INT DEFAULT 0,
 precio DECIMAL(10,2),
 fecha DATE
);
/* EJEMPLO */
CREATE TABLE clientes (
 idcliente INT AUTO_INCREMENT PRIMARY KEY,
 nombrecliente VARCHAR(50) NOT NULL,
 tipolugar VARCHAR(20),
 telefono VARCHAR(20),
 correo VARCHAR(80),
 numeroidentificacion VARCHAR(20) UNIQUE
);

/* 03 PRIMARY KEY / UNIQUE / NOT NULL / DEFAULT / CHECK
   Identificacion unica -> PRIMARY KEY; dato no repetido -> UNIQUE;
   obligatorio -> NOT NULL; valor inicial -> DEFAULT; limites -> CHECK.
   CHECK puede ir sin CONSTRAINT; con CONSTRAINT tiene nombre propio. */
/* ESTRUCTURA */
CREATE TABLE tabla_restricciones (
 id INT AUTO_INCREMENT PRIMARY KEY,
 codigo VARCHAR(20) NOT NULL UNIQUE,
 estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
 capacidad DECIMAL(10,2) CHECK (capacidad >= 0.5),
 CHECK (estado IN ('pendiente','entregado','cancelado'))
);
/* EJEMPLO: licencia solo A, B, C */
CREATE TABLE licencia_ejemplo (
 id INT PRIMARY KEY,
 licencia CHAR(1) NOT NULL,
 CONSTRAINT chk_licencia CHECK (licencia IN ('A','B','C'))
);

/* 04 FOREIGN KEY | Relacion 1:N; cada despacho pertenece a un cliente. */
/* ESTRUCTURA */
CREATE TABLE tabla_hija (
 id INT AUTO_INCREMENT PRIMARY KEY,
 id_padre INT NOT NULL,
 CONSTRAINT fk_hija_padre FOREIGN KEY (id_padre) REFERENCES tabla_padre(id)
);
/* EJEMPLO */
CREATE TABLE despacho (
 iddespacho INT AUTO_INCREMENT PRIMARY KEY,
 idcliente INT NOT NULL,
 fechaprogramada DATE NOT NULL,
 fechaentrega DATE,
 estado VARCHAR(20) DEFAULT 'pendiente',
 CONSTRAINT fk_despacho_cliente FOREIGN KEY (idcliente) REFERENCES clientes(idcliente)
);

/* 05 TABLA INTERMEDIA | Muchos despachos tienen muchas categorias N:M;
   dos FK y PK compuesta; cantidad y peso de cada combinacion van aqui. */
/* ESTRUCTURA */
CREATE TABLE tabla_intermedia (
 id_a INT NOT NULL,
 id_b INT NOT NULL,
 cantidad INT NOT NULL,
 PRIMARY KEY (id_a,id_b),
 FOREIGN KEY (id_a) REFERENCES tabla_a(id_a),
 FOREIGN KEY (id_b) REFERENCES tabla_b(id_b)
);
/* EJEMPLO */
CREATE TABLE detalle_despacho (
 iddespacho INT NOT NULL,
 idcategoriaproducto INT NOT NULL,
 cantidad INT NOT NULL,
 peso DECIMAL(10,2),
 PRIMARY KEY (iddespacho,idcategoriaproducto),
 FOREIGN KEY (iddespacho) REFERENCES despacho(iddespacho),
 FOREIGN KEY (idcategoriaproducto) REFERENCES categoriaproducto(idcategoriaproducto)
);

/* 06 SELF FOREIGN KEY | Un conductor puede supervisar a otros conductores. */
/* ESTRUCTURA */
ALTER TABLE conductor ADD CONSTRAINT fk_conductor_supervisor
FOREIGN KEY (idsupervisor) REFERENCES conductor(idconductor);
/* EJEMPLO DE CONSULTA: ver seccion SELF JOIN. */

/* 07 ALTER ADD | Agregar columna, nuevo atributo, municipio faltante. */
/* ESTRUCTURA */
ALTER TABLE nombre_tabla ADD COLUMN nueva_columna VARCHAR(50);
/* EJEMPLO */
ALTER TABLE clientes ADD COLUMN municipio VARCHAR(50);

/* 08 MODIFY | Ampliar VARCHAR, cambiar tipo, volver obligatorio u opcional. */
/* ESTRUCTURA */
ALTER TABLE nombre_tabla MODIFY COLUMN nombre_columna VARCHAR(120) NOT NULL;
/* EJEMPLO */
ALTER TABLE clientes MODIFY COLUMN nombrecliente VARCHAR(120) NOT NULL;

/* 09 RENAME | Renombrar columna, cambiar nombre sin borrar datos. */
/* ESTRUCTURA */
ALTER TABLE nombre_tabla RENAME COLUMN nombre_viejo TO nombre_nuevo;
/* EJEMPLO */
ALTER TABLE clientes RENAME COLUMN telefono TO celular;

/* 10 DROP COLUMN | Eliminar atributo, quitar columna innecesaria. */
/* ESTRUCTURA */
ALTER TABLE nombre_tabla DROP COLUMN columna;
/* EJEMPLO */
ALTER TABLE clientes DROP COLUMN municipio;

/* 11 ALTER ADD CONSTRAINT | Nueva validacion, valor no repetido, relacion nueva. */
/* ESTRUCTURA */
ALTER TABLE nombre_tabla ADD CONSTRAINT chk_nombre CHECK (columna >= 0);
ALTER TABLE nombre_tabla ADD CONSTRAINT uq_nombre UNIQUE (columna);
ALTER TABLE tabla_hija ADD CONSTRAINT fk_nombre FOREIGN KEY (id_padre) REFERENCES tabla_padre(id);
/* EJEMPLO */
ALTER TABLE vehiculo ADD CONSTRAINT chk_capacidad CHECK (capacidad >= 0.5);
ALTER TABLE clientes ADD CONSTRAINT uq_correo UNIQUE (correo);

/* 12 DROP CONSTRAINT | Quitar restricciones; en MySQL cambia segun tipo. */
/* ESTRUCTURA */
ALTER TABLE nombre_tabla DROP CHECK nombre_check;
ALTER TABLE nombre_tabla DROP FOREIGN KEY nombre_fk;
ALTER TABLE nombre_tabla DROP INDEX nombre_unique;
/* EJEMPLO */
ALTER TABLE vehiculo DROP CHECK chk_capacidad;

/* 13 DROP TABLE / TRUNCATE / DROP DATABASE
   Borrar tabla entera -> DROP TABLE; vaciar datos -> TRUNCATE;
   borrar toda la base -> DROP DATABASE. Cuidado: operaciones destructivas. */
/* ESTRUCTURA */
DROP TABLE IF EXISTS nombre_tabla;
TRUNCATE TABLE nombre_tabla;
DROP DATABASE IF EXISTS nombre_base;
/* EJEMPLO */
DROP TABLE IF EXISTS tabla_temporal;

/* 14 INSERT | Registrar, incorporar, almacenar una fila o varias. */
/* ESTRUCTURA */
INSERT INTO nombre_tabla (columna1,columna2) VALUES ('texto',10);
INSERT INTO nombre_tabla (columna1,columna2) VALUES ('a',1),('b',2);
/* EJEMPLO */
INSERT INTO clientes (nombrecliente,tipolugar,numeroidentificacion)
VALUES ('Hospital San Gabriel','hospital','900456123'),
       ('Distribuidora Andina','distribuidores','901785432');

/* 15 UPDATE | Cambiar datos existentes, estado, precio, telefono.
   MODIFY cambia la DEFINICION de columna; UPDATE cambia sus VALORES.
   Sin WHERE se actualizan todas las filas. */
/* ESTRUCTURA */
UPDATE nombre_tabla SET columna = 'nuevo' WHERE id = 1;
UPDATE nombre_tabla SET columna1 = 'nuevo', columna2 = 10 WHERE id = 1;
/* EJEMPLO */
UPDATE vehiculo SET estado = 'mantenimiento'
WHERE estado = 'activo' AND capacidad < 2;

/* 16 DELETE | Eliminar algunos registros, cancelar registros sin detalles.
   No es DROP: DELETE quita filas, DROP quita la tabla. */
/* ESTRUCTURA */
DELETE FROM nombre_tabla WHERE columna = 'valor';
/* EJEMPLO: puede impedirlo una FK de historial */
DELETE FROM despacho
WHERE estado = 'cancelado'
AND NOT EXISTS (SELECT 1 FROM detalle_despacho dd
                WHERE dd.iddespacho = despacho.iddespacho);

/* 17 SELECT | Mostrar todo, solo ciertas columnas, alias. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla;
SELECT columna1,columna2 AS nombre_visible FROM nombre_tabla;
/* EJEMPLO */
SELECT nombrecliente,correo AS correo_cliente FROM clientes;

/* 18 WHERE / AND / OR | Filtrar; ambas condiciones -> AND; cualquiera -> OR.
   Si mezclo AND y OR, uso parentesis para agrupar correctamente. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE condicion1 AND condicion2;
SELECT * FROM nombre_tabla WHERE (condicion1 AND condicion2) OR condicion3;
/* EJEMPLO */
SELECT * FROM vehiculo WHERE (estado = 'activo' AND capacidad > 5)
OR (estado = 'mantenimiento' AND capacidad > 10);

/* 19 BETWEEN | Entre 2 limites inclusive; precios, fechas, capacidades.
   Entre 2 y 8 y ademas activo -> BETWEEN ... AND ... AND estado=...
   BETWEEN incluye ambos extremos. Para DATETIME con horas puede ser mejor
   usar >= fecha_inicio y < dia_siguiente. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna BETWEEN valor_minimo AND valor_maximo;
/* EJEMPLO BASICO */
SELECT * FROM vehiculo WHERE capacidad BETWEEN 2 AND 8;
/* EJEMPLO DIFICIL: rango + dos condiciones */
SELECT * FROM vehiculo
WHERE capacidad BETWEEN 2 AND 8 AND estado = 'activo' AND idcentro <> 3;
/* EJEMPLO FECHAS */
SELECT * FROM revision WHERE fecharevision BETWEEN '2026-07-01' AND '2026-12-31';

/* 20 COMPARACIONES | Mayor >, menor <, al menos >=, maximo <=.
   Diferente de <> o !=; no es igual a un valor; no sean hospitales.
   Para NULL NO usar = NULL ni <> NULL, usar IS NULL / IS NOT NULL. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna > valor;
SELECT * FROM nombre_tabla WHERE columna < valor;
SELECT * FROM nombre_tabla WHERE columna >= valor;
SELECT * FROM nombre_tabla WHERE columna <= valor;
SELECT * FROM nombre_tabla WHERE columna <> valor;
/* EJEMPLOS */
SELECT * FROM revision WHERE costo > 500000 AND costo <= 2000000;
SELECT * FROM conductor WHERE licencia <> 'A';
SELECT * FROM despacho WHERE estado != 'cancelado';

/* 21 IS NULL / IS NOT NULL | Sin fecha, sin correo, con fecha, con correo. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna IS NULL;
SELECT * FROM nombre_tabla WHERE columna IS NOT NULL;
/* EJEMPLO DIFICIL */
SELECT * FROM despacho
WHERE fechaentrega IS NULL AND estado = 'pendiente' AND distancia > 20;
SELECT * FROM clientes WHERE correo IS NOT NULL AND nombrecliente LIKE 'H%';

/* 22 IN / NOT IN | Uno de varios estados o municipios; excluir varios.
   IN ('A','B') equivale a A OR B; NOT IN excluye varios.
   OJO: NOT IN con una lista/subconsulta que contiene NULL puede no devolver filas. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna IN ('A','B');
SELECT * FROM nombre_tabla WHERE columna NOT IN ('A','B');
/* EJEMPLO DIFICIL */
SELECT * FROM despacho WHERE municipio IN ('Bogota','Tunja','Medellin')
AND estado NOT IN ('cancelado','entregado')
ORDER BY fechaprogramada ASC;

/* 23 LIKE / NOT LIKE | Empieza, contiene, termina, patron.
   'H%' comienza H; '%a%' contiene a; '%gmail.com' termina gmail.com;
   '_a%' segunda letra a; '_' exactamente un caracter, '%' cero o mas.
   Mayusculas/minusculas pueden depender de la collation. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna LIKE 'texto%';
SELECT * FROM nombre_tabla WHERE columna LIKE '%texto%';
SELECT * FROM nombre_tabla WHERE columna LIKE '%texto';
SELECT * FROM nombre_tabla WHERE columna NOT LIKE '%texto%';
/* EJEMPLOS */
SELECT * FROM clientes WHERE nombrecliente LIKE 'H%';
SELECT * FROM clientes WHERE correo LIKE '%@gmail.com';
SELECT * FROM clientes WHERE nombrecliente LIKE 'H%' AND correo LIKE '%@gmail.com';

/* 24 REGEXP | Solo numeros, empieza por patron, formato de codigos.
   ^ inicio, $ final, [0-9] digito, [A-Z] mayuscula, . cualquier caracter,
   + una o mas, * cero o mas, {3} tres, | alternativa. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna REGEXP '^[0-9]+$';
/* EJEMPLO */
SELECT * FROM clientes WHERE numeroidentificacion REGEXP '^[0-9]+$';

/* 25 ORDER BY / DISTINCT / LIMIT | Mayor a menor DESC, A-Z ASC,
   mas recientes primero DESC, sin repetir DISTINCT, primeros 5 LIMIT. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla ORDER BY columna ASC;
SELECT * FROM nombre_tabla ORDER BY columna DESC LIMIT 5;
SELECT DISTINCT columna FROM nombre_tabla;
/* EJEMPLOS */
SELECT * FROM revision ORDER BY costo DESC LIMIT 3;
SELECT DISTINCT municipio FROM despacho;
SELECT * FROM despacho ORDER BY municipio ASC,fechaprogramada DESC;

/* 26 COUNT / SUM / AVG / MAX / MIN | Numero, total, promedio, mayor, menor.
   COUNT(*) cuenta filas; COUNT(columna) ignora NULL; AVG ignora NULL. */
/* ESTRUCTURA */
SELECT COUNT(*) AS cantidad FROM nombre_tabla;
SELECT SUM(columna) AS total FROM nombre_tabla;
SELECT AVG(columna) AS promedio FROM nombre_tabla;
SELECT MAX(columna) AS mayor FROM nombre_tabla;
SELECT MIN(columna) AS menor FROM nombre_tabla;
/* EJEMPLOS */
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT SUM(costo) AS costo_total FROM revision;
SELECT ROUND(AVG(costo),2) AS promedio FROM revision;
SELECT MAX(capacidad) AS mayor_capacidad FROM vehiculo;
SELECT MIN(fecharevision) AS primera_revision FROM revision;

/* 27 GROUP BY | Cantidad POR estado, promedio POR vehiculo, total POR cliente.
   WHERE filtra filas ANTES de agrupar. */
/* ESTRUCTURA */
SELECT columna,COUNT(*) AS total FROM nombre_tabla GROUP BY columna;
/* EJEMPLO */
SELECT estado,COUNT(*) AS total FROM despacho GROUP BY estado;
SELECT idvehiculo,SUM(costo) AS gasto FROM revision GROUP BY idvehiculo;

/* 28 HAVING | Grupos con mas de 3, al menos 2 despachos, promedio mayor a 4.
   HAVING filtra grupos DESPUES de GROUP BY; WHERE filtra filas. */
/* ESTRUCTURA */
SELECT columna,COUNT(*) AS total FROM nombre_tabla
GROUP BY columna HAVING COUNT(*) >= 2;
/* EJEMPLO DIFICIL */
SELECT idcliente,COUNT(*) AS total FROM despacho
WHERE estado = 'entregado'
GROUP BY idcliente HAVING COUNT(*) >= 2
ORDER BY total DESC;

/* 29 INNER JOIN | Mostrar coincidencias entre 2 o mas tablas.
   Clientes CON despachos, vehiculos CON revisiones. */
/* ESTRUCTURA */
SELECT a.columna,b.columna FROM tabla_a a
INNER JOIN tabla_b b ON a.id = b.id_a;
/* EJEMPLO */
SELECT c.nombrecliente,d.iddespacho FROM clientes c
INNER JOIN despacho d ON c.idcliente = d.idcliente;
/* EJEMPLO 3 TABLAS */
SELECT c.nombrecliente,d.iddespacho,v.placa FROM despacho d
INNER JOIN clientes c ON d.idcliente = c.idcliente
INNER JOIN vehiculo v ON d.idvehiculo = v.idvehiculo;

/* 30 LEFT JOIN | Todos aunque no tengan; todos los clientes incluso sin despachos.
   Para contar solo entregados sin excluir clientes sin entregas,
   pongo estado en ON, no en WHERE. */
/* ESTRUCTURA */
SELECT a.columna,b.columna FROM tabla_a a
LEFT JOIN tabla_b b ON a.id = b.id_a;
/* EJEMPLO */
SELECT c.nombrecliente,d.iddespacho FROM clientes c
LEFT JOIN despacho d ON c.idcliente = d.idcliente;
/* EJEMPLO DIFICIL */
SELECT c.idcliente,c.nombrecliente,COUNT(d.iddespacho) AS entregados
FROM clientes c LEFT JOIN despacho d
ON c.idcliente = d.idcliente AND d.estado = 'entregado'
GROUP BY c.idcliente,c.nombrecliente;

/* 31 SELF JOIN | Conductor y su supervisor en la MISMA tabla. */
/* ESTRUCTURA */
SELECT a.nombre,b.nombre FROM tabla a
LEFT JOIN tabla b ON a.idsupervisor = b.id;
/* EJEMPLO */
SELECT c.nombreconductor,COALESCE(s.nombreconductor,'SIN SUPERVISOR') AS supervisor
FROM conductor c LEFT JOIN conductor s ON c.idsupervisor = s.idconductor;

/* 32 SUBCONSULTA PROMEDIO | Superior al promedio general, inferior al promedio,
   comparar cada fila con un calculo de otra consulta. */
/* ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna >
(SELECT AVG(columna) FROM nombre_tabla);
/* EJEMPLO */
SELECT * FROM vehiculo WHERE capacidad >
(SELECT AVG(capacidad) FROM vehiculo);

/* 33 CLIENTES SIN DESPACHOS | Clientes que nunca solicitaron nada,
   vehiculos sin revisiones, elementos sin relacion. Se puede usar NOT EXISTS. */
/* ESTRUCTURA */
SELECT * FROM tabla_a a WHERE NOT EXISTS
(SELECT 1 FROM tabla_b b WHERE b.id_a = a.id);
/* EJEMPLO */
SELECT * FROM clientes c WHERE NOT EXISTS
(SELECT 1 FROM despacho d WHERE d.idcliente = c.idcliente);
/* EJEMPLO VEHICULOS SIN REVISION */
SELECT * FROM vehiculo v WHERE NOT EXISTS
(SELECT 1 FROM revision r WHERE r.idvehiculo = v.idvehiculo);

/* 34 EXISTS / NOT EXISTS | Existe al menos uno, no existe ninguno.
   IN con consulta sirve para valores que aparecen en otra tabla;
   NOT EXISTS es mas seguro que NOT IN si la columna consultada puede ser NULL. */
/* ESTRUCTURA */
SELECT * FROM tabla_a a WHERE EXISTS
(SELECT 1 FROM tabla_b b WHERE b.id_a = a.id);
SELECT * FROM tabla_a a WHERE NOT EXISTS
(SELECT 1 FROM tabla_b b WHERE b.id_a = a.id);
/* EJEMPLO */
SELECT * FROM clientes c WHERE EXISTS
(SELECT 1 FROM despacho d WHERE d.idcliente = c.idcliente);
/* EJEMPLO IN CON CONSULTA */
SELECT * FROM clientes WHERE idcliente IN
(SELECT idcliente FROM despacho);

/* 35 CONTAR VARIAS TABLAS EN UNA FILA | Un solo reporte con tres totales. */
/* ESTRUCTURA */
SELECT (SELECT COUNT(*) FROM tabla_a) AS total_a,
       (SELECT COUNT(*) FROM tabla_b) AS total_b;
/* EJEMPLO */
SELECT (SELECT COUNT(*) FROM clientes) AS total_clientes,
       (SELECT COUNT(*) FROM despacho) AS total_despachos,
       (SELECT COUNT(*) FROM vehiculo WHERE estado='mantenimiento') AS mantenimiento;

/* 36 COALESCE / CONCAT | Reemplazar NULL, unir textos. */
/* ESTRUCTURA */
SELECT COALESCE(columna,'SIN DATO') FROM nombre_tabla;
SELECT CONCAT(columna1,' ',columna2) FROM nombre_tabla;
/* EJEMPLO */
SELECT nombrecliente,COALESCE(correo,'SIN CORREO') AS correo FROM clientes;
SELECT CONCAT(nombrecliente,' - ',telefono) AS contacto FROM clientes;

/* 37 UPPER / LOWER / TRIM / LENGTH / CHAR_LENGTH
   Mayusculas, minusculas, quitar espacios, longitud.
   LENGTH mide bytes; CHAR_LENGTH mide caracteres. */
/* ESTRUCTURA */
SELECT UPPER(columna),LOWER(columna),TRIM(columna),
       LENGTH(columna),CHAR_LENGTH(columna) FROM nombre_tabla;
/* EJEMPLO */
SELECT UPPER(nombrecliente),LOWER(correo),TRIM(nombrecliente),
CHAR_LENGTH(nombrecliente) FROM clientes;

/* 38 ROUND / ABS / SQRT | Redondear, valor absoluto, raiz cuadrada. */
/* ESTRUCTURA */
SELECT ROUND(numero,2),ABS(numero),SQRT(numero);
/* EJEMPLO */
SELECT ROUND(AVG(costo),2) AS promedio FROM revision;
SELECT ABS(-150) AS positivo,SQRT(144) AS raiz;

/* 39 CASE | Clasificar por capacidad, mostrar etiquetas segun condiciones. */
/* ESTRUCTURA */
SELECT columna,CASE WHEN condicion1 THEN 'ALTO'
WHEN condicion2 THEN 'MEDIO' ELSE 'BAJO' END AS clasificacion
FROM nombre_tabla;
/* EJEMPLO */
SELECT idvehiculo,capacidad,
CASE WHEN capacidad >= 5 THEN 'ALTA'
     WHEN capacidad >= 2 THEN 'MEDIA'
     ELSE 'BAJA' END AS nivel
FROM vehiculo;

/* 40 FECHAS | Dias de retraso DATEDIFF; minutos u horas TIMESTAMPDIFF;
   sumar dias DATE_ADD; fecha actual CURRENT_DATE; fecha y hora NOW(). */
/* ESTRUCTURA */
SELECT DATEDIFF(fecha_final,fecha_inicial) FROM nombre_tabla;
SELECT TIMESTAMPDIFF(MINUTE,fecha_inicial,fecha_final) FROM nombre_tabla;
SELECT DATE_ADD(CURRENT_DATE,INTERVAL 15 DAY);
/* EJEMPLO */
SELECT iddespacho,DATEDIFF(fechaentrega,fechaprogramada) AS dias FROM despacho;
SELECT DATE_ADD(CURRENT_DATE,INTERVAL 30 DAY) AS fecha_limite;

/* 41 VIEW | Crear reporte reutilizable, consulta guardada, tablero. */
/* ESTRUCTURA */
CREATE VIEW nombre_vista AS SELECT columna FROM nombre_tabla WHERE condicion;
SELECT * FROM nombre_vista;
/* EJEMPLO */
CREATE VIEW vw_despachos_pendientes AS
SELECT iddespacho,idcliente,fechaprogramada FROM despacho
WHERE estado='pendiente';
SELECT * FROM vw_despachos_pendientes;
/* REEMPLAZAR O ELIMINAR VISTA */
CREATE OR REPLACE VIEW vw_despachos_pendientes AS
SELECT iddespacho,estado FROM despacho WHERE estado='pendiente';
DROP VIEW IF EXISTS vw_despachos_pendientes;

/* 42 INDEX | Mejorar busquedas frecuentes; indice sencillo y compuesto. */
/* ESTRUCTURA */
CREATE INDEX idx_nombre ON nombre_tabla(columna);
CREATE INDEX idx_dos ON nombre_tabla(columna1,columna2);
DROP INDEX idx_nombre ON nombre_tabla;
/* EJEMPLO */
CREATE INDEX idx_despacho_estado_fecha ON despacho(estado,fechaprogramada);

/* 43 TRANSACTION / COMMIT / ROLLBACK / SAVEPOINT
   Varias operaciones como una sola, confirmar, deshacer, punto intermedio.
   Usar tablas transaccionales como InnoDB. DDL puede confirmar implicitamente. */
/* ESTRUCTURA */
START TRANSACTION;
UPDATE nombre_tabla SET columna = 'nuevo' WHERE id = 1;
SAVEPOINT punto1;
UPDATE nombre_tabla SET columna = 'otro' WHERE id = 2;
ROLLBACK TO SAVEPOINT punto1;
COMMIT;
/* EJEMPLO: para deshacer todo antes de COMMIT */
START TRANSACTION;
UPDATE vehiculo SET estado='mantenimiento' WHERE idvehiculo=1;
ROLLBACK;

/* 44 UPSERT | Insertar o actualizar si ya existe una clave UNIQUE o PK. */
/* ESTRUCTURA */
INSERT INTO nombre_tabla (id,columna) VALUES (1,'valor')
ON DUPLICATE KEY UPDATE columna = 'valor';
/* EJEMPLO */
INSERT INTO clientes (idcliente,nombrecliente) VALUES (1,'Hospital Central')
ON DUPLICATE KEY UPDATE nombrecliente = 'Hospital Central';

/* 45 PROCEDURE | Realizar varios pasos, validar antes de insertar,
   ejecutar con CALL, recibir IN y devolver OUT. */
/* ESTRUCTURA */
DELIMITER //
CREATE PROCEDURE sp_nombre(IN p_id INT)
BEGIN
 SELECT * FROM nombre_tabla WHERE id = p_id;
END //
DELIMITER ;
CALL sp_nombre(1);
/* EJEMPLO */
DELIMITER //
CREATE PROCEDURE sp_consultar_cliente(IN p_idcliente INT)
BEGIN
 SELECT * FROM clientes WHERE idcliente = p_idcliente;
END //
DELIMITER ;
CALL sp_consultar_cliente(1);

/* 46 DECLARE / SELECT INTO / OUT | Variable local, guardar calculo,
   devolver resultado de procedimiento. DECLARE al inicio de BEGIN. */
/* ESTRUCTURA */
DELIMITER //
CREATE PROCEDURE sp_contar(OUT p_total INT)
BEGIN
 DECLARE v_total INT DEFAULT 0;
 SELECT COUNT(*) INTO v_total FROM nombre_tabla;
 SET p_total = v_total;
END //
DELIMITER ;
CALL sp_contar(@total);
SELECT @total;
/* EJEMPLO */
DELIMITER //
CREATE PROCEDURE sp_total_clientes(OUT p_total INT)
BEGIN
 SELECT COUNT(*) INTO p_total FROM clientes;
END //
DELIMITER ;
CALL sp_total_clientes(@cantidad);
SELECT @cantidad;

/* 47 FUNCTION | Calcular y devolver un valor con RETURN.
   PROCEDURE usa CALL; FUNCTION se usa en SELECT. */
/* ESTRUCTURA */
DELIMITER //
CREATE FUNCTION fn_nombre(p_numero INT) RETURNS INT DETERMINISTIC
BEGIN
 DECLARE v_resultado INT;
 SET v_resultado = p_numero * 2;
 RETURN v_resultado;
END //
DELIMITER ;
SELECT fn_nombre(5);
/* EJEMPLO: funcion sencilla con valor calculado */
DELIMITER //
CREATE FUNCTION fn_costo_distancia(p_km DECIMAL(10,2))
RETURNS DECIMAL(12,2) DETERMINISTIC
BEGIN
 RETURN p_km * 1200;
END //
DELIMITER ;
SELECT fn_costo_distancia(15);

/* 48 IF / SIGNAL | Si una regla no se cumple, detener con mensaje.
   IF THEN END IF solo dentro de procedimientos, funciones o triggers. */
/* ESTRUCTURA */
DELIMITER //
CREATE PROCEDURE sp_validar(IN p_cantidad INT)
BEGIN
 IF p_cantidad <= 0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Cantidad invalida';
 END IF;
 SELECT 'Cantidad valida' AS resultado;
END //
DELIMITER ;
CALL sp_validar(3);
/* EJEMPLO */
DELIMITER //
CREATE PROCEDURE sp_validar_capacidad(IN p_capacidad DECIMAL(10,2))
BEGIN
 IF p_capacidad < 0.5 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Capacidad insuficiente';
 END IF;
 SELECT 'Valida' AS resultado;
END //
DELIMITER ;
CALL sp_validar_capacidad(2);

/* 49 TRIGGER | Automatizar auditoria al actualizar, registrar historial,
   impedir datos incorrectos. BEFORE UPDATE permite SET NEW.columna;
   AFTER UPDATE registra en OTRA tabla. OLD valor anterior, NEW valor nuevo.
   FOR EACH ROW ejecuta por cada fila modificada. */
/* ESTRUCTURA */
DELIMITER //
CREATE TRIGGER trg_tabla_estado AFTER UPDATE ON nombre_tabla
FOR EACH ROW
BEGIN
 IF OLD.estado <> NEW.estado THEN
  INSERT INTO historial_ejemplo (idregistro,estadoanterior,estadonuevo,fechacambio)
  VALUES (NEW.id,OLD.estado,NEW.estado,NOW());
 END IF;
END //
DELIMITER ;
/* EJEMPLO HISTORIAL: la tabla de historial debe existir antes del trigger. */
CREATE TABLE cambiosestadodespacho (
 idcambiodespacho INT AUTO_INCREMENT PRIMARY KEY,
 iddespacho INT NOT NULL,
 estadoanterior VARCHAR(20),
 estadonuevo VARCHAR(20),
 fechacambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (iddespacho) REFERENCES despacho(iddespacho)
);
DELIMITER //
CREATE TRIGGER trg_despacho_estado AFTER UPDATE ON despacho
FOR EACH ROW
BEGIN
 IF OLD.estado <> NEW.estado THEN
  INSERT INTO cambiosestadodespacho (iddespacho,estadoanterior,estadonuevo)
  VALUES (NEW.iddespacho,OLD.estado,NEW.estado);
 END IF;
END //
DELIMITER ;

/* 50 TRIGGER BEFORE | Normalizar correo, bloquear fechas incorrectas.
   No se puede actualizar la misma tabla que dispara el trigger con UPDATE;
   para cambiar la fila actual se usa SET NEW.columna en BEFORE. */
/* ESTRUCTURA */
DELIMITER //
CREATE TRIGGER trg_tabla_antes BEFORE INSERT ON nombre_tabla
FOR EACH ROW
BEGIN
 SET NEW.correo = LOWER(TRIM(NEW.correo));
END //
DELIMITER ;
/* EJEMPLO */
DELIMITER //
CREATE TRIGGER trg_clientes_correo BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
 SET NEW.correo = LOWER(TRIM(NEW.correo));
END //
DELIMITER ;

/* 51 DROP PROCEDURE / FUNCTION / TRIGGER | Borrar rutina o automatizacion. */
/* ESTRUCTURA */
DROP PROCEDURE IF EXISTS sp_nombre;
DROP FUNCTION IF EXISTS fn_nombre;
DROP TRIGGER IF EXISTS trg_tabla_estado;
/* EJEMPLO */
DROP PROCEDURE IF EXISTS sp_consultar_cliente;

/* 52 DDL / DML / DQL | DDL estructura CREATE ALTER DROP TRUNCATE;
   DML datos INSERT UPDATE DELETE; DQL consultas SELECT.
   DELETE elimina filas, DROP tabla completa, TRUNCATE todas las filas.
*/

/* 53 ORDEN SELECT | SELECT FROM JOIN ON WHERE GROUP BY HAVING ORDER BY LIMIT.
   EJEMPLO DIFICIL: clientes con 2+ despachos entregados, mayor primero. */
/* ESTRUCTURA */
SELECT columna,COUNT(*) AS total
FROM nombre_tabla
WHERE condicion
GROUP BY columna
HAVING COUNT(*) >= 2
ORDER BY total DESC
LIMIT 5;
/* EJEMPLO */
SELECT idcliente,COUNT(*) AS total
FROM despacho
WHERE estado = 'entregado'
GROUP BY idcliente
HAVING COUNT(*) >= 2
ORDER BY total DESC
LIMIT 5;

/* FIN. IMPORTANTE: Las plantillas genericas NO funcionan sin reemplazar nombres.
   Algunos ejemplos CREATE/ALTER/DROP se contradicen si se ejecutan seguidos.
   Copiar SOLO el bloque necesario, verificar tablas, FK y datos antes de ejecutar.
*/
