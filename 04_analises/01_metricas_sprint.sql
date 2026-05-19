-- ================================================
-- 01_metricas_sprint.sql
-- Pergunta: Como evoluiu a qualidade ao longo das sprints?
-- Técnicas: GROUP BY, CASE, ROUND, NULLIF
-- ================================================

USE QA_Portfolio;
GO

SELECT
    s.nome                                                          AS sprint,
    COUNT(DISTINCT ct.id_caso)                                      AS casos_planejados,
    COUNT(DISTINCT et.id_execucao)                                  AS execucoes_realizadas,
    SUM(CASE WHEN et.resultado = 'Passou'    THEN 1 ELSE 0 END)    AS passou,
    SUM(CASE WHEN et.resultado = 'Falhou'    THEN 1 ELSE 0 END)    AS falhou,
    SUM(CASE WHEN et.resultado = 'Bloqueado' THEN 1 ELSE 0 END)    AS bloqueado,
    COUNT(DISTINCT d.id_defeito)                                    AS defeitos_encontrados,
    -- Taxa de aprovação da sprint
    ROUND(
        100.0 * SUM(CASE WHEN et.resultado = 'Passou' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(et.id_execucao), 0), 1
    )                                                               AS taxa_aprovacao_pct,
    -- Média de duração das execuções em segundos
    ROUND(AVG(CAST(et.duracao_seg AS FLOAT)), 1)                   AS duracao_media_seg
FROM Sprint s
LEFT JOIN Caso_Teste ct      ON ct.id_sprint  = s.id_sprint
LEFT JOIN Execucao_Teste et  ON et.id_caso    = ct.id_caso
LEFT JOIN Defeito d          ON d.id_sprint   = s.id_sprint
GROUP BY s.id_sprint, s.nome
ORDER BY s.id_sprint;
GO