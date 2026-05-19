-- ================================================
-- 05_ranking_componentes.sql
-- Pergunta: Quais componentes concentram mais defeitos?
-- Técnicas: CTE, RANK(), PARTITION BY
-- ================================================

USE QA_Portfolio;
GO

WITH defeitos_por_componente AS (
    SELECT
        c.nome                                              AS componente,
        COUNT(d.id_defeito)                                 AS total_defeitos,
        SUM(CASE WHEN d.escaped = 1   THEN 1 ELSE 0 END)   AS escapados,
        SUM(CASE WHEN sv.nivel = 1    THEN 1 ELSE 0 END)   AS criticos,
        SUM(CASE WHEN sv.nivel = 2    THEN 1 ELSE 0 END)   AS altos,
        SUM(CASE WHEN sv.nivel = 3    THEN 1 ELSE 0 END)   AS medios,
        SUM(CASE WHEN sv.nivel = 4    THEN 1 ELSE 0 END)   AS baixos
    FROM Componente c
    LEFT JOIN Defeito d     ON d.id_componente  = c.id_componente
    LEFT JOIN Severidade sv ON sv.id_severidade = d.id_severidade
    GROUP BY c.id_componente, c.nome
)
SELECT
    RANK() OVER (ORDER BY total_defeitos DESC, criticos DESC)   AS ranking,
    componente,
    total_defeitos,
    criticos,
    altos,
    medios,
    baixos,
    escapados,
    -- Percentual de defeitos críticos no componente
    ROUND(
        100.0 * criticos / NULLIF(total_defeitos, 0), 1
    )                                                           AS pct_criticos
FROM defeitos_por_componente
ORDER BY ranking;
GO