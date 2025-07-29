/*
 * 1. Mostrar el ranking de los diez medicamentos con mayor cantidad de ventas en todas las farmacias de la cadena.
 * NOTA: Consideramos que el ranking toma la cantidad total de ejemplares vendidos, y no la cantidad de veces que un medicamento aparece en los comprobantes.
*/
SELECT m.descripcion, SUM(c.cantidad) AS unidades_vendidas FROM medicamentos m
INNER JOIN contienen c ON c.codMed = m.codMedicamento
GROUP BY c.codMed
ORDER BY SUM(c.cantidad) DESC
LIMIT 10;

/*
 * 2. Listar los códigos y nombres de los medicamentos que fueron vendidos en todas las farmacias.
*/
SELECT m.codMedicamento, m.presentacion FROM medicamentos m
INNER JOIN contienen cont ON m.codMedicamento = cont.codMed
INNER JOIN comprobantes compr ON cont.nroComprobante = compr.nro
GROUP BY m.codMedicamento
HAVING count(DISTINCT compr.idF) = (SELECT count(id) FROM farmacias);

/*
 * 3. Mostrar cantidad de afiliados crónicos y eventuales que compraron medicamentos en la farmacia de Resistencia en la última semana.
*/
-- compradores es una tabla virtual con el 'id' del afiliado y 'idAfiliado' que es la FK de la tabla poseen.
-- Si 'idAfiliado' es NULL, entonces no tiene ningún diagnóstico (y es un afiliado eventual).
WITH compradores AS (
	SELECT DISTINCT a.id, p.idAfiliado FROM afiliados a
    LEFT JOIN poseen p ON p.idAfiliado = a.id
	INNER JOIN comprobantes c ON c.idA = a.id
	WHERE c.idF IN (SELECT id FROM farmacias WHERE codPostal = 3500) 
	AND  7 < DATEDIFF(now(), c.fechaEmision)
)
SELECT 
	(SELECT count(c.id) FROM compradores c WHERE c.idAfiliado IS NOT NULL) AS crónicos, 
	(SELECT count(c.id) FROM compradores c WHERE c.idAfiliado IS NULL) AS eventuales;

/*
 * 4. Informar el top de las 5 farmacias que solicitaron mayores cantidades de amoxidal duo en los últimos 15 dias.
*/
SELECT f.id, f.direccion, SUM(transfieren.cantidad) AS total_solicitado FROM farmacias f
INNER JOIN transferencias t ON f.id = t.idF
INNER JOIN transfieren ON transfieren.nroTransf = t.nro
INNER JOIN medicamentos m ON transfieren.codMed = m.codMedicamento
WHERE m.descripcion = "amoxidal duo"
AND t.fechaConfeccion >= DATE_SUB(CURDATE(), INTERVAL 15 DAY)
GROUP BY f.id
ORDER BY SUM(transfieren.cantidad) DESC
LIMIT 5;

/*
 * 5. Listado de farmacias con la menor cantidad de transferencias pendientes. 
*/
SELECT f.id, f.direccion, COUNT(t.nro) AS transferencias_pendientes FROM farmacias f
INNER JOIN transferencias t ON f.id = t.idF
WHERE t.estado = "Pendiente"
GROUP BY f.id
HAVING COUNT(t.nro) = (
	SELECT MIN(cant) FROM (
		SELECT COUNT(t.nro) cant FROM farmacias f
		INNER JOIN transferencias t ON f.id = t.idF
		GROUP BY f.id
	) AS temp
);

/*
 * 6. Identificar para una farmacia determinada cuales son los medicamentos sin stock en la misma pero con stock en deposito central.
*/
-- Nota: 153 es el 'id' de la farmacia determinada, podría ser cualquiera. 
-- Consideramos que si para algún medicamento no participa en 'stockean', entonces también está sin stock.
SELECT m.codMedicamento, m.descripcion FROM medicamentos m
LEFT JOIN stockean s ON m.codMedicamento = s.codMed
WHERE (s.idF = 153 OR s.idF IS NULL)
AND (s.stock = 0 OR s.idF IS NULL)
AND m.stockCentral > 0;

/*
 * 7. ¿Cuál es la empresa de transporte con mayor actividad en el último mes?
*/
-- NOTA: consideramos que la de mayor actividada es la que más ingresos realizó.
SELECT t.cuit, COUNT(i.codIngreso) AS cantidad_ingresos
FROM transportadoras t
JOIN ingresos i ON t.codTransportadora = i.codTransp
WHERE i.fechaIngreso >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY t.cuit, t.email
ORDER BY cantidad_ingresos DESC
LIMIT 1;

/*
 * 8. Informar el monto total de ventas por farmacia en el último trimestre ordenado en forma descendente.
*/
SELECT f.id, f.direccion, SUM(c.precioUnitario * c.cantidad) AS total_ventas FROM farmacias f
JOIN comprobantes co ON f.id = co.idF
JOIN contienen c ON co.nro = c.nroComprobante
WHERE co.fechaEmision >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY f.id, f.direccion
ORDER BY monto_total_ventas DESC;
