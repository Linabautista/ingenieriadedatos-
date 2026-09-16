/* TABLA COMPANIA*/
CREATE TABLE compania (
    NIT VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fechaFundacion DATE,
    representanteLegal VARCHAR(50)
);

/*TABLA AUTOMOVIL*/
CREATE TABLE automovil (
    idAutomovil SERIAL PRIMARY KEY,
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(30),
    placa VARCHAR(10) NOT NULL UNIQUE,
    tipo VARCHAR(30),
    anioFabricacion INT,
    nroChasis VARCHAR(30),
    pasajeros INT,
    cilindraje INT
);

/* TABLA SEGURO*/
CREATE TABLE seguro (
    idSeguro SERIAL PRIMARY KEY,
    NITCompaniaFK VARCHAR(20) NOT NULL,
    idAutomovilFK INT NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaExpiracion DATE,
    estado VARCHAR(20),
    valorAsegurado DECIMAL(12,2),
    costo DECIMAL(10,2),

    CONSTRAINT fk_seguro_compania
        FOREIGN KEY (NITCompaniaFK)
        REFERENCES compania(NIT),

    CONSTRAINT fk_seguro_automovil
        FOREIGN KEY (idAutomovilFK)
        REFERENCES automovil(idAutomovil)
);

/*TABLA ACCIDENTE*/
CREATE TABLE accidente (
    idAccidente SERIAL PRIMARY KEY,
    fechaAccidente DATE NOT NULL,
    lugar VARCHAR(100),
    heridos INT,
    fatalidades INT
);

/* TABLA INTERMEDIA AUTOMOVIL - ACCIDENTE*/
CREATE TABLE involucra (
    idInvolucra SERIAL PRIMARY KEY,
    idAutomovilFK INT NOT NULL,
    idAccidenteFK INT NOT NULL,

    CONSTRAINT fk_involucra_automovil
        FOREIGN KEY (idAutomovilFK)
        REFERENCES automovil(idAutomovil),

    CONSTRAINT fk_involucra_accidente
        FOREIGN KEY (idAccidenteFK)
        REFERENCES accidente(idAccidente)
);