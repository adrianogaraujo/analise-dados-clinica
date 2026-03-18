# Guia — Dashboard Power BI
## Projeto: Análise de Dados — Clínica Médica

---

## Pré-requisito

Baixe o **Power BI Desktop** gratuitamente em:  
https://powerbi.microsoft.com/pt-br/downloads/

---

## Passo 1 — Importar os Dados

1. Abra o Power BI Desktop
2. Clique em **Obter Dados → Excel**
3. Selecione o arquivo `outputs/relatorio_clinica.xlsx`
4. Na janela do Navegador, marque **todas as abas** e clique em **Transformar Dados**

No Power Query Editor:
- Verifique se a primeira linha foi promovida como cabeçalho (se não: **Página Inicial → Usar Primeira Linha como Cabeçalho**)
- Confirme os tipos de dados: colunas de valor devem ser **Número Decimal**
- Clique em **Fechar e Aplicar**

---

## Passo 2 — Modelo de Dados (Relacionamentos)

Na aba **Modelo** (ícone de diagrama à esquerda):

Crie os seguintes relacionamentos:
- `Por Especialidade[especialidade]` → `KPIs` (opcional, apenas referência)
- Não é necessário relacionamento complexo neste projeto — as tabelas já são agregadas

---

## Passo 3 — Criar os Visuais

### Visual 1 — Cartões de KPI (topo da página)

Insira 4 cartões (**Inserir → Cartão**) com os seguintes campos da aba `KPIs`:

| Cartão | Campo | Rótulo |
|---|---|---|
| 1 | Atendimentos Realizados | Atendimentos |
| 2 | Taxa de Realização (%) | Taxa de Realização |
| 3 | Receita Total (R$) | Receita Total |
| 4 | Ticket Médio (R$) | Ticket Médio |

Formate cada cartão: fonte grande, cor de destaque azul escuro (`#1F4E79`).

---

### Visual 2 — Gráfico de Barras: Receita por Especialidade

1. Insira um **Gráfico de Barras Clusterizado**
2. Configuração:
   - **Eixo Y:** `Por Especialidade[especialidade]`
   - **Valores:** `Por Especialidade[receita_total]`
3. Ordene por valor decrescente (clique nos `...` do visual → Classificar por → receita_total)
4. Título: "Receita por Especialidade (R$)"

---

### Visual 3 — Gráfico de Linha: Evolução Mensal

1. Insira um **Gráfico de Linhas**
2. Configuração:
   - **Eixo X:** `Evolução Mensal[Mês]`
   - **Valores:** `Evolução Mensal[receita]`
3. Adicione marcadores de ponto (Formatar → Marcadores → Ativado)
4. Título: "Evolução Mensal da Receita"

---

### Visual 4 — Gráfico de Rosca: Status dos Atendimentos

1. Insira um **Gráfico de Rosca**
2. Configuração:
   - **Legenda:** `Status Atendimentos[status]`
   - **Valores:** `Status Atendimentos[quantidade]`
3. Título: "Distribuição de Status"

---

### Visual 5 — Tabela: Ranking de Médicos

1. Insira uma **Tabela**
2. Campos: `medico`, `atendimentos_realizados`, `receita_gerada`, `duracao_media_min`
3. Formate: aplique formatação condicional de cor em `receita_gerada` (Formatar → Formatação Condicional → Escala de Cores)

---

## Passo 4 — Filtros e Segmentações

1. Insira uma **Segmentação de Dados** (Slicer)
   - Campo: `Por Convênio[convenio]`
   - Isso permite filtrar todos os visuais por convênio

2. Insira outra segmentação para `Por Especialidade[especialidade]`

---

## Passo 5 — Formatação Final

- Fundo da página: cinza muito claro (`#F5F5F5`)
- Título principal: caixa de texto no topo — **"PAINEL DE DESEMPENHO — CLÍNICA MÉDICA 2024"**
- Fonte título: Segoe UI, 18pt, negrito, cor `#1F4E79`
- Bordas dos visuais: sombra suave

---

## Passo 6 — Exportar para Portfólio

1. **Arquivo → Exportar → Exportar para PDF** — salve como `dashboard_clinica.pdf`
2. Tire um print da tela completa do dashboard
3. Adicione a imagem ao `README.md` do GitHub:
   ```markdown
   ![Dashboard](dashboard_preview.png)
   ```

---

## Resultado Esperado

O dashboard final deve conter:
- 4 cartões de KPI no topo
- 1 gráfico de barras (receita por especialidade)
- 1 gráfico de linhas (evolução mensal)
- 1 gráfico de rosca (status dos atendimentos)
- 1 tabela de ranking de médicos
- 2 segmentações de filtro (convênio e especialidade)

Tempo estimado de construção: **60 a 90 minutos** para quem está aprendendo.
