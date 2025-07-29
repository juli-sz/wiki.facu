/*
 * 1. Se borran las farmacias sin empleados y cuyo código postal sea inferior a 10000.
*/
DELETE FROM farmacias
WHERE id NOT IN (SELECT DISTINCT idFarmacia FROM empleados)
  AND codPostal < 10000;

/*
 * 2. Borrado de medicamentos que tengan un stock central inferior a 10 y no estén en ningún comprobante.
*/
DELETE FROM medicamentos
WHERE stockCentral < 10
  AND codMedicamento NOT IN (SELECT DISTINCT codMed FROM contienen);
 
/*
 * 3.  Borrado de empleados cuyo nombre comience con la letra 'A' y hayan ingresado antes del 1 de enero de 2020.
*/
DELETE FROM empleados
WHERE nombre LIKE 'A%'
  AND fechaIngreso < '2020-01-01';
 
/*
 * 4. Borrado de afiliados que tengan un porcentaje de descuento superior al promedio de descuentos de todos los afiliados.
*/
DELETE FROM afiliados
WHERE porcDescuento > (SELECT AVG(porcDescuento) FROM afiliados);
 
/*
 * 5. Borrado de farmacias que no hayan realizado ninguna venta en los últimos 6 meses.
*/
DELETE FROM farmacias
WHERE id NOT IN (SELECT DISTINCT idF FROM comprobantes WHERE fechaEmision >= DATE_SUB(NOW(), INTERVAL 6 MONTH));
 
/*
* 6. Borrado de medicamentos que no tengan ninguna acción terapéutica asociada.
*/
DELETE FROM medicamentos
WHERE codMedicamento NOT IN (SELECT DISTINCT codMed FROM prestan);

