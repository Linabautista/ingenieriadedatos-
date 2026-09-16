CREATE DATABASE encomiendas;

*/TABLA CAMIONERO*/
CREATE TABLE camionero (
    identificacion INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(100)
);

/*TABLA CAMION*/
CREATE TABLE camion (
    placa VARCHAR(10) PRIMARY KEY,
    modelo VARCHAR(30),
    potencia VARCHAR(30),
    tipo VARCHAR(30)
);

/* TABLA CIUDAD*/
CREATE TABLE ciudad (
    codigoCiudad SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

/*TABLA PAQUETE*/
CREATE TABLE paquete (
    codigoPaquete SERIAL PRIMARY KEY,
    descripcion VARCHAR(100),
    destinatario VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    identificacionCamioneroFK INT,
    codigoCiudadFK INT,

    CONSTRAINT fk_paquete_camionero
        FOREIGN KEY (identificacionCamioneroFK)
        REFERENCES camionero(identificacion),

    CONSTRAINT fk_paquete_ciudad
        FOREIGN KEY (codigoCiudadFK)
        REFERENCES ciudad(codigoCiudad)
);

/*TABLA INTERMEDIA CONDUCE*/
CREATE TABLE conduce (
    idConduce SERIAL PRIMARY KEY,
    identificacionCamioneroFK INT NOT NULL,
    placaCamionFK VARCHAR(10) NOT NULL,

    CONSTRAINT fk_conduce_camionero
        FOREIGN KEY (identificacionCamioneroFK)
        REFERENCES camionero(identificacion),

    CONSTRAINT fk_conduce_camion
        FOREIGN KEY (placaCamionFK)
        REFERENCES camion(placa)
);