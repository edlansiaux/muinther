#' @title  Shannon entropy heatmap
#' @author Edouard lansiaux, Philippe Pierre Pébaÿ
#' @description Contingence table heatmap of normalized mutual information theory coefficients with the Chi2 p-value. Studied variables can be binary or quantitative.
#' @param z is the entropy metrics outputs matrix/data frame (computated previously with the loop function) file
#' @examples heatmap2(entropy_outputs)
#' @import ggtext
#' @import ggplot2
#'
#' @export

heatmap2 <- function(z){
  z <- as.data.frame(z)
  z <- z[, - c(3,4,5,7,8,9,10,11,12)]
  names(z) <- c("var1", "var2", "value_p", "value_r")

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
      size = 1.5,
      na.rm = TRUE
    ) +
    ggplot2::scale_fill_viridis_c(na.value = "white", name = "Mutual\nInformation\nTheory") +
    ggplot2::labs(
      x = NULL, y = NULL,
      caption = "Values denoted in tiles correspond to p-value of Chi2 test."
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.caption = ggtext::element_markdown(size = ggplot2::rel(0.5)), axis.text.x = ggtext::element_markdown(angle = ggplot2::rel(90)))
}
