-- ================================================
-- 04_cobertura_testes.sql
-- Pergunta: Quais casos de teste nunca foram executados?
-- Técnicas: LEFT JOIN, IS NULL, subquery
-- ================================================

USE QA_Portfolio;
GO

-- Casos nunca executados
SELECT
    ct.id_caso,
    s.nome          AS sprint,
    ct.titulo,
    ct.prioridade,
    ct.tipo
FROM Caso_Teste ct
INNER JOIN Sprint s         ON s.id_sprint  = ct.id_sprint
LEFT  JOIN Execucao_Teste et ON et.id_caso  = ct.id_caso
WHERE et.id_execucao IS NULL
ORDER BY ct.prioridade, s.id_sprint;
GO

-- Resumo de cobertura por sprint
SELECT
    s.nome                                              AS sprint,
    COUNT(DISTINCT ct.id_caso)                          AS planejados,
    COUNT(DISTINCT et.id_caso)                          AS executados,
    COUNT(DISTINCT ct.id_caso)
        - COUNT(DISTINCT et.id_caso)                    AS nao_executados,
    ROUND(
        100.0 * COUNT(DISTINCT et.id_caso)
        / NULLIF(COUNT(DISTINCT ct.id_caso), 0), 1
    )                                                   AS cobertura_pct
FROM Sprint s
LEFT JOIN Caso_Teste ct      ON ct.id_sprint = s.id_sprint
LEFT JOIN Execucao_Teste et  ON et.id_caso   = ct.id_caso
GROUP BY s.id_sprint, s.nome
ORDER BY s.id_sprint;
GO