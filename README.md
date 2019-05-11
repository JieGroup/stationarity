# The 'stationarity' R package
Our package contains a parametric test, Priestley-Subba Rao test (PSR test), and a non-parametric test, Rank-based Stationarity test (RS test). Both tests are based on the multitaper method. 

## Getting Started

First install the devtools package

install.packages("devtools")

library("devtools")

Then install this package

install_github('JieGroup/stationarity')

## Using This Package

To see the available function to use, type 

ls("package:stationarity")

A quick guide of package can be found [here](https://github.com/JieGroup/stationarity/blob/master/vignettes/user-guide.pdf) 

## Related Work  

The PSR test resembles the stationarity function in "fractal: A Fractal Time Series Modeling and Analysis Package" by William Constantine and Donald Percival. However, in our paper given below, we provide a rigorous analysis for the bias/variance/resolution tradeoff for the multitaper method under the evolutionary spectra framework by Priestley. Our non-parametric test is complementary to the PSR test, as the RS test is more robust to the underlying data-generating mechanism. 

## Reference Paper 

Y. Xiang, J. Ding, V. Tarokh, "Evolutionary Spectra Based on the Multitaper Method with Application to Stationarity Test,"  IEEE Transactions on Signal Processing, 2018. [pdf](https://arxiv.org/pdf/1802.09053.pdf) 
