url <- "https://www.camara.leg.br/busca-api/api/v1/busca/proposicoes/_search"

body <- list(
  'emTramitacao' = 'Sim',
  'order' = "relevancia",
  'pagina' = '1',
  'q' = 'desinformação',
  'tiposDeProposicao' = 'PL'
)

res <- httr::POST(url, body = body)