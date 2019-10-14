--1. CREACION DE TABLAS

CREATE TABLE profesion(
	cod_prof INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE pais(
	cod_pais INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	CONSTRAINT UC_nombrePais UNIQUE(nombre)
);

CREATE TABLE puesto(
	cod_puesto INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE departamento(
	cod_depto INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	CONSTRAINT UC_nombreDepto UNIQUE(nombre)
);

CREATE TABLE miembro(
	cod_miembro INTEGER PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
	edad INTEGER NOT NULL,
	telefono INTEGER,
	residencia VARCHAR(100),
	PAIS_cod_pais INTEGER NOT NULL,
	PROFESION_cod_prof INTEGER NOT NULL,
	CONSTRAINT FK_mi_pais FOREIGN KEY (PAIS_cod_pais) REFERENCES pais(cod_pais),
	CONSTRAINT FK_mi_prof FOREIGN KEY (PROFESION_cod_prof) REFERENCES profesion(cod_prof)
		
);

CREATE TABLE puesto_miembro(
    MIEMBRO_cod_miembro INTEGER NOT NULL,
    PUESTO_cod_puesto INTEGER NOT NULL,
    DEPARTAMENTO_cod_depto INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    PRIMARY KEY (MIEMBRO_cod_miembro,PUESTO_cod_puesto,DEPARTAMENTO_cod_depto),
    CONSTRAINT FK_pm_miembro FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES miembro(cod_miembro),
    CONSTRAINT FK_pm_puesto FOREIGN KEY (PUESTO_cod_puesto) REFERENCES puesto(cod_puesto),
    CONSTRAINT FK_pm_depto FOREIGN KEY (DEPARTAMENTO_cod_depto) REFERENCES departamento(cod_depto)
);

CREATE TABLE tipo_medalla(
    cod_tipo INTEGER PRIMARY KEY,
    medalla VARCHAR(20) NOT NULL,
    CONSTRAINT UC_nombreTM UNIQUE(medalla)
);

CREATE TABLE medallero(
    PAIS_cod_pais INTEGER NOT NULL,
    cantidad_medallas INTEGER NOT NULL,
    TIPO_MEDALLA_cod_tipo INTEGER NOT NULL,
    PRIMARY KEY (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo),
    CONSTRAINT FK_me_pais FOREIGN KEY (PAIS_cod_pais) REFERENCES pais(cod_pais),
    CONSTRAINT FK_me_tipo FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES tipo_medalla(cod_tipo) ON DELETE CASCADE
);

CREATE TABLE disciplina(
    cod_disciplina INTEGER PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
);

CREATE TABLE atleta(
    cod_atleta INTEGER PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER NOT NULL,
    participaciones VARCHAR(100) NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    PAIS_cod_pais INTEGER NOT NULL,
    CONSTRAINT FK_atl_dis FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES disciplina(cod_disciplina) ON DELETE CASCADE,
    CONSTRAINT FK_atl_pais FOREIGN KEY (PAIS_cod_pais) REFERENCES pais(cod_pais)
);

CREATE TABLE categoria(
    cod_categoria INTEGER PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL
);

CREATE TABLE tipo_participacion(
    cod_participacion INTEGER PRIMARY KEY,
    tipo_participacion VARCHAR(100) NOT NULL
);

CREATE TABLE evento(
    cod_evento INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    hora DATE NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    TIPO_PARTICIPACION_cod_p INTEGER NOT NULL,
    CATEGORIA_cod_categoria INTEGER NOT NULL,
    CONSTRAINT FK_ev_dis FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES disciplina(cod_disciplina),
    CONSTRAINT FK_ev_tipoP FOREIGN KEY (TIPO_PARTICIPACION_cod_p) REFERENCES tipo_participacion(cod_participacion),
    CONSTRAINT FK_ev_cate FOREIGN KEY (CATEGORIA_cod_categoria) REFERENCES categoria(cod_categoria)    
);

CREATE TABLE evento_atleta(
    ATLETA_cod_atleta INTEGER NOT NULL,
    EVENTO_cod_evento INTEGER NOT NULL,
    PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
    CONSTRAINT FK_ea_atl FOREIGN KEY (ATLETA_cod_atleta) REFERENCES atleta(cod_atleta),
    CONSTRAINT FK_ea_eve FOREIGN KEY (EVENTO_cod_evento) REFERENCES evento(cod_evento)
);

CREATE TABLE televisora(
    cod_televisora INTEGER PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE costo_evento(
    EVENTO_cod_evento INTEGER NOT NULL,
    TELEVISORA_cod_televisora INTEGER NOT NULL,
    Tarifa INTEGER NOT NULL,
    PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    CONSTRAINT FK_ce_evn FOREIGN KEY (EVENTO_cod_evento) REFERENCES evento(cod_evento),
    CONSTRAINT FK_ce_tele FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES televisora(cod_televisora)
);

-- 2. MODIFICANDO LA TABLA EVENTO
ALTER TABLE evento 
DROP COLUMN fecha,
DROP COLUMN hora;

ALTER TABLE evento 
ADD fecha_hora TIMESTAMP(0) NOT NULL;

-- 3. SET FECHA Y HORARIO
ALTER TABLE evento
ADD CONSTRAINT CHK_Date CHECK (TO_TIMESTAMP(CAST(fecha_hora AS TEXT),'DD-MM-YYYY HH24:MI:SS')
                               BETWEEN TO_TIMESTAMP('24-07-2020 09:00:00','DD-MM-YYYY HH24:MI:SS')
                               AND TO_TIMESTAMP('09-08-2020 20:00:00','DD-MM-YYYY HH24:MI:SS'));

-- 4. SEDE
-- a)
CREATE TABLE sede(
    cod_sede INTEGER PRIMARY KEY,
    sede VARCHAR(50) NOT NULL
);
-- b)
ALTER TABLE evento 
ALTER COLUMN ubicacion TYPE INTEGER USING (ubicacion::INTEGER);
--c)
ALTER TABLE evento
ADD CONSTRAINT FK_ub_se FOREIGN KEY (ubicacion) REFERENCES sede(cod_sede);

-- 5. DEFAULT miembro
ALTER TABLE miembro
ALTER COLUMN telefono SET DEFAULT 0;

-- 6. Inserscion de datos
-- Profesion
INSERT INTO profesion 
VALUES
      (1,'Medico'),
      (2,'Arquitecto'),
      (3,'Ingeniero'),
      (4,'Secretaria'),
      (5,'Auditor');
-- Pais
INSERT INTO pais 
VALUES
      (1,'Guatemala'),
      (2,'Francia'),
      (3,'Argentina'),
      (4,'Alemania'),
      (5,'Italia'),
      (6,'Brasil'),
      (7,'Estados Unidos');
-- Miembro
INSERT INTO miembro 
VALUES
      (1,'Scott','Mitchell',32,default,'1092 Highland Drive Manitowoc, WI 54220',7,3),
      (2,'Fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4),
      (3,'Laura','Cuhna Silva',55,default,'Rua Onze, 86 Uberaba-MG',6,5),
      (4,'Juan José','López',38,36985247,'26 calle 4-10 zona 11',1,2),
      (5,'Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1),
      (6,'Jeuel','Villalpando',31,default,'Acuña de Figeroa 6106 80101 Playa Pascual',3,5);
-- Disciplina
INSERT INTO disciplina 
VALUES
      (1,'Atletismo','Saltos de longitud y triples, de altura y con periga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco'),
      (2,'Bádminton',NULL),
      (3,'Ciclismo',NULL),
      (4,'Judo','Es un arte marcial que se orgino en Japón alrededor de 1880'),
      (5,'Lucha',NULL),
      (6,'Tenis de Mesa',NULL),
      (7,'Boxeo',NULL),
      (8,'Natacion','Esta presente como deporte en los juegos desde la primera edicion de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas'),
      (9,'Esgrima',NULL),
      (10,'Vela',NULL);
-- Tipo_medalla
INSERT INTO tipo_medalla 
VALUES
      (1,'Oro'),
      (2,'Plata'),
      (3,'Bronce'),
      (4,'Platino');
-- Categoria
INSERT INTO categoria 
VALUES
      (1,'Clasificatorio'),
      (2,'Eliminatorio'),
      (3,'Final');
-- Tipo_participacion
INSERT INTO tipo_participacion 
VALUES 
      (1,'Individual'),
      (2,'Parejas'),
      (3,'Equipos');
-- Medallero
INSERT INTO medallero 
VALUES
      (5,3,1),
      (2,5,1),
      (6,4,3),
      (4,3,4),
      (7,10,3),
      (3,8,2),
      (1,2,1),
      (1,5,4),
      (5,7,2);
-- Sede
INSERT INTO sede 
VALUES
      (1,'Gimnasio Metropolitano de Tokio'),
      (2,'Jardín del Palacio Imperial de Tokio'),
      (3,'Gimnasio Nacional Yoyogi'),
      (4,'Nippon Budokan'),
      (5,'Estadio Olímpico');
-- Evento
SET datestyle = 'SQL, DMY';

INSERT INTO evento 
VALUES
      (1,3,2,2,1,TO_TIMESTAMP('24-07-2020 11:00:00','DD-MM-YYYY HH24:MI:SS')),
      (2,1,6,1,1,TO_TIMESTAMP('26-07-2020 10:30:00','DD-MM-YYYY HH24:MI:SS')),
      (3,5,7,1,1,TO_TIMESTAMP('30-07-2020 18:45:00','DD-MM-YYYY HH24:MI:SS')),
      (4,2,1,1,1,TO_TIMESTAMP('01-08-2020 12:15:00','DD-MM-YYYY HH24:MI:SS')),
      (5,4,10,3,1,TO_TIMESTAMP('08-08-2020 19:35:00','DD-MM-YYYY HH24:MI:SS'));
      
-- 7. Eliminar UNIQUE
ALTER TABLE pais 
DROP CONSTRAINT UC_nombrePais;

ALTER TABLE tipo_medalla 
DROP CONSTRAINT UC_nombreTM;

ALTER TABLE departamento
DROP CONSTRAINT UC_nombreDepto;

-- 8.
-- a)
ALTER TABLE atleta
DROP CONSTRAINT FK_atl_dis;
-- b) 
CREATE TABLE disciplina_atleta(
    cod_atleta INTEGER,
    cod_disciplina INTEGER,
    PRIMARY KEY(cod_atleta,cod_disciplina),
    FOREIGN KEY (cod_atleta) REFERENCES atleta(cod_atleta),
    FOREIGN KEY (cod_disciplina) REFERENCES disciplina(cod_disciplina)
);

-- 9. 
ALTER TABLE costo_evento
ALTER COLUMN tarifa TYPE NUMERIC(15,2);

-- 10. DELETE REGISTRY
DELETE FROM tipo_medalla
WHERE cod_tipo = 4;

-- 11. DROP TABLE
DROP TABLE costo_evento;
DROP TABLE televisora;

-- 12. DELETE ALL
TRUNCATE disciplina CASCADE;

--13. UPDATE
UPDATE miembro
SET telefono = 55464601
WHERE nombre = 'Laura' AND apellido = 'Cuhna Silva'; 

UPDATE miembro
SET telefono = 91514243
WHERE nombre = 'Jeuel' AND apellido = 'Villalpando'; 

UPDATE miembro
SET telefono = 920686670
WHERE nombre = 'Scott' AND apellido = 'Mitchell'; 

-- 14. ADD fotografia
ALTER TABLE atleta
ADD fotografia BYTEA;

-- 15. Check edad atletas
ALTER TABLE atleta
ADD CONSTRAINT CHK_edad CHECK (edad < 25);

-- Eliminar todas las tablas
--DROP TABLE costo_evento;
--DROP TABLE televisora;
--DROP TABLE evento_atleta;
--DROP TABLE evento;
--DROP TABLE tipo_participacion;
--DROP TABLE categoria;
--DROP TABLE atleta cascaDE;
--DROP TABLE disciplina cascade;
--DROP TABLE medallero;
--DROP TABLE tipo_medalla;
--DROP TABLE puesto_miembro;
--DROP TABLE miembro;
--DROP TABLE departamento;
--DROP TABLE puesto;
--DROP TABLE pais;
--DROP TABLE profesion;
--DROP TABLE sede cascade;
--DROP TABLE disciplina_atleta;