-- ================================================
-- 03_indexes.sql
-- Índices para otimização de consultas frequentes
--
-- Justificativas documentadas por index:
-- Queries de análise filtram muito por sprint, status
-- e severidade — campos mais consultados
-- nas views e relatórios analíticos.
-- ================================================

USE QA_Portfolio;
GO

-- Defeitos por sprint (query mais executada nas análises)
CREATE NONCLUSTERED INDEX IX_Defeito_Sprint
    ON Defeito (id_sprint)
    INCLUDE (id_status, id_severidade, escaped, data_abertura);
GO

-- Defeitos escapados (defect escape rate)
CREATE NONCLUSTERED INDEX IX_Defeito_Escaped
    ON Defeito (escaped, id_sprint)
    INCLUDE (id_severidade, data_fechamento);
GO

-- Execuções por caso de teste (cobertura e histórico)
CREATE NONCLUSTERED INDEX IX_Execucao_Caso
    ON Execucao_Teste (id_caso)
    INCLUDE (resultado, data_execucao, id_ambiente);
GO

-- Execuções por resultado (filtro de falhas)
CREATE NONCLUSTERED INDEX IX_Execucao_Resultado
    ON Execucao_Teste (resultado, id_ambiente)
    INCLUDE (id_caso, data_execucao, duracao_seg);
GO

-- Casos de teste por sprint
CREATE NONCLUSTERED INDEX IX_CasoTeste_Sprint
    ON Caso_Teste (id_sprint)
    INCLUDE (prioridade, tipo);
GO

-- Defeitos por componente (ranking de componentes problemáticos)
CREATE NONCLUSTERED INDEX IX_Defeito_Componente
    ON Defeito (id_componente)
    INCLUDE (id_sprint, id_severidade, escaped);
GO

PRINT 'Índices criados com sucesso.';
GO