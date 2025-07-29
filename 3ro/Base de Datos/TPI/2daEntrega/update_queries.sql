/*
 * 1. Se establecen los porcentajes de descuento de los afiliados, dependiendo de si son crónicos o no.
 * A los crónicos les corresponde 70%, a los no crónicos les corresponde 20%.
 * NOTA: En nuestro esquema, un afiliado es crónico si su id está en la tabla 'poseen' un diagnóstico.
*/
UPDATE afiliados a
SET porcDescuento = (
	CASE 
	WHEN (SELECT DISTINCT p.idAfiliado
		FROM poseen p
		WHERE a.id = p.idAfiliado) IS NULL THEN 20
	ELSE 70 
	END);

/*
 * 2. Actualización del porcentaje de descuento a 80% para los afiliados crónicos que tienen más de 5 años de antigüedad.
*/ 
UPDATE afiliados a
SET a.porcDescuento = 80
WHERE a.fechaIngreso < DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
AND a.id IN (
	SELECT p.idAfiliado
	FROM poseen p
	WHERE p.idAfiliado = a.id
);

/*
 * 3. Se incrementa un 10% el precio de todos los medicamentos con stock en el depósito central.
*/ 
UPDATE medicamentos
SET precio = precio * 1.10
WHERE codMedicamento IN (
    SELECT codMed
    FROM medicamentos
    WHERE stockCentral > 0);

/*
 * 4. Se incrementa en 10 unidades el stock de un medicamento en cada farmacia con stock inferior al promedio general.
 * NOTA: Parece que en MySQL no se puede hacer un FROM de la tabla que se está UPDATEando. Para evitar ese problema usamos WITH.
 * https://dev.mysql.com/doc/refman/8.0/en/with.html
*/
WITH s2 AS (SELECT * FROM stockean) 
UPDATE stockean s1
SET s1.stock = s1.stock + 10
WHERE s1.stock < (
    SELECT AVG(s2.stock) FROM s2
    WHERE s1.codMed = s2.codMed
    GROUP BY codMed);
 
/*
 * 5. Cambio del estado de todas las transferencias que tienen más de 30 días de antigüedad:
*/ 
UPDATE transferencias
SET estado = 'Vencida'
WHERE fechaConfeccion < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

/* 
 * 5. Cambio del estado de las transferencias a "EnProceso" si su estado actual es "Pendiente" si es más de 30 días antigua
 * o participa en la tabla 'transfieren', lo que indica que una transportadora ya la llevó o está llevando.
*/
UPDATE transferencias
SET estado = 'EnProceso'
WHERE estado = 'Pendiente' 
AND (fechaConfeccion < DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    OR nro IN (SELECT nroTransf FROM transfieren)
);

/*
 * 6. Reducción del stock de cada medicamento en cada farmacia, en base a los comprobantes (ventas) generados en el día de hoy.
*/
UPDATE stockean s
SET stock = stock - IFNULL((
	SELECT cont.cantidad FROM contienen cont 						 -- La cantidad vendida
	INNER JOIN comprobantes compr ON cont.nroComprobante = compr.nro -- De un comprobante
    INNER JOIN farmacias f ON f.id = compr.idF 						 -- De una farmacia
    WHERE f.id = s.idF 												 -- Afectando al stock de esa farmacia
    AND s.codMed = cont.codMed 										 -- Y de ese medicamento en particular
    AND DATE(compr.fechaEmision) = CURDATE() 						 -- Solo si fue vendido hoy
), 0);
