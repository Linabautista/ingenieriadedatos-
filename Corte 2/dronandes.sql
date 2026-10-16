drop database if exists dronandes;
create database dronandes;
use dronandes;

create table bases (
id_base INT auto_increment,
nombre varchar (60) not null,
municipio varchar (60) not null, 
departamento varchar (40) not null, 
capacidad_drones INT not null, 
fecha_apertura date not null, 

primary key (id_base),
unique (nombre),
constraint chk_bases_capacidad check (capacidad_drones > 0)

);

create table tipos_carga (
        id_tipo int auto_increment, 
        nombre varchar (40) not null, 
        tarifa_kg decimal (10,2) not null, 
        requiere_frio boolean not null default false,
        
        primary key (id_tipo),
        unique (nombre),
        constraint chk_tipos_tarifa check (tarifa_kg > 0)
        );

create table drones (
    id_dron int auto_increment, 
    codigo_serie varchar (12) not null, 
    modelo varchar (40) not null,
    carga_max_kg decimal (5,2) not null, 
    autonomia_km decimal (5,1) not null, 
    estado varchar (15) not null default 'activo', 
    hora_vuelo decimal (7,1) not null default 0, 
    fecha_adquisicion date not null, 
    id_base int not null, 
    primary key (id_dron),
    unique (codigo_serie),
    constraint chk_drones_autonomia check (autonomia_km >0),
    constraint chk_drones_estado check (estado in ('activo', 'mantenimiento' , 'retirado')),
    constraint chk_drones_horas check (hora_vuelo>=0),
    constraint fk_drones_base 
       foreign key (id_base) references bases(id_base)
    );
    
    
    
create table pilotos (
     id_piloto int auto_increment,
     documento varchar (15) not null,
     nombre varchar (50) not null, 
     email varchar (80) not null,
     licencia char (1) not null, 
     fecha_ingreo date not null, 
     id_supervisor int,
     id_base int not null, 
     primary key (id_piloto),
     unique (documento),
     unique (email), 
     constraint chk_pilotos_licencia 
                check (licencia in ('a', 'b', 'c')),
        
     constraint fk_pilotos_base 
     foreign key (id_base)references bases (id_base)
     );
     


create table clientes (
     id_cliente int auto_increment,
     tipo varchar (12) not null,
     nombre varchar (80) not null, 
     nit_documento varchar (15) not null,
     email varchar (80), 
     telefono varchar (15), 
     municipio varchar (60) not null, 
     fecha_registro date not null default (current_date),
     
     primary key (id_cliente),
     unique (nit_documento),
     unique (email), 
     
     constraint chk_clientes_tipo
                check (tipo in ('hospital', 'farmacia', 'comercio','ong', 'persona'))

);
     
create table entregas (
    id_entrega int auto_increment,
    codigo varchar (10) not null, 
    id_cliente int not null,
    id_dron int not null,
    id_piloto int not null,
    fecha_programada datetime not null,
    fecha_entrega datetime,
    distancia_km decimal (5, 1) not null, 
    prioridad varchar (8) not null default 'normal',
    estado varchar (12) not null default 'programada', 
   calificacion smallint,
   
     
     primary key (id_entrega),
     unique (codigo),
  
     
     constraint chk_entregas_distancia
         check (distancia_km >0),
    
     constraint chk_entregas_prioridad
         check (prioridad in ('normal','urgente', 'vital')),
         
      constraint chk_entregas_estado
         check  (estado in ('programada','en_vuelo', 'entregada','cancelada', 'fallida')),
       
      constraint chk_entregas_calificacion
         check  (calificacion between 1 and 5),
       

      constraint chk_entregas_clientes
      foreign key (id_cliente) references clientes(id_cliente),
      
      constraint chk_entregas_dron
      foreign key (id_dron) references drones(id_dron),
      constraint fk_entregas_piloto
      foreign key (id_dron) references pilotos (id_piloto)
     

);






