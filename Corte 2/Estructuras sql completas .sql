/* GUIA SQL MYSQL DBEAVER - CTRL + F
   Archivo de plantillas: ejecutar SOLO el bloque elegido, no todo junto.
   INDICE: CREATE DATABASE, CREATE TABLE, PRIMARY KEY, FOREIGN KEY, CHECK,
   INSERT, UPDATE, DELETE, ALTER, MODIFY, DROP, TRUNCATE,
   SELECT, WHERE, BETWEEN, AND, OR, <>, IS NULL, IN, NOT IN, LIKE,
   ORDER BY, DISTINCT, LIMIT, COUNT, SUM, AVG, MAX, MIN,
   GROUP BY, HAVING, JOIN, LEFT JOIN, SELECT DENTRO DE SELECT,
   EXISTS, NOT EXISTS, CASE, COALESCE, FECHAS, VIEW, INDEX,
   TRANSACTION, SAVEPOINT, PROCEDURE, FUNCTION, TRIGGER, DELIMITER.
*/

/* TIPOS DE DATOS - CUANDO USAR
   INT: identificadores y cantidades enteras.
   BIGINT: enteros muy grandes.
   VARCHAR(n): nombres, correos, telefonos, documentos, placas.
   CHAR(n): codigos de longitud fija.
   TEXT: observaciones largas.
   DECIMAL(10,2): dinero, peso, capacidad exacta; 10 digitos, 2 decimales.
   FLOAT/DOUBLE: mediciones aproximadas.
   DATE: fecha sin hora.
   TIME: hora sin fecha.
   DATETIME: fecha y hora.
   TIMESTAMP: fecha y hora; util para auditorias.
   YEAR: año.
   BOOLEAN: verdadero/falso (MySQL usa 1 y 0).
   BLOB: datos binarios.
*/

/* 01 CREATE DATABASE
   CUANDO: crear una base nueva; iniciar proyecto.
   ESTRUCTURA: reemplazar nombre_base.
*/
CREATE DATABASE IF NOT EXISTS nombre_base;
USE nombre_base;
/* EJEMPLO */
CREATE DATABASE IF NOT EXISTS redlogistica;
USE redlogistica;

/* 02 CREATE TABLE
   CUANDO: crear entidad; almacenar clientes, vehiculos o despachos.
   PRIMARY KEY: ID unico.
   AUTO_INCREMENT: ID aumenta automaticamente.
   NOT NULL: obligatorio.
   UNIQUE: no repetir valor.
   DEFAULT: valor si no se especifica.
   CHECK: solo permitir valores validos.
   ESTRUCTURA */
CREATE TABLE nombre_tabla (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo',
    cantidad INT CHECK (cantidad >= 0),
    codigo VARCHAR(20) UNIQUE
);
/* EJEMPLO */
CREATE TABLE clientes_ejemplo (
    idcliente INT AUTO_INCREMENT PRIMARY KEY,
    nombrecliente VARCHAR(80) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    tipolugar VARCHAR(20) CHECK (tipolugar IN ('hospital','farmacia','distribuidores'))
);

/* 03 FOREIGN KEY / CONSTRAINT
   CUANDO: relacionar tablas; cada vehiculo pertenece a un centro.
   CONSTRAINT: pone nombre a la regla.
   FOREIGN KEY: columna que apunta al ID de otra tabla.
   ESTRUCTURA */
CREATE TABLE tabla_hija (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_padre INT NOT NULL,
    CONSTRAINT fk_hija_padre FOREIGN KEY (id_padre) REFERENCES tabla_padre(id)
);
/* EJEMPLO: necesita centrologistico previamente creada */
CREATE TABLE vehiculo_ejemplo (
    idvehiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10),
    idcentro INT NOT NULL,
    CONSTRAINT fk_vehiculo_centro_ejemplo FOREIGN KEY (idcentro) REFERENCES centrologistico(idcentro)
);

/* 04 CLAVE COMPUESTA / TABLA INTERMEDIA
   CUANDO: un despacho tiene varios productos y un producto aparece en varios despachos.
   ESTRUCTURA */
CREATE TABLE tabla_intermedia (
    id_a INT NOT NULL,
    id_b INT NOT NULL,
    cantidad INT,
    PRIMARY KEY (id_a,id_b),
    FOREIGN KEY (id_a) REFERENCES tabla_a(id),
    FOREIGN KEY (id_b) REFERENCES tabla_b(id)
);
/* EJEMPLO */
CREATE TABLE detalle_despacho_ejemplo (
    iddespacho INT NOT NULL,
    idcategoriaproducto INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (iddespacho,idcategoriaproducto),
    FOREIGN KEY (iddespacho) REFERENCES despacho(iddespacho),
    FOREIGN KEY (idcategoriaproducto) REFERENCES categoriaproducto(idcategoriaproducto)
);

/* 05 ALTER TABLE ADD COLUMN
   CUANDO: agregar una columna nueva; falta municipio o telefono.
   ESTRUCTURA */
ALTER TABLE nombre_tabla ADD COLUMN nueva_columna VARCHAR(50);
/* EJEMPLO */
ALTER TABLE clientes ADD COLUMN municipio VARCHAR(50);

/* 06 MODIFY COLUMN
   CUANDO: ampliar VARCHAR; cambiar tipo; hacer obligatorio u opcional.
   MODIFY cambia la DEFINICION de columna, no sus datos.
   ESTRUCTURA */
ALTER TABLE nombre_tabla MODIFY COLUMN nombre_columna VARCHAR(120) NOT NULL;
/* EJEMPLO */
ALTER TABLE clientes MODIFY COLUMN nombrecliente VARCHAR(120) NOT NULL;

/* 07 RENAME COLUMN
   CUANDO: cambiar nombre de columna.
   ESTRUCTURA */
ALTER TABLE nombre_tabla RENAME COLUMN anterior TO nuevo;
/* EJEMPLO */
ALTER TABLE clientes RENAME COLUMN telefono TO celular;

/* 08 DROP COLUMN / DROP TABLE / TRUNCATE
   CUANDO: DROP COLUMN quita una columna.
   DROP TABLE elimina tabla completa.
   TRUNCATE vacia tabla, conserva estructura.
   ESTRUCTURAS */
ALTER TABLE nombre_tabla DROP COLUMN columna;
DROP TABLE IF EXISTS nombre_tabla;
TRUNCATE TABLE nombre_tabla;
/* EJEMPLOS */
ALTER TABLE clientes DROP COLUMN municipio;
DROP TABLE IF EXISTS tabla_temporal;
TRUNCATE TABLE tabla_temporal;

/* 09 ADD CONSTRAINT
   CUANDO: agregar UNIQUE, CHECK o FOREIGN KEY a tabla existente.
   ESTRUCTURAS */
ALTER TABLE nombre_tabla ADD CONSTRAINT uq_codigo UNIQUE (codigo);
ALTER TABLE nombre_tabla ADD CONSTRAINT chk_cantidad CHECK (cantidad >= 0);
ALTER TABLE tabla_hija ADD CONSTRAINT fk_nueva FOREIGN KEY (id_padre) REFERENCES tabla_padre(id);
/* EJEMPLOS */
ALTER TABLE clientes ADD CONSTRAINT uq_correo UNIQUE (correo);
ALTER TABLE vehiculo ADD CONSTRAINT chk_capacidad CHECK (capacidad >= 0.5);

/* 10 INSERT
   CUANDO: registrar datos; incorporar uno o varios clientes.
   ESTRUCTURA */
INSERT INTO nombre_tabla (columna1,columna2) VALUES ('texto',10);
/* EJEMPLO */
INSERT INTO clientes (nombrecliente,tipolugar,numeroidentificacion)
VALUES ('Hospital San Gabriel','hospital','900456123');
/* VARIOS EN UNA SOLA INSTRUCCION */
INSERT INTO clientes (nombrecliente,tipolugar,numeroidentificacion)
VALUES ('Hospital Santa Clara','hospital','900321654'),
       ('Distribuidora Andina','distribuidores','901785432');

/* 11 UPDATE
   CUANDO: cambiar estado, telefono, precio de filas existentes.
   IMPORTANTE: WHERE decide cuales filas cambiar.
   ESTRUCTURA */
UPDATE nombre_tabla SET columna = 'nuevo valor' WHERE id = 1;
/* EJEMPLO */
UPDATE vehiculo SET estado = 'mantenimiento'
WHERE estado = 'activo' AND capacidad < 2;
/* VARIAS COLUMNAS */
UPDATE clientes SET telefono = '3001234567', correo = 'correo@gmail.com'
WHERE idcliente = 1;

/* 12 DELETE
   CUANDO: eliminar algunas filas; borrar cancelados.
   NO confundir con DROP TABLE.
   ESTRUCTURA */
DELETE FROM nombre_tabla WHERE columna = 'valor';
/* EJEMPLO */
DELETE FROM despacho WHERE estado = 'cancelado';

/* 13 SELECT / WHERE
   CUANDO: consultar todos; mostrar ciertas columnas; filtrar.
   ESTRUCTURAS */
SELECT * FROM nombre_tabla;
SELECT columna1,columna2 FROM nombre_tabla;
SELECT * FROM nombre_tabla WHERE columna = 'valor';
/* EJEMPLOS */
SELECT * FROM clientes;
SELECT nombrecliente,correo FROM clientes;
SELECT * FROM clientes WHERE tipolugar = 'hospital';

/* 14 BETWEEN
   CUANDO: entre 2 y 8; dentro de dos fechas; rango que INCLUYE extremos.
   BETWEEN contiene su propio AND para los dos limites.
   Agregar otro AND cuando tambien exige otra condicion.
   ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna BETWEEN minimo AND maximo;
/* EJEMPLO BASICO */
SELECT * FROM vehiculo WHERE capacidad BETWEEN 2 AND 8;
/* EJEMPLO DIFICIL: rango, activo y distinto de centro 3 */
SELECT * FROM vehiculo
WHERE capacidad BETWEEN 2 AND 8
  AND estado = 'activo'
  AND idcentro <> 3;
/* FECHAS */
SELECT * FROM revision
WHERE fecharevision BETWEEN '2026-07-01' AND '2026-12-31';

/* 15 > < >= <=
   CUANDO: superior a -> > ; inferior a -> < .
   Al menos / minimo -> >= ; como maximo / hasta -> <= .
   ESTRUCTURAS */
SELECT * FROM nombre_tabla WHERE columna > 10;
SELECT * FROM nombre_tabla WHERE columna < 10;
SELECT * FROM nombre_tabla WHERE columna >= 10;
SELECT * FROM nombre_tabla WHERE columna <= 10;
/* EJEMPLOS */
SELECT * FROM revision WHERE costo > 500000 AND costo <= 2000000;
SELECT * FROM vehiculo WHERE capacidad >= 0.5;

/* 16 AND / OR / PARENTESIS
   CUANDO: AND = cumplir TODO; OR = una opcion u otra.
   Con AND y OR juntos usar parentesis para aclarar.
   ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE condicion1 AND condicion2;
SELECT * FROM nombre_tabla WHERE condicion1 OR condicion2;
/* EJEMPLOS */
SELECT * FROM vehiculo WHERE estado = 'activo' AND capacidad > 5;
SELECT * FROM vehiculo
WHERE (estado = 'activo' AND capacidad > 5)
   OR (estado = 'mantenimiento' AND capacidad > 10);

/* 17 <> / != DIFERENTE DE
   CUANDO: distinto de A; no sea cancelado; excluir UN valor.
   <> y != significan lo mismo en MySQL.
   No incluyen automaticamente los NULL.
   ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna <> 'valor';
/* EJEMPLOS */
SELECT * FROM conductor WHERE licencia <> 'A';
SELECT * FROM despacho WHERE estado != 'cancelado';

/* 18 IS NULL / IS NOT NULL
   CUANDO: sin fecha, sin correo, sin supervisor -> IS NULL.
   Con correo, con fecha, dato registrado -> IS NOT NULL.
   No escribir = NULL.
   ESTRUCTURAS */
SELECT * FROM nombre_tabla WHERE columna IS NULL;
SELECT * FROM nombre_tabla WHERE columna IS NOT NULL;
/* EJEMPLOS */
SELECT * FROM despacho WHERE fechaentrega IS NULL AND estado <> 'cancelado';
SELECT * FROM clientes WHERE correo IS NOT NULL;

/* 19 IN / NOT IN
   CUANDO: IN = cualquiera de varias opciones.
   NOT IN = excluir varias opciones.
   Si la lista contiene NULL, NOT IN puede no devolver lo esperado.
   ESTRUCTURAS */
SELECT * FROM nombre_tabla WHERE columna IN ('A','B');
SELECT * FROM nombre_tabla WHERE columna NOT IN ('A','B');
/* EJEMPLOS */
SELECT * FROM clientes WHERE tipolugar IN ('hospital','farmacia');
SELECT * FROM despacho
WHERE estado NOT IN ('cancelado','entregado')
  AND municipio IN ('Bogota','Tunja','Medellin');

/* 20 LIKE / NOT LIKE
   CUANDO: comienza H -> 'H%'; contiene a -> '%a%'; termina gmail -> '%gmail.com'.
   % = cualquier cantidad de caracteres; _ = exactamente un caracter.
   ESTRUCTURAS */
SELECT * FROM nombre_tabla WHERE columna LIKE 'H%';
SELECT * FROM nombre_tabla WHERE columna LIKE '%a%';
SELECT * FROM nombre_tabla WHERE columna LIKE '%texto';
SELECT * FROM nombre_tabla WHERE columna NOT LIKE '%texto%';
/* EJEMPLOS */
SELECT * FROM clientes WHERE nombrecliente LIKE 'H%';
SELECT * FROM conductor WHERE nombreconductor LIKE '%a%';
SELECT * FROM clientes
WHERE nombrecliente LIKE 'H%' AND correo LIKE '%@gmail.com';

/* 21 REGEXP
   CUANDO: buscar patrones; solo numeros; comienza con letras determinadas.
   ^ inicio; $ final; [0-9] digito; + una o mas repeticiones.
   ESTRUCTURA */
SELECT * FROM nombre_tabla WHERE columna REGEXP '^[0-9]+$';
/* EJEMPLO */
SELECT * FROM clientes WHERE numeroidentificacion REGEXP '^[0-9]+$';

/* 22 ORDER BY ASC / DESC
   CUANDO: A-Z, menor-mayor, antiguo-reciente -> ASC.
   Z-A, mayor-menor, reciente-antiguo -> DESC.
   ESTRUCTURAS */
SELECT * FROM nombre_tabla ORDER BY columna ASC;
SELECT * FROM nombre_tabla ORDER BY columna DESC;
/* EJEMPLOS */
SELECT * FROM clientes ORDER BY nombrecliente ASC;
SELECT * FROM vehiculo ORDER BY capacidad DESC;
SELECT * FROM despacho ORDER BY municipio ASC, fechaprogramada DESC;

/* 23 DISTINCT / LIMIT / OFFSET
   CUANDO: DISTINCT = sin repetir; LIMIT = primeros N; OFFSET = saltar filas.
   ESTRUCTURAS */
SELECT DISTINCT columna FROM nombre_tabla;
SELECT * FROM nombre_tabla ORDER BY columna DESC LIMIT 5;
SELECT * FROM nombre_tabla ORDER BY columna DESC LIMIT 5 OFFSET 10;
/* EJEMPLOS */
SELECT DISTINCT municipio FROM despacho;
SELECT * FROM revision ORDER BY costo DESC LIMIT 3;

/* 24 COUNT SUM AVG MAX MIN
   CUANDO: cuantos -> COUNT; total -> SUM; promedio -> AVG.
   Mayor -> MAX; menor -> MIN.
   COUNT(*) cuenta filas; COUNT(columna) omite NULL.
   ESTRUCTURAS */
SELECT COUNT(*) AS total FROM nombre_tabla;
SELECT SUM(columna) AS total FROM nombre_tabla;
SELECT AVG(columna) AS promedio FROM nombre_tabla;
SELECT MAX(columna) AS mayor FROM nombre_tabla;
SELECT MIN(columna) AS menor FROM nombre_tabla;
/* EJEMPLOS */
SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT SUM(costo) AS costo_total FROM revision;
SELECT ROUND(AVG(costo),2) AS promedio FROM revision;
SELECT MAX(capacidad) AS mayor_capacidad FROM vehiculo;
SELECT MIN(costo) AS menor_costo FROM revision;

/* 25 GROUP BY
   CUANDO: cuantos POR estado; total POR cliente; promedio POR vehiculo.
   Agrupa filas de igual valor para calcular un resultado por grupo.
   ESTRUCTURA */
SELECT columna, COUNT(*) AS total FROM nombre_tabla GROUP BY columna;
/* EJEMPLOS */
SELECT estado, COUNT(*) AS total FROM despacho GROUP BY estado;
SELECT idvehiculo, SUM(costo) AS costo_total FROM revision GROUP BY idvehiculo;

/* 26 HAVING
   CUANDO: clientes con MAS DE 3 despachos; grupos con promedio mayor a X.
   WHERE filtra filas; HAVING filtra el resultado de cada grupo.
   ESTRUCTURA */
SELECT columna, COUNT(*) AS total
FROM nombre_tabla
GROUP BY columna
HAVING COUNT(*) > 3;
/* EJEMPLO */
SELECT idcliente, COUNT(*) AS total_despachos
FROM despacho
GROUP BY idcliente
HAVING COUNT(*) >= 2;
/* EJEMPLO COMBINADO */
SELECT idvehiculo, AVG(costo) AS promedio
FROM revision
WHERE costo IS NOT NULL
GROUP BY idvehiculo
HAVING AVG(costo) > 500000
ORDER BY promedio DESC;

/* 27 INNER JOIN
   CUANDO: mostrar nombre del cliente JUNTO con su despacho.
   Une filas que coinciden en ambas tablas.
   ON explica cuales ID se relacionan.
   ESTRUCTURA */
SELECT a.columna,b.columna
FROM tabla1 a
INNER JOIN tabla2 b ON a.id = b.id_fk;
/* EJEMPLO */
SELECT c.nombrecliente,d.iddespacho
FROM clientes c
INNER JOIN despacho d ON c.idcliente = d.idcliente;
/* TRES TABLAS */
SELECT c.nombrecliente,d.iddespacho,v.placa
FROM despacho d
INNER JOIN clientes c ON d.idcliente = c.idcliente
INNER JOIN vehiculo v ON d.idvehiculo = v.idvehiculo;

/* 28 LEFT JOIN
   CUANDO: mostrar TODOS los clientes, incluso los que no tienen despachos.
   Mantiene todas las filas de la tabla de la izquierda.
   ESTRUCTURA */
SELECT a.columna,b.columna
FROM tabla1 a
LEFT JOIN tabla2 b ON a.id = b.id_fk;
/* EJEMPLO */
SELECT c.nombrecliente,d.iddespacho
FROM clientes c
LEFT JOIN despacho d ON c.idcliente = d.idcliente;

/* 29 SELF JOIN
   CUANDO: conductor y su supervisor estan en la MISMA tabla.
   Usar dos alias para distinguir ambos papeles.
   ESTRUCTURA */
SELECT a.nombre,b.nombre
FROM tabla_personas a
LEFT JOIN tabla_personas b ON a.idsupervisor = b.id;
/* EJEMPLO */
SELECT c.nombreconductor AS conductor,s.nombreconductor AS supervisor
FROM conductor c
LEFT JOIN conductor s ON c.idsupervisor = s.idconductor;

/* 30 SELECT DENTRO DE SELECT: COMPARAR CON PROMEDIO
   CUANDO: vehiculos por encima del promedio; revisiones superiores al costo medio.
   El SELECT interior calcula un numero; el exterior busca filas.
   ESTRUCTURA */
SELECT * FROM nombre_tabla
WHERE columna > (SELECT AVG(columna) FROM nombre_tabla);
/* EJEMPLO */
SELECT * FROM vehiculo
WHERE capacidad > (SELECT AVG(capacidad) FROM vehiculo);

/* 31 SELECT DENTRO DE SELECT: SI APARECEN EN OTRA TABLA
   CUANDO: clientes que SI hicieron despachos; vehiculos que SI tuvieron revisiones.
   SELECT interior obtiene IDs; exterior muestra sus datos.
   ESTRUCTURA */
SELECT * FROM tabla1
WHERE id IN (SELECT id_fk FROM tabla2);
/* EJEMPLO */
SELECT * FROM clientes
WHERE idcliente IN (SELECT idcliente FROM despacho);

/* 32 SELECT DENTRO DE SELECT: NUNCA APARECEN
   CUANDO: clientes que NUNCA hicieron despachos; vehiculos SIN revisiones.
   Mejor usar NOT EXISTS cuando hay posibilidad de NULL en los IDs consultados.
   ESTRUCTURA */
SELECT * FROM tabla1 a
WHERE NOT EXISTS (SELECT 1 FROM tabla2 b WHERE b.id_fk = a.id);
/* EJEMPLO */
SELECT * FROM clientes c
WHERE NOT EXISTS (SELECT 1 FROM despacho d WHERE d.idcliente = c.idcliente);

/* 33 EXISTS / NOT EXISTS
   CUANDO: existe AL MENOS UNO relacionado -> EXISTS.
   No existe NINGUNO relacionado -> NOT EXISTS.
   SELECT 1 solo comprueba existencia; no muestra el numero 1.
   ESTRUCTURAS */
SELECT * FROM tabla1 a
WHERE EXISTS (SELECT 1 FROM tabla2 b WHERE b.id_fk = a.id);
SELECT * FROM tabla1 a
WHERE NOT EXISTS (SELECT 1 FROM tabla2 b WHERE b.id_fk = a.id);
/* EJEMPLOS */
SELECT * FROM vehiculo v
WHERE EXISTS (SELECT 1 FROM revision r WHERE r.idvehiculo = v.idvehiculo);
SELECT * FROM vehiculo v
WHERE NOT EXISTS (SELECT 1 FROM revision r WHERE r.idvehiculo = v.idvehiculo);

/* 34 BORRAR SOLO SI NO HAY RELACION
   CUANDO: borrar despachos cancelados SIN productos asociados.
   OJO: otras tablas, como historial, tambien pueden impedir el DELETE.
   ESTRUCTURA */
DELETE FROM tabla1
WHERE condicion
AND NOT EXISTS (SELECT 1 FROM tabla2 WHERE tabla2.id_fk = tabla1.id);
/* EJEMPLO */
DELETE FROM despacho
WHERE estado = 'cancelado'
AND NOT EXISTS (
    SELECT 1 FROM detalle_despacho dd
    WHERE dd.iddespacho = despacho.iddespacho
);

/* 35 VARIOS TOTALES EN UNA SOLA FILA
   CUANDO: muestre total clientes, despachos y vehiculos en una sola consulta.
   Cada SELECT interior calcula un total.
   ESTRUCTURA */
SELECT (SELECT COUNT(*) FROM tabla1) AS total1,
       (SELECT COUNT(*) FROM tabla2) AS total2;
/* EJEMPLO */
SELECT (SELECT COUNT(*) FROM clientes) AS total_clientes,
       (SELECT COUNT(*) FROM despacho) AS total_despachos,
       (SELECT COUNT(*) FROM vehiculo WHERE estado = 'mantenimiento') AS en_mantenimiento;

/* 36 COALESCE
   CUANDO: reemplazar NULL por 'SIN CORREO' o por 0 en resultado.
   No cambia la tabla; solo la salida de SELECT.
   ESTRUCTURA */
SELECT COALESCE(columna,'SIN DATO') AS resultado FROM nombre_tabla;
/* EJEMPLO */
SELECT nombrecliente,COALESCE(correo,'SIN CORREO') AS correo FROM clientes;

/* 37 CASE
   CUANDO: clasificar ALTO/MEDIO/BAJO; crear etiquetas segun condiciones.
   ESTRUCTURA */
SELECT columna,
CASE WHEN columna >= 10 THEN 'ALTO' ELSE 'BAJO' END AS categoria
FROM nombre_tabla;
/* EJEMPLO */
SELECT idvehiculo,capacidad,
CASE WHEN capacidad >= 5 THEN 'ALTA'
     WHEN capacidad >= 2 THEN 'MEDIA'
     ELSE 'BAJA' END AS categoria
FROM vehiculo;

/* 38 TEXTO
   CUANDO: CONCAT unir textos; UPPER mayusculas; LOWER minusculas.
   TRIM quitar espacios; CHAR_LENGTH contar caracteres; LENGTH contar bytes.
   ESTRUCTURAS */
SELECT CONCAT(columna1,' ',columna2) FROM nombre_tabla;
SELECT UPPER(columna),LOWER(columna),TRIM(columna),CHAR_LENGTH(columna),LENGTH(columna) FROM nombre_tabla;
/* EJEMPLOS */
SELECT CONCAT(nombrecliente,' - ',telefono) AS contacto FROM clientes;
SELECT UPPER(nombrecliente),LOWER(correo),TRIM(nombrecliente),CHAR_LENGTH(nombrecliente) FROM clientes;

/* 39 NUMEROS
   CUANDO: ROUND redondear; ABS valor absoluto; SQRT raiz cuadrada.
   ESTRUCTURAS */
SELECT ROUND(numero,2);
SELECT ABS(numero);
SELECT SQRT(numero);
/* EJEMPLOS */
SELECT ROUND(AVG(costo),2) AS promedio FROM revision;
SELECT ABS(-150) AS absoluto;
SELECT SQRT(144) AS raiz;

/* 40 FECHAS
   CUANDO: DATEDIFF dias entre fechas.
   TIMESTAMPDIFF minutos, horas, dias entre fechas y horas.
   DATE_ADD sumar dias; CURRENT_DATE fecha actual; NOW fecha y hora actual.
   ESTRUCTURAS */
SELECT DATEDIFF(fecha_final,fecha_inicial) FROM nombre_tabla;
SELECT TIMESTAMPDIFF(HOUR,fecha_inicio,fecha_fin) FROM nombre_tabla;
SELECT DATE_ADD(CURRENT_DATE,INTERVAL 15 DAY);
SELECT NOW();
/* EJEMPLOS */
SELECT iddespacho,DATEDIFF(fechaentrega,fechaprogramada) AS dias FROM despacho;
SELECT DATE_ADD(CURRENT_DATE,INTERVAL 15 DAY) AS vencimiento;

/* 41 VIEW - VISTA
   CUANDO: crear un reporte con nombre para consultarlo muchas veces.
   Una vista guarda la CONSULTA, no necesariamente una copia de datos.
   ESTRUCTURA */
CREATE OR REPLACE VIEW nombre_vista AS
SELECT columnas FROM nombre_tabla WHERE condicion;
/* EJEMPLO */
CREATE OR REPLACE VIEW vw_despachos_pendientes AS
SELECT iddespacho,municipio,estado FROM despacho WHERE estado = 'pendiente';
/* CONSULTAR VISTA */
SELECT * FROM vw_despachos_pendientes;
/* ELIMINAR VISTA */
DROP VIEW IF EXISTS vw_despachos_pendientes;

/* 42 INDEX - INDICE
   CUANDO: acelerar busquedas frecuentes por estado, fecha, cliente.
   No modifica los datos; crea una estructura para encontrarlos.
   ESTRUCTURA */
CREATE INDEX idx_nombre ON nombre_tabla(columna);
/* EJEMPLO */
CREATE INDEX idx_despacho_estado ON despacho(estado);
/* DOS COLUMNAS */
CREATE INDEX idx_despacho_estado_fecha ON despacho(estado,fechaprogramada);
/* ELIMINAR INDICE */
DROP INDEX idx_despacho_estado ON despacho;

/* 43 TRANSACTION / COMMIT / ROLLBACK
   CUANDO: varias operaciones deben confirmarse juntas o deshacerse.
   START TRANSACTION abre; COMMIT confirma; ROLLBACK deshace cambios sin confirmar.
   ESTRUCTURA */
START TRANSACTION;
UPDATE nombre_tabla SET columna = 'valor' WHERE id = 1;
COMMIT;
/* EJEMPLO */
START TRANSACTION;
UPDATE vehiculo SET estado = 'mantenimiento' WHERE idvehiculo = 1;
COMMIT;
/* PARA DESHACER EN VEZ DE CONFIRMAR: */
ROLLBACK;

/* 44 SAVEPOINT
   CUANDO: deshacer solo desde un punto intermedio de una transaccion.
   ESTRUCTURA */
START TRANSACTION;
UPDATE nombre_tabla SET columna = 'A' WHERE id = 1;
SAVEPOINT punto1;
UPDATE nombre_tabla SET columna = 'B' WHERE id = 2;
ROLLBACK TO SAVEPOINT punto1;
COMMIT;
/* EJEMPLO */
START TRANSACTION;
UPDATE vehiculo SET estado = 'mantenimiento' WHERE idvehiculo = 1;
SAVEPOINT antes_segundo;
UPDATE vehiculo SET estado = 'retirado' WHERE idvehiculo = 2;
ROLLBACK TO SAVEPOINT antes_segundo;
COMMIT;

/* 45 DELIMITER - QUE ES Y CUANDO USAR
   DELIMITER NO es una tabla ni una funcion.
   Cambia temporalmente la señal de FINAL de instruccion para el cliente MySQL.
   Normalmente ; termina una instruccion.
   En PROCEDURE, FUNCTION y TRIGGER hay varios ; dentro de BEGIN ... END.
   Por eso ponemos DELIMITER // antes, cerramos END // y volvemos a DELIMITER ;.
   En DBeaver puede depender de ejecutar el SCRIPT completo (Alt+X) y del editor SQL.
   ESTRUCTURA DE USO */
DELIMITER //
/* Aqui va CREATE PROCEDURE, FUNCTION o TRIGGER con BEGIN ... END // */
DELIMITER ;

/* 46 PROCEDURE - PROCEDIMIENTO
   CUANDO: crear pasos que se ejecutan con CALL.
   IN = dato que entra; OUT = dato que sale.
   BEGIN/END = inicio y final del bloque.
   ESTRUCTURA */
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

/* 47 DECLARE / SELECT INTO / SET
   CUANDO: guardar un numero en una variable DENTRO de un procedimiento o funcion.
   DECLARE crea variable; SELECT INTO guarda resultado; SET asigna valor.
   DECLARE debe ir al principio del bloque BEGIN, antes de otras instrucciones.
   ESTRUCTURA */
DELIMITER //
CREATE PROCEDURE sp_contar(IN p_estado VARCHAR(20), OUT p_total INT)
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM despacho WHERE estado = p_estado;
    SET p_total = v_total;
END //
DELIMITER ;
CALL sp_contar('pendiente',@resultado);
SELECT @resultado;

/* 48 FUNCTION - FUNCION
   CUANDO: calcular un valor y devolverlo dentro de SELECT.
   RETURNS dice tipo devuelto; RETURN entrega resultado.
   DETERMINISTIC significa que con mismos argumentos devuelve igual resultado.
   ESTRUCTURA */
DELIMITER //
CREATE FUNCTION fn_doble(p_numero INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_resultado INT;
    SET v_resultado = p_numero * 2;
    RETURN v_resultado;
END //
DELIMITER ;
SELECT fn_doble(5);
/* EJEMPLO CON DECIMAL */
DELIMITER //
CREATE FUNCTION fn_iva(p_precio DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN ROUND(p_precio * 0.19,2);
END //
DELIMITER ;
SELECT fn_iva(100000);

/* 49 IF / SIGNAL
   CUANDO: IF = si pasa esto, hacer algo; ELSE = si no.
   SIGNAL = detener y mostrar error personalizado.
   Se usan dentro de procedimientos, funciones o triggers.
   ESTRUCTURA */
DELIMITER //
CREATE PROCEDURE sp_validar_cantidad(IN p_cantidad INT)
BEGIN
    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad invalida';
    ELSE
        SELECT 'Cantidad valida' AS resultado;
    END IF;
END //
DELIMITER ;
CALL sp_validar_cantidad(5);

/* 50 TRIGGER - ACCION AUTOMATICA
   CUANDO: al INSERTAR, ACTUALIZAR o ELIMINAR, ejecutar una accion automaticamente.
   BEFORE = antes; AFTER = despues.
   OLD = valor anterior; NEW = valor nuevo.
   FOR EACH ROW = por cada fila afectada.
   EJEMPLO: guardar cambios de estado de despacho.
   ESTRUCTURA: el INSERT de auditoria se ajusta a la tabla de historial existente.
*/
DELIMITER //
CREATE TRIGGER trg_registrar_cambio
AFTER UPDATE ON despacho
FOR EACH ROW
BEGIN
    IF NOT (OLD.estado <=> NEW.estado) THEN
        INSERT INTO cambiosestadodespacho
            (iddespacho,estadoanterior,estadonuevo,fechacambio)
        VALUES (NEW.iddespacho,OLD.estado,NEW.estado,CURRENT_TIMESTAMP);
    END IF;
END //
DELIMITER ;
/* <=> compara incluso cuando alguno es NULL; NOT significa que son diferentes. */

/* 51 TRIGGER BEFORE INSERT - VALIDAR
   CUANDO: impedir un registro si no cumple una regla antes de guardarlo.
   ESTRUCTURA / EJEMPLO */
DELIMITER //
CREATE TRIGGER trg_validar_capacidad
BEFORE INSERT ON vehiculo
FOR EACH ROW
BEGIN
    IF NEW.capacidad < 0.5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Capacidad inferior al minimo';
    END IF;
END //
DELIMITER ;

/* 52 TRIGGER AFTER DELETE - AUDITORIA
   CUANDO: guardar evidencia de eliminaciones.
   Necesita tabla de auditoria independiente que no dependa por FK de la fila eliminada.
   ESTRUCTURA / EJEMPLO */
CREATE TABLE auditoria_clientes_ejemplo (
    idaudit INT AUTO_INCREMENT PRIMARY KEY,
    idcliente_eliminado INT,
    nombre_anterior VARCHAR(120),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER trg_cliente_eliminado
AFTER DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_clientes_ejemplo(idcliente_eliminado,nombre_anterior)
    VALUES (OLD.idcliente,OLD.nombrecliente);
END //
DELIMITER ;

/* 53 ELIMINAR OBJETOS
   CUANDO: eliminar vista, indice, procedimiento, funcion o trigger.
   ESTRUCTURAS */
DROP VIEW IF EXISTS nombre_vista;
DROP PROCEDURE IF EXISTS sp_nombre;
DROP FUNCTION IF EXISTS fn_nombre;
DROP TRIGGER IF EXISTS trg_nombre;
DROP INDEX idx_nombre ON nombre_tabla;
/* EJEMPLOS */
DROP PROCEDURE IF EXISTS sp_consultar_cliente;
DROP FUNCTION IF EXISTS fn_iva;
DROP TRIGGER IF EXISTS trg_validar_capacidad;

/* 54 ORDEN PARA ESCRIBIR SELECT
   SELECT columnas -> FROM tabla -> JOIN y ON -> WHERE filas ->
   GROUP BY agrupar -> HAVING filtrar grupos -> ORDER BY ordenar -> LIMIT.
   ESTRUCTURA */
SELECT columna,COUNT(*) AS total
FROM nombre_tabla
WHERE condicion
GROUP BY columna
HAVING COUNT(*) > 2
ORDER BY total DESC
LIMIT 5;
/* EJEMPLO */
SELECT estado,COUNT(*) AS total
FROM despacho
WHERE municipio IN ('Bogota','Tunja')
GROUP BY estado
HAVING COUNT(*) >= 2
ORDER BY total DESC
LIMIT 5;

/* ============================================================
   55. GUIA FINAL: QUE USAR SEGUN COMO LO DIGA LA PROFESORA
   ============================================================
   CREAR una base de datos -> CREATE DATABASE.
   CREAR una entidad o tabla -> CREATE TABLE.
   IDENTIFICAR cada fila -> PRIMARY KEY.
   RELACIONAR tablas -> FOREIGN KEY.
   N:M, varios a varios -> tabla intermedia, PRIMARY KEY compuesta.
   DATO OBLIGATORIO -> NOT NULL.
   NO REPETIR documento o correo -> UNIQUE.
   VALOR POR DEFECTO -> DEFAULT.
   SOLO VALORES VALIDOS -> CHECK.
   AGREGAR atributo -> ALTER TABLE ADD COLUMN.
   AMPLIAR VARCHAR -> ALTER TABLE MODIFY COLUMN.
   CAMBIAR TIPO de columna -> MODIFY COLUMN.
   RENOMBRAR columna -> RENAME COLUMN.
   ELIMINAR columna -> DROP COLUMN.
   BORRAR tabla -> DROP TABLE.
   VACIAR tabla -> TRUNCATE.
   REGISTRAR nuevos datos -> INSERT.
   CAMBIAR estado, precio o telefono -> UPDATE SET WHERE.
   ELIMINAR algunas filas -> DELETE FROM WHERE.
   MOSTRAR informacion -> SELECT.
   FILTRAR registros -> WHERE.
   ENTRE dos valores o fechas -> BETWEEN ... AND ... .
   CUMPLIR DOS O MAS condiciones -> AND.
   CUMPLIR UNA U OTRA -> OR.
   SUPERIOR A -> >.
   INFERIOR A -> <.
   AL MENOS / MINIMO -> >=.
   COMO MAXIMO / HASTA -> <=.
   DIFERENTE DE UN VALOR -> <> o !=.
   EXCLUIR VARIOS VALORES -> NOT IN.
   PERTENECE A VARIAS OPCIONES -> IN.
   NO TIENE fecha, correo o dato -> IS NULL.
   SI TIENE dato -> IS NOT NULL.
   EMPIEZA POR letra -> LIKE 'H%'.
   CONTIENE letra o palabra -> LIKE '%a%'.
   TERMINA EN -> LIKE '%gmail.com'.
   NO CONTIENE -> NOT LIKE.
   PATRON DE NUMEROS/LETRAS -> REGEXP.
   ALFABETICAMENTE / MENOR A MAYOR -> ORDER BY ASC.
   MAYOR A MENOR / MAS RECIENTE -> ORDER BY DESC.
   SIN REPETIR -> DISTINCT.
   PRIMEROS 5 -> LIMIT 5.
   CUANTOS -> COUNT.
   SUMA TOTAL -> SUM.
   PROMEDIO -> AVG.
   MAXIMO -> MAX.
   MINIMO -> MIN.
   POR CADA cliente, estado o vehiculo -> GROUP BY.
   GRUPOS CON MAS DE 3 -> HAVING COUNT(*) > 3.
   DOS TABLAS RELACIONADAS -> INNER JOIN.
   TODOS INCLUSO SIN RELACION -> LEFT JOIN.
   EMPLEADO Y SUPERVISOR -> SELF JOIN.
   SUPERIOR AL PROMEDIO GENERAL -> SELECT dentro de SELECT con AVG.
   CLIENTES QUE SI HICIERON PEDIDOS -> IN con SELECT / EXISTS.
   CLIENTES QUE NUNCA HICIERON PEDIDOS -> NOT EXISTS.
   NO EXISTE NINGUN REGISTRO RELACIONADO -> NOT EXISTS.
   EXISTE AL MENOS UNO -> EXISTS.
   MOSTRAR TRES TOTALES EN UNA FILA -> varios SELECT dentro de SELECT.
   REEMPLAZAR NULL POR TEXTO -> COALESCE.
   CLASIFICAR EN ALTO/MEDIO/BAJO -> CASE.
   UNIR TEXTOS -> CONCAT.
   MAYUSCULAS -> UPPER.
   MINUSCULAS -> LOWER.
   QUITAR ESPACIOS -> TRIM.
   CONTAR CARACTERES -> CHAR_LENGTH.
   REDONDEAR -> ROUND.
   VALOR ABSOLUTO -> ABS.
   RAIZ CUADRADA -> SQRT.
   DIAS ENTRE FECHAS -> DATEDIFF.
   HORAS/MINUTOS ENTRE FECHAS -> TIMESTAMPDIFF.
   SUMAR DIAS A FECHA -> DATE_ADD.
   GUARDAR CONSULTA COMO REPORTE -> VIEW.
   MEJORAR BUSQUEDAS -> INDEX.
   CONFIRMAR VARIAS OPERACIONES -> TRANSACTION y COMMIT.
   DESHACER CAMBIOS -> ROLLBACK.
   VOLVER A PUNTO INTERMEDIO -> SAVEPOINT.
   EJECUTAR PASOS CON CALL -> PROCEDURE.
   DEVOLVER UN VALOR CALCULADO -> FUNCTION.
   CREAR VARIABLE INTERNA -> DECLARE.
   GUARDAR RESULTADO EN VARIABLE -> SELECT INTO.
   SI SE CUMPLE UNA CONDICION -> IF.
   MOSTRAR ERROR Y DETENER -> SIGNAL.
   ACCION AUTOMATICA AL CAMBIAR FILAS -> TRIGGER.
   ANTES DEL CAMBIO -> BEFORE.
   DESPUES DEL CAMBIO -> AFTER.
   VALOR ANTERIOR -> OLD.
   VALOR NUEVO -> NEW.
   CAMBIAR FINAL DE INSTRUCCION EN BLOQUES -> DELIMITER.
   REGISTRAR HISTORIAL -> TABLA AUDITORIA + TRIGGER.

   COMBINACIONES QUE PUEDEN SALIR:
   ENTRE 2 Y 8 Y ACTIVO -> BETWEEN ... AND ... AND estado='activo'.
   ENTRE FECHAS Y NO CANCELADO -> BETWEEN ... AND ... AND estado <> 'cancelado'.
   NO CANCELADO NI ENTREGADO -> NOT IN ('cancelado','entregado').
   SIN FECHA Y PENDIENTE -> IS NULL AND estado='pendiente'.
   NOMBRE CON H Y GMAIL -> LIKE 'H%' AND LIKE '%@gmail.com'.
   TRES MUNICIPIOS Y COSTO MAYOR -> IN (...) AND costo > numero.
   HOSPITALES O FARMACIAS Y CON CORREO -> IN (...) AND correo IS NOT NULL.
   CLIENTES CON MAS DE 2 DESPACHOS -> JOIN + GROUP BY + HAVING.
   CLIENTES SIN DESPACHOS -> NOT EXISTS o LEFT JOIN con IS NULL.
   VEHICULOS MAS CAROS QUE EL PROMEDIO -> SELECT dentro de SELECT.
   CAMBIO DE ESTADO Y REGISTRAR HISTORIAL -> UPDATE + TRIGGER.
   SI FALLA DESHACER TODO -> TRANSACTION + ROLLBACK.

   FIN DE LA GUIA.
*/
