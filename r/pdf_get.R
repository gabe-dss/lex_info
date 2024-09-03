## Importa o relatório com "desinformação" retirado do portal CD em 21/08/2024
proj <- xlsx::read.xlsx("~/Erre/lex_info/data/desinf_21082024_138_cd.xlsx", sheetIndex = 1) |> 
  dplyr::rename(link = "Link",
                prop = "Proposições",
                ementa = "Ementa",
                autor = "Autor",
                uf = "UF",
                partido = "Partido",
                data = "Apresentação",
                situ = "Situação") |>
  dplyr::select(-"Explicação")

## Apaga as linhas de 139 ao fim que não são proposições
proj <- proj[1:138, ]

## Salva a tabela proj
xlsx::write.xlsx(proj, "~/Erre/lex_info/data/proj.xlsx")

## Carrega a tabela proj
proj <- xlsx::read.xlsx("~/Erre/lex_info/data/proj.xlsx", sheetIndex = 1)

## Função para baixar os PDF
# Pega o id da proposição
pdf_Teor <- function(id) {
  
  # Cria o link para ficha de tramitação
  url <- glue::glue("https://www.camara.leg.br/proposicoesWeb/fichadetramitacao?idProposicao={id}")
  
  # Requere e lê o conteúdo da página html
  res <- httr::GET(url)
  content <- httr::content(res, as = "text")
  doc <- xml2::read_html(content)
  
  # Busca o link para o inteiro teor
  int_teor <- xml2::xml_find_first(doc, "//h3[@class='inteiroTeor']/span/a")
  href <- xml2::xml_attr(int_teor, "href")
  
  # Acessa e baixa o PDF
  httr::GET(URLencode(href), httr::write_disk(glue::glue("pdf/{id}.pdf"), overwrite = TRUE))
  
  # Retorna mensagem de sucesso
  cli::cli_alert_success(glue::glue("PDF {id} baixado com sucesso!"))
  return(invisible(NULL))
}

## Aplica a função pdf_Teor para cada proposição
proj |>
  dplyr::pull("link") |>
  stringr::str_extract("(?<=idProposicao=)\\d+") |>
  purrr::walk(pdf_Teor)