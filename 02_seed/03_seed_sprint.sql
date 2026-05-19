-- ================================================
-- 03_seed_sprint.sql
-- Dados fictícios: sprints do projeto
-- ================================================

USE QA_Portfolio;
GO

INSERT INTO Sprint (id_projeto, nome, data_inicio, data_fim, velocidade_planejada) VALUES
    (1, 'Sprint 01', '2025-01-06', '2025-01-17', 40),
    (1, 'Sprint 02', '2025-01-20', '2025-01-31', 42),
    (1, 'Sprint 03', '2025-02-03', '2025-02-14', 38),
    (1, 'Sprint 04', '2025-02-17', '2025-02-28', 45),
    (1, 'Sprint 05', '2025-03-03', '2025-03-14', 43),
    (1, 'Sprint 06', '2025-03-17', '2025-03-28', 50),
    (1, 'Sprint 07', '2025-03-31', '2025-04-11', 48),
    (1, 'Sprint 08', '2025-04-14', '2025-04-25', 46);
GO

PRINT 'Sprints inseridas com sucesso.';