-- ================================================
-- 04_seed_casos.sql
-- Dados fictícios: casos de teste por sprint
-- ================================================

USE QA_Portfolio;
GO

INSERT INTO Caso_Teste (id_sprint, titulo, precondições, passos, resultado_esperado, prioridade, tipo) VALUES
-- Sprint 1 - Autenticação
(1, 'Login com credenciais válidas',
    'Usuário cadastrado e ativo no sistema',
    '1. Acessar /login 2. Informar email e senha válidos 3. Clicar em Entrar',
    'Usuário redirecionado ao dashboard com sessão iniciada',
    'Alta', 'Funcional'),
(1, 'Login com senha incorreta',
    'Usuário cadastrado no sistema',
    '1. Acessar /login 2. Informar email válido e senha errada 3. Clicar em Entrar',
    'Mensagem de erro exibida, acesso negado',
    'Alta', 'Funcional'),
(1, 'Logout encerra sessão corretamente',
    'Usuário autenticado',
    '1. Clicar no menu do usuário 2. Selecionar Sair',
    'Sessão encerrada e redirecionamento para /login',
    'Alta', 'Funcional'),
(1, 'Smoke: páginas principais carregam sem erro 500',
    'Ambiente QA disponível',
    '1. Acessar /login /dashboard /contratos /relatorios',
    'Todas as páginas retornam HTTP 200',
    'Alta', 'Smoke'),

-- Sprint 2 - Dashboard
(2, 'Dashboard exibe resumo de contratos ativos',
    'Usuário autenticado com contratos vinculados',
    '1. Acessar /dashboard 2. Verificar card de contratos ativos',
    'Número de contratos ativos exibido corretamente',
    'Alta', 'Funcional'),
(2, 'Dashboard atualiza dados sem recarregar página',
    'Usuário autenticado',
    '1. Acessar /dashboard 2. Aguardar 30s 3. Verificar atualização automática',
    'Dados atualizados via polling sem reload completo',
    'Média', 'Funcional'),
(2, 'Regressão: login ainda funciona após deploy do dashboard',
    'Build do sprint 2 deployado em QA',
    '1. Repetir casos de login da Sprint 1',
    'Comportamento idêntico ao sprint anterior',
    'Alta', 'Regressão'),

-- Sprint 3 - Contratos
(3, 'Listagem de contratos exibe todos os registros do usuário',
    'Usuário com 3 ou mais contratos cadastrados',
    '1. Acessar /contratos 2. Verificar lista',
    'Todos os contratos do usuário listados com status correto',
    'Alta', 'Funcional'),
(3, 'Filtro por status de contrato funciona corretamente',
    'Usuário com contratos em status variados',
    '1. Acessar /contratos 2. Aplicar filtro Ativo 3. Verificar resultado',
    'Apenas contratos ativos exibidos',
    'Média', 'Funcional'),
(3, 'Download de contrato em PDF gera arquivo válido',
    'Usuário com contrato assinado',
    '1. Acessar /contratos 2. Clicar em Download PDF',
    'Arquivo PDF gerado e baixado corretamente',
    'Alta', 'Funcional'),

-- Sprint 4 - Notificações
(4, 'Usuário recebe notificação ao vencer contrato',
    'Contrato com vencimento em 7 dias cadastrado',
    '1. Aguardar job de notificação 2. Verificar inbox do usuário',
    'E-mail de alerta recebido com dados corretos do contrato',
    'Alta', 'Funcional'),
(4, 'Notificação não é enviada em duplicidade',
    'Job de notificação executado duas vezes seguidas',
    '1. Executar job manualmente 2. Executar novamente',
    'Apenas um e-mail enviado por evento',
    'Alta', 'Funcional'),

-- Sprint 5 - Relatórios
(5, 'Relatório de contratos exporta dados corretos em XLSX',
    'Usuário com contratos cadastrados',
    '1. Acessar /relatorios 2. Selecionar período 3. Exportar XLSX',
    'Arquivo XLSX gerado com dados correspondentes ao filtro',
    'Alta', 'Funcional'),
(5, 'Relatório com filtro de data respeita intervalo selecionado',
    'Contratos em datas variadas cadastrados',
    '1. Acessar /relatorios 2. Filtrar Jan-Mar 2025 3. Verificar registros',
    'Apenas contratos do período exibidos',
    'Média', 'Funcional'),
(5, 'Performance: relatório com 10k registros carrega em menos de 3s',
    'Base populada com 10.000 contratos',
    '1. Acessar /relatorios 2. Exportar sem filtro 3. Medir tempo',
    'Exportação concluída em até 3 segundos',
    'Alta', 'Performance');
GO

PRINT 'Casos de teste inseridos com sucesso.';