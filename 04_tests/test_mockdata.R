# 1. Carrega todas as funções salvas na pasta R/
devtools::load_all()

# 2. Re-executa o teste com o mockdata
dados_mock <- data.frame(
  CAUSABAS = c("B410", "B450", "I219", "B390", "J180"),
  OCUP = c("621005", "231105", NA, "agropecuaria", "225120"),
  IDADE = c("445", "460", "305", "502", "430"),
  SEXO = c("1", "2", "1", "1", "2"),
  DTOBITO = c("15012023", "20022023", "10032023", "05042023", "12052023")
)

dados_limpos <- ag_clean(dados_mock)
head(dados_limpos)