# ==============================================================================
# TESTE DE CONEXÃO COM A API DO GEMINI VIA ELLMER
# ==============================================================================

# 1. Carrega o pacote na memória
library(ellmer)

message(">>> [TESTE API]: Iniciando teste de comunicação com o Gemini...")

tryCatch({
  # Chamada direta via namespace para evitar falhas de carregamento de escopo
  chat <- ellmer::chat_gemini()
  
  # Envia mensagem de teste
  resposta <- chat$chat("Responda apenas exatamente: Conexão OK.")
  
  message(">>> [SUCESSO]: A API respondeu perfeitamente!")
  message(">>> Resposta: ", resposta)
}, error = function(e) {
  message(">>> [ERRO DE CONEXÃO]: ", e$message)
  message(">>> Verifique se a variável GEMINI_API_KEY está salva no arquivo .Renviron")
})