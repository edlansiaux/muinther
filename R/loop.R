#' @title Loop to computate all entropy metrics outputs
#' @description Table of mutual information theory coefficients for variables association study. Computated outputs gather: Computed marginal EPMF of X, Computed marginal EPMF of Y, Chi2, Chi2 p-value, Information entropy of X, Information entropy of Y, Joint information entropy of X and Y, Conditional information entropy of Y given X, Conditional information entropy of X given Y, Mutual information of X and Y, Normalized mutual information of X and Y.
#' @references Shannon, C. A mathematical theory of communication. Bell Labs Tech. J. 27, 379–423, DOI: 10.1002/j.1538-7305.1948.tb01338.x (1948).
#' @param fn is the path to source data csv file with variables studied beginning on the second column
#' @param m is the first studied X variable column number
#' @param n is the studied variables number
#' @examples loop('I:/muinther/R/muinther/docs_phenotype_file_1.csv',1,7)
#'
#' @import reticulate
#' @export

loop <- function(fn,m,n){
  os <- reticulate::import("os")
  reticulate::source_python('I:/muinther/R/muinther/R/loop.py')
  loopy(fn,m,n)
  fn <- as.data.frame(readr::read_csv(fn))
  var_1 <- colnames(fn)
  entropy_outputs <- as.data.frame(readr::read_csv('I:/muinther/R/muinther/vignettes/entropy_outputs.csv'))
  for (i in 0:(length(fn)-1)) {
    y = i + 1 + m
    entropy_outputs[, 1:2] <- replace(entropy_outputs[, 1:2],entropy_outputs[, 1:2]==i,var_1[y])
  }

  write.csv(entropy_outputs, 'entropy_outputs.csv', row.names = FALSE)
  print(entropy_outputs)
}


