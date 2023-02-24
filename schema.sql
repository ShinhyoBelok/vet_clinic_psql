CREATE TABLE animals(
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL(6, 3) NOT NULL,
  PRIMARY KEY (id)
);
ALTER TABLE animals ADD COLUMN species VARCHAR(50);

CREATE TABLE owners (
  id SERIAL,
  full_name VARCHAR(50) NOT NULL,
  age INT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE species (
  id SERIAL,
  name VARCHAR(50),
  PRIMARY KEY (id)
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id  INT;
ALTER TABLE animals ADD FOREIGN KEY (owner_id ) REFERENCES owners(id);

CREATE TABLE vets(
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  age INT NOT NULL,
  date_of_graduation DATE NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE specializations (
  id SERIAL,
  species_id INT NOT NULL,
  vets_id INT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE visits (
  id SERIAL,
  animals_id INT NOT NULL,
  vets_id INT NOT NULL,
  date_of_visit DATE NOT NULL,
  PRIMARY KEY (id)
);
