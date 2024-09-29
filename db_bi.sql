
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
