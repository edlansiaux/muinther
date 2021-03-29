#' Contingence table heatmap
#' Contingence table of normalized mutual information theory coefficients
#' @param z is the entropy metrics outputs csv file
#'
#' @import ggtext
#' @import ggplot2
#' @import readr
#' @export

heatmap2 <- function(z){
  z <- as.data.frame(z)
  z <- z[, - c(3,4,5,7,8,9,10,11,12)]
  names(z) <- c("var1", "var2", "value_p", "value_r")

  ggplot2::ggplot(
    data = z,
    mapping = ggplot2::aes(x = var1, y = var2, fill = value_r, text = value_p)
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
    ggplot2::scale_fill_viridis_c(na.value = "white", name = "Mutual\nInformation\nTheory") +
    ggplot2::labs(
      x = NULL, y = NULL,
      caption = "Values denoted in tiles correspond to p-value of Chi2 test."
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.caption = ggtext::element_markdown(size = ggplot2::rel(0.5)))
}
