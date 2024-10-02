
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
    
    
    
    
    
    