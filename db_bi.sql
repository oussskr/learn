
SELECT
    a.`type_designation` AS anomalie,
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f
JOIN
    `dw_date_dim` d ON f.date_id = d.date_id
JOIN
    `alert_type` a ON f.alert_type_id = a.alert_type_id
WHERE
    d.full_date BETWEEN '2024-09-01' AND '2024-09-30'

GROUP BY
    a.`type designation`;





SELECT
    a.`type designation` AS anomalie,
    SUM(f.nbr_alert) AS nombre,
    CASE
        WHEN a.`type designation` = 'depassment de vitesse' THEN MAX(fo.max_speed)
        WHEN a.`type designation` = 'entres/sortie de zone' THEN 'Buira'
        WHEN a.`type designation` = 'conduit en dehors de heurs de travaile' THEN MAX(TIME_FORMAT(TIMEDIFF(SEC_TO_TIME(fo.used_time * 3600), '00:00:00'), '%H:%i'))
        WHEN a.`type designation` = 'conduite en weekend' THEN MAX(d.day_name)
    END AS valeur
FROM
    `dw_alert_fact` f
JOIN
    `dw_date_dim` d ON f.date_id = d.date_id
JOIN
    `alert_type` a ON f.alert_type_id = a.alert_type_id
LEFT JOIN
    `dw_fleetop_fact` fo ON f.thing_id = fo.thing_id AND f.date_id = fo.date_id
WHERE
    d.full_date BETWEEN '2024-09-01' AND '2024-09-30'
GROUP BY
    a.`type designation`;





    SELECT
    a.`type designation` AS anomalie,
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f

JOIN
    `alert_type` a ON f.alert_type_id = a.alert_type_id


GROUP BY
    a.`type designation`;








     SELECT
    n.`lname` AS chauffeur,
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f

JOIN
    `alert_type` a ON f.alert_type_id = a.alert_type_id


GROUP BY
    n.`lname`;


corrected v:




    SELECT
    CONCAT(u.fname, ' ', u.lname) AS chauffeur,
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f
JOIN
    `alert_type` a ON f.alert_type_id = a.alert_type_id
JOIN
    `user` u ON f.user_id = u.user_id
GROUP BY
    u.fname, u.lname;





v5 vehicule

SELECT
t.thing_type AS vehicule,
    t.thing_id AS matricule,  
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f
JOIN
    `dw_thing_dim` t ON f.thing_id = t.thing_id 
GROUP BY
    t.thing_id;














date v

SELECT
    d.full_date AS date, 
    SUM(f.nbr_alert) AS nombre  
FROM
    `dw_alert_fact` f
JOIN
    `dw_date_dim` d ON f.date_id = d.date_id  
GROUP BY
    d.full_date;  



full date v 

SELECT
    d.full_date AS date, 
    SUM(f.nbr_alert) AS nombre  
FROM
    `dw_alert_fact` f
JOIN
    `dw_date_dim` d ON f.date_id = d.date_id  
    
    WHERE d.full_date BETWEEN '2024-09-01' AND '2024-09-30' 
GROUP BY
    d.full_date;



par mois


    SELECT
    d.month_name AS mois,  
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f
JOIN
    `dw_date_dim` d ON f.date_id = d.date_id 
GROUP BY
    d.month_name;



    year

    SELECT
    d.year AS annes,  
    SUM(f.nbr_alert) AS nombre
FROM
    `dw_alert_fact` f
JOIN
    `dw_date_dim` d ON f.date_id = d.date_id 
GROUP BY
    d.year;







    















-----------------






    new db new queyrs



WITH anomaly_data AS (
    SELECT
        f.date_id,
        f.nbr_anomaly_speed,
        f.nbr_anomaly_zone,
        f.nbr_anomaly_longrun,
        f.max_speed,
        f.active_time,
        d.day_name,
        CASE 
            WHEN f.nbr_anomaly_speed > 0 THEN 'depassment de vitesse'
            WHEN f.nbr_anomaly_zone > 0 THEN 'entres/sortie de zone'
            WHEN f.nbr_anomaly_longrun > 0 THEN 'conduit en dehors de heurs de travaile'
            WHEN d.day_name IN ('Saturday', 'Sunday') THEN 'conduite en weekend'
            ELSE 'Autre'
        END AS anomalie_type
    FROM
        `DW_fleetop_fact` f
    JOIN
        `DW_date_dim` d ON f.date_id = d.date_id
    WHERE
        d.full_date BETWEEN '2024-09-01' AND '2024-09-30'
)
SELECT
    anomalie_type AS anomalie,
    COUNT(*) AS nombre,
    CASE 
        WHEN anomalie_type = 'depassment de vitesse' THEN MAX(max_speed)
        WHEN anomalie_type = 'entres/sortie de zone' THEN 'Buira'
        WHEN anomalie_type = 'conduit en dehors de heurs de travaile' THEN MAX(TIME_FORMAT(SEC_TO_TIME(active_time * 3600), '%H:%i'))
        WHEN anomalie_type = 'conduite en weekend' THEN MAX(day_name)
        ELSE NULL
    END AS valeur
FROM
    anomaly_data
GROUP BY
    anomalie_type;    
    
    
    
    
    
    -- Query 2: Anomalies by driver
SELECT
    CONCAT(u.contact_prenom, ' ', u.contact_nom) AS chauffeur,
    SUM(f.nbr_anomaly) AS nombre
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_user_dim` u ON f.user_id = u.user_id
GROUP BY
    u.user_id, u.contact_prenom, u.contact_nom;

-- Query 3: Anomalies by vehicle
SELECT
    t.thing_type AS vehicule,
    t.thing_id AS matricule,  
    SUM(f.nbr_anomaly) AS nombre
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_thing_dim` t ON f.thing_id = t.thing_id 
GROUP BY
    t.thing_id, t.thing_type;

-- Query 4: Anomalies by date
SELECT
    d.full_date AS date, 
    SUM(f.nbr_anomaly) AS nombre  
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id  
WHERE 
    d.full_date BETWEEN '2024-09-01' AND '2024-09-30' 
GROUP BY
    d.full_date;

-- Query 5: Anomalies by month
SELECT
    d.month_name AS mois,  
    SUM(f.nbr_anomaly) AS nombre
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id 
GROUP BY
    d.month_name;

-- Query 6: Anomalies by year
SELECT
    d.year AS annes,  
    SUM(f.nbr_anomaly) AS nombre
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id 
GROUP BY
    d.year;
    
    
    









    
    --------python script
    import mysql.connector
import random
from faker import Faker
from datetime import datetime, timedelta

# Initialize Faker for generating fake data
fake = Faker()

# Database connection configuration
config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'db_bi3',
}


# config = {
#     'user': 'postgres',
#     'password': 'ryqn',
#     'host': 'localhost',
#     'database': 'geoDWprod',
# }


# Establish database connection
conn = mysql.connector.connect(**config)
# conn = psycopg2.connect(**config)
cursor = conn.cursor()

# Generate and insert random data for DW_date_dim
def populate_date_dim(cursor, num_days=700):
    start_date = datetime.today() - timedelta(days=num_days)
    for i in range(num_days):
        date = start_date + timedelta(days=i)
        year = date.year
        month = date.strftime('%Y-%m')
        day = date.day
        month_name = date.strftime('%B')
        day_name = date.strftime('%A')
        quarter = f"{year}-Q{(date.month-1)//3 + 1}"
        season = ("Winter" if date.month in [12, 1, 2] else
                  "Spring" if date.month in [3, 4, 5] else
                  "Summer" if date.month in [6, 7, 8] else
                  "Fall")
        
        cursor.execute("""
            INSERT INTO DW_date_dim (full_date, year, month, day, month_name, day_name, quarter, season)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (date, year, month, day, month_name, day_name, quarter, season))

# Generate and insert random data for DW_thing_dim
def populate_thing_dim(cursor, num_things=4000):
    for i in range(num_things):
        thing_type = random.choice(['Vehicle', 'Drone', 'Robot'])
        thing_group = random.choice(['Group A', 'Group B', 'Group C'])
        
        cursor.execute("""
            INSERT INTO DW_thing_dim (thing_type, thing_group)
            VALUES (%s, %s)
        """, (thing_type, thing_group))

# Generate and insert random data for DW_user_dim
def populate_user_dim(cursor, num_users=1000):
    for i in range(num_users):
        user_id = i + 1
        contact_prenom = fake.first_name()
        contact_nom = fake.last_name()
        telephone = fake.phone_number()
        
        cursor.execute("""
            INSERT INTO DW_user_dim (user_id, contact_prenom, contact_nom, telephone)
            VALUES (%s, %s, %s, %s)
        """, (user_id, contact_prenom, contact_nom, telephone))

# Generate and insert random data for DW_fleetop_fact
def populate_fleetop_fact(cursor, num_records=2800000):
    # Fetch the necessary IDs
    cursor.execute("SELECT thing_id FROM DW_thing_dim")
    thing_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT date_id FROM DW_date_dim")
    date_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT user_id FROM DW_user_dim")
    user_ids = [row[0] for row in cursor.fetchall()]

    # Ensure the number of records doesn't exceed the possible combinations
    max_combinations = min(len(thing_ids) * len(date_ids), num_records)
    
    count = 0
    for thing_id in thing_ids:
        for date_id in date_ids:
            if count >= max_combinations:
                break  # Stop when reaching the limit of combinations

            user_id = random.choice(user_ids)
            max_speed = random.uniform(50, 120)
            avg_speed = random.uniform(30, 70)
            fuel_consumption = random.uniform(5, 20)
            nbr_mission = random.randint(1, 10)
            car_parts_cost = random.uniform(50, 300)
            fuel_costs = random.uniform(50, 200)
            nbr_actions = random.randint(1, 5)
            idle_time = random.uniform(1, 8)
            active_time = random.uniform(8, 24)
            travelled_distance = random.uniform(100, 500)
            nbr_anomaly_longrun = random.randint(0, 5)
            nbr_anomaly_longstop = random.randint(0, 5)
            nbr_anomaly_speed = random.randint(0, 5)
            nbr_anomaly_zone = random.randint(0, 5)

            cursor.execute("""
                INSERT INTO DW_fleetop_fact (
                    thing_id, date_id, user_id, max_speed, avg_speed, fuel_consumption,
                    nbr_mission, car_parts_cost, fuel_costs, nbr_actions, idle_time, active_time,
                    travelled_distance, nbr_anomaly_longrun, nbr_anomaly_longstop, nbr_anomaly_speed,
                    nbr_anomaly_zone
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                thing_id, date_id, user_id, max_speed, avg_speed, fuel_consumption,
                nbr_mission, car_parts_cost, fuel_costs, nbr_actions, idle_time, active_time,
                travelled_distance, nbr_anomaly_longrun, nbr_anomaly_longstop, nbr_anomaly_speed,
                nbr_anomaly_zone
            ))

            count += 1
        if count >= max_combinations:
            break


# Populate tables
populate_date_dim(cursor)
print("Date dimension populated")
populate_thing_dim(cursor)
print("Thing dimension populated")
populate_user_dim(cursor)
print("User dimension populated")
populate_fleetop_fact(cursor)
print("Fleet operation fact populated")

# Commit changes and close connection
conn.commit()
cursor.close()
conn.close()
















-------------------------------part 2-----------------------------




    SELECT
    t.thing_type AS vehicule,
    t.thing_id AS matricule,
    ROUND(SUM(f.fuel_consumption), 3) AS total_litres,
    ROUND(SUM(f.travelled_distance), 3) AS total_km,
    ROUND(SUM(f.total_cost), 3) AS couts_DA,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND(SUM(f.total_cost) / SUM(f.travelled_distance), 3)
        ELSE 0
    END AS couts_per_km_DA,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND((SUM(f.fuel_consumption) / SUM(f.travelled_distance)) * 100, 3)
        ELSE 0
    END AS litres_per_100_km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_thing_dim` t ON f.thing_id = t.thing_id
GROUP BY
    t.thing_id, t.thing_type;
    
    
    
    
    
    
    
    
    
    
    
    
    
    SELECT
    CONCAT(u.contact_prenom, ' ', u.contact_nom) AS chauffeur,
    ROUND(SUM(f.fuel_consumption), 3) AS total_litres,
    ROUND(SUM(f.travelled_distance), 3) AS total_km,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND(SUM(f.total_cost) / SUM(f.travelled_distance), 3)
        ELSE 0
    END AS couts_per_km_DA,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND((SUM(f.fuel_consumption) / SUM(f.travelled_distance)) * 100, 3)
        ELSE 0
    END AS litres_per_100_km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_user_dim` u ON f.user_id = u.user_id
GROUP BY
    u.user_id, u.contact_prenom, u.contact_nom;















SELECT
    d.full_date AS jours,
    ROUND(SUM(f.fuel_consumption), 3) AS total_litres,
    ROUND(SUM(f.travelled_distance), 3) AS total_km,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND(SUM(f.total_cost) / SUM(f.travelled_distance), 3)
        ELSE 0
    END AS couts_per_km_DA,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND((SUM(f.fuel_consumption) / SUM(f.travelled_distance)) * 100, 3)
        ELSE 0
    END AS litres_per_100_km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
GROUP BY
    d.full_date
ORDER BY
    d.full_date;
    
    
    
    
    
    
    
    
    SELECT
    d.month AS mois,
    ROUND(SUM(f.fuel_consumption), 3) AS total_litres,
    ROUND(SUM(f.travelled_distance), 3) AS total_km,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND(SUM(f.total_cost) / SUM(f.travelled_distance), 3)
        ELSE 0
    END AS couts_per_km_DA,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND((SUM(f.fuel_consumption) / SUM(f.travelled_distance)) * 100, 3)
        ELSE 0
    END AS litres_per_100_km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
WHERE
    d.year = 2024 -- You can adjust the year if needed
GROUP BY
    d.month
ORDER BY
    d.month;
    
    
    
    
    
    
    
    
    
    
    
    
    SELECT
    d.year AS annee,
    ROUND(SUM(f.fuel_consumption), 3) AS total_litres,
    ROUND(SUM(f.travelled_distance), 3) AS total_km,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND(SUM(f.total_cost) / SUM(f.travelled_distance), 3)
        ELSE 0
    END AS couts_per_km_DA,
    CASE 
        WHEN SUM(f.travelled_distance) > 0 THEN ROUND((SUM(f.fuel_consumption) / SUM(f.travelled_distance)) * 100, 3)
        ELSE 0
    END AS litres_per_100_km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
GROUP BY
    d.year
ORDER BY
    d.year;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 SELECT
    d.full_date AS date,
    t.thing_type AS vehicule,
    t.thing_id AS matricule,
    NULL AS niveau_avant,  -- Commented out for now
    NULL AS niveau_apres,  -- Commented out for now
    ROUND(f.fuel_consumption, 3) AS total_litres,
    ROUND(f.fuel_consumption * 45.97, 3) AS total_da,  -- Total cost using Naftal price
    ROUND(f.fuel_consumption, 3) AS total_litres_naftal,
    ROUND(f.fuel_consumption * 45.97, 3) AS total_da_naftal  -- Total cost using Naftal price
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
JOIN
    `DW_thing_dim` t ON f.thing_id = t.thing_id
WHERE
    f.fuel_consumption > 0
ORDER BY
    d.full_date;











    ---------------------part 3------------------------






    
    SELECT
    t.thing_type AS vehicule,             -- Vehicle type
    t.thing_id AS matricule,              -- Vehicle ID (matricule)
    SUM(f.nbr_mission) AS missions,       -- Total number of missions
    NULL AS CA,                           -- Placeholder for CA (to be defined later)
    ROUND(SUM(f.travelled_distance), 3) AS total_km,  -- Total kilometers traveled
    NULL AS ca_per_km                     -- Placeholder for CA/km (to be defined later)
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_thing_dim` t ON f.thing_id = t.thing_id
GROUP BY
    t.thing_type, t.thing_id  -- Group by vehicle and matricule
ORDER BY
    t.thing_type, t.thing_id;  -- Order by vehicle type and matricule

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    SELECT
    CONCAT(u.contact_prenom, ' ', u.contact_nom) AS chauffeur, -- Chauffeur's full name
    SUM(f.nbr_mission) AS missions,                           -- Total number of missions
    NULL AS CA,                                               -- Placeholder for CA (to be defined later)
    ROUND(SUM(f.travelled_distance), 3) AS total_km,          -- Total kilometers traveled
    ROUND(SUM(f.total_cost), 3) AS frais_de_mission,          -- Total mission costs (frais de mission)
    NULL AS ca_per_km                                         -- Placeholder for CA/km (to be defined later)
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_user_dim` u ON f.user_id = u.user_id
GROUP BY
    u.contact_prenom, u.contact_nom  -- Group by chauffeur's first and last name
ORDER BY
    u.contact_prenom, u.contact_nom;  -- Order by chauffeur name

    
    
    
    
    
    
    
    
    
    SELECT
    t.thing_group AS destination,                            -- Destination (from thing_group)
    SUM(f.nbr_mission) AS missions,                          -- Total number of missions
    NULL AS CA,                                              -- Placeholder for CA (to be defined later)
    ROUND(SUM(f.travelled_distance), 3) AS total_km,         -- Total kilometers traveled
    NULL AS ca_per_km                                        -- Placeholder for CA/km (to be defined later)
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_thing_dim` t ON f.thing_id = t.thing_id
GROUP BY
    t.thing_group                                           -- Group by destination
ORDER BY
    t.thing_group;                                          -- Order by destination

    
    
    
    
    
    
    
    
    
    
    
    SELECT
    d.full_date AS jours,                                    -- Day (full date)
    SUM(f.nbr_mission) AS missions,                          -- Total number of missions
    NULL AS CA,                                              -- Placeholder for CA
    ROUND(SUM(f.travelled_distance), 3) AS total_km,         -- Total kilometers traveled
    ROUND(SUM(f.total_cost), 3) AS frais_de_mission,         -- Total mission costs
    NULL AS ca_per_km                                        -- Placeholder for CA/km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
GROUP BY
    d.full_date                                              -- Group by each day
ORDER BY
    d.full_date;                                             -- Order by date

    
    
    
    
    
    
    
    
    
    SELECT
    d.month_name AS mois,                                    -- Month name
    SUM(f.nbr_mission) AS missions,                          -- Total number of missions
    NULL AS CA,                                              -- Placeholder for CA
    ROUND(SUM(f.travelled_distance), 3) AS total_km,         -- Total kilometers traveled
    ROUND(SUM(f.total_cost), 3) AS frais_de_mission,         -- Total mission costs
    NULL AS ca_per_km                                        -- Placeholder for CA/km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
GROUP BY
    d.month_name                                             -- Group by month
ORDER BY
    d.month_name;                                            -- Order by month

    
    
    
    
    
    
    
    
    
    
    SELECT
    d.year AS annes,                                         -- Year
    SUM(f.nbr_mission) AS missions,                          -- Total number of missions
    NULL AS CA,                                              -- Placeholder for CA
    ROUND(SUM(f.travelled_distance), 3) AS total_km,         -- Total kilometers traveled
    ROUND(SUM(f.total_cost), 3) AS frais_de_mission,         -- Total mission costs
    NULL AS ca_per_km                                        -- Placeholder for CA/km
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_date_dim` d ON f.date_id = d.date_id
GROUP BY
    d.year                                                   -- Group by year
ORDER BY
    d.year;                                                  -- Order by year
	













-----------------part4




    SELECT 
    'Carburant' AS type,
    ROUND(SUM(f.fuel_costs), 3) AS montant
FROM 
    `DW_fleetop_fact` f
WHERE 
    f.fuel_costs > 0

UNION ALL

SELECT 
    'Assurance' AS type,
    ROUND(SUM(f.assurence), 3) AS montant
FROM 
    `DW_fleetop_fact` f
WHERE 
    f.assurence > 0

UNION ALL

SELECT 
    'Contrôle Technique' AS type,
    ROUND(SUM(f.controle_technique), 3) AS montant
FROM 
    `DW_fleetop_fact` f
WHERE 
    f.controle_technique > 0

UNION ALL

SELECT 
    'Vignettes' AS type,
    ROUND(SUM(f.vignettes), 3) AS montant
FROM 
    `DW_fleetop_fact` f
WHERE 
    f.vignettes > 0;

























SELECT
    t.thing_type AS vehicle,
    t.thing_id AS matricule,
        ROUND(SUM(f.fuel_costs), 3) AS carburant,
    ROUND(SUM(f.car_parts_cost ), 3)AS maintenance,
    ROUND(SUM(f.assurence), 3) AS assurence,
    ROUND(SUM(f.controle_technique), 3) AS controle_technique,
    ROUND(SUM(f.vignettes), 3) AS vignettes,
    ROUND(SUM(f.fuel_costs + f.assurence + f.controle_technique + f.vignettes), 3) AS total -- Sum of all the costs
FROM
    `DW_fleetop_fact` f
JOIN
    `DW_thing_dim` t ON f.thing_id = t.thing_id
GROUP BY
    t.thing_type, t.thing_id
ORDER BY
    t.thing_type, t.thing_id;







