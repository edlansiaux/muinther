#' @title Pearson correlation outputs computation
#' @description Contingence table heatmap of Pearson coefficients and p-values. Studied variables can be binary or quantitative.Concerning Pearson correlation, it is a commonly formulated criticism that one may not establish a linear correlation between a series of quantitative variables and another one of qualitative variables . However, this concern is misguided in the case of dichotomous variables (i.e., taking binary values), for this correlation can be legitimately established using the point biserial correlation coefficient.
#' @references 1/ Lev, J. The point biserial coefficient of correlation. Ann. Math. Stat. 20, DOI: 10.1214/aoms/1177730103 (1949). 2/ Tate, R. Correlation between a discrete and a continuous variable. point-biserial correlation. The Annals Math. Stat. 25,DOI: 10.1214/aoms/1177728730 (1954) 3/ Kornbrot, D. Point biserial correlation. In Encyclopedia of Statistics in Behavioral Science, DOI: 10.1002/0470013192.bsa485 (American Cancer Society, 2005)
#' @examples pearsontable(docs_phenotype_file_1)
#'
#' @param x is the source data file
#'
#' @import Hmisc
#' @import data.table
#' @import ggplot2
#' @import ggtext
#' @export


pearsontable <- function(x){
  data <- x
  cor_vals <- Hmisc::rcorr(as.matrix(data), type = "pearson")
  cor_vals <- lapply(cor_vals[c("r", "P")], function(i) {
    i[lower.tri(i)] <- NA
    data.table::melt(data.table::as.data.table(i, keep.rownames = "var1"), id.vars = "var1", variable.name = "var2")
  })
  cor_vals <- merge(cor_vals[[1]], cor_vals[[2]], by = c("var1", "var2"), suffix = c("_r", "_p"))

  ggplot2::theme_set(
    ggplot2::theme_light(base_size = 11) +
      ggplot2::theme(
        plot.title = ggtext::element_markdown(),
        plot.title.position = "plot",
        plot.subtitle = ggtext::element_markdown(face = "italic", size = ggplot2::rel(0.8)),
        plot.caption = ggtext::element_markdown(face = "italic", size = ggplot2::rel(0.65)),
        plot.caption.position = "plot",
        axis.text.x = ggtext::element_markdown(),
        axis.text.x.top = ggtext::element_markdown(),
        axis.text.y = ggtext::element_markdown(),
        legend.box.just = "left",
        legend.key.size = ggplot2::unit(0.5, "lines"),
        legend.text = ggplot2::element_text(size = ggplot2::rel(1))
      )
  )

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
      size = 2,
      na.rm = TRUE
    ) +
    ggplot2::scale_fill_viridis_c(na.value = "white", name = "Pearson's\nCorrelation") +
    ggplot2::labs(
      x = NULL, y = NULL,
      caption = "Values denoted in tiles correspond to p-value of correlation test."
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.caption = ggtext::element_markdown(size = ggplot2::rel(0.5)), axis.text.x = ggtext::element_markdown(angle = ggplot2::rel(90)))
}
