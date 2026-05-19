-- ================================================
-- 02_defect_escape_rate.sql
-- Pergunta: Quais sprints deixaram defeitos escaparem para produção?
-- Técnicas: CTE, window function, CAST, NULLIF
-- ================================================

USE QA_Portfolio;
GO

WITH metricas AS (
    SELECT
        s.id_sprint,
        s.nome                                              AS sprint,
        COUNT(d.id_defeito)                                 AS total_defeitos,
        SUM(CASE WHEN d.escaped = 1 THEN 1 ELSE 0 END)     AS escaparam
    FROM Sprint s
    LEFT JOIN Defeito d ON d.id_sprint = s.id_sprint
    GROUP BY s.id_sprint, s.nome
)
SELECT
    sprint,
    total_defeitos,
    escaparam,
    ROUND(
        100.0 * escaparam / NULLIF(total_defeitos, 0), 1
    )                                                       AS escape_rate_pct,
    -- Média móvel de 3 sprints
    ROUND(AVG(
        100.0 * escaparam / NULLIF(total_defeitos, 0)
    ) OVER (
        ORDER BY id_sprint
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 1)                                                   AS media_movel_3_sprints
FROM metricas
ORDER BY id_sprint;
GO