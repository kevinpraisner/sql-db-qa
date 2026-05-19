-- ================================================
-- 05_seed_execucoes.sql
-- Dados fictícios: execuções de teste
-- ================================================

USE QA_Portfolio;
GO

SET DATEFORMAT ymd;

-- Limpa execuções anteriores se houver
DELETE FROM Execucao_Teste;
GO

INSERT INTO Execucao_Teste (id_caso, id_usuario, id_ambiente, data_execucao, resultado, duracao_seg) VALUES
-- Sprint 1
(1,  1, 2, '2025-01-14 09:00:00', 'Passou',    45),
(2,  1, 2, '2025-01-14 09:10:00', 'Passou',    30),
(3,  1, 2, '2025-01-14 09:20:00', 'Passou',    25),
(4,  2, 2, '2025-01-14 10:00:00', 'Passou',    60),
-- Sprint 2
(5,  1, 2, '2025-01-29 09:00:00', 'Passou',    50),
(6,  2, 2, '2025-01-29 09:30:00', 'Falhou',    40),
(7,  1, 2, '2025-01-29 10:00:00', 'Passou',    90),
-- Sprint 3
(8,  1, 2, '2025-02-12 09:00:00', 'Passou',    55),
(9,  2, 2, '2025-02-12 09:20:00', 'Falhou',    35),
(10, 1, 2, '2025-02-12 10:00:00', 'Bloqueado', 20),
-- Sprint 4
(11, 2, 2, '2025-02-26 09:00:00', 'Falhou',    70),
(12, 1, 2, '2025-02-26 09:40:00', 'Passou',    45),
-- Sprint 5
(13, 1, 2, '2025-03-12 09:00:00', 'Passou',    80),
(14, 2, 2, '2025-03-12 09:30:00', 'Passou',    50),
(15, 1, 2, '2025-03-12 10:00:00', 'Falhou',   210);
GO

PRINT 'Execuções inseridas com sucesso.';