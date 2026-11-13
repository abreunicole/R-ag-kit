#' Agente de Geração de Relatórios Automatizados (ag_report)
#'
#' Compila os resultados da análise epidemiológica e os pareceres da LLM
#' em um relatório estruturado em R Markdown / HTML.
#'
#' @param uf Sigla da Unidade da Federação
#' @param tabela_resumo Dataframe com os dados consolidados
#' @param parecer_llm Texto gerado pelo agente estatístico (ellmer)
#' @param output_dir Pasta onde o relatório final será salvo
#' @export
ag_report_generate <- function(uf, tabela_resumo, parecer_llm, output_dir = "resultados") {
  message("[ag-report]: Gerando relatório epidemiológico...")
  
  # Garante que a pasta de resultados existe
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Caminho do arquivo R Markdown temporário
  rmd_file <- file.path(output_dir, paste0("relatorio_epidemiologico_", uf, ".Rmd"))
  html_file <- file.path(output_dir, paste0("relatorio_epidemiologico_", uf, ".html"))
  
  # Conteúdo do documento em formato R Markdown
  conteudo_rmd <- c(
    "---",
    paste0("title: \"Relatório Epidemiológico Automatizado - ", uf, "\""),
    "output: html_document",
    "---",
    "",
    "## 1. Resumo dos Dados Epidemiológicos",
    "",
    "```{r echo=FALSE, message=FALSE, warning=FALSE}",
    "knitr::kable(tabela_resumo, caption = 'Tabela Descritiva dos Achados')",
    "```",
    "",
    "## 2. Parecer e Interpretação do Agente de IA (`ag_stats`)",
    "",
    "> " , gsub("\n", "\n> ", parecer_llm),
    "",
    "---",
    "_Relatório gerado automaticamente pelo pacote R-ag-kit._"
  )
  
  # Escreve o arquivo Rmd em disco
  writeLines(conteudo_rmd, con = rmd_file)
  
  # Compila o Rmd para HTML usando o knitr/rmarkdown
  if (requireNamespace("rmarkdown", quietly = TRUE)) {
    rmarkdown::render(input = rmd_file, output_file = html_file, quiet = TRUE)
    message(paste0("[ag-report]: Relatório HTML compilado com sucesso em: ", html_file))
  } else {
    message("[ag-report]: Pacote 'rmarkdown' não instalado. O arquivo .Rmd foi salvo em disco.")
  }
  
  return(invisible(html_file))
}
