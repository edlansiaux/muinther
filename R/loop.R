#' Loop for computate all entropy metrics outputs
#' Contingence table of normalized mutual information theory coefficients
#' @param s is the source data csv file
#'
#' @import reticulate
#' @export

loop <- function(x){
  reticulate::source_python("I:/muinther/R/muinther/R/loop.py")}
