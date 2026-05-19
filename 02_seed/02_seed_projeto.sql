-- ================================================
-- 02_seed_projeto.sql
-- Dados fictícios: projeto e componentes
-- ================================================

USE QA_Portfolio;
GO

INSERT INTO Projeto (nome, descricao, data_inicio, data_fim_prevista, status) VALUES
    ('Portal do Cliente',
     'Plataforma web para autoatendimento e gestão de contratos',
     '2025-01-06', '2025-12-31', 'Ativo');
GO

INSERT INTO Componente (id_projeto, nome, responsavel) VALUES
    (1, 'Autenticação',       'Bruno Teixeira'),
    (1, 'Dashboard',          'Carla Mendes'),
    (1, 'Gestão de Contratos','Bruno Teixeira'),
    (1, 'Notificações',       'Carla Mendes'),
    (1, 'Relatórios',         'Bruno Teixeira');
GO

PRINT 'Projeto e componentes inseridos com sucesso.';