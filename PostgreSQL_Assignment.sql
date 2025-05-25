-- rangers Table creation
CREATE Table rangers(
    ranger_id SERIAL PRIMARY KEY UNIQUE,
    name VARCHAR(20),
    region VARCHAR(25)
);

-- species Table creation
CREATE Table species(
    species_id SERIAL PRIMARY KEY UNIQUE,
    common_name VARCHAR(20),
    scientific_name VARCHAR(25),
    discovery_date DATE,
    conservation_status VARCHAR(15)
);

-- sightings Table creation
CREATE Table sightings(
    sighting_id SERIAL PRIMARY KEY UNIQUE,
    species_id INTEGER REFERENCES species(species_id) ON DELETE CASCADE,
    ranger_id INTEGER REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    location VARCHAR(25),
    sighting_time TIMESTAMP
);



-- rangers Table data insertion
INSERT INTO rangers(ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

-- species Table data insertion
INSERT INTO species(species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', DATE '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', DATE '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', DATE '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', DATE '1758-01-01', 'Endangered');

-- sightings Table data insertion
INSERT INTO sightings(sighting_id, species_id, ranger_id, location, sighting_time) VALUES
(1, 1, 1, 'Peak Ridge', TIMESTAMP '2024-05-10 07:45:00'),
(2, 2, 2, 'Bankwood Area', TIMESTAMP '2024-05-12 16:20:00'),
(3, 3, 3, 'Bamboo Grove East', TIMESTAMP '2024-05-15 09:10:00'),
(4, 1, 2, 'Snowfall Pass', TIMESTAMP '2024-05-18 18:30:00');


-- View table's data
SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;




-- Problem 1: Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers(ranger_id, name, region) VALUES(4, 'Derek Fox', 'Coastal Plains');



-- Problem 2: Count unique species ever sighted.
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings;



-- Problem 3: Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location LIKE '%Pass%';



-- Problem 4: List each ranger's name and their total number of sightings.
SELECT rangers.name as name, count(*) as total_sightings FROM sightings JOIN rangers USING(ranger_id)
GROUP BY ranger_id, rangers.name;



-- Problem 5: List species that have never been sighted.
SELECT common_name FROM sightings FULL JOIN species USING(species_id) WHERE sighting_id IS NULL



-- Problem 6: Show the most recent 2 sightings.
SELECT common_name, sighting_time, name FROM sightings JOIN species USING (species_id) JOIN rangers USING(ranger_id) ORDER BY sighting_time DESC LIMIT 2;



-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species SET conservation_status = 'Historic' WHERE extract(year FROM discovery_date) < 1800;



-- Problem 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT
    sighting_id,
    CASE 
        WHEN extract( HOUR FROM sighting_time::TIMESTAMP ) < 12 THEN 'Morning' 
        WHEN extract( HOUR FROM sighting_time::TIMESTAMP ) BETWEEN 12 AND 17 THEN 'Afternoon' 
        WHEN extract( HOUR FROM sighting_time::TIMESTAMP ) > 17 THEN 'Evening'
    END AS time_of_day
FROM sightings;



-- Problem 9: Delete rangers who have never sighted any species.
DELETE FROM rangers WHERE name = (SELECT rangers.name FROM sightings FULL JOIN rangers USING(ranger_id) WHERE sighting_id IS NULL);
