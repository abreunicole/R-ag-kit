# Criar banco fictício de teste
dados_mock <- data.frame(
  CAUSABAS = c("B410", "B450", "I219", "B390", "J180"),
  OCUP = c("621005", "231105", NA, "agropecuaria", "225120"),
  IDADE = c("445", "460", "305", "502", "430"),
  SEXO = c("1", "2", "1", "1", "2"),
  DTOBITO = c("15012023", "20022023", "10032023", "05042023", "12052023")
)

# Testar encadeamento dos agentes
source("R/ag_clean.R")
source("R/ag_stats.R")
source("R/ag_report.R")

dados_limpos <- ag_clean_datasus(dados_mock)
# Se gerar a tabela e não der erro de coluna ausente, o ag_clean está OK!