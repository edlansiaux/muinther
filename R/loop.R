#' Loop for computate all entropy metrics outputs
#' Contingence table of normalized mutual information theory coefficients
#' @param x is the working directory
#' @param fn is the path to source data csv file
#' @param m is the first studied X variable column number
#' @param n is the studied variables number
#'
#' @import reticulate
#' @export

loop <- function(x,fn,m,n){
  os <- reticulate::import("os")
  os$chdir(x)
  reticulate::source_python('I:/muinther/R/muinther/R/loop.py')
  loopy(fn,m,n)
}
