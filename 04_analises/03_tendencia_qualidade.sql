-- ================================================
-- 03_tendencia_qualidade.sql
-- Pergunta: A qualidade está melhorando ou piorando ao longo do tempo?
-- Técnicas: window functions, LAG, RANK
-- ================================================

USE QA_Portfolio;
GO

WITH base AS (
    SELECT
        s.id_sprint,
        s.nome                                                          AS sprint,
        COUNT(DISTINCT et.id_execucao)                                  AS total_execucoes,
        SUM(CASE WHEN et.resultado = 'Passou' THEN 1 ELSE 0 END)       AS passou,
        COUNT(DISTINCT d.id_defeito)                                    AS defeitos
    FROM Sprint s
    LEFT JOIN Caso_Teste ct     ON ct.id_sprint = s.id_sprint
    LEFT JOIN Execucao_Teste et ON et.id_caso   = ct.id_caso
    LEFT JOIN Defeito d         ON d.id_sprint  = s.id_sprint
    GROUP BY s.id_sprint, s.nome
),
com_taxa AS (
    SELECT
        id_sprint,
        sprint,
        total_execucoes,
        passou,
        defeitos,
        ROUND(100.0 * passou / NULLIF(total_execucoes, 0), 1)  AS taxa_aprovacao
    FROM base
)
SELECT
    sprint,
    total_execucoes,
    defeitos,
    taxa_aprovacao,
    -- Taxa da sprint anterior para comparação
    LAG(taxa_aprovacao) OVER (ORDER BY id_sprint)               AS taxa_sprint_anterior,
    -- Variação em pontos percentuais
    ROUND(
        taxa_aprovacao - LAG(taxa_aprovacao) OVER (ORDER BY id_sprint), 1
    )                                                           AS variacao_pp,
    -- Tendência
    CASE
        WHEN taxa_aprovacao > LAG(taxa_aprovacao) OVER (ORDER BY id_sprint) THEN 'Melhorando'
        WHEN taxa_aprovacao < LAG(taxa_aprovacao) OVER (ORDER BY id_sprint) THEN 'Piorando'
        WHEN taxa_aprovacao = LAG(taxa_aprovacao) OVER (ORDER BY id_sprint) THEN 'Estável'
        ELSE '-'
    END                                                         AS tendencia
FROM com_taxa
ORDER BY id_sprint;
GO