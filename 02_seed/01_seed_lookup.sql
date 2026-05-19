-- ================================================
-- 01_seed_lookup.sql
-- Dados de domínio: severidade, status e ambientes
-- ================================================

USE QA_Portfolio;
GO

-- Severidade
INSERT INTO Severidade (nome, nivel) VALUES
    ('Crítico',  1),
    ('Alto',     2),
    ('Médio',    3),
    ('Baixo',    4);
GO

-- Status de Defeito
INSERT INTO Status_Defeito (nome, cor_hex) VALUES
    ('Aberto',      '#FF4444'),
    ('Em Análise',  '#FFA500'),
    ('Em Correção', '#1E90FF'),
    ('Resolvido',   '#32CD32'),
    ('Fechado',     '#808080'),
    ('Reaberto',    '#FF6347');
GO

-- Ambientes
INSERT INTO Ambiente (nome, descricao, url_base) VALUES
    ('Desenvolvimento', 'Ambiente local dos devs',            'http://localhost:3000'),
    ('QA',              'Ambiente dedicado a testes',         'https://qa.app.internal'),
    ('Homologação',     'Ambiente de validação com cliente',  'https://hml.app.internal'),
    ('Produção',        'Ambiente live',                      'https://app.empresa.com');
GO

-- Usuários
INSERT INTO Usuario (nome, email, papel) VALUES
    ('Kevin Praisner',  'kevin@empresa.com',   'QA'),
    ('Ana Lima',        'ana@empresa.com',     'QA'),
    ('Bruno Teixeira',  'bruno@empresa.com',   'Dev'),
    ('Carla Mendes',    'carla@empresa.com',   'Dev'),
    ('Diego Souza',     'diego@empresa.com',   'PO'),
    ('Fernanda Costa',  'fernanda@empresa.com','SM');
GO

PRINT 'Dados de domínio inseridos com sucesso.';