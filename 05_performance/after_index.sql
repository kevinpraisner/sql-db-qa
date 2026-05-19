-- ================================================
-- after_index.sql
-- Mesma query com índice habilitado — Index Seek
-- Compare o Execution Plan com o before_index
-- ================================================

USE QA_Portfolio;
GO

-- Reabilita o índice
ALTER INDEX IX_Defeito_Sprint ON Defeito REBUILD;
GO

-- Mesma query agora com índice ativo
SELECT
    s.nome          AS sprint,
    sv.nome         AS severidade,
    COUNT(*)        AS total_defeitos,
    SUM(CASE WHEN d.escaped = 1 THEN 1 ELSE 0 END) AS escapados
FROM Defeito d
INNER JOIN Sprint s         ON s.id_sprint      = d.id_sprint
INNER JOIN Severidade sv    ON sv.id_severidade = d.id_severidade
GROUP BY s.nome, sv.nome
ORDER BY total_defeitos DESC;
GO