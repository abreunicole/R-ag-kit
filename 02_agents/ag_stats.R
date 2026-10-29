#' Agente de Interpretação e Modelagem Estatística com LLM
#'
#' @param dados_resumo Dataframe com os resultados da tabela de contingência ou modelo
#' @param provider Provedor de LLM ("gemini" ou "openai")
#' @export
ag_stats_interpret <- function(dados_resumo, provider = "gemini") {
  library(ellmer)
  
  # 1. Definir o Prompt de Sistema Especialista
  system_prompt <- "
  Você é o agente 'ag-stats', especialista em bioestatística e epidemiologia.
  Receba o resumo de dados de um estudo epidemiológico (ex: OR, IC95%, p-valor)
  e elabore um parágrafo conciso de interpretação acadêmica nos padrões de revistas científicas,
  enfatizando a associação ocupacional ou temporal observada.
  "
  
  # 2. Inicializar o Chat via ellmer
  if (provider == "gemini") {
    chat <- chat_google_gemini(system_prompt = system_prompt)
  } else {
    chat <- chat_openai(system_prompt = system_prompt)
  }
  
  # 3. Converter os dados do R em texto para o modelo
  dados_texto <- paste(capture.output(print(dados_resumo)), collapse = "\n")
  
  # 4. Enviar para a LLM e retornar a resposta
  resposta <- chat$chat(paste("Interprete epidemiologicamente o seguinte resultado:\n\n", dados_texto))
  
  return(resposta)
}