USE farmaciasdb;

/* 
1. Inserta en el stock de la farmacia con id '153', 
el stock del medicamento con id '831' del depósito central. 
*/
INSERT INTO stockean(IdF, codMed, stock) VALUES(
	153,
	831,
	(SELECT stockCentral FROM medicamentos WHERE codMedicamento = 831) 
);

/*
2. Al medicamento con presentación (nombre) 'Obenauf' se le agrega la monodroga con nombre científico 'CT').
*/
INSERT iNTO compuestospor(idMono, codMed)
VALUES (
	(SELECT id FROM monodrogas WHERE nombreCientifico = 'CT'),
	(SELECT codMedicamento FROM medicamentos WHERE presentacion = "Obenauf")
) ;

/*
3. Se inserta una transferencia con fecha actual y estado 'Pendiente', ya que se acaba de registrar.
*/
INSERT INTO transferencias(nro, fechaConfeccion, estado) 
VALUES(1, now(), "Pendiente");

/*
4. Se inserta que la última transferencia creada transfiere 5 unidades del medicamento con código '19991831'.
*/
INSERT INTO transfieren(nroTransf, codMed, cantidad) VALUES(
	(SELECT nro FROM transferencias WHERE fechaConfeccion = (
		SELECT MAX(fechaConfeccion) FROM transferencias)
	),
    19991831, 
	5);

/*
5. Se inserta la ciudad Resistencia asociada a la farmacéutica Olivia Fernandez, 
que previamente no tenía ninguna ciudad asignada.
*/
INSERT INTO ciudades(codPostal, dniFarmaceutico, nombre) VALUES (
	3500,
	(SELECT dni FROM farmaceuticos WHERE nombre = "Olivia Fernandez"),
	"Resistencia");

/*
6. A una transportadora que tenga menos de 10 destinos se le inserta un nuevo alcance a Resistencia.
*/
INSERT INTO alcanzan(codTransp, codPostal) VALUES(
	(SELECT a.codTransp FROM alcanzan a
	GROUP BY a.codTransp
	HAVING count(a.codPostal) < 10 
	LIMIT 1),
	3500);
