

/* EJEMPLO 1*/

/*Crear la funcion delete para reservas*/
create OR REPLACE  FUNCTION fn_delete_reservas() RETURNS trigger as
$$
Begin 
	if((select count(*)from reservas)>1)then
	raise notice 'No es posible borrar más de un registro';
	ROLLBACK;
	end if;
end
$$
language plpgsql;

/* Crear el trigger */
Create trigger tr_delete_reservas
before delete on reservas
FOR EACH ROW execute procedure fn_delete_reservas();


/*Eliminar usando drop*/
drop TRIGGER tr_delete_reservas on reservas
drop FUNCTION fn_delete_reservas()

/*Borrar registros de reservas*/
delete from reservas;


/*Ejercicio 2*/

select * from vuelos;
INSERT into vuelos values ('VUE-50','AMS-UIO','AJO-GYE','A330F-01','2023-03-14','00:30:00','PIL-04','COP-01','AUX-04')
INSERT into vuelos values ('VUE-40','AMS-UIO','AJO-GYE','A330F-01','2022-03-14','00:30:00','PIL-04','COP-01','AUX-04')

create table log_delete_vuelos (
   CODIGOVUE            TEXT                 not null,
   CODIGOAER            VARCHAR(10)          null,
   AER_CODIGOAER        VARCHAR(10)          null,
   CODIGOAVI            TEXT                 null,
   FECHAVUE             DATE                 not null,
   DURACIONVUE          TIME                 not null
 )
 
 Create OR REPLACE FUNCTION fn_delete_fechavue() returns trigger
 as
 $$
  DECLARE
  fecha date= current_date;
  Begin
  if(old.fechavue>fecha) then
  raise notice 'No se puede borrar el registro debido a que el vuelo esta programado para %',old.fechavue;
  ROLLBACK;
  ELSE
  insert into log_delete_vuelos values (old.codigovue,old.codigoaer,old.aer_codigoaer,old.codigoavi, old.fechavue, 
										old.duracionvue);
  raise notice 'Se ha realizado el respaldo del vuelo eliminado';
  return new;
  end if;
 end
  $$
 Language plpgsql;
 
 /* Crear el trigger */
Create trigger tr_delete_vuelos
before delete on vuelos
FOR EACH ROW execute procedure fn_delete_fechavue();

/*Eliminar usando drop*/
drop TRIGGER tr_delete_vuelos on vuelos
drop FUNCTION fn_delete_fechavue();

/*Intentar*/
Delete from vuelos where codigovue='VUE-50';
Delete from vuelos where codigovue='VUE-40';

/*Visualizar tabla log*/
select* from log_delete_vuelos


