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

monitoramento_2023 <- proder_2023 |> dplyr::bind_rows(prodeic_2023) |>
  dplyr::mutate(CIDADE = tolower(CIDADE)) |>
  dplyr::mutate(CIDADE = stringr::str_replace_all(CIDADE, "nova marilândoa",
                                                  "nova marilândia"))

curl::curl_download(paste0("https://github.com/WillianDambros/",
                           "data_source/raw/main/compilado_decodificador.xlsx"),
                    destfile = paste0(getwd(), "/compilado_decodificador.xlsx"))

readxl::excel_sheets(paste0(getwd(), "/compilado_decodificador.xlsx"))

territorialidade <- 
  readxl::read_excel(paste0(getwd(), "/compilado_decodificador.xlsx"),
                     sheet = "territorialidade") |>
  dplyr::rename(CIDADE = territorio_municipio_decodificado)

#### Selecionar e obter os valores distintos de cada dataframe
#cidades_territorialidade <- territorialidade |> dplyr::select(CIDADE) |> dplyr::distinct()

#cidades_monitoramento <- monitoramento_2023 |> dplyr::select(CIDADE) |> dplyr::mutate(CIDADE = tolower(CIDADE)) |> dplyr::distinct(CIDADE)

# Encontrar cidades que estão em territorialidade, mas não estão em monitoramento_2023
#cidades_nao_correspondentes <- cidades_territorialidade |> dplyr::anti_join(cidades_monitoramento, by = "CIDADE")

#cidades_nao_correspondentes_2 <- cidades_monitoramento |> dplyr::anti_join(cidades_territorialidade, by = "CIDADE")

#cidades_nao_correspondentes

##cidades_nao_correspondentes_2

#setdiff(cidades_monitoramento$CIDADE, cidades_territorialidade$CIDADE)

#### retornar valores

monitoramento_2023 |> dplyr::left_join(territorialidade) |>
  dplyr::select(`Razão Social`, IE, CIDADE,
                programa, territorio_latitude, territorio_longitude)

# writing

readr::write_csv2(monitoramento_2023,
                  paste0(getwd(), "/monitoramento_2023.csv"))
