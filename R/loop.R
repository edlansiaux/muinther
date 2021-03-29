#' Loop for computate all entropy metrics outputs
#' Contingence table of normalized mutual information theory coefficients
#'
#' @import reticulate
#' @export

loop <- function(x){
  sys <- reticulate::import("sys")
  codecs <- reticulate::import("codecs")
  os <- reticulate::import("os")
  getopt <- reticulate::import("getopt")
  csv <- reticulate::import("csv")
  math <- reticulate::import("math")
  np <- reticulate::import("numpy")
  ss <- reticulate::import("scipy.stats")


  reticulate::source_python('I:/muinther/R/muinther/R/loop.py')
  }

