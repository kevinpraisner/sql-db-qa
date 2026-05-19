-- ================================================
-- 04_foreign_keys.sql
-- Documentação e validação das Foreign Keys
-- Use este script para verificar integridade
-- referencial do banco após qualquer alteração
-- ================================================

USE QA_Portfolio;
GO

-- Lista todas as FK do banco com tabelas de origem e destino
SELECT
    fk.name                                    AS foreign_key,
    tp.name                                    AS tabela_origem,
    cp.name                                    AS coluna_origem,
    tr.name                                    AS tabela_destino,
    cr.name                                    AS coluna_destino,
    fk.is_disabled                             AS desativada,
    fk.delete_referential_action_desc          AS acao_delete,
    fk.update_referential_action_desc          AS acao_update
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.tables  tp ON fkc.parent_object_id      = tp.object_id
INNER JOIN sys.columns cp ON fkc.parent_object_id      = cp.object_id
                          AND fkc.parent_column_id     = cp.column_id
INNER JOIN sys.tables  tr ON fkc.referenced_object_id  = tr.object_id
INNER JOIN sys.columns cr ON fkc.referenced_object_id  = cr.object_id
                          AND fkc.referenced_column_id = cr.column_id
ORDER BY tp.name, fk.name;
GO

PRINT 'Validação de Foreign Keys concluída.';