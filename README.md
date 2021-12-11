![GitHub R package version](https://img.shields.io/github/r-package/v/edlansiaux/muinther)

*muinther*: relationship study between several variables
==

Authors: Edouard Lansiaux, Jean-Luc Caut, Joachim Forget and Philippe Pierre Pébaÿ

R package to compute Pearson correlation and mutual information theory outputs for multiple variables association study. Final outputs include a Pearson contingence heatmap, a theory information entropy outputs table and a theory information entropy heatmap.

A typical call to `pearsontable` to apply the Pearson algorithm to study correlation between several variables (binary and/or quantitative) takes the following form:

```
library(muinther)
pearsontable(Independent_NPIs)
pearsontable(Synergestic_NPIs)
```

where source represents a  matrix or data frame.


A typical call to `loop` to compute the Shannon theory outputs to study association between several variables (binary and/or quantitative) takes the following form:

```
loop(Independent_NPIs,1,12)
loop(Independent_NPIs,1,26)
```

where 
- source represents a  matrix or data frame, 
- 1 is the first studied X variable column number,
- 8 the number of studied variables.

The output of the `loop` function is a csv object of Shannon theory outputs(X variable name, Y variable name, X information entropy, Y information entropy, Computed marginal EPMF of X, Computed marginal EPMF of Y, Chi2, Chi2 p-value, Information entropy of X, Information entropy of Y, Joint information entropy of X and Y, Conditional information entropy of Y given X, Conditional information entropy of X given Y, Mutual information of X and Y, Normalized mutual information of X and Y) on which standard plot and summary functions can be directly applied; the former uses functionalities from the ggplot2 package. 


A typical `call` to heatmap2 to compute the Shannon theory outputs to study association between several variables (binary and/or quantitative) takes the following form:

```
heatmap2(entropy_Independent_NPIs)
heatmap2(entropy_Synergestic_NPIs)
```

where entropy_outputs is a matrix or a data frame with the loop outputs.


How to quote the package
-
Lansiaux, Edouard; Caut, Jean-Luc; Forget, Joachim; Pébaÿ, Philippe Pierre (2021): muinther. figshare. Software. https://doi.org/10.6084/m9.figshare.17161871.v1 

Reference
-
- Lansiaux, Edouard; Tchagaspanian, Noé; Arnaud, Juliette; Durand, Pierre; Changizi, Mark; Forget, Joachim (2021): Side-effects of public health policies against Covid-19: the story of an over-reaction. figshare. Preprint. https://doi.org/10.6084/m9.figshare.13660910.v3 
- Lansiaux, Edouard; Tchagaspanian, Noé; Forget, Joachim (2021): Community impact on a cryptocurrency: Twitter comparison example between Dogecoin and Litecoin. figshare. Preprint. https://doi.org/10.6084/m9.figshare.17125436.v1 

License
-
The muinther package is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License, version 3, as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchantability or fitness for a particular purpose. See the GNU General Public License for more details.

A copy of the GNU General Public License, version 3, is available at http://www.r-project.org/Licenses/GPL-3.
