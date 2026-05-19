-- ================================================
-- 04_triggers.sql
-- Trigger de auditoria automática em defeitos
-- Registra toda alteração de status em log
-- ================================================

USE QA_Portfolio;
GO

-- Tabela de auditoria
CREATE TABLE Audit_Defeito (
    id_audit        INT           PRIMARY KEY IDENTITY(1,1),
    id_defeito      INT           NOT NULL,
    campo_alterado  VARCHAR(50)   NOT NULL,
    valor_anterior  VARCHAR(200)  NULL,
    valor_novo      VARCHAR(200)  NULL,
    data_alteracao  DATETIME      NOT NULL DEFAULT GETDATE(),
    usuario_sistema VARCHAR(100)  NOT NULL DEFAULT SYSTEM_USER
);
GO

-- Trigger: dispara após UPDATE em Defeito
CREATE OR ALTER TRIGGER trg_audit_defeito
ON Defeito
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Auditoria de mudança de status
    IF UPDATE(id_status)
    BEGIN
        INSERT INTO Audit_Defeito (id_defeito, campo_alterado, valor_anterior, valor_novo)
        SELECT
            i.id_defeito,
            'status',
            sd_old.nome,
            sd_new.nome
        FROM inserted i
        INNER JOIN deleted d          ON d.id_defeito   = i.id_defeito
        INNER JOIN Status_Defeito sd_old ON sd_old.id_status = d.id_status
        INNER JOIN Status_Defeito sd_new ON sd_new.id_status = i.id_status
        WHERE d.id_status <> i.id_status;
    END

    -- Auditoria de mudança de severidade
    IF UPDATE(id_severidade)
    BEGIN
        INSERT INTO Audit_Defeito (id_defeito, campo_alterado, valor_anterior, valor_novo)
        SELECT
            i.id_defeito,
            'severidade',
            sv_old.nome,
            sv_new.nome
        FROM inserted i
        INNER JOIN deleted d              ON d.id_defeito      = i.id_defeito
        INNER JOIN Severidade sv_old      ON sv_old.id_severidade = d.id_severidade
        INNER JOIN Severidade sv_new      ON sv_new.id_severidade = i.id_severidade
        WHERE d.id_severidade <> i.id_severidade;
    END

    -- Auditoria de escaped
    IF UPDATE(escaped)
    BEGIN
        INSERT INTO Audit_Defeito (id_defeito, campo_alterado, valor_anterior, valor_novo)
        SELECT
            i.id_defeito,
            'escaped',
            CAST(d.escaped AS VARCHAR),
            CAST(i.escaped AS VARCHAR)
        FROM inserted i
        INNER JOIN deleted d ON d.id_defeito = i.id_defeito
        WHERE d.escaped <> i.escaped;
    END
END;
GO

PRINT 'Trigger e tabela de auditoria criados com sucesso.';

------------------------------------------------------------------------------

USE QA_Portfolio;

-- Altera status do defeito 2 para "Em Correção"
UPDATE Defeito SET id_status = 3 WHERE id_defeito = 2;

-- Altera severidade do defeito 3 para "Crítico"
UPDATE Defeito SET id_severidade = 1 WHERE id_defeito = 3;

-- Consulta o log gerado automaticamente
SELECT * FROM Audit_Defeito ORDER BY data_alteracao;