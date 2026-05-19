-- ================================================
-- 03_functions.sql
-- Funções escalares e de tabela para cálculos de QA
-- ================================================

USE QA_Portfolio;
GO

CREATE OR ALTER FUNCTION fn_cobertura_sprint (@id_sprint INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @planejados INT;
    DECLARE @executados INT;

    SELECT @planejados = COUNT(*)
    FROM Caso_Teste
    WHERE id_sprint = @id_sprint;

    SELECT @executados = COUNT(DISTINCT et.id_caso)
    FROM Execucao_Teste et
    INNER JOIN Caso_Teste ct ON ct.id_caso = et.id_caso
    WHERE ct.id_sprint = @id_sprint;

    RETURN CASE
        WHEN @planejados = 0 THEN 0
        ELSE ROUND(100.0 * @executados / @planejados, 2)
    END;
END;
GO

PRINT 'fn_cobertura_sprint corrigida.';

----------------------------------------------------------------

USE QA_Portfolio;

-- Defect escape rate por sprint
SELECT
    s.nome                              AS sprint,
    dbo.fn_defect_escape_rate(s.id_sprint) AS escape_rate_pct,
    dbo.fn_cobertura_sprint(s.id_sprint)   AS cobertura_pct
FROM Sprint s
ORDER BY s.id_sprint;

-- Histórico de execuções do caso 1
SELECT * FROM dbo.fn_historico_caso(1);