#' @title Loop to computate all entropy metrics outputs
#' @description Table of mutual information theory coefficients for variables association study. Computated outputs gather: X variable name, Y variable name, X information entropy, Y information entropy, Computed marginal EPMF of X, Computed marginal EPMF of Y, Chi2, Chi2 p-value, Information entropy of X, Information entropy of Y, Joint information entropy of X and Y, Conditional information entropy of Y given X, Conditional information entropy of X given Y, Mutual information of X and Y, Normalized mutual information of X and Y.
#' @author Edouard Lansiaux, Philippe Pierre Pébaÿ
#' @references Shannon, C. A mathematical theory of communication. Bell Labs Tech. J. 27, 379–423, DOI: 10.1002/j.1538-7305.1948.tb01338.x (1948).
#' @param input is the source data frame
#' @param m is the first studied X variable column number
#' @param n is the studied variables number
#'
#' @example inst/examples/mutual_information_example.R
#' @import reticulate
#' @export

loop <- function(input,m,n){
  write.csv(input,'input.csv')

  os <- NULL
  sys <- NULL
  codecs <- NULL
  getopt <- NULL
  csv <- NULL
  math <- NULL
  np <- NULL
  ss <- NULL


    # delay load modules (will only be loaded when accessed via $)
    os <<- reticulate::import("os", delay_load = TRUE)
    sys <<- reticulate::import("sys", delay_load = TRUE)
    codecs <<- reticulate::import("codecs", delay_load = TRUE)
    getopt <<- reticulate::import("getopt", delay_load = TRUE)
    csv <<- reticulate::import("csv", delay_load = TRUE)
    math <<- reticulate::import("math", delay_load = TRUE)
    np <<- reticulate::import("numpy", delay_load = TRUE)
    ss <<- reticulate::import("scipy.stats", delay_load = TRUE)

  reticulate::source_python(system.file("python","loop.py", package = "muinther"))
  loopy('input.csv',m,n)
  fn1 <- as.data.frame(readr::read_csv('input.csv'))
  fn1 <- fn1[, (m+1):(m+n)]
  var_1 <- colnames(fn1)
  entropy_outputs <- as.data.frame(readr::read_csv('entropy_outputs.csv'))
  for (i in 0:(n-1)) {
    y = i + m
    entropy_outputs[, 1:2] <- replace(entropy_outputs[, 1:2],entropy_outputs[, 1:2]==i,var_1[y])
  }
  write.csv(entropy_outputs, 'entropy_outputs.csv', row.names = FALSE)
  print(entropy_outputs)
  entropy_outputs <- as.data.frame(entropy_outputs)

}
