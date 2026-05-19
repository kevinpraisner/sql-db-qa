-- ================================================
-- 01_views.sql
-- Views analíticas para consulta rápida
-- ================================================

USE QA_Portfolio;
GO

-- ========================
-- 1. Dashboard por Sprint
-- Resumo executivo de qualidade por sprint
-- ========================
CREATE OR ALTER VIEW vw_dashboard_sprint AS
SELECT
    s.nome                                              AS sprint,
    p.nome                                              AS projeto,
    COUNT(DISTINCT ct.id_caso)                          AS total_casos,
    COUNT(DISTINCT et.id_execucao)                      AS total_execucoes,
    SUM(CASE WHEN et.resultado = 'Passou'    THEN 1 ELSE 0 END) AS passou,
    SUM(CASE WHEN et.resultado = 'Falhou'    THEN 1 ELSE 0 END) AS falhou,
    SUM(CASE WHEN et.resultado = 'Bloqueado' THEN 1 ELSE 0 END) AS bloqueado,
    COUNT(DISTINCT d.id_defeito)                        AS total_defeitos,
    SUM(CASE WHEN d.escaped = 1 THEN 1 ELSE 0 END)     AS defeitos_escapados,
    -- Taxa de aprovação
    ROUND(
        100.0 * SUM(CASE WHEN et.resultado = 'Passou' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(et.id_execucao), 0), 1
    )                                                   AS taxa_aprovacao_pct
FROM Sprint s
INNER JOIN Projeto p        ON p.id_projeto  = s.id_projeto
LEFT  JOIN Caso_Teste ct    ON ct.id_sprint  = s.id_sprint
LEFT  JOIN Execucao_Teste et ON et.id_caso   = ct.id_caso
LEFT  JOIN Defeito d        ON d.id_sprint   = s.id_sprint
GROUP BY s.id_sprint, s.nome, p.nome;
GO

-- ========================
-- 2. Defeitos em Aberto
-- Lista operacional para o time de QA
-- ========================
CREATE OR ALTER VIEW vw_defeitos_abertos AS
SELECT
    d.id_defeito,
    s.nome                  AS sprint,
    c.nome                  AS componente,
    sv.nome                 AS severidade,
    sv.nivel                AS nivel_severidade,
    sd.nome                 AS status,
    d.titulo,
    d.ambiente_encontrado,
    d.data_abertura,
    DATEDIFF(DAY, d.data_abertura, GETDATE()) AS dias_aberto,
    u.nome                  AS reportado_por,
    d.escaped
FROM Defeito d
INNER JOIN Sprint s         ON s.id_sprint      = d.id_sprint
LEFT  JOIN Componente c     ON c.id_componente  = d.id_componente
INNER JOIN Severidade sv    ON sv.id_severidade = d.id_severidade
INNER JOIN Status_Defeito sd ON sd.id_status    = d.id_status
INNER JOIN Usuario u        ON u.id_usuario     = d.id_usuario
WHERE sd.nome NOT IN ('Fechado', 'Resolvido');
GO

-- ========================
-- 3. Cobertura de Testes
-- Casos executados vs planejados por sprint
-- ========================
CREATE OR ALTER VIEW vw_cobertura_testes AS
SELECT
    s.nome                                          AS sprint,
    COUNT(DISTINCT ct.id_caso)                      AS casos_planejados,
    COUNT(DISTINCT et.id_caso)                      AS casos_executados,
    ROUND(
        100.0 * COUNT(DISTINCT et.id_caso)
        / NULLIF(COUNT(DISTINCT ct.id_caso), 0), 1
    )                                               AS cobertura_pct
FROM Sprint s
LEFT JOIN Caso_Teste ct     ON ct.id_sprint = s.id_sprint
LEFT JOIN Execucao_Teste et ON et.id_caso   = ct.id_caso
GROUP BY s.id_sprint, s.nome;
GO

PRINT 'Views criadas com sucesso.';