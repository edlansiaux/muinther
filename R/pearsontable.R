#' @title Pearson correlation heatmap
#' @description Contingence table heatmap of Pearson coefficients and p-values. Studied variables can be binary or quantitative.Concerning Pearson correlation, it is a commonly formulated criticism that one may not establish a linear correlation between a series of quantitative variables and another one of qualitative variables . However, this concern is misguided in the case of dichotomous variables (i.e., taking binary values), for this correlation can be legitimately established using the point biserial correlation coefficient.
#' @author Joachim Forget, Jean-Luc Caut
#' @references 1/ Lev, J. The point biserial coefficient of correlation. Ann. Math. Stat. 20, DOI: 10.1214/aoms/1177730103 (1949). 2/ Tate, R. Correlation between a discrete and a continuous variable. point-biserial correlation. The Annals Math. Stat. 25,DOI: 10.1214/aoms/1177728730 (1954) 3/ Kornbrot, D. Point biserial correlation. In Encyclopedia of Statistics in Behavioral Science, DOI: 10.1002/0470013192.bsa485 (American Cancer Society, 2005)
#' @example inst/examples/pearson_correlation.R
#'
#' @param x is the source data matrix/data frame
#'
#' @import Hmisc
#' @import data.table
#' @import ggplot2
#' @import ggtext
#' @import reshape2
#' @import formattable
#' @export


pearsontable <- function(x){
  data <- x
  cor_vals <- Hmisc::rcorr(as.matrix(data), type = "pearson")


  get_lower_tri<-function(cor){
    cor[upper.tri(cor)] <- NA
    return(cor)
  }

  get_upper_tri <- function(cor){
    cor[lower.tri(cor)]<- NA
    return(cor)
  }

  reorder_cor <- function(cormat){
    # Use correlation between variables as distance
    dd <- as.dist((1-cormat)/2)
    hc <- hclust(dd)
    cormat <-cormat[hc$order, hc$order]
  }

  cor_r <- reorder_cor(cor_vals$r)
  cor_P <- reorder_cor(cor_vals$P)

  upper_r <- get_upper_tri(cor_r)
  upper_p <- get_upper_tri(cor_P)

  cor_v <- reshape2::melt(upper_r)
  cor_p <- reshape2::melt(upper_p)
  cor_p <- cor_p[,3]
  cor <- cbind(cor_v,cor_p)
  names(cor) <- c("var1", "var2", "value_r", "value_p")

  ggplot2::theme_set(
    ggplot2::theme_light(base_size = 40) +
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


  plot <- ggplot2::ggplot(
    data = cor,
    mapping = ggplot2::aes(x = var1, y = var2, fill = value_r, text = value_p)
  ) +
    ggplot2::geom_tile() +
    ggtext::geom_richtext(
      mapping = ggplot2::aes(
        label = gsub(
          pattern = "(.*)e([-+]*)0*(.*)",
          replacement = "10<sup>\\2\\3</sup>",
          x = scales::scientific(.data[["value_p"]], digits = 3)
        )
      ),
      colour = "white",
      fill = NA,
      label.colour = NA,
      size = 2,
      na.rm = TRUE
    ) +
    ggplot2::scale_fill_viridis_c(na.value = "white", name = "Pearson\nCorrelation\n") +
    ggplot2::labs(
      x = NULL, y = NULL,
      caption = "Values denoted in tiles correspond to p-value of Pearson test."
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.caption = ggtext::element_markdown(size = ggplot2::rel(0.5)), axis.text.x = ggtext::element_markdown(angle = ggplot2::rel(90)))
  table <- formattable::formattable(cor)
  results <- list(plot,table)
  return(results)
  }

