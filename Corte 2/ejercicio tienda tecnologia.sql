create database tienda_tecno;
           with encoding ='UTF8'
           template=template0;

/* crear tablas*/
create table clientes( 
idcliente serial primary key, 
nombreCliente varchar(50) not null, 
correoCliente varchar(120)not null unique,
fechaRegristro date not null default current_date
);


create table product(
idProducto serial primary key, 
nombreProducto varchar (100) not null, 
precioProducto numeric (10,2) not null check (precioProducto>0), 
stock int not null default 0
);


create table pedido(
idPedido serial primary key,
idClienteFK integer not null references clientes(idCliente) on delete cascade,
fechaPedido timestamp not null default now()  ,
estadoPedido varchar (20) not null default 'pendiente'
);


create table detallePedido (
idPedidoFK integer not null references pedido (idPedido) on delete cascade,
idproductoFK  integer not null references product (idProducto) on delete cascade,
cantidad integer not null check (cantidad>0),
primary key (idPedidoFk, idProductoFK)
);

alter table clientes add column Telefono varchar (20);

/* cambiar en t producto tipo de columna, nombreProducto varchar (150) */
alter table product alter column nombreProducto type varchar (150);

/*renombrear estadoPedido por estado*/
alter table pedido rename column estadopedido to estado;

alter table product 
add constraint stockPositive
check( stock>=0);

drop table if exists detallepedido;

