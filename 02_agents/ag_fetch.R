#' Agente DataFetcher para DATASUS
#'
#' @param uf Sigla do estado (ex: "MT")
#' @param sistema Sistema do DATASUS ("SIM-DO" ou "SIH-RD")
#' @param ano_inicio Ano inicial
#' @param ano_fim Ano final
#' @export
ag_fetch_datasus <- function(uf = "MT", sistema = "SIM-DO", ano_inicio = 2015, ano_fim = 2024) {
  options(timeout = 900)
  message(paste("[ag-fetch]: Baixando dados do", sistema, "para", uf, "..."))
  
  if (sistema == "SIH-RD") {
    dados_raw <- microdatasus::fetch_datasus(
      year_start = ano_inicio, month_start = 1,
      year_end = ano_fim, month_end = 12,
      uf = uf, information_system = sistema
    )
    dados_proc <- microdatasus::process_sih(dados_raw)
  } else {
    dados_raw <- microdatasus::fetch_datasus(
      year_start = ano_inicio, year_end = ano_fim,
      uf = uf, information_system = sistema
    )
    dados_proc <- microdatasus::process_sim(dados_raw)
  }
  
  message("[ag-fetch]: Concluído com sucesso!")
  return(dados_proc)
}
