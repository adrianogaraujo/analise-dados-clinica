"""
gerar_dataset.py
Gera dataset sintético de atendimentos de clínica médica.
Execute este script uma vez para criar os arquivos CSV em /data.
"""

import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta
import os

# Semente para reprodutibilidade
np.random.seed(42)
random.seed(42)

# ─────────────────────────────────────────────
# Parâmetros gerais
# ─────────────────────────────────────────────
N_ATENDIMENTOS = 500
DATA_INICIO = datetime(2024, 1, 1)
DATA_FIM = datetime(2024, 12, 31)

especialidades = ["Clínica Geral", "Pediatria", "Cardiologia", "Ortopedia", "Dermatologia"]
convenios = ["Unimed", "Bradesco Saúde", "SulAmérica", "Particular", "Hapvida"]
status_opcoes = ["Realizado", "Cancelado", "Faltou", "Remarcado"]
medicos = [
    "Dr. Carlos Lima", "Dra. Ana Paula", "Dr. Marcos Souza",
    "Dra. Fernanda Reis", "Dr. Roberto Alves"
]
bairros = ["Centro", "Adrianópolis", "Ponta Negra", "Chapada", "Flores"]

# ─────────────────────────────────────────────
# Geração de atendimentos
# ─────────────────────────────────────────────
def data_aleatoria(inicio, fim):
    delta = fim - inicio
    return inicio + timedelta(days=random.randint(0, delta.days))

registros = []
for i in range(1, N_ATENDIMENTOS + 1):
    especialidade = random.choice(especialidades)
    convenio = random.choice(convenios)
    status = random.choices(
        status_opcoes,
        weights=[0.70, 0.12, 0.10, 0.08]
    )[0]

    # Valor varia por especialidade
    base_valor = {
        "Clínica Geral": 150, "Pediatria": 180,
        "Cardiologia": 350, "Ortopedia": 300, "Dermatologia": 250
    }[especialidade]
    valor = round(base_valor * np.random.uniform(0.85, 1.25), 2) if status == "Realizado" else 0.0

    data_agendamento = data_aleatoria(DATA_INICIO, DATA_FIM)
    duracao_min = random.choice([20, 30, 40, 60]) if status == "Realizado" else 0

    registros.append({
        "id_atendimento": i,
        "data_agendamento": data_agendamento.strftime("%Y-%m-%d"),
        "mes": data_agendamento.month,
        "dia_semana": data_agendamento.strftime("%A"),
        "medico": random.choice(medicos),
        "especialidade": especialidade,
        "convenio": convenio,
        "bairro_paciente": random.choice(bairros),
        "status": status,
        "duracao_minutos": duracao_min,
        "valor_cobrado": valor
    })

df_atendimentos = pd.DataFrame(registros)

# ─────────────────────────────────────────────
# Tabela de médicos (dimensão)
# ─────────────────────────────────────────────
df_medicos = pd.DataFrame({
    "medico": medicos,
    "especialidade": especialidades,
    "carga_horaria_semanal": [40, 32, 36, 40, 32],
    "anos_experiencia": [12, 8, 20, 15, 6]
})

# ─────────────────────────────────────────────
# Exportação
# ─────────────────────────────────────────────
os.makedirs("data", exist_ok=True)
df_atendimentos.to_csv("data/atendimentos.csv", index=False, encoding="utf-8-sig")
df_medicos.to_csv("data/medicos.csv", index=False, encoding="utf-8-sig")

print(f"Dataset gerado com sucesso!")
print(f"  atendimentos.csv → {len(df_atendimentos)} linhas")
print(f"  medicos.csv      → {len(df_medicos)} linhas")
