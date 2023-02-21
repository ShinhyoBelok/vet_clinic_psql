CREATE TABLE animals(
  id SERIAL,
  name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL(6, 3) NOT NULL,
  PRIMARY KEY (id)
);
