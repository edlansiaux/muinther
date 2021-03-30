#' Loop for computate all Pearson correlation outputs
#' Contingence table of Pearson coefficients
#' @param x is the source data csv file
#'
#' @import Hmisc
#' @import data.table
#' @import ggplot2
#' @import ggtext
#' @import readr
#' @export


pearsontable <- function(x){
  data <- readr::read_csv(x)
  cor_vals <- Hmisc::rcorr(as.matrix(data), type = "pearson")
  cor_vals <- lapply(cor_vals[c("r", "P")], function(i) {
    i[lower.tri(i)] <- NA
    data.table::melt(data.table::as.data.table(i, keep.rownames = "var1"), id.vars = "var1", variable.name = "var2")
  })
  cor_vals <- merge(cor_vals[[1]], cor_vals[[2]], by = c("var1", "var2"), suffix = c("_r", "_p"))

  ggplot2::ggplot(
    data = cor_vals,
    mapping = ggplot2::aes(x = var2, y = var1, fill = value_r, text = value_p)
  ) +
    ggplot2::geom_tile() +
    ggtext::geom_richtext(
      mapping = ggplot2::aes(
        label = gsub(
          pattern = "(.*)e([-+]*)0*(.*)",
          replacement = "\\1<br>&times;<br>10<sup>\\2\\3</sup>",
          x = scales::scientific(.data[["value_p"]], digits = 3)
        )
      ),
      colour = "white",
      fill = NA,
      label.colour = NA,
      size = 2.5,
      na.rm = TRUE
    ) +
    ggplot2::scale_fill_viridis_c(na.value = "white", name = "Pearson's\nCorrelation") +
    ggplot2::labs(
      x = NULL, y = NULL,
      caption = "Values denoted in tiles correspond to p-value of correlation test."
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.caption = ggtext::element_markdown(size = ggplot2::rel(0.5)))
}
