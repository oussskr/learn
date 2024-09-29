
SELECT
    a.`type designation` AS anomalie,
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