# Testar criação dinâmica da pasta de saída
dir.create("resultados/teste_infra", recursive = TRUE, showWarnings = FALSE)

# Testar gravação de arquivo de texto simples
writeLines("Teste de infraestrutura R-ag-kit", "resultados/teste_infra/status.txt")

# Verificar se o arquivo foi fisicamente criado
file.exists("resultados/teste_infra/status.txt")