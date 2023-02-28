SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT name, species FROM animals;
ROLLBACK;
SELECT name, species FROM animals;
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT name, species FROM animals;
COMMIT;
SELECT name, species FROM animals;
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT delete_animals;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO delete_animals;
SELECT * FROM animals;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM (SELECT * FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31') AS animals_between_1990_2000 GROUP BY species;
-- query multiple tables
SELECT name AS animals, full_name AS owner FROM animals A 
JOIN owners O ON A.owner_id = O.id 
WHERE O.full_name = 'Melody Pond';

SELECT A.name AS animals, S.name AS type FROM animals A
JOIN species S ON A.species_id = S.id
WHERE S.name = 'Pokemon';

SELECT A.name AS animals, O.full_name AS owner
FROM animals A
RIGHT JOIN owners O ON A.owner_id = O.id;

SELECT S.name AS type, COUNT(A.name) AS num_of_animals
FROM animals A 
JOIN species S ON A.species_id = S.id
GROUP BY S.name;

SELECT A.name, S.name AS type, O.full_name AS owner
FROM animals A 
JOIN species S ON A.species_id = S.id
JOIN owners O ON A.owner_id = O.id
WHERE S.name = 'Digimon' AND O.full_name = 'Jennifer Orwell';

SELECT A.name AS animals, A.escape_attempts, O.full_name AS owner
FROM animals A
JOIN owners O ON A.owner_id = O.id
WHERE A.escape_attempts = 0 AND O.full_name = 'Dean Winchester';

SELECT COUNT(A.name) AS num_of_animals, O.full_name AS owner
FROM animals A
JOIN owners O ON A.owner_id = O.id
GROUP BY O.full_name
ORDER BY num_of_animals DESC
LIMIT 1;

-- queries join table
SELECT A.name AS animal, VE.name AS vet, VI.date_of_visit
FROM visits VI
JOIN animals A ON VI.animals_id = A.id
JOIN vets VE ON VI.vets_id = VE.id
WHERE VE.name = 'William Tatcher'
ORDER BY date_of_visit DESC
LIMIT 1;

SELECT COUNT(DISTINCT A.name), VE.name AS vet
FROM visits VI
JOIN animals A ON VI.animals_id = A.id
JOIN vets VE ON VI.vets_id = VE.id
GROUP BY VE.name
HAVING VE.name = 'Stephanie Mendez';

SELECT VE.name AS vet, SP.name AS specialties
FROM specializations S
FULL JOIN vets VE ON S.vets_id = VE.id
FULL JOIN species SP ON S.species_id = SP.id;

SELECT A.name, VE.name AS vet, VI.date_of_visit
FROM visits VI
JOIN animals A ON VI.animals_id = A.id
JOIN vets VE ON VI.vets_id = VE.id
GROUP BY A.name, VE.name, VI.date_of_visit
HAVING VE.name = 'Stephanie Mendez'
AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT A.name, COUNT(VI.date_of_visit) AS visits_to_vets
FROM visits VI
JOIN animals A ON VI.animals_id = A.id
JOIN vets VE ON VI.vets_id = VE.id
GROUP BY A.name
ORDER BY visits_to_vets DESC
LIMIT 1;

SELECT A.name AS animals, VE.name AS vet, VI.date_of_visit
FROM visits VI
JOIN animals A ON VI.animals_id = A.id
JOIN vets VE ON VI.vets_id = VE.id
WHERE VE.name = 'Maisy Smith'
ORDER BY VI.date_of_visit ASC
LIMIT 1;

SELECT A.name AS animals, VE.name AS vet, VI.date_of_visit
FROM visits VI
JOIN animals A ON VI.animals_id = A.id
JOIN vets VE ON VI.vets_id = VE.id
ORDER BY VI.date_of_visit DESC
LIMIT 1;

-- List of visits were with a vet that did not specialize in that animal's species
SELECT 
  a.name AS animals,
  s.name AS species,
  v.name AS vets,
  sp.name AS specialties
FROM visits vi
  JOIN animals a ON vi.animals_id = a.id
  JOIN vets v ON vi.vets_id = v.id
  JOIN species s ON a.species_id = s.id
  LEFT JOIN specializations spec ON v.id = spec.vets_id
  FULL JOIN species sp ON spec.species_id = sp.id
WHERE 
  v.name <> 'Stephanie Mendez'
  AND s.name <> sp.name OR sp.name IS NULL;

-- number of visits were with a vet that did not specialize in that animal's species
SELECT 
  COUNT(*) AS num_not_specialize_visits
FROM visits vi
  JOIN animals a ON vi.animals_id = a.id
  JOIN vets v ON vi.vets_id = v.id
  JOIN species s ON a.species_id = s.id
  LEFT JOIN specializations spec ON v.id = spec.vets_id
  FULL JOIN species sp ON spec.species_id = sp.id
WHERE 
  v.name <> 'Stephanie Mendez'
  AND s.name <> sp.name OR sp.name IS NULL;

SELECT
  v.name AS vet,
  s.name AS species,
  vi.date_of_visit
FROM
  visits vi
  JOIN vets v ON vi.vets_id = v.id
  JOIN animals a ON vi.animals_id = a.id
  JOIN species s ON a.species_id = s.id
WHERE
  v.name = 'Maisy Smith';

--performance audit queries
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animals_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vets_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

ALTER TABLE visits
ADD PRIMARY KEY (vets_id);