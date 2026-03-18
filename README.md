# Análise de Dados — Clínica Médica

Pipeline de análise de dados e automação desenvolvido como projeto de portfólio.  
Demonstra integração entre Python (ETL), SQL (análise) e Power BI (visualização).

---

## Contexto do Projeto

Uma clínica médica em Manaus/AM possui registros mensais de agendamentos em planilhas
manuais. O objetivo deste projeto é automatizar a consolidação desses dados e gerar
relatórios visuais com indicadores de desempenho (KPIs) para apoiar a gestão.

---

## Tecnologias Utilizadas

| Ferramenta | Finalidade |
|---|---|
| Python 3.x + pandas | Ingestão, limpeza e transformação dos dados |
| openpyxl | Exportação de relatório Excel formatado |
| SQLite / SQL | Queries analíticas e criação de views |
| Power BI Desktop | Dashboard interativo com KPIs |

---

## Estrutura do Repositório

```
projeto_clinica/
│
├── data/
│   ├── atendimentos.csv       # Dataset principal (500 registros)
│   └── medicos.csv            # Tabela dimensão de médicos
│
├── scripts/
│   ├── gerar_dataset.py       # Gerador do dataset sintético
│   └── pipeline_etl.py        # Pipeline principal: ETL + exportação Excel
│
├── sql/
│   └── queries_analise.sql    # 5 queries + 1 VIEW + stored procedure
│
├── outputs/
│   └── relatorio_clinica.xlsx # Relatório gerado automaticamente
│
└── README.md
```

---

## Como Executar

**Pré-requisitos:**
```bash
pip install pandas openpyxl
```

**Passo 1 — Gerar o dataset:**
```bash
python scripts/gerar_dataset.py
```

**Passo 2 — Executar o pipeline:**
```bash
python scripts/pipeline_etl.py
```

O arquivo `outputs/relatorio_clinica.xlsx` será gerado com 6 abas formatadas.

---

## KPIs Gerados

| Indicador | Valor |
|---|---|
| Total de Agendamentos | 500 |
| Atendimentos Realizados | 354 |
| Taxa de Realização | 70,8% |
| Receita Total | R$ 92.617,04 |
| Ticket Médio | R$ 261,63 |

---

## Queries SQL — Resumo

| # | Query | Objetivo |
|---|---|---|
| 1 | KPIs Gerais | Visão executiva consolidada |
| 2 | Por Especialidade | Receita e volume por área médica |
| 3 | Ranking de Médicos | Produtividade individual (com JOIN) |
| 4 | Evolução Mensal | Sazonalidade e tendência de receita |
| 5 | Cancelamentos por Convênio | Taxa de perda por operadora |

---

## Dashboard Power BI

O arquivo `outputs/relatorio_clinica.xlsx` pode ser importado diretamente no
Power BI Desktop para construção do dashboard. Veja o guia em `powerbi/guia_dashboard.md`.

---

## Principais Insights

1. **Cardiologia** é a especialidade de maior receita (R$ 26.229), apesar de não ser
   a de maior volume — o ticket médio é 2,8x superior à Clínica Geral.

2. **SulAmérica** apresenta a maior taxa de perda (cancelamentos + faltas): 24,5%.
   Unimed e Hapvida têm as menores taxas (< 14%).

3. A **taxa de realização geral** de 70,8% indica espaço para melhoria na confirmação
   de agendamentos — automatizar lembretes por WhatsApp/SMS pode recuperar receita.

---

## Autor

Adriano — Consultor de Dados | Manaus, AM  
[LinkedIn](#) · [GitHub](#)
