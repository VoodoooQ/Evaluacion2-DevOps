-- NOTA PARA EL EVALUADOR:
-- Este archivo crea la tabla 'student' y agrega datos de ejemplo para que la aplicación muestre información al iniciar.
-- Puede modificar o agregar más registros según lo requiera la evaluación.
/*
El uso de esta tabla e insercion es netamente
para generar una prueba rapida y efectiva
que muestre un valor dentro de localhost:8080/students
ya que se usa h2 en memoria y esta no perduran los cambios.*/


CREATE TABLE student (
	id BIGINT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255)
);


INSERT INTO student (name) VALUES ('Maximiliano Andres Diaz Caro');
