use planta;

select * from produccion;


/*CREACION DE  RELACIONES*/
ALTER TABLE desperdicios
ADD CONSTRAINT fk_desperdicioDepatamentos
FOREIGN KEY (id_departamento) REFERENCES departamentos(id);

ALTER TABLE produccion
ADD CONSTRAINT fk_produccionDepatamentos
FOREIGN KEY (id_departamento) REFERENCES departamentos(id);



/*CONSULTAS DE RELACIONES EXISTENTES*/
SELECT
*
FROM
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
  REFERENCED_TABLE_SCHEMA = 'planta';
  
 /*produccion x operador*/ 
select    empleados.id, nombre , round( sum(kilos), 2) as producido from produccion  
left join empleados on produccion.id_Empleado = empleados.id 
group by nombre  order by producido;


/* vista  de desperdicio x operador*/
create view desperdicioxOperador as 
select   desperdicios.id_empleado, nombre, round( sum(desperdicios.desperdicio),2)  as despTotal from desperdicios  
left join empleados on desperdicios.id_Empleado = empleados.id  
group by nombre  order by despTotal;

/* vista  de produccion x operador*/
create view vwproduccionxOperador as 
select    empleados.id, nombre , round( sum(kilos), 2) as producido from produccion  
left join empleados on produccion.id_Empleado = empleados.id 
group by nombre  order by producido;


/*INNER JOIN produccion, desperdicio, %*/
select vwproduccionxoperador.nombre,
vwproduccionxoperador.producido,   
vwdesperdicioxoperador.despTotal , 
round( (vwdesperdicioxoperador.despTotal /vwproduccionxoperador.producido) *100 , 2)as porcentaje  from vwproduccionxoperador 
inner join vwdesperdicioxoperador on vwproduccionxoperador.id = vwdesperdicioxoperador.id_empleado order by porcentaje desc;




/*PRODUCCION MAYOR AL PROMEDIO*/
select    empleados.id, nombre , round( sum(kilos), 2)  as cantidad ,
round((select  sum(kilos) /  count(distinct(id_Empleado), 2)  from  produccion),2) as promedio from produccion  
left join empleados on produccion.id_Empleado = empleados.id group by nombre having cantidad >= 
(select  sum(kilos) /  round(count(distinct(id_Empleado)), 2)  from  produccion);





SET @mes = 5;
SET @departamento = 'SG';

	/*PRODUCCION X DIA Y DEPARTAMENTOS  +  PROMEDIO */
	select  ID_DEPARTAMENTO ,
	IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL') AS fechaConvertida , 
	sum(kilos) as prod , 
   round( (SELECT sum(kilos) AS total FROM produccion WHERE month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 5 and ID_DEPARTAMENTO ="SG" ) / (SELECT count(distinct(fecha)) AS total FROM produccion
	WHERE month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 5 and ID_DEPARTAMENTO ="SG" ),2) as promedio from produccion
	where   month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 5 and  ID_DEPARTAMENTO ="SG"  group by fechaConvertida;



/* crear vista eficiencia x operador
create view vwEficienciaXOperador as
select produccion.id_empleado, round( (avg(kilos) * 8 )* cwdiaslaborados.diasLaborados,0)  as capacidad, round(sum(kilos),0) as total , ( round(sum(kilos),0) / round( (avg(kilos) * 8 )* cwdiaslaborados.diasLaborados,0) ) * 100 as porcentaje from produccion 
left join cwdiaslaborados on produccion.id_empleado = cwdiaslaborados.id_empleado
where month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 6 group by produccion.id_empleado ;

*/

/* CREAR VISTA DIAS LABORADOS
Create view cwDiasLaborados as
select id_empleado, count(distinct(fecha)) as diasLaborados from produccion where month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 6 group by id_empleado ;
*/

select * from empleados left join	vweficienciaxoperador on empleados.id = vweficienciaxoperador.id_empleado order by porcentaje desc; 
















/*
(SELECT sum(kilos) AS total
FROM produccion
WHERE month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 5 and ID_DEPARTAMENTO ="SG" );
*
(SELECT count(distinct(fecha)) AS total
FROM produccion
WHERE month(IFNULL(STR_TO_DATE(fecha, '%d/%m/%Y'), 'NULL')) = 5 and ID_DEPARTAMENTO ="SG" )



create view vwDesperdicioDepartamento as
select id_departamento, departamento, sum(desperdicio)* 10  as desperdicio from	desperdicios 
left join  departamentos on desperdicios.id_departamento = departamentos.id  group by id_departamento  ;

*/

