proj <- xlsx::read.xlsx("data/proj.xlsx", sheetIndex = 1) |> dplyr::select(-NA.)
notas <- xlsx::read.xlsx("data/notas.xlsx", sheetIndex = 1) |> dplyr::select(-NA.)

proj_notas <- notas |> 
  dplyr::left_join(proj, by = c("prop" = "prop"))

proj_notas <- proj_notas |>
  dplyr::select(cod, prop, class, data, uf, partido)

proj_notas <- proj_notas |> 
  dplyr::mutate(
    data = lubridate::dmy(data),
    data = lubridate::year(data)
  )

proj_notas <- proj_notas |> dplyr::filter(!is.na(class))

teste <- dplyr::filter(proj_notas, class == 2) |>
  dplyr::filter(data %in% c(2009, 2013))

## apresenta tibble::tibble com a distribuição de ano com a class 2

proj_notas |>
  dplyr::count(data) |>
  dplyr::arrange(data) |>
  print()

proj_notas |>
  dplyr::filter(class == 2) |>
  dplyr::count(data) |>
  dplyr::arrange(data) |>
  print()

proj_notas |>
  dplyr::filter(class == 3) |>
  dplyr::count(data) |>
  dplyr::arrange(data) |>
  print()

## Cria um gráfico de frequência dos projetos por ano de 2003 a 2024

graf1 <- proj_notas |>
  ggplot2::ggplot(ggplot2::aes(x = data)) +
  ggplot2::geom_bar(fill = "#ad9aff") +
  ggplot2::scale_x_continuous(breaks = seq(2003, 2024, 1)) +
  ggplot2::scale_y_continuous(limits = c(0, 40), breaks = seq(0, 50, 10)) +
  ggplot2::labs(title = "Frequência de projetos por ano",
                x = "Ano",
                y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1),
                 plot.title = ggplot2::element_text(hjust = 0.5))

## Cria um gráfico de frequência dos projetos dividos por class em cores diferentes na mesma barra



graf2 <- proj_notas |>
  ggplot2::ggplot(ggplot2::aes(x = data, fill = as.factor(class))) +
  ggplot2::geom_bar() +
  ggplot2::scale_x_continuous(breaks = seq(2003, 2024, 1)) +
  ggplot2::scale_y_continuous(limits = c(0, 40), breaks = seq(0, 40, 20)) +
  ggplot2::scale_fill_manual(values = c("#faa1a1", "#ffefaa", "#b7ffac", "#89f6ff")) +
  ggplot2::labs(title = "",
                x = "Ano",
                y = "Frequência",
                fill = "Classe") +
  ggplot2::theme_light() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1),
                 plot.title = ggplot2::element_text(hjust = 0.5),
                 plot.background = ggplot2::element_rect(fill = "white"))

graf2 <- proj_notas |>
  ggplot2::ggplot(ggplot2::aes(x = data, fill = as.factor(class))) +
  ggplot2::geom_bar() +
  ggplot2::scale_x_continuous(breaks = seq(2003, 2024, 4)) +
  ggplot2::scale_y_continuous(limits = c(0, 40), breaks = seq(0, 40, 10), expand = c(0, 0)) +
  ggplot2::scale_fill_manual(values = c("#faa1a1", "#ffefaa", "#b7ffac", "#89f6ff")) +
  ggplot2::labs(title = "",
                x = "Ano",
                y = "Frequência",
                fill = "Classe") +
  ggplot2::theme_bw() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1),
                 plot.title = ggplot2::element_text(hjust = 0.5),
                 panel.border = ggplot2::element_blank(),
                 panel.grid = ggplot2::element_blank(),
                 panel.grid.major.y = ggplot2::element_line(color = "lightgrey", linewidth = 0.5),
                 plot.background = ggplot2::element_rect(fill = "white"))


## salva o gráfico
ggplot2::ggsave(
  filename = "graf/graf2.png",
  plot = graf2,
  width = 16,
  height = 9,
  units = "cm",
  dpi = 600
)


