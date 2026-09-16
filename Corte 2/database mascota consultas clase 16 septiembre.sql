CREATE DATABASE tienda_mascota1;

CREATE TABLE cliente1 (
    cedula INT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    telefono VARCHAR(20)
);

/* crear tabla mascota1 */
CREATE TABLE mascota1 (
    codigoMascota INT PRIMARY KEY,
    nombreMascota VARCHAR(50) NOT NULL,
    tipoMascota VARCHAR(30),
    generoMascota VARCHAR(20),
    razaMascota VARCHAR(50),
    cedulaClienteFK INT,
    CONSTRAINT fk_mascota1_cliente1
    FOREIGN KEY (cedulaClienteFK)
    REFERENCES cliente1(cedula)
);

/* crear tabla producto1 */
CREATE TABLE producto1 (
    codigoBarras VARCHAR(30) PRIMARY KEY,
    nombreProducto VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    precio DECIMAL(10,2)
);

/* crear tabla vacuna1 */
CREATE TABLE vacuna1 (
    codigoVacuna INT PRIMARY KEY,
    nombreVacuna VARCHAR(50) NOT NULL,
    dosis VARCHAR(30),
    enfermedad VARCHAR(100)
);

/* crear tabla compra1 */
CREATE TABLE compra1 (
    idCompra INT PRIMARY KEY,
    cedulaClienteFK INT,
    codigoBarrasFK VARCHAR(30),
    CONSTRAINT fk_compra1_cliente1
    FOREIGN KEY (cedulaClienteFK)
    REFERENCES cliente1(cedula),
    CONSTRAINT fk_compra1_producto1
    FOREIGN KEY (codigoBarrasFK)
    REFERENCES producto1(codigoBarras)
);

/* crear tabla aplicacionVacuna1 */
CREATE TABLE aplicacionVacuna1 (
    idAplicacion INT PRIMARY KEY,
    codigoMascotaFK INT,
    codigoVacunaFK INT,
    CONSTRAINT fk_aplicacion1_mascota1
    FOREIGN KEY (codigoMascotaFK)
    REFERENCES mascota1(codigoMascota),
    CONSTRAINT fk_aplicacion1_vacuna1
    FOREIGN KEY (codigoVacunaFK)
    REFERENCES vacuna1(codigoVacuna)
);

/* crear index para precio de producto1 */
CREATE INDEX index_precio_producto1
ON producto1(precio);


/* insertar 10 registros en cliente1 */
INSERT INTO cliente1 (cedula, nombres, apellidos, direccion, telefono) VALUES
(1001, 'Ana', 'Lopez', 'Calle 10', '3001111111'),
(1002, 'Laura', 'Gomez', 'Calle 20', '3002222222'),
(1003, 'Carlos', 'Perez', 'Carrera 5', '3003333333'),
(1004, 'Sofia', 'Torres', 'Calle 30', '3004444444'),
(1005, 'Daniel', 'Ruiz', 'Carrera 10', '3005555555'),
(1006, 'Maria', 'Diaz', 'Calle 40', '3006666666'),
(1007, 'Andres', 'Rojas', 'Carrera 15', '3007777777'),
(1008, 'Paula', 'Castro', 'Calle 50', '3008888888'),
(1009, 'Juan', 'Martinez', 'Carrera 20', '3009999999'),
(1010, 'Camila', 'Vargas', 'Calle 60', '3011111111');


/* insertar 10 registros en producto1 */
INSERT INTO producto1 (codigoBarras, nombreProducto, marca, precio) VALUES
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
INSERT INTO vacuna1 (codigoVacuna, nombreVacuna, dosis, enfermedad) VALUES
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
INSERT INTO mascota1
(codigoMascota, nombreMascota, tipoMascota, generoMascota, razaMascota, cedulaClienteFK) VALUES
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
INSERT INTO compra1 (idCompra, cedulaClienteFK, codigoBarrasFK) VALUES
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
INSERT INTO aplicacionVacuna1
(idAplicacion, codigoMascotaFK, codigoVacunaFK) VALUES
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
select * from  cliente1;
/* consultar mascota1 */
SELECT * FROM mascota1;

/* consultar producto1 */
SELECT * FROM producto1;

/* consultar vacuna1 */
SELECT * FROM vacuna1;

/* consultar compra1 */
SELECT * FROM compra1;

/* consultar aplicacionVacuna1 */
SELECT * FROM aplicacionVacuna1;

/* sentencia select */

select  codigoMascota  from mascota1;

/* consultar con alias usara el as 'nombredealias' */
SELECT codigoMascota AS codigo, nombreMascota AS nombre, tipoMascota AS tipo, razaMascota AS raza
FROM mascota1;

/* consultas con ordenamiento  para nombrar de a a z y de z a a  asc desc*/ 
SELECT * FROM mascota1 ORDER BY nombreMascota ASC;
SELECT * FROM mascota1 ORDER BY nombreMascota DESC;

/* consulta una sola categoria ejemplo las mascotas que sean perros */
SELECT * FROM mascota1 WHERE tipoMascota = 'Perro';

/* consultar mascotas con dos condiciones */
SELECT * FROM mascota1 WHERE tipoMascota = 'Perro' AND codigoMascota <= 3;
SELECT * FROM mascota1 WHERE tipoMascota = 'Gato' AND  codigoMascota <=3;


