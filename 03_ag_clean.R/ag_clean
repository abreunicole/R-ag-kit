#' Agente de Limpeza e Higienização (DataCleaner)
#'
#' Limpa e padroniza CIDs, CBOs, datas e idades provenientes do DATASUS (SIM/SIH).
#'
#' @param dados Dataframe contendo os dados brutos ou processados do DATASUS
#' @return Dataframe higienizado e pronto para modelagem estatística
#' @import dplyr stringr lubridate
#' @export
ag_clean_datasus <- function(dados) {
  message("[ag-clean]: Iniciando higienização das variáveis...")
  
  dados_limpos <- dados %>%
    # 1. Padronização de CIDs (Remove pontos, espaços e converte para maiúsculas)
    mutate(
      across(contains("CAUSABAS") | contains("DIAG_PRINC"), 
             ~ str_replace_all(str_to_upper(as.character(.)), "[^A-Z0-9]", ""),
             .names = "{.col}_clean")
    ) %>%
    
    # 2. Higienização de CBOs (Ocupações - Mantém apenas dígitos)
    mutate(
      across(contains("OCUP") | contains("CBOR"),
             ~ {
               x <- str_replace_all(as.character(.), "[^0-9]", "")
               if_else(x == "" | x == "000000", NA_character_, x)
             },
             .names = "{.col}_clean")
    ) %>%
    
    # 3. Decodificação de Idade do SIM (Unidade no 1º dígito: 4 = Anos, 5 = Centenários)
    mutate(
      idade_anos = if ("IDADE" %in% names(.)) {
        sapply(as.character(IDADE), function(x) {
          x_pad <- str_pad(x, width = 3, side = "left", pad = "0")
          unidade <- substr(x_pad, 1, 1)
          valor <- suppressWarnings(as.numeric(substr(x_pad, 2, 3)))
          case_when(
            unidade %in% c("0", "1", "2", "3") ~ 0,
            unidade == "4" ~ valor,
            unidade == "5" ~ 100 + valor,
            TRUE ~ NA_real_
          )
        })
      } else { NA_real_ }
    ) %>%
    
    # 4. Agrupamento por Faixas Etárias Padrão Epidemiológicas
    mutate(
      faixa_etaria = cut(
        idade_anos,
        breaks = c(0, 20, 40, 60, 80, Inf),
        right = FALSE,
        labels = c("0-19", "20-39", "40-59", "60-79", "80+")
      )
    )
  
  message("[ag-clean]: Limpeza concluída com sucesso!")
  return(dados_limpos)
}

# Teste de execução rápida no Console
#library(dplyr)
#library(stringr)

# Chamada da função do agente
#dados_tratados <- ag_clean_datasus(dados_raw)
#head(dados_tratados)