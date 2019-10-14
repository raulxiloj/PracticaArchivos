-- 1. CREACION DE TABLAS

CREATE TABLE profesion(
    cod_prof INTEGER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE pais(
    cod_pais INTEGER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    CONSTRAINT UC_nombrePais UNIQUE(nombre)
);

CREATE TABLE puesto(
    cod_puesto INTEGER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE departamento(
    cod_depto INTEGER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    CONSTRAINT UC_nombreDepto UNIQUE(nombre)
);

CREATE TABLE miembro(
    cod_miembro INTEGER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellido VARCHAR2(100) NOT NULL,
    edad INTEGER NOT NULL,
    telefono INTEGER,
    residencia VARCHAR2(100),
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
    medalla VARCHAR2(20) NOT NULL,
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
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(150)
);

CREATE TABLE atleta(
    cod_atleta INTEGER PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    apellido VARCHAR2(50) NOT NULL,
    edad INTEGER NOT NULL,
    participaciones VARCHAR2(100) NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    PAIS_cod_pais INTEGER NOT NULL,
    CONSTRAINT FK_atl_dis FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES disciplina(cod_disciplina) ON DELETE CASCADE,
    CONSTRAINT FK_atl_pais FOREIGN KEY (PAIS_cod_pais) REFERENCES pais(cod_pais)
);

CREATE TABLE categoria(
    cod_categoria INTEGER PRIMARY KEY,
    categoria VARCHAR2(50) NOT NULL
);

CREATE TABLE tipo_participacion(
    cod_participacion INTEGER PRIMARY KEY,
    tipo_participacion VARCHAR2(100) NOT NULL
);

CREATE TABLE evento(
    cod_evento INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
    ubicacion VARCHAR2(50) NOT NULL,
    hora DATE NOT NULL,
    DISCIPLINA_cod_disciplina INTEGER NOT NULL,
    TIPO_PARTICIPACION_cod_p INTEGER NOT NULL,
    CATEGORIA_cod_categoria INTEGER NOT NULL,
    CONSTRAINT FK_ev_dis FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES disciplina(cod_disciplina) ON DELETE CASCADE,
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
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE costo_evento(
    EVENTO_cod_evento INTEGER NOT NULL,
    TELEVISORA_cod_televisora INTEGER NOT NULL,
    Tarifa NUMBER(10,2) NOT NULL,
    PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    CONSTRAINT FK_ce_evn FOREIGN KEY (EVENTO_cod_evento) REFERENCES evento(cod_evento),
    CONSTRAINT FK_ce_tele FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES televisora(cod_televisora)
);

-- 2. MODIFICANDO LA TABLA EVENTO
ALTER TABLE evento 
DROP (fecha,hora);

ALTER TABLE evento 
ADD fecha_hora TIMESTAMP(0) NOT NULL;

-- 3. SET FECHA Y HORARIO
ALTER TABLE evento
ADD CONSTRAINT CHK_Date CHECK (TO_TIMESTAMP(fecha_hora,'DD-MM-YYYY HH24:MI:SS')
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
MODIFY ubicacion INTEGER;
--c)
ALTER TABLE evento
ADD FOREIGN KEY (ubicacion) REFERENCES sede(cod_sede);

-- 5. DEFAULT miembro
ALTER TABLE miembro
MODIFY telefono DEFAULT 0;

-- 6. Inserscion de datos
-- Profesion
INSERT INTO profesion VALUES(1,'Medico');
INSERT INTO profesion VALUES(2,'Arquitecto');
INSERT INTO profesion VALUES(3,'Ingeniero');
INSERT INTO profesion VALUES(4,'Secretaria');
INSERT INTO profesion VALUES(5,'Auditor');
-- Pais
INSERT INTO pais VALUES(1,'Guatemala');
INSERT INTO pais VALUES(2,'Francia');
INSERT INTO pais VALUES(3,'Argentina');
INSERT INTO pais VALUES(4,'Alemania');
INSERT INTO pais VALUES(5,'Italia');
INSERT INTO pais VALUES(6,'Brasil');
INSERT INTO pais VALUES(7,'Estados Unidos');
-- Miembro
INSERT INTO miembro VALUES(1,'Scott','Mitchell',32,default,'1092 Highland Drive Manitowoc, WI 54220',7,3);
INSERT INTO miembro VALUES(2,'Fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4);
INSERT INTO miembro VALUES(3,'Laura','Cuhna Silva',55,default,'Rua Onze, 86 Uberaba-MG',6,5);
INSERT INTO miembro VALUES(4,'Juan José','López',38,36985247,'26 calle 4-10 zona 11',1,2);
INSERT INTO miembro VALUES(5,'Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1);
INSERT INTO miembro VALUES(6,'Jeuel','Villalpando',31,default,'Acuña de Figeroa 6106 80101 Playa Pascual',3,5);
-- Disciplina
INSERT INTO disciplina VALUES(1,'Atletismo','Saltos de longitud y triples, de altura y con periga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco');
INSERT INTO disciplina VALUES(2,'Bádminton',NULL);
INSERT INTO disciplina VALUES(3,'Ciclismo',NULL);
INSERT INTO disciplina VALUES(4,'Judo','Es un arte marcial que se orgino en Japón alrededor de 1880');
INSERT INTO disciplina VALUES(5,'Lucha',NULL);
INSERT INTO disciplina VALUES(6,'Tenis de Mesa',NULL);
INSERT INTO disciplina VALUES(7,'Boxeo',NULL);
INSERT INTO disciplina VALUES(8,'Natacion','Esta presente como deporte en los juegos desde la primera edicion de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas');
INSERT INTO disciplina VALUES(9,'Esgrima',NULL);
INSERT INTO disciplina VALUES(10,'Vela',NULL);
-- Tipo_medalla
INSERT INTO tipo_medalla VALUES(1,'Oro');
INSERT INTO tipo_medalla VALUES(2,'Plata');
INSERT INTO tipo_medalla VALUES(3,'Bronce');
INSERT INTO tipo_medalla VALUES(4,'Platino');
-- Categoria
INSERT INTO categoria VALUES(1,'Clasificatorio');
INSERT INTO categoria VALUES(2,'Eliminatorio');
INSERT INTO categoria VALUES(3,'Final');
-- Tipo_participacion
INSERT INTO tipo_participacion VALUES (1,'Individual');
INSERT INTO tipo_participacion VALUES (2,'Parejas');
INSERT INTO tipo_participacion VALUES (3,'Equipos');
-- Medallero
INSERT INTO medallero VALUES(5,3,1);
INSERT INTO medallero VALUES(2,5,1);
INSERT INTO medallero VALUES(6,4,3);
INSERT INTO medallero VALUES(4,3,4);
INSERT INTO medallero VALUES(7,10,3);
INSERT INTO medallero VALUES(3,8,2);
INSERT INTO medallero VALUES(1,2,1);
INSERT INTO medallero VALUES(1,5,4);
INSERT INTO medallero VALUES(5,7,2);
-- Sede
INSERT INTO sede VALUES(1,'Gimnasio Metropolitano de Tokio');
INSERT INTO sede VALUES(2,'Jardín del Palacio Imperial de Tokio');
INSERT INTO sede VALUES(3,'Gimnasio Nacional Yoyogi');
INSERT INTO sede VALUES(4,'Nippon Budokan');
INSERT INTO sede VALUES(5,'Estadio Olímpico');
-- Evento
ALTER SESSION SET NLS_TIMESTAMP_FORMAT='DD-MM-YYYY HH24:MI:SS';
INSERT INTO evento VALUES(1,3,2,2,1,TO_TIMESTAMP('24-07-2020 11:00:00','DD-MM-YYYY HH24:MI:SS'));
INSERT INTO evento VALUES(2,1,6,1,1,TO_TIMESTAMP('26-07-2020 10:30:00','DD-MM-YYYY HH24:MI:SS'));
INSERT INTO evento VALUES(3,5,7,1,1,TO_TIMESTAMP('30-07-2020 18:45:00','DD-MM-YYYY HH24:MI:SS'));
INSERT INTO evento VALUES(4,2,1,1,1,TO_TIMESTAMP('01-08-2020 12:15:00','DD-MM-YYYY HH24:MI:SS'));
INSERT INTO evento VALUES(5,4,10,3,1,TO_TIMESTAMP('08-08-2020 19:35:00','DD-MM-YYYY HH24:MI:SS'));

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
MODIFY tarifa DECIMAL(20,2);

-- 10. DELETE COLUMN
DELETE FROM tipo_medalla
WHERE cod_tipo = 4;

-- 11. DROP TABLE
DROP TABLE costo_evento;
DROP TABLE televisora;

-- 12. DELETE ALL 
DELETE FROM disciplina;

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
ADD fotografia BLOB;

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
--DROP TABLE atleta;
--DROP TABLE disciplina;
--DROP TABLE medallero;
--DROP TABLE tipo_medalla;
--DROP TABLE puesto_miembro;
--DROP TABLE miembro;
--DROP TABLE departamento;
--DROP TABLE puesto;
--DROP TABLE pais;
--DROP TABLE profesion;
--DROP TABLE sede;
--DROP TABLE disciplina_atleta;