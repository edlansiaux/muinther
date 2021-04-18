\name{entropy_outputs}
\alias{entropy_outputs}
\docType{data}
\title{Entropy outputs
%%   ~~ data name/kind ... ~~
}
\description{Computated entropy outputs fromm the fonction loop
%%  ~~ A concise (1-5 lines) description of the dataset. ~~
}
\usage{data("entropy_outputs")}
\format{
  A data frame with 28 observations on the following 13 variables.
  \describe{
    \item{\samp{X studied variable}}{a numeric vector}
    \item{\samp{Y studied variable}}{a numeric vector}
    \item{\samp{Computed marginal EPMF of X}}{a numeric vector}
    \item{\samp{Computed marginal EPMF of Y}}{a numeric vector}
    \item{\code{Chi2}}{a numeric vector}
    \item{\samp{Chi2 p-value}}{a numeric vector}
    \item{\samp{Information entropy of X}}{a numeric vector}
    \item{\samp{Information entropy of Y}}{a numeric vector}
    \item{\samp{Joint information entropy of X and Y}}{a numeric vector}
    \item{\samp{Conditional information entropy of Y given X}}{a numeric vector}
    \item{\samp{Conditional information entropy of X given Y}}{a numeric vector}
    \item{\samp{Mutual information of X and Y}}{a numeric vector}
    \item{\samp{Normalized mutual information of X and Y}}{a numeric vector}
  }
}

\source{Output from the function loop() when `docs_phenotype_file_1` dataset was used
}

\keyword{datasets}
