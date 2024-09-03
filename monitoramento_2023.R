proder_2023_caminho <- "X:/DEMANDAS/monitoramento/PRODER 2023.xlsx"

prodeic_2023_caminho <- "X:/DEMANDAS/monitoramento/PRODEIC 2023.xlsx"

# PRODER
proder_2023 <- readxl::read_excel(proder_2023_caminho,
                                  sheet = "CONTROLE DE RECEBIMENTO",
                                  skip = 1,
                                  col_types = c("text", "text", "text", "skip")
                                  ) |>
  dplyr::mutate(programa = "PRODER")
  
prodeic_2023 <- readxl::read_excel(prodeic_2023_caminho,
                                  sheet = "CONTROLE DE RECEBIMENTO",
                                  skip = 1,
                                  col_types = c("text", "text", "text", "skip")
) |>
  dplyr::mutate(programa = "PRODEIC")

monitoramento_2023 <- proder_2023 |> dplyr::bind_rows(prodeic_2023)

# writing

readr::write_csv2(monitoramento_2023,
                  paste0(getwd(), "monitoramento_2023"))
