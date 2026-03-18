-- ============================================================
-- queries_analise.sql
-- Projeto: Análise de Dados — Clínica Médica
-- Autor: Adriano | Portfólio Sidia
-- Banco: SQLite / PostgreSQL / MySQL (sintaxe compatível)
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- SETUP: Criação das tabelas
-- (executar antes das queries de análise)
-- ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS atendimentos (
    id_atendimento     INTEGER PRIMARY KEY,
    data_agendamento   DATE,
    mes                INTEGER,
    dia_semana         VARCHAR(20),
    medico             VARCHAR(60),
    especialidade      VARCHAR(50),
    convenio           VARCHAR(50),
    bairro_paciente    VARCHAR(50),
    status             VARCHAR(20),
    duracao_minutos    INTEGER,
    valor_cobrado      DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS medicos (
    medico                  VARCHAR(60) PRIMARY KEY,
    especialidade           VARCHAR(50),
    carga_horaria_semanal   INTEGER,
    anos_experiencia        INTEGER
);

-- ────────────────────────────────────────────────────────────
-- QUERY 1 — KPIs Gerais da Clínica
-- Objetivo: visão executiva dos principais indicadores
-- ────────────────────────────────────────────────────────────

SELECT
    COUNT(*)                                               AS total_agendamentos,
    SUM(CASE WHEN status = 'Realizado' THEN 1 ELSE 0 END) AS total_realizados,
    ROUND(
        SUM(CASE WHEN status = 'Realizado' THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1
    )                                                      AS taxa_realizacao_pct,
    ROUND(SUM(valor_cobrado), 2)                           AS receita_total,
    ROUND(AVG(CASE WHEN status = 'Realizado'
              THEN valor_cobrado END), 2)                  AS ticket_medio
FROM atendimentos;


-- ────────────────────────────────────────────────────────────
-- QUERY 2 — Receita e Volume por Especialidade
-- Objetivo: identificar especialidades mais rentáveis
-- ────────────────────────────────────────────────────────────

SELECT
    especialidade,
    COUNT(*)                        AS atendimentos,
    ROUND(SUM(valor_cobrado), 2)    AS receita_total,
    ROUND(AVG(valor_cobrado), 2)    AS ticket_medio
FROM atendimentos
WHERE status = 'Realizado'
GROUP BY especialidade
ORDER BY receita_total DESC;


-- ────────────────────────────────────────────────────────────
-- QUERY 3 — Ranking de Médicos por Produtividade
-- Objetivo: comparar volume de atendimentos e receita gerada
-- ────────────────────────────────────────────────────────────

SELECT
    a.medico,
    m.anos_experiencia,
    COUNT(*)                        AS atendimentos_realizados,
    ROUND(SUM(a.valor_cobrado), 2)  AS receita_gerada,
    ROUND(AVG(a.duracao_minutos), 0) AS duracao_media_min
FROM atendimentos a
INNER JOIN medicos m ON a.medico = m.medico
WHERE a.status = 'Realizado'
GROUP BY a.medico, m.anos_experiencia
ORDER BY atendimentos_realizados DESC;


-- ────────────────────────────────────────────────────────────
-- QUERY 4 — Evolução Mensal de Receita
-- Objetivo: identificar sazonalidade ao longo do ano
-- ────────────────────────────────────────────────────────────

SELECT
    mes,
    COUNT(*)                        AS atendimentos,
    ROUND(SUM(valor_cobrado), 2)    AS receita_mensal,
    ROUND(AVG(valor_cobrado), 2)    AS ticket_medio_mes
FROM atendimentos
WHERE status = 'Realizado'
GROUP BY mes
ORDER BY mes;


-- ────────────────────────────────────────────────────────────
-- QUERY 5 — Análise de Cancelamentos e Faltas por Convênio
-- Objetivo: identificar convênios com maior índice de perda
-- ────────────────────────────────────────────────────────────

SELECT
    convenio,
    COUNT(*)                                                    AS total_agendamentos,
    SUM(CASE WHEN status = 'Cancelado' THEN 1 ELSE 0 END)       AS cancelamentos,
    SUM(CASE WHEN status = 'Faltou'    THEN 1 ELSE 0 END)       AS faltas,
    ROUND(
        (SUM(CASE WHEN status IN ('Cancelado','Faltou') THEN 1.0 ELSE 0 END)
         / COUNT(*)) * 100, 1
    )                                                           AS taxa_perda_pct
FROM atendimentos
GROUP BY convenio
ORDER BY taxa_perda_pct DESC;


-- ────────────────────────────────────────────────────────────
-- VIEW — v_resumo_mensal
-- Objeto reutilizável para dashboards e relatórios
-- ────────────────────────────────────────────────────────────

CREATE VIEW IF NOT EXISTS v_resumo_mensal AS
SELECT
    mes,
    especialidade,
    COUNT(*)                        AS atendimentos,
    ROUND(SUM(valor_cobrado), 2)    AS receita
FROM atendimentos
WHERE status = 'Realizado'
GROUP BY mes, especialidade;

-- Uso da view:
-- SELECT * FROM v_resumo_mensal WHERE especialidade = 'Cardiologia';


-- ────────────────────────────────────────────────────────────
-- STORED PROCEDURE (sintaxe PostgreSQL)
-- Objetivo: atualizar status de um atendimento com log
-- ────────────────────────────────────────────────────────────

/*
CREATE OR REPLACE PROCEDURE atualizar_status_atendimento(
    p_id        INTEGER,
    p_novo_status VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE atendimentos
    SET status = p_novo_status
    WHERE id_atendimento = p_id;

    RAISE NOTICE 'Atendimento % atualizado para status: %', p_id, p_novo_status;
END;
$$;

-- Chamada: CALL atualizar_status_atendimento(42, 'Remarcado');
*/
