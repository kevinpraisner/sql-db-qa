-- ================================================
-- 06_seed_defeitos.sql
-- Dados fictícios: defeitos encontrados nas execuções
-- ================================================

USE QA_Portfolio;
GO

SET DATEFORMAT ymd;

INSERT INTO Defeito (id_execucao, id_sprint, id_componente, id_usuario, id_status, id_severidade, titulo, descricao, data_abertura, data_fechamento, ambiente_encontrado, escaped) VALUES

-- Sprint 2
(6,  2, 2, 1, 1, 3,
 'Dashboard não atualiza após 30s em Firefox',
 'O polling de atualização automática falha especificamente no Firefox 122. Chrome e Edge funcionam normalmente.',
 '2025-01-29 09:35:00', NULL, 'QA', 0),

-- Sprint 3
(9,  3, 3, 2, 2, 2,
 'Filtro de contratos ignora status Suspenso',
 'Ao filtrar por status Ativo, contratos com status Suspenso também aparecem na listagem.',
 '2025-02-12 09:25:00', NULL, 'QA', 0),

(10, 3, 3, 1, 1, 1,
 'Download de PDF bloqueia thread principal',
 'A geração do PDF é síncrona e bloqueia toda a aplicação por até 8s em contratos longos. Causa timeout em produção.',
 '2025-02-12 10:05:00', NULL, 'QA', 0),

-- Sprint 4
(11, 4, 4, 2, 3, 2,
 'Notificação de vencimento enviada com dados do contrato errado',
 'O e-mail de alerta exibe o número e valor de um contrato diferente do que está vencendo.',
 '2025-02-26 09:10:00', NULL, 'QA', 0),

-- Defeito escapado - encontrado em produção
(NULL, 3, 3, 1, 4, 1,
 'Contrato excluído ainda aparece na listagem após reload',
 'Após exclusão de contrato, o registro continua visível até que o cache do servidor expire (~10min). Reportado por cliente em produção.',
 '2025-02-20 14:00:00', '2025-02-21 11:00:00', 'Produção', 1),

-- Sprint 5
(15, 5, 5, 1, 1, 2,
 'Relatório com 10k registros estoura timeout de 3s',
 'A query de exportação não utiliza paginação nem índice no campo data_contrato. Execution plan mostra full table scan.',
 '2025-03-12 10:10:00', NULL, 'QA', 0),

-- Outro defeito escapado
(NULL, 4, 4, 2, 4, 2,
 'E-mail de notificação enviado em duplicidade no domingo',
 'O job de notificações executa duas vezes aos domingos por conflito de timezone no agendador. Reportado por clientes.',
 '2025-03-01 08:00:00', '2025-03-03 16:00:00', 'Produção', 1);
GO

PRINT 'Defeitos inseridos com sucesso.';