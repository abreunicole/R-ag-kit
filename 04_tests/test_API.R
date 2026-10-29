# ==============================================================================
# TESTE DE CONEXÃO COM A API DO GEMINI VIA ELLMER
# ==============================================================================

library(ellmer)

message(">>> [TESTE API]: Iniciando teste de comunicação com o Gemini...")

tryCatch({
  # Nome atual da função no pacote ellmer
  chat <- chat_google_gemini()
  
  # Envia mensagem de teste
  resposta <- chat$chat("Responda apenas exatamente: Conexão OK.")
  
  message(">>> [SUCESSO]: A API respondeu perfeitamente!")
  message(">>> Resposta: ", resposta)
}, error = function(e) {
  message(">>> [ERRO DE CONEXÃO]: ", e$message)
  message(">>> Verifique se a variável GEMINI_API_KEY está salva no arquivo .Renviron")
})