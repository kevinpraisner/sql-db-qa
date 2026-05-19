-- ================================================
-- 02_stored_procedures.sql
-- Procedures com tratamento de erro e transações
-- ================================================

USE QA_Portfolio;
GO

-- ========================
-- 1. Registra execução de teste e abre defeito automaticamente se falhou
-- ========================
CREATE OR ALTER PROCEDURE sp_registrar_execucao
    @id_caso        INT,
    @id_usuario     INT,
    @id_ambiente    INT,
    @resultado      VARCHAR(10),
    @duracao_seg    INT          = NULL,
    @evidencias_url VARCHAR(500) = NULL,
    @titulo_defeito VARCHAR(200) = NULL,
    @desc_defeito   TEXT         = NULL,
    @id_severidade  INT          = 3       -- padrão: Médio
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- Valida resultado
            IF @resultado NOT IN ('Passou','Falhou','Bloqueado','N/A')
                THROW 50001, 'Resultado inválido. Use: Passou, Falhou, Bloqueado ou N/A.', 1;

            -- Insere execução
            INSERT INTO Execucao_Teste
                (id_caso, id_usuario, id_ambiente, resultado, duracao_seg, evidencias_url)
            VALUES
                (@id_caso, @id_usuario, @id_ambiente, @resultado, @duracao_seg, @evidencias_url);

            DECLARE @id_execucao INT = SCOPE_IDENTITY();

            -- Busca sprint do caso
            DECLARE @id_sprint INT;
            SELECT @id_sprint = id_sprint FROM Caso_Teste WHERE id_caso = @id_caso;

            -- Se falhou e título informado, abre defeito automaticamente
            IF @resultado = 'Falhou' AND @titulo_defeito IS NOT NULL
            BEGIN
                INSERT INTO Defeito
                    (id_execucao, id_sprint, id_usuario, id_status, id_severidade, titulo, descricao, escaped)
                VALUES
                    (@id_execucao, @id_sprint, @id_usuario, 1, @id_severidade, @titulo_defeito, @desc_defeito, 0);

                PRINT 'Execução registrada e defeito aberto automaticamente.';
            END
            ELSE
                PRINT 'Execução registrada com sucesso.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Erro: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

-- ========================
-- 2. Fecha defeito com validação de status
-- ========================
CREATE OR ALTER PROCEDURE sp_fechar_defeito
    @id_defeito  INT,
    @id_usuario  INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

            DECLARE @status_atual VARCHAR(30);
            SELECT @status_atual = sd.nome
            FROM Defeito d
            INNER JOIN Status_Defeito sd ON sd.id_status = d.id_status
            WHERE d.id_defeito = @id_defeito;

            IF @status_atual IS NULL
                THROW 50002, 'Defeito não encontrado.', 1;

            IF @status_atual = 'Fechado'
                THROW 50003, 'Defeito já está fechado.', 1;

            -- Status 5 = Fechado
            UPDATE Defeito
            SET id_status       = 5,
                data_fechamento = GETDATE()
            WHERE id_defeito    = @id_defeito;

            PRINT 'Defeito ' + CAST(@id_defeito AS VARCHAR) + ' fechado com sucesso.';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Erro: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

PRINT 'Stored procedures criadas com sucesso.';