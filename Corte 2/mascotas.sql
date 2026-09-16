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