-- ================================================
-- before_index.sql
-- Query sem índice otimizado — full scan
-- Execute com Ctrl+M ativado para ver o Execution Plan
-- ================================================

USE QA_Portfolio;
GO

-- Ativa exibição do Execution Plan
-- No SSMS: Query > Include Actual Execution Plan (Ctrl+M)

-- Desabilita índice existente para simular cenário sem otimização
ALTER INDEX IX_Defeito_Sprint ON Defeito DISABLE;
GO

-- Query de análise sem índice
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