

/* ===========================================================
   1. CREACION DE LA BASE DE DATOS
   =========================================================== */



drop database if exists biblioteca_db;

create database biblioteca_db;

use biblioteca_db;


/* ===========================================================
   2. CREACION DE TABLAS
   =========================================================== */


/* TABLA SOCIOS */


create table socios (
    id int auto_increment primary key,
    nombre varchar(100) not null,
    email varchar(100) not null unique,
    activo boolean not null default true
);


/* TABLA LIBROS */

/* Creo la tabla libros para almacenar el inventario.
   Uso CHECK para impedir cantidades negativas. */

create table libros (
    id int auto_increment primary key,
    titulo varchar(150) not null,
    autor varchar(100) not null,
    ejemplares_totales int not null,
    ejemplares_disponibles int not null,

    constraint chk_libros_totales
    check (ejemplares_totales >= 0),

    constraint chk_libros_disponibles
    check (ejemplares_disponibles >= 0)
);


/* TABLA PRESTAMOS */

/* Creo la tabla prestamos para saber quien tiene
   cada libro y las fechas del prestamo.

   Uso FOREIGN KEY para relacionar socios y libros.
   La fecha_devolucion puede ser NULL porque
   el libro todavia puede estar prestado. */

create table prestamos (
    id int auto_increment primary key,
    socio_id int not null,
    libro_id int not null,
    fecha_prestamo date not null,
    fecha_limite date not null,
    fecha_devolucion date,

    constraint fk_prestamos_socio
    foreign key (socio_id)
    references socios(id),

    constraint fk_prestamos_libro
    foreign key (libro_id)
    references libros(id)
);


/* TABLA HISTORIAL_PRESTAMOS */

/* Creo la tabla historial para registrar
   cuando se presta o devuelve un libro.

   Uso DEFAULT CURRENT_TIMESTAMP para guardar
   automaticamente la fecha y hora. */

create table historial_prestamos (
    id int auto_increment primary key,
    prestamo_id int not null,
    accion varchar(20) not null,
    detalle varchar(255),
    usuario varchar(100) not null,
    fecha datetime not null default current_timestamp,

    constraint fk_historial_prestamo
    foreign key (prestamo_id)
    references prestamos(id)
);


/* Compruebo que las cuatro tablas existen. */

show tables;


/* ===========================================================
   3. INSERCION DE DATOS INICIALES
   =========================================================== */

/* Inserto los socios del enunciado.
   Valentina es inactiva y Mateo tiene tres prestamos. */

insert into socios (nombre, email, activo)
values
('Camila Rojas','camila@correo.com',true),
('Andrés Díaz','andres@correo.com',true),
('Valentina Ríos','valentina@correo.com',false),
('Mateo Castro','mateo@correo.com',true);


/* Inserto los libros.
   Clean Code no tiene ejemplares disponibles. */

insert into libros
(titulo, autor, ejemplares_totales, ejemplares_disponibles)
values
('Cien años de soledad','Gabriel García Márquez',3,2),
('Clean Code','Robert C. Martin',2,0),
('Fundamentos de bases de datos','Abraham Silberschatz',4,3),
('El principito','Antoine de Saint-Exupéry',2,2);


/* Inserto los cinco prestamos iniciales.
   Uso DATE_SUB y DATE_ADD para trabajar
   con fechas relativas al dia actual. */

insert into prestamos
(socio_id, libro_id, fecha_prestamo,
fecha_limite, fecha_devolucion)
values

(1,1,
date_sub(current_date, interval 40 day),
date_sub(current_date, interval 26 day),
date_sub(current_date, interval 27 day)),

(2,2,
date_sub(current_date, interval 20 day),
date_sub(current_date, interval 6 day),
null),

(4,2,
date_sub(current_date, interval 18 day),
date_sub(current_date, interval 4 day),
null),

(4,1,
date_sub(current_date, interval 5 day),
date_add(current_date, interval 9 day),
null),

(4,3,
date_sub(current_date, interval 2 day),
date_add(current_date, interval 12 day),
null);


/* Compruebo que los datos se insertaron. */

select * from socios;
select * from libros;
select * from prestamos;
select * from historial_prestamos;


/* ===========================================================
   R1. VISTA DE PRESTAMOS VENCIDOS
   =========================================================== */

/* Creo una VIEW porque quiero consultar
   los prestamos vencidos sin guardar
   una tabla adicional.

   Uso INNER JOIN para relacionar las tres tablas.
   Uso IS NULL porque busco libros no devueltos.
   Uso DATEDIFF para calcular los dias de retraso. */

create view v_prestamos_vencidos as
select
    p.id as id_prestamo,
    s.nombre as nombre_socio,
    s.email,
    l.titulo as titulo_libro,
    p.fecha_limite,
    datediff(current_date, p.fecha_limite) as dias_retraso
from prestamos p
inner join socios s
    on p.socio_id = s.id
inner join libros l
    on p.libro_id = l.id
where p.fecha_devolucion is null
and p.fecha_limite < current_date;


/* PRUEBA R1
   Deben aparecer dos prestamos vencidos:
   Andres con 6 dias y Mateo con 4 dias. */

select *
from v_prestamos_vencidos
order by dias_retraso desc;


/* ===========================================================
   R2. PROCEDIMIENTO ALMACENADO PARA PRESTAR LIBROS
   =========================================================== */

/* Creo un PROCEDURE porque necesito validar
   varias condiciones antes de registrar un prestamo.

   Uso IN para recibir socio, libro y dias.
   Uso OUT para devolver el ID del prestamo creado.

   Las reglas son:
   1. El socio debe existir y estar activo.
   2. No puede tener mas de 3 prestamos activos.
   3. El libro debe tener ejemplares disponibles.
   4. El prestamo debe durar entre 1 y 30 dias.

   Uso START TRANSACTION y ROLLBACK para
   evitar operaciones incompletas si hay errores. */

delimiter //

create procedure sp_prestar_libro(
    in p_socio_id int,
    in p_libro_id int,
    in p_dias int,
    out p_id_prestamo int
)
begin

    declare v_existe int default 0;
    declare v_activo boolean;
    declare v_prestamos_activos int default 0;
    declare v_disponibles int default 0;

    /* Si ocurre un error, deshago la transaccion. */

    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    /* Inicializo el parametro de salida. */

    set p_id_prestamo = null;

    /* Inicio la transaccion. */

    start transaction;

    /* Verifico que la cantidad de dias sea valida. */

    if p_dias is null
       or p_dias < 1
       or p_dias > 30 then

        signal sqlstate '45000'
        set message_text = 'Los dias deben estar entre 1 y 30';

    end if;


    /* Verifico que el socio exista. */

    select count(*)
    into v_existe
    from socios
    where id = p_socio_id;

    if v_existe = 0 then

        signal sqlstate '45000'
        set message_text = 'El socio no existe';

    end if;


    /* Verifico que el socio este activo. */

    select activo
    into v_activo
    from socios
    where id = p_socio_id
    for update;

    if v_activo = false then

        signal sqlstate '45000'
        set message_text = 'El socio esta inactivo';

    end if;


    /* Cuento los prestamos que no se han devuelto. */

    select count(*)
    into v_prestamos_activos
    from prestamos
    where socio_id = p_socio_id
    and fecha_devolucion is null;

    /* Bloqueo si ya tiene tres prestamos activos. */

    if v_prestamos_activos >= 3 then

        signal sqlstate '45000'
        set message_text = 'El socio ya tiene 3 prestamos activos';

    end if;


    /* Verifico que el libro exista. */

    select count(*)
    into v_existe
    from libros
    where id = p_libro_id;

    if v_existe = 0 then

        signal sqlstate '45000'
        set message_text = 'El libro no existe';

    end if;


    /* Consulto los ejemplares disponibles.
       FOR UPDATE bloquea el registro del libro
       mientras termina la transaccion. */

    select ejemplares_disponibles
    into v_disponibles
    from libros
    where id = p_libro_id
    for update;

    if v_disponibles <= 0 then

        signal sqlstate '45000'
        set message_text = 'No hay ejemplares disponibles';

    end if;


    /* Registro el prestamo con fecha de hoy.
       DATE_ADD calcula la fecha limite. */

    insert into prestamos (
        socio_id,
        libro_id,
        fecha_prestamo,
        fecha_limite,
        fecha_devolucion
    )
    values (
        p_socio_id,
        p_libro_id,
        current_date,
        date_add(current_date, interval p_dias day),
        null
    );


    /* Guardo el ID del prestamo recien creado. */

    set p_id_prestamo = last_insert_id();


    /* Descuento un ejemplar del inventario. */

    update libros
    set ejemplares_disponibles = ejemplares_disponibles - 1
    where id = p_libro_id;


    /* Registro la accion en el historial. */

    insert into historial_prestamos (
        prestamo_id,
        accion,
        detalle,
        usuario
    )
    values (
        p_id_prestamo,
        'PRESTAMO',
        concat('Prestamo realizado por ',p_dias,' dias'),
        current_user()
    );


    /* Confirmo todas las operaciones. */

    commit;

end //

delimiter ;


/* ===========================================================
   R3. TRIGGER PARA REGISTRAR DEVOLUCIONES
   =========================================================== */

/* Creo un TRIGGER AFTER UPDATE sobre prestamos.

   OLD contiene los datos anteriores.
   NEW contiene los datos actualizados.

   Uso IF para comprobar que antes no estaba devuelto
   y ahora si tiene fecha de devolucion.

   Cuando eso ocurre:
   1. Aumento el inventario en uno.
   2. Registro DEVOLUCION en el historial.

   Si se modifica otra columna, no hago nada. */

delimiter //

create trigger trg_prestamos_after_update
after update on prestamos
for each row
begin

    declare v_retraso int default 0;

    /* Solo actuo si acaba de devolverse el libro. */

    if old.fecha_devolucion is null
       and new.fecha_devolucion is not null then

        /* Aumento en uno los ejemplares disponibles. */

        update libros
        set ejemplares_disponibles = ejemplares_disponibles + 1
        where id = new.libro_id;


        /* Calculo el retraso.
           GREATEST evita resultados negativos. */

        set v_retraso = greatest(
            datediff(new.fecha_devolucion,new.fecha_limite),
            0
        );


        /* Registro la devolucion en el historial. */

        insert into historial_prestamos (
            prestamo_id,
            accion,
            detalle,
            usuario
        )
        values (
            new.id,
            'DEVOLUCION',
            concat('Devolucion con ',v_retraso,' dias de retraso'),
            current_user()
        );

    end if;

end //

delimiter ;


/* ===========================================================
   4. PRUEBAS DEL LABORATORIO
   =========================================================== */


/* PRUEBA 1
   Consulto la vista.
   Espero dos prestamos vencidos:
   Andres: 6 dias.
   Mateo: 4 dias. */

select *
from v_prestamos_vencidos;


/* PRUEBA 2
   Presto El principito a Camila por 14 dias.
   Debe generarse el prestamo 6.
   El inventario debe pasar de 2 a 1. */

call sp_prestar_libro(1,4,14,@id_prestamo);

select @id_prestamo as id_generado;

select *
from prestamos
where id = @id_prestamo;

select id, titulo, ejemplares_disponibles
from libros
where id = 4;

select *
from historial_prestamos;


/* PRUEBA 3
   Intento prestar a Valentina.
   Debe mostrar error porque esta inactiva.

   Ejecute esta llamada por separado
   quitando los comentarios.*/

call sp_prestar_libro(3,1,14,@id_prestamo);




/* PRUEBA 4
   Intento prestar Clean Code a Camila.
   Debe mostrar error porque no hay ejemplares.

   Ejecute esta llamada por separado. */

call sp_prestar_libro(1,2,14,@id_prestamo);



/* PRUEBA 5
   Intento prestar un libro a Mateo.
   Debe mostrar error porque ya tiene
   tres prestamos activos.

   Ejecute esta llamada por separado.*/

call sp_prestar_libro(4,4,14,@id_prestamo);




/* PRUEBA 6
   Intento prestar por cero dias.
   Debe mostrar error porque el rango
   permitido es de 1 a 30 dias.

   Ejecute esta llamada por separado.*/

call sp_prestar_libro(1,4,0,@id_prestamo);




/* PRUEBA 7
   Registro la devolucion del prestamo 2.
   El trigger debe aumentar el inventario
   de Clean Code de 0 a 1.
   Tambien debe registrar seis dias de retraso. */

update prestamos
set fecha_devolucion = current_date
where id = 2;


/* Verifico el inventario de Clean Code. */

select id, titulo, ejemplares_disponibles
from libros
where id = 2;


/* Verifico el registro de devolucion. */

select *
from historial_prestamos
where prestamo_id = 2;


/* PRUEBA 8
   Consulto nuevamente la vista.
   Ahora solo debe aparecer Mateo. */

select *
from v_prestamos_vencidos;


/* PRUEBA 9
   Repito el UPDATE del prestamo 2.
   Como ya tenia fecha de devolucion,
   el trigger no debe aumentar el inventario
   ni agregar otro registro al historial. */

update prestamos
set fecha_devolucion = current_date
where id = 2;


/* Verifico que el inventario siga en uno. */

select id, titulo, ejemplares_disponibles
from libros
where id = 2;


/* Verifico que solo exista una devolucion
   en el historial de este prestamo. */

select count(*) as total_devoluciones
from historial_prestamos
where prestamo_id = 2
and accion = 'DEVOLUCION';


/* ===========================================================
   5. RETO OPCIONAL
   =========================================================== */

/* Creo un segundo trigger BEFORE UPDATE para impedir
   devoluciones anteriores a la fecha del prestamo.

   Uso SIGNAL para mostrar un mensaje de error. */

delimiter //

create trigger trg_prestamos_before_update
before update on prestamos
for each row
begin

    if new.fecha_devolucion is not null
       and new.fecha_devolucion < new.fecha_prestamo then

        signal sqlstate '45000'
        set message_text = 'La devolucion no puede ser anterior al prestamo';

    end if;

end //

delimiter ;


/* PRUEBA OPCIONAL
   Debe generar error porque la devolucion
   es anterior a la fecha de prestamo.

   Ejecute por separado si desea comprobarlo.*/

update prestamos
set fecha_devolucion =
    date_sub(fecha_prestamo, interval 1 day)
where id = 3;




/* ===========================================================
   6. PREGUNTAS DE ANALISIS
   =========================================================== */


/* PREGUNTA 1
   ¿Por que el reporte de vencidos es una vista
   y no una tabla que se llena cada noche?

   RESPUESTA:

   Use una VIEW porque consulta los datos actualizados
   cada vez que ejecuto el SELECT.

   Si guardara una tabla cada noche, los datos
   podrian quedar desactualizados durante el dia.

   En PostgreSQL utilizaria una vista materializada
   si el reporte necesitara procesar muchisimos datos
   y quisiera guardar temporalmente el resultado
   para consultar mas rapido.

   La diferencia es que una vista materializada
   necesita actualizarse para reflejar los cambios.
*/


/* PREGUNTA 2
   ¿Por que el prestamo es un procedimiento
   y no un trigger BEFORE INSERT?

   RESPUESTA:

   Elegi un PROCEDURE porque puedo validar
   las reglas antes de registrar el prestamo
   y controlar toda la transaccion.

   Ventaja del procedimiento:
   Permite organizar varias operaciones y
   devolver el ID del prestamo creado.

   Desventaja del procedimiento:
   Si otro usuario inserta directamente en la tabla,
   podria saltarse las validaciones.

   Ventaja del trigger:
   Se ejecuta automaticamente cuando ocurre
   la operacion correspondiente.

   Desventaja del trigger:
   La logica es menos visible y puede ser
   mas dificil de revisar y mantener.
*/


/* PREGUNTA 3
   ¿Por que la devolucion usa un trigger
   en lugar de un procedimiento?

   RESPUESTA:

   Utilice un TRIGGER porque necesito actualizar
   el inventario automaticamente cuando cambia
   la fecha_devolucion.

   Asi, aunque alguien haga UPDATE directamente,
   la devolucion queda registrada.

   Sin el trigger, un funcionario podria registrar
   una devolucion y olvidar aumentar el inventario.
*/


/* PREGUNTA 4
   ¿Que pasa si dos funcionarios prestan
   al mismo tiempo el ultimo ejemplar?

   RESPUESTA:

   Sin control, ambos podrian consultar que
   queda un ejemplar e intentar prestarlo.

   Utilice FOR UPDATE para bloquear la fila
   del libro durante la transaccion.

   La instruccion es:

   SELECT ejemplares_disponibles
   INTO v_disponibles
   FROM libros
   WHERE id = p_libro_id
   FOR UPDATE;

   El segundo funcionario debe esperar
   hasta que termine la primera transaccion.

   Despues se vuelve a comprobar la cantidad
   disponible y no puede prestarse si es cero.

   Tambien bloqueo el registro del socio
   para evitar que se superen tres prestamos
   activos en operaciones simultaneas.
*/


/* PREGUNTA 5
   Mencione dos cambios necesarios para
   llevar el codigo de MySQL a PostgreSQL.

   RESPUESTA:

   PRIMER CAMBIO:
   En MySQL utilizo AUTO_INCREMENT.
   En PostgreSQL puedo utilizar:

   GENERATED ALWAYS AS IDENTITY

   SEGUNDO CAMBIO:
   En MySQL utilizo SIGNAL SQLSTATE '45000'.
   En PostgreSQL utilizaria RAISE EXCEPTION.

   Otros cambios:
   MySQL usa LAST_INSERT_ID().
   PostgreSQL puede usar RETURNING id INTO.

   MySQL usa DELIMITER //.
   PostgreSQL utiliza bloques $$ con PL/pgSQL.
*/


/* ===========================================================
   7. CONSULTAS FINALES DE VERIFICACION
   =========================================================== */

/* Consulto todos los libros y su disponibilidad. */

select *
from libros;


/* Consulto los prestamos con sus socios y libros. */

select
    p.id,
    s.nombre as socio,
    l.titulo as libro,
    p.fecha_prestamo,
    p.fecha_limite,
    p.fecha_devolucion
from prestamos p
inner join socios s
    on p.socio_id = s.id
inner join libros l
    on p.libro_id = l.id
order by p.id;


/* Consulto el historial completo. */

select *
from historial_prestamos
order by id;


/* Consulto los prestamos que siguen vencidos. */

select *
from v_prestamos_vencidos;


