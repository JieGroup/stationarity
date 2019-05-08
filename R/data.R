#' Exchange rates with respect to US over the period of January 1970 to December 2017,
#' for understanding purchasing power parity (PPP) hypothesis
#'
#' Data used in the experimental study in reference 
#'
#' @docType data
#'
#' @usage data(ppp)
#'
#' @format A data frame with 576 rows and 5 variables:
#' \describe{
#'   \item{china}{exchange rates of China}
#'   \item{canada}{exchange rates of Canada}
#'   \item{uk}{exchange rates of UK}
#'   \item{germany}{exchange rates of Germany}
#'   \item{japan}{exchange rates of Japan}
#' }
#'
#' @keywords datasets
#'
#' @references Y. Xiang, J. Ding, V. Tarokh, “Evolutionary Spectra Based on the 
#' Multitaper Method with Application to Stationarity Test,” 
#' IEEE Transactions on Signal Processing, 2018
#'
#'
#' @examples
#' data(ppp)
#' isStationary <- stationaryTest(ppp$uk)
"ppp"