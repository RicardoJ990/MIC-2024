-- Creamos la base de datos con nombre "colegio"
CREATE DATABASE colegio CHARACTER SET utf8;

USE colegio

-- creamos tabla alumno  

CREATE TABLE Alumnos (
    id_alumno INT UNSIGNED PRIMARY KEY,
    cedula VARCHAR(15) UNIQUE,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    carrera VARCHAR(50),
    grupo CHAR(1) NOT NULL CHECK(grupo >= 'A' AND grupo <= 'Z')
);


-- Creación tabla pruebas
CREATE TABLE Pruebas (
    id_pruebas INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_prueba VARCHAR(50),
    fecha_realizacion DATE,
    materia VARCHAR(50)
);

-- Creación tabla profesores

CREATE TABLE Profesores (
    id_profesores INT UNSIGNED PRIMARY KEY,
    cedula VARCHAR(15) UNIQUE,
    nombre VARCHAR(50),
    apellido VARCHAR(50)
);

-- creación tabla resultados que albergará en lso examenes

CREATE TABLE Resultados (
    id_resultados INT PRIMARY KEY,
    id_alumno INT UNSIGNED,
    id_pruebas INT UNSIGNED,
    resultado DECIMAL(5, 2),
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_pruebas) REFERENCES Pruebas(id_pruebas)
);

-- Tabla examenes teóricos

CREATE TABLE ExamenesTeoricos (
    id_teoricos INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    num_preguntas INT,
	#num_preguntas TINYINT UNSIGNED CHECK(numero_preguntas > 0),
    fecha_realizacion DATE,
    id_profesores INT UNSIGNED,
	FOREIGN KEY (id_profesores) REFERENCES Profesores(id_profesores)
);

-- Tabla exámenes teóricos (NOTA)

CREATE TABLE NotasExamenesTeoricos 
(
	id_alumno INT UNSIGNED,
    id_teoricos INT UNSIGNED,
	nota FLOAT NOT NULL CHECK (nota >= 0 AND nota <= 20),
	PRIMARY KEY (id_alumno, id_teoricos),
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_teoricos) REFERENCES ExamenesTeoricos(id_teoricos)
);


-- Lo mismo de los teóricos pero para los practicos 
 
CREATE TABLE ExamenesPracticos (
    id_practicos INT UNSIGNED PRIMARY KEY,
    titulo VARCHAR(50),
    grado_dificultad ENUM('BAJA', 'MEDIA', 'ALTA') NOT NULL
);

CREATE TABLE NotasExamenesPracticos (
    id_nota_practicos INT UNSIGNED PRIMARY KEY,
    id_alumno INT UNSIGNED,
    id_practicos INT UNSIGNED,
    fecha_realizacion DATE,
    nota DECIMAL(5, 2),
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (id_practicos) REFERENCES ExamenesPracticos(id_practicos)
);

CREATE TABLE ParticipacionProfesoresPracticas (
    id_participacion INT PRIMARY KEY,
    id_profesores INT UNSIGNED,
    id_practicos INT UNSIGNED,
    fecha_participacion DATE NOT NULL,
    FOREIGN KEY (id_profesores) REFERENCES Profesores(id_profesores),
    FOREIGN KEY (id_practicos) REFERENCES ExamenesPracticos(id_practicos)
);

-- Creamos Usuarios 
CREATE USER 'Adminisatrador'@'colegio' IDENTIFIED BY 'password_admin';
CREATE USER 'Gestor'@'colegio' IDENTIFIED BY 'password_gestor';
CREATE USER 'Consulta'@'colegio' IDENTIFIED BY 'password_consulta';

-- Damos privilegios al usuario 'admin'
GRANT ALL PRIVILEGES ON colegio.* TO 'Administrador'@'colegio' WITH GRANT OPTION;

-- Damos privilegios al usuario 'gestor'
GRANT SELECT, INSERT, UPDATE, DELETE ON colegio.Alumnos TO 'Gestor'@'colegio';
GRANT SELECT, INSERT, UPDATE, DELETE ON colegio.Profesores TO 'Gestor'@'colegio';

-- Damos privilegios al usuario 'consulta'
GRANT SELECT ON colegio.Alumnos TO 'Consulta'@'colegio';
GRANT SELECT ON colegio.Profesores TO 'Consulta'@'colegio';

-- Para garantizar mayor seguridad en accesos autorizados, creamos un usuario permitido solo desde una dirección IP específica
CREATE USER 'user'@'192.168.100.1' IDENTIFIED BY 'Password';
GRANT ALL PRIVILEGES ON colegio.* TO 'user'@'192.168.100.1';


-- En términos de seguridad...
-- Configuro la auditoría de MySQL para registrar eventos relevantes. Esto ayudará a rastrear actividades sospechosas y proporciona registros de auditoría para la revisión.
SET GLOBAL audit_log=ON;
SET GLOBAL server_audit_logging=ON;

-- CONSULTAS:
# Consulta para obtener el nombre de los alumnos que aprobaron el examen teórico y práctico con una nota mayor o igual a 14
SELECT Alumnos.nombre, Alumnos.apellido
FROM Alumnos
JOIN NotasExamenesTeoricos ON Alumnos.id_alumno = NotasExamenesTeoricos.id_alumno
JOIN ExamenesTeoricos ON NotasExamenesTeoricos.id_teoricos = ExamenesTeoricos.id_teoricos
JOIN NotasExamenesPracticos ON Alumnos.id_alumno = NotasExamenesPracticos.id_alumno
JOIN ExamenesPracticos ON NotasExamenesPracticos.id_practicos = ExamenesPracticos.id_practicos
WHERE (NotasExamenesTeoricos.nota + NotasExamenesPracticos.nota) >= 14;

# Mostrar el nombre y apellido de los alumnos que realizaron exámenes teóricos, junto con el título y la nota de esos exámenes.
SELECT Alumnos.nombre, Alumnos.apellido, ExamenesTeoricos.titulo, NotasExamenesTeoricos.nota
FROM Alumnos
JOIN NotasExamenesTeoricos ON Alumnos.id_alumno = NotasExamenesTeoricos.id_alumno
JOIN ExamenesTeoricos ON NotasExamenesTeoricos.id_teoricos = ExamenesTeoricos.id_teoricos;

# ------------------------------------------------------------------------------------------------------
-- Inserción de registros en la tabla Alumnos
INSERT INTO Alumnos (id_alumno, nombre, apellido, carrera, grupo) VALUES
(1, 'Juan', 'Perez', 'Gestion de Bases de Datos', 'A'),
(2, 'Tin', 'Delgado', 'Networking', 'B'),
(3, 'Carlos', 'Duty', 'Ingeniería de Software II', 'A'),
(4, 'Elsa', 'Capuntas', 'Seguridad Informática', 'C'),
(5, 'Pedrito', 'Coco', 'Desarrollo Web', 'Z');

-- Inserción de registros en la tabla Pruebas
INSERT INTO Pruebas (nombre_prueba, fecha_realizacion, materia) VALUES
('Examen Matemáticas', '2024-03-10', 'Matemáticas'),
('Examen Programación', '2024-03-15', 'Programación'),
('Examen Base de Datos', '2024-03-20', 'Bases de Datos'),
('Examen Redes', '2024-03-25', 'Redes'),
('Examen Ingeniería de Software', '2024-03-30', 'Ingeniería de Software');

-- Inserción de registros en la tabla Profesores
INSERT INTO Profesores (id_profesores, cedula, nombre, apellido) VALUES
(1, '123456789', 'María', 'Gonzalez'),
(2, '987654321', 'José', 'Fernández'),
(3, '654321987', 'Elena', 'Ruiz'),
(4, '789123456', 'Antonio', 'Díaz'),
(5, '456789123', 'Isabel', 'Sánchez');

-- Inserción de registros en la tabla ExamenesTeoricos
INSERT INTO ExamenesTeoricos (id_teoricos, titulo, num_preguntas, fecha_realizacion, id_profesores) VALUES
(1, 'Examen Teórico Matemáticas', 10, '2024-03-10', 1),
(2, 'Examen Teórico Programación', 15, '2024-03-15', 2),
(3, 'Examen Teórico Base de Datos', 12, '2024-03-20', 3),
(4, 'Examen Teórico Redes', 8, '2024-03-25', 4),
(5, 'Examen Teórico Ingeniería de Software', 50, '2024-03-30', 5);

-- Inserción de registros en la tabla NotasExamenesTeoricos
INSERT INTO NotasExamenesTeoricos (id_alumno, id_teoricos, nota) VALUES
(1, 1, 18.5),
(2, 2, 12),
(3, 3, 20),
(4, 4, 17),
(5, 5, 15);



-- Inserción de registros en la tabla ExamenesPracticos
INSERT INTO ExamenesPracticos (id_practicos, titulo, grado_dificultad) VALUES
(1, 'Práctica SQL', 'ALTA'),
(2, 'Práctica Java', 'MEDIA'),
(3, 'Práctica Redes Troncales', 'BAJA'),
(4, 'Práctica NodeJS', 'MEDIA'),
(5, 'Práctica Seguridad Informática', 'ALTA');

-- Inserción de registros en la tabla NotasExamenesPracticos
INSERT INTO NotasExamenesPracticos (id_nota_practicos, id_alumno, id_practicos, fecha_realizacion, nota) VALUES
(1, 1, 1, '2024-04-05', 16),
(2, 2, 2, '2024-04-10', 20),
(3, 3, 3, '2024-04-15', 18),
(4, 4, 4, '2024-04-20', 14),
(5, 5, 5, '2024-04-25', 18);

-- Inserción de registros en la tabla ParticipacionProfesoresPracticas
INSERT INTO ParticipacionProfesoresPracticas (id_participacion, id_profesores, id_practicos, fecha_participacion) VALUES
(1, 1, 1, '2024-03-15'),
(2, 2, 2, '2024-03-20'),
(3, 3, 3, '2024-03-25'),
(4, 4, 4, '2024-03-30'),
(5, 5, 5, '2024-04-05');




