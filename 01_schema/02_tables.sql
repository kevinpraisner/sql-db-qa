-- ================================================
-- 02_tables.sql
-- Criação de todas as tabelas do banco QA_Portfolio
-- Ordem respeitando dependências de FK
-- ================================================

USE QA_Portfolio;
GO

-- ========================
-- TABELAS DE DOMÍNIO (lookup)
-- ========================

CREATE TABLE Severidade (
    id_severidade   INT           PRIMARY KEY IDENTITY(1,1),
    nome            VARCHAR(30)   NOT NULL,
    nivel           INT           NOT NULL,  -- 1=Crítico, 2=Alto, 3=Médio, 4=Baixo
    CONSTRAINT uq_severidade_nome UNIQUE (nome)
);
GO

CREATE TABLE Status_Defeito (
    id_status   INT           PRIMARY KEY IDENTITY(1,1),
    nome        VARCHAR(30)   NOT NULL,
    cor_hex     CHAR(7)       NULL,          -- ex: '#FF4444'
    CONSTRAINT uq_status_nome UNIQUE (nome)
);
GO

CREATE TABLE Ambiente (
    id_ambiente   INT           PRIMARY KEY IDENTITY(1,1),
    nome          VARCHAR(50)   NOT NULL,
    descricao     VARCHAR(200)  NULL,
    url_base      VARCHAR(255)  NULL,
    CONSTRAINT uq_ambiente_nome UNIQUE (nome)
);
GO

-- ========================
-- USUÁRIOS
-- ========================

CREATE TABLE Usuario (
    id_usuario   INT           PRIMARY KEY IDENTITY(1,1),
    nome         VARCHAR(100)  NOT NULL,
    email        VARCHAR(150)  NOT NULL,
    papel        VARCHAR(30)   NOT NULL      -- 'QA', 'Dev', 'PO', 'SM'
        CONSTRAINT chk_usuario_papel CHECK (papel IN ('QA','Dev','PO','SM')),
    ativo        BIT           NOT NULL DEFAULT 1,
    CONSTRAINT uq_usuario_email UNIQUE (email)
);
GO

-- ========================
-- PROJETO E SPRINT
-- ========================

CREATE TABLE Projeto (
    id_projeto          INT           PRIMARY KEY IDENTITY(1,1),
    nome                VARCHAR(100)  NOT NULL,
    descricao           VARCHAR(500)  NULL,
    data_inicio         DATE          NOT NULL,
    data_fim_prevista   DATE          NULL,
    status              VARCHAR(20)   NOT NULL DEFAULT 'Ativo'
        CONSTRAINT chk_projeto_status CHECK (status IN ('Ativo','Pausado','Encerrado'))
);
GO

CREATE TABLE Sprint (
    id_sprint               INT           PRIMARY KEY IDENTITY(1,1),
    id_projeto              INT           NOT NULL,
    nome                    VARCHAR(50)   NOT NULL,
    data_inicio             DATE          NOT NULL,
    data_fim                DATE          NOT NULL,
    velocidade_planejada    INT           NULL,
    CONSTRAINT fk_sprint_projeto FOREIGN KEY (id_projeto) REFERENCES Projeto(id_projeto),
    CONSTRAINT chk_sprint_datas  CHECK (data_fim > data_inicio)
);
GO

CREATE TABLE Componente (
    id_componente   INT           PRIMARY KEY IDENTITY(1,1),
    id_projeto      INT           NOT NULL,
    nome            VARCHAR(100)  NOT NULL,
    responsavel     VARCHAR(100)  NULL,
    CONSTRAINT fk_componente_projeto FOREIGN KEY (id_projeto) REFERENCES Projeto(id_projeto)
);
GO

-- ========================
-- CASOS DE TESTE
-- ========================

CREATE TABLE Caso_Teste (
    id_caso             INT           PRIMARY KEY IDENTITY(1,1),
    id_sprint           INT           NOT NULL,
    titulo              VARCHAR(200)  NOT NULL,
    precondições        VARCHAR(500)  NULL,
    passos              TEXT          NOT NULL,
    resultado_esperado  VARCHAR(500)  NOT NULL,
    prioridade          VARCHAR(10)   NOT NULL DEFAULT 'Média'
        CONSTRAINT chk_caso_prioridade CHECK (prioridade IN ('Alta','Média','Baixa')),
    tipo                VARCHAR(20)   NOT NULL DEFAULT 'Funcional'
        CONSTRAINT chk_caso_tipo CHECK (tipo IN ('Funcional','Regressão','Smoke','Performance','Segurança')),
    CONSTRAINT fk_caso_sprint FOREIGN KEY (id_sprint) REFERENCES Sprint(id_sprint)
);
GO

-- ========================
-- EXECUÇÕES DE TESTE
-- ========================

CREATE TABLE Execucao_Teste (
    id_execucao      INT           PRIMARY KEY IDENTITY(1,1),
    id_caso          INT           NOT NULL,
    id_usuario       INT           NOT NULL,
    id_ambiente      INT           NOT NULL,
    data_execucao    DATETIME      NOT NULL DEFAULT GETDATE(),
    resultado        VARCHAR(10)   NOT NULL
        CONSTRAINT chk_execucao_resultado CHECK (resultado IN ('Passou','Falhou','Bloqueado','N/A')),
    duracao_seg      INT           NULL,
    evidencias_url   VARCHAR(500)  NULL,
    CONSTRAINT fk_execucao_caso     FOREIGN KEY (id_caso)     REFERENCES Caso_Teste(id_caso),
    CONSTRAINT fk_execucao_usuario  FOREIGN KEY (id_usuario)  REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_execucao_ambiente FOREIGN KEY (id_ambiente) REFERENCES Ambiente(id_ambiente)
);
GO

-- ========================
-- DEFEITOS
-- ========================

CREATE TABLE Defeito (
    id_defeito          INT           PRIMARY KEY IDENTITY(1,1),
    id_execucao         INT           NULL,       -- NULL se reportado fora de execução formal
    id_sprint           INT           NOT NULL,
    id_componente       INT           NULL,
    id_usuario          INT           NOT NULL,   -- quem reportou
    id_status           INT           NOT NULL,
    id_severidade       INT           NOT NULL,
    titulo              VARCHAR(200)  NOT NULL,
    descricao           TEXT          NULL,
    data_abertura       DATETIME      NOT NULL DEFAULT GETDATE(),
    data_fechamento     DATETIME      NULL,
    ambiente_encontrado VARCHAR(50)   NULL,
    escaped             BIT           NOT NULL DEFAULT 0,  -- 1 = defeito escapou para produção
    CONSTRAINT fk_defeito_execucao   FOREIGN KEY (id_execucao)   REFERENCES Execucao_Teste(id_execucao),
    CONSTRAINT fk_defeito_sprint     FOREIGN KEY (id_sprint)      REFERENCES Sprint(id_sprint),
    CONSTRAINT fk_defeito_componente FOREIGN KEY (id_componente)  REFERENCES Componente(id_componente),
    CONSTRAINT fk_defeito_usuario    FOREIGN KEY (id_usuario)     REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_defeito_status     FOREIGN KEY (id_status)      REFERENCES Status_Defeito(id_status),
    CONSTRAINT fk_defeito_severidade FOREIGN KEY (id_severidade)  REFERENCES Severidade(id_severidade)
);
GO

PRINT 'Todas as tabelas criadas com sucesso.';