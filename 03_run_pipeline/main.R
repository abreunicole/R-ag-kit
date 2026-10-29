# ==============================================================================
# PIPELINE R-AG-KIT: AUTOMAÇÃO EPIDEMIOLÓGICA DE DADOS DO DATASUS
# ==============================================================================

# 1. CARREGAMENTO DE PACOTES E DEPENDÊNCIAS
library(dplyr)
library(stringr)
library(lubridate)
library(readr)
library(knitr)
library(rmarkdown)
library(ellmer)

# 2. CARREGAMENTO DOS MÓDULOS DOS AGENTES
# Adapte os caminhos caso seus arquivos estejam dentro de pastas específicas (ex: "R/" ou subpastas numeradas)
source("02_ag_fetch.R/ag_fetch.R", error_arg = NULL) # Ou source("R/ag_fetch.R")
source("03_ag_clean.R/ag_clean.R", error_arg = NULL) # Ou source("R/ag_clean.R")
source("04_ag_stats.R/ag_stats.R", error_arg = NULL) # Ou source("R/ag_stats.R")
source("R/ag_report.R", error_arg = NULL)             # Agente de geração de relatório

message("\n==================================================")
message(">>> [R-AG-KIT]: INICIANDO EXECUÇÃO DO PIPELINE <<<")
message("==================================================\n")

# ------------------------------------------------------------------------------
# PARÂMETROS DA ANÁLISE
# ------------------------------------------------------------------------------
UF_ALVO       <- "MT"
ANO_INICIO    <- 2015
ANO_FIM       <- 2024
SISTEMA_SAUDE <- "SIM-DO" # SIM-DO (Mortalidade) ou SIH-RD (Internações)
PASTA_SAIDA   <- "C:/Users/nicol/Searches/Pneumopatias fúngicas/SIM"

# ------------------------------------------------------------------------------
# ETAPA 1: AGENTE DE EXTRAÇÃO (ag_fetch)
# ------------------------------------------------------------------------------
message(">>> [1/4] Executando Agente de Extração (ag_fetch)...")

dados_brutos <- ag_fetch_datasus(
  uf = UF_ALVO,
  ano_inicio = ANO_INICIO,
  ano_fim = ANO_FIM,
  sistema = SISTEMA_SAUDE
)

# ------------------------------------------------------------------------------
# ETAPA 2: AGENTE DE LIMPEZA E TRATAMENTO (ag_clean)
# ------------------------------------------------------------------------------
message(">>> [2/4] Executando Agente de Higienização (ag_clean)...")

dados_limpos <- ag_clean_datasus(dados_brutos)

# Consolidação da tabela descritiva resumida
tabela_resumo <- dados_limpos %>%
  filter(!is.na(trabalho_agro)) %>%
  group_by(trabalho_agro) %>%
  summarise(
    total_casos = n(),
    obitos_fungicos = sum(fungal_pulm_basica, na.rm = TRUE),
    percentual = round(100 * mean(fungal_pulm_basica, na.rm = TRUE), 2)
  )

# ------------------------------------------------------------------------------
# ETAPA 3: AGENTE ESTATÍSTICO E INTEGRAÇÃO LLM (ag_stats)
# ------------------------------------------------------------------------------
message(">>> [3/4] Executando Agente Estatístico e IA (ag_stats via ellmer)...")

parecer_llm <- ag_stats_interpret(
  dados_resumo = tabela_resumo,
  provider = "gemini"
)

# ------------------------------------------------------------------------------
# ETAPA 4: AGENTE DE RELATÓRIO (ag_report)
# ------------------------------------------------------------------------------
message(">>> [4/4] Executando Agente de Relatório (ag_report)...")

ag_report_generate(
  uf = UF_ALVO,
  tabela_resumo = tabela_resumo,
  parecer_llm = parecer_llm,
  output_dir = PASTA_SAIDA
)

# Exportação do backup em CSV dos dados sintetizados
write_csv(
  x = tabela_resumo,
  file = file.path(PASTA_SAIDA, paste0("resumo_pipeline_", UF_ALVO, "_", ANO_INICIO, "_", ANO_FIM, ".csv"))
)

message("\n==================================================")
message(">>> [R-AG-KIT]: PIPELINE CONCLUÍDO COM SUCESSO! <<<")
message(">>> Arquivos gerados em: ", PASTA_SAIDA)
message("==================================================\n")

# Limpeza de memória RAM
gc()