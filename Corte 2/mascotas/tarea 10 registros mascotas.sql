CREATE DATABASE tienda_mascota1;

 USE tienda_mascota1;

/* crear tabla cliente */
CREATE TABLE cliente (
    cedula INT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    telefono VARCHAR(20)
);

/* crear tabla mascota */
CREATE TABLE mascota (
    codigoMascota INT AUTO_INCREMENT PRIMARY KEY,
    nombreMascota VARCHAR(50) NOT NULL,
    tipoMascota VARCHAR(30),
    generoMascota VARCHAR(20),
    razaMascota VARCHAR(50),
    cedulaClienteFK INT,

    CONSTRAINT fk_mascota_cliente
    FOREIGN KEY (cedulaClienteFK)
    REFERENCES cliente(cedula)
);

/* crear tabla producto */
CREATE TABLE producto (
    codigoBarras VARCHAR(30) PRIMARY KEY,
    nombreProducto VARCHAR(100) NOT NULL,
    marca VARCHAR (50),
    precio DECIMAL (10,2)
    
  );
    
/* crear tabla vacuna */
CREATE TABLE vacuna (
    codigoVacuna INT AUTO_INCREMENT PRIMARY KEY,
    nombreVacuna VARCHAR(50) NOT NULL,
    dosis VARCHAR(30),
    enfermedad VARCHAR(100)
);


/* crear tabla compra */
CREATE TABLE compra (
    idCompra INT AUTO_INCREMENT PRIMARY KEY,
    cedulaClienteFK INT,
    codigoBarrasFK VARCHAR(30),

    CONSTRAINT fk_compra_cliente
    FOREIGN KEY (cedulaClienteFK)
    REFERENCES cliente(cedula),

    CONSTRAINT fk_compra_producto
    FOREIGN KEY (codigoBarrasFK)
    REFERENCES producto(codigoBarras)
);


/* crear tabla aplicacion vacuna */
CREATE TABLE aplicacionVacuna (
    idAplicacion INT AUTO_INCREMENT PRIMARY KEY,
    codigoMascotaFK INT,
    codigoVacunaFK INT,

    CONSTRAINT fk_aplicacion_mascota
    FOREIGN KEY (codigoMascotaFK)
    REFERENCES mascota(codigoMascota),

    CONSTRAINT fk_aplicacion_vacuna
    FOREIGN KEY (codigoVacunaFK)
    REFERENCES vacuna(codigoVacuna)
);


/* mostrar las tablas creadas */
SHOW TABLES;


create index idxProdructo on producto (nombreProducto, precio);
create index idxcompra on compra(cedulaClienteFK , codigoBarrasFK);



insert into producto (codigoBarras, nombreProducto, marca, precio) values ('1001', 'concntrado para perro', 'dogFood',4500)

select *from producto;

USE tienda_mascota1;


/* insertar 10 registros en cliente */
INSERT INTO cliente (cedula, nombres, apellidos, direccion, telefono) VALUES
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


/* insertar 10 registros en producto */
INSERT INTO producto (codigoBarras, nombreProducto, marca, precio) VALUES
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


/* insertar 10 registros en vacuna */
INSERT INTO vacuna (nombreVacuna, dosis, enfermedad) VALUES
('Vacuna A', '1 dosis', 'Enfermedad A'),
('Vacuna B', '1 dosis', 'Enfermedad B'),
('Vacuna C', '2 dosis', 'Enfermedad C'),
('Vacuna D', '1 dosis', 'Enfermedad D'),
('Vacuna E', '2 dosis', 'Enfermedad E'),
('Vacuna F', '1 dosis', 'Enfermedad F'),
('Vacuna G', '2 dosis', 'Enfermedad G'),
('Vacuna H', '1 dosis', 'Enfermedad H'),
('Vacuna I', '2 dosis', 'Enfermedad I'),
('Vacuna J', '1 dosis', 'Enfermedad J');


/* insertar 10 registros en mascota */
INSERT INTO mascota (nombreMascota, tipoMascota, generoMascota, razaMascota, cedulaClienteFK) VALUES
('Luna', 'Perro', 'Hembra', 'Labrador', 1001),
('Max', 'Perro', 'Macho', 'Beagle', 1002),
('Milo', 'Gato', 'Macho', 'Siames', 1003),
('Nala', 'Gato', 'Hembra', 'Persa', 1004),
('Toby', 'Perro', 'Macho', 'Pug', 1005),
('Kira', 'Perro', 'Hembra', 'Husky', 1006),
('Simba', 'Gato', 'Macho', 'Criollo', 1007),
('Rocky', 'Perro', 'Macho', 'Bulldog', 1008),
('Mia', 'Gato', 'Hembra', 'Angora', 1009),
('Coco', 'Perro', 'Macho', 'Criollo', 1010);


/* insertar 10 registros en compra */
INSERT INTO compra (cedulaClienteFK, codigoBarrasFK) VALUES
(1001, 'P001'),
(1002, 'P002'),
(1003, 'P003'),
(1004, 'P004'),
(1005, 'P005'),
(1006, 'P006'),
(1007, 'P007'),
(1008, 'P008'),
(1009, 'P009'),
(1010, 'P010');


/* insertar 10 registros en aplicacion vacuna */
INSERT INTO aplicacionVacuna (codigoMascotaFK, codigoVacunaFK) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


/* consultar los registros de cliente */
SELECT * FROM cliente;

/* consultar los registros de producto */
SELECT * FROM producto;

/* consultar los registros de vacuna */
SELECT * FROM vacuna;

/* consultar los registros de mascota */
SELECT * FROM mascota;

/* consultar los registros de compra */
SELECT * FROM compra;

/* consultar los registros de aplicacion vacuna */
e-