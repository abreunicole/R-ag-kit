# CARREGAMENTO DOS MÓDULOS DOS AGENTES
devtools::load_all()

# Download de teste de carga levíssimo
teste_fetch <- ag_fetch_datasus(
  uf = "AP",
  ano_inicio = 2023,
  ano_fim = 2023,
  sistema = "SIM-DO"
)

# Se retornar um dataframe preenchido, a conexão FTP/microdatasus está 100%
dim(teste_fetch)
