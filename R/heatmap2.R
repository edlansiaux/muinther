#' @title  Shannon entropy heatmap
#' @author Edouard Lansiaux, Philippe Pierre Pébaÿ
#' @description Contingence table heatmap of normalized mutual information theory coefficients with the Chi2 p-value. Studied variables can be binary or quantitative.
#' @param z is the entropy metrics outputs matrix/data frame (computated previously with the loop function) file
#' @example inst/examples/mutual_information_example.R
#' @import ggtext
#' @import ggplot2
#' @import reshape2
#'
#' @export

heatmap2 <- function(z){
  z <- as.data.frame(z)
  z <- z[, - c(3,4,5,7,8,9,10,11,12)]
  z1 <- z[,1:3]
  z2 <- cbind(z[,1:2],z[,4])
  z1 <- reshape2::dcast(z1, X.studied.variable~Y.studied.variable,value.var="Chi2.p.value", fill = NA)
  z2 <- reshape2::dcast(z2, X.studied.variable~Y.studied.variable,value.var="z[, 4]", fill = NA)

  names1 <- z1[,1]
  z1 <- z1[,-1]
  z4 <- t(z1)

  for (i in 1:ncol(z1)) {
    c <- as.vector(z1[,i])
    d <- as.vector(z4[,i])
    for (y in 1:ncol(z1)) {
      if (is.na(c[y])) {
        c <- replace(c,y,d[y])
      }
    }
    names1 <- cbind(names1,c)
  }


  names2 <- z2[,1]
  z2 <- z2[,-1]
  z3 <- t(z2)

  for (i in 1:ncol(z2)) {
    c <- as.vector(z2[,i])
    d <- as.vector(z3[,i])
    for (y in 1:ncol(z2)) {
      if (is.na(c[y])) {
        c <- replace(c,y,d[y])
      }
    }
    names2 <- cbind(names2,c)
  }

  get_lower_tri<-function(cormat){
    cormat[upper.tri(cormat)] <- NA
    return(cormat)
  }

  get_upper_tri <- function(cormat){
    cormat[lower.tri(cormat, diag = FALSE)]<- NA
    return(cormat)
  }

  row.names(names1)<- names1[,1]
  names1<-names1[,-1]
  colnames(names1)<- rownames(names1)
  row.names(names2) <- names2[,1]
  names2<-names2[,-1]
  colnames(names2)<- rownames(names2)

  upper_triz1 <- get_upper_tri(names1)
  upper_triz2 <- get_upper_tri(names2)

  z1 <- reshape2::melt(upper_triz1, na.rm = TRUE)
  z2 <- reshape2::melt(upper_triz2, na.rm = TRUE)

  z2 <- z2[,3]
  z <- cbind(z1,z2)

  r<-as.numeric(z[,4])
  p<-as.numeric(z[,3])
  z<-cbind(z[,1:2],p,r)

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
          replacement = "10<sup>\\2\\3</sup>",
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
