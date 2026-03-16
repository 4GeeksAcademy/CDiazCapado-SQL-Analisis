-- PLEASE READ THIS BEFORE RUNNING THE EXERCISE

-- ⚠️ IMPORTANT: This SQL file may crash due to two common issues: comments and missing semicolons.

-- ✅ Suggestions:
-- 1) Always end each SQL query with a semicolon `;`
-- 2) Ensure comments are well-formed:
--    - Use `--` for single-line comments only
--    - Avoid inline comments after queries
--    - Do not use `/* */` multi-line comments, as they may break execution

-- -----------------------------------------------
-- queries.sql
-- Complete each mission by writing your SQL query
-- directly below the corresponding instruction
-- -----------------------------------------------

SELECT * FROM regions;
SELECT * FROM species;
SELECT * FROM climate;
SELECT * FROM observations;


--1 Primeras 10 observaciones
SELECT * FROM observations LIMIT 10;

--2 Identificadores de región presentes
SELECT DISTINCT region_id
FROM observations
ORDER BY region_id;

--3 ESPECIES DISTINTAS OBSERVADAS
SELECT COUNT(DISTINCT species_id) AS distinct_species_observed
FROM observations;

--4 OBSERVACIONES EN LA REGIÓN CON ID 2
SELECT COUNT(*) AS observations_in_region_2
FROM observations
WHERE region_id = 2;

--5 OBSERVACIONES DEL DÍA 1998-08-08
SELECT COUNT(*) AS observations_on_1998_08_08
FROM observations
WHERE observation_date = '1998-08-08';

--6 REGIÓN CON MÁS OBSERVACIONES
SELECT region_id, COUNT(*) AS total_observations
FROM observations
GROUP BY region_id
ORDER BY total_observations DESC, region_id ASC
LIMIT 1;

-- 7 ESPECIES MÁS FRECUENTES
SELECT species_id, COUNT(*) AS total_observations
FROM observations
GROUP BY species_id
ORDER BY total_observations DESC, species_id ASC
LIMIT 5;

--8 ESPECIES CON MENOS DE 5 REGISTROS
SELECT species_id, COUNT(*) AS total_observations
FROM observations
GROUP BY species_id
HAVING COUNT(*) < 5
ORDER BY total_observations ASC, species_id ASC;

--9 OBSERVADORES MÁS ACTIVOS
SELECT observer, COUNT(*) AS total_observations
FROM observations
GROUP BY observer
ORDER BY total_observations DESC, observer ASC;

--10 NOMBRE DE LA REGIÓN POR OBSERVACIÓN
SELECT o.id AS observation_id, r.name AS region_name
FROM observations AS o
JOIN regions AS r
  ON o.region_id = r.id
ORDER BY o.id;

-- 11 NOMBRE CIENTÍFICO DE LA ESPECIE POR OBSERVACIÓN
SELECT o.id AS observation_id, s.scientific_name
FROM observations AS o
JOIN species AS s
  ON o.species_id = s.id
ORDER BY o.id;

-- 12 ESPECIE MÁS OBSERVADA POR REGIÓN
WITH species_per_region AS (
    SELECT
        r.id AS region_id,
        r.name AS region_name,
        s.id AS species_id,
        s.scientific_name,
        COUNT(*) AS total_observations,
        ROW_NUMBER() OVER (
            PARTITION BY r.id
            ORDER BY COUNT(*) DESC, s.id ASC
        ) AS rn
    FROM observations AS o
    JOIN regions AS r
      ON o.region_id = r.id
    JOIN species AS s
      ON o.species_id = s.id
    GROUP BY r.id, r.name, s.id, s.scientific_name
)
SELECT
    region_id,
    region_name,
    species_id,
    scientific_name,
    total_observations
FROM species_per_region
WHERE rn = 1
ORDER BY region_id;

-- 13 INSERTAR OBSERVACIÓN FICTICIA EN LA TABLA `observations`
INSERT INTO observations (
    species_id,
    region_id,
    observer,
    observation_date,
    latitude,
    longitude,
    count
) VALUES (
    1,
    1,
    'obsr_test_optional',
    '2026-03-15',
    -16.820152,
    145.636250,
    1
);

SELECT *
FROM observations
WHERE observer = 'obsr_test_optional'
ORDER BY id DESC
LIMIT 1;

--14 CORRECCIÓN DE NOMBRE CIENTÍFICO 
UPDATE species
SET scientific_name = 'Ramphastos toco'
WHERE scientific_name = 'Ramphastos tosco'

-- 15 ELIMINAR OBSERVACIÓN
DELETE FROM observations
WHERE id = 501;

