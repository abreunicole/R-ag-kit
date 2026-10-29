library(ellmer)

# Teste simples de fumaça na API
chat <- chat_gemini()
resposta <- chat$chat("Responda apenas: Conexão ok.")
print(resposta)