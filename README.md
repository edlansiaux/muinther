![GitHub R package version](https://img.shields.io/github/r-package/v/edlansiaux/muinther)
[![License](https://img.shields.io/github/license/edlansiaux/muinther)](https://github.com/edlansiaux/muinther/blob/main/LICENSE)

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
loop(Synergestic_NPIs,1,26)
```

where 
- source represents a  matrix or data frame, 
- 1 is the first studied X variable column number,
- 12 or 26 the number of studied variables.

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

References
- Lansiaux E, Tchagaspanian N and Forget J (2022) Community Impact on a Cryptocurrency: Twitter Comparison Example Between Dogecoin and Litecoin. Front. Blockchain 5:829865. doi: 10.3389/fbloc.2022.829865
- Tuma, I., Lansiaux, E.: Folding at home: Artificial intelligence and crypto symbiosis for the science. IET Blockchain 1–13 (2024). https://doi.org/10.1049/blc2.12060
