-- Active: 1747460841798@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(150) NOT NULL
);

SELECT * FROM rangers;

INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    );

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

SELECT * FROM species;

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER NOT NULL REFERENCES rangers (ranger_id),
    species_id INTEGER NOT NULL REFERENCES species (species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(150) NOT NULL,
    notes TEXT
);

SELECT * FROM sightings;

-- DROP TABLE sightings;

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- Problems 01
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');
-- SELECT * FROM rangers;
-- DROP TABLE rangers

-- Problems 02
SELECT COUNT(DISTINCT species_id) as unique_species_count
FROM sightings;

-- Problems 03
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- Problems 04
SELECT r.name, COUNT(s.sighting_id) as total_sightings
FROM rangers as r
    JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.name
ORDER BY r.name

-- Problems 05
SELECT common_name
FROM species
WHERE
    species_id NOT IN (
        SELECT species_id
        FROM sightings
    );

-- Problems 06
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings as s
    JOIN species as sp ON s.species_id = sp.species_id
    JOIN rangers as r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problems 07
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01'

-- Problems 08
-- SELECT * FROM sightings

SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- Problems 09
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    )

SELECT * FROM rangers;

