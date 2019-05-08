#' Stationarity test using the multitaper spectrum estimation method
#'
#' This function uses the multitaper method to construct hypothesis tests to test whether
#' a given one dimensional is stationary. The test can be either two-way ANOVA or Rank-based test
#'
#' @param X Vector of 1D time series to test, whose length is at least 40
#' @param alpha Float of significance level (between 0 and 1, default to 0.05)
#' @param method String of method type ('nonparametric' or 'parametric', default to 'parametric'), 
#' 'nonparametric' means two-way ANOVA test and 'parametric' means rank-based test
#' @return Boolean (False means rejection of the null hypothesis that the time seres is stationary)
#' @export
#' @examples
#' data(ppp)
#' dat <- ppp$japan
#' plot(dat)
#' stationaryTest(X=dat, alpha=0.01, method='parametric')
#' plot(diff(log(dat)))
#' stationaryTest(X=diff(log(dat)), alpha=0.01, method='parametric')
#' 
stationarityTest <- function(X, alpha=0.05, method='parametric'){
 
  TT <-  length(X) 
  
  if (TT < 40){
    stop('time series length should be at least 40!')
  }
  if (alpha >= 1 || alpha <= 0){
    stop('significance level should be between 0 and 1')
  } 

  X <- X - mean(X)
  
  # parameters of MTM
  nblock <- max(2, floor(log2(TT)))
  
  N <- floor(TT / nblock)
  
  # K in the paper
  ntaper <- min(5, ceiling((N-6)/4)) # no larger than floor((N + 1) / 6) # 5 #37
  
  # N*W to be used in multi-taper
  nw <- (ntaper+1) / 2
  
  # B is interval of frequency to be sampled (as in the paper)
  B <- 2 * pi * (ntaper + 1) / (N + 1) 
  
  # num of Time
  ITime <- nblock

  # gap is B divided by fundamental frequency (step of index in representing spectrum)
  gap <- ceiling(N * B / (2 * pi))
  
  # size of buffer is eta * gap, where eta should be within [0.5, 1] according to the reference
  eta <- 0.5
  
  # to guarantee length(ind)>1 so that JFreq>1,  floor(N / 2) > 2 floor(eta * gap) + gap
  # or N >= 2 (2*eta+1) gap + 2 = 4 gap + 2
  # simple calculations show that 
  # ntaper <= (N - 6) / 4 if eta = 0.5
  ind <- seq(floor(eta * gap), floor(N / 2) - floor(eta * gap), by=gap)
  
  # num of Freq
  JFreq <- length(ind)
  
  fs <- 1
  
  QxxIJ <- matrix(NA, nrow=ITime, ncol=JFreq)
  
  for (iTime in 1:ITime){
    
    Xblock <- X[((iTime-1) * N + 1) : (iTime * N)]
    # choose 'unity' in the MTM, which is the uniform weighting 
    
    # this corresponds to taking the log transformation
    res <- multitaper::spec.mtm(timeSeries=Xblock, nw=nw, k=ntaper, nFFT=N, adaptiveWeighting=TRUE, deltat=fs, plot=FALSE)
    temp <- log(res$spec)  
    
    QxxIJ[iTime, ] <- temp[ind] - digamma(ntaper) + log(ntaper)
    
  }
  
  # Now we have obtained the time-frequency matrix QxxIJ
  # Next perform hypothesis test using either of two methods
  
  if (method == "parametric"){

      var <- trigamma(ntaper)
      
      # %%%  Qxx %%%
      QxxMean <- mean(QxxIJ)
      
      QxxMeanTime <- rowMeans(QxxIJ)
      
      QxxMeanFreq <- colMeans(QxxIJ)
      
      # between time sum
      SxxTime <- JFreq * sum((QxxMeanTime-QxxMean)^2)
      # between freq sum
      SxxFreq <- ITime*sum((QxxMeanFreq-QxxMean)^2) 
      # interaction and residual
      Sxx <- sum((QxxIJ - QxxMean)^2)  
      SxxIR <- Sxx - SxxTime - SxxFreq 
      
      SxxTimeTest <- SxxTime/var
      SxxFreqTest <- SxxFreq/var
      SxxIRTest <- SxxIR/var
      
      dfTime <- ITime-1
      dfInter <- (ITime-1) * (JFreq-1)

      # %%%%%%% chi-square test %%%%%%
      # Bonferroni correction - fix significant level to be alpha
    
      threTime <- stats::qchisq(1-alpha/2, df=dfTime)
      threInter <- stats::qchisq(1-alpha/2, df=dfInter)
      
      if ((SxxTimeTest < threTime) && (SxxIRTest < threInter)){
        
        stationary <- T
        
      } else{
        
        stationary <- F
        
      }
      
    }else if (method == "nonparametric"){
      
      QxxRank <- matrix(NA, nrow=JFreq, ncol=ITime)
      
      for (j in 1:JFreq){
        
        # computes the ranks of the values in the vector, the smallest is ranked as 1
        QxxRank[j, ] <- rank(QxxIJ[ ,j], ties.method = c("average"))
      }
      
      # overall mean
      QxxMeanRank <- mean(QxxRank)
      
      QxxColRank <- colMeans(QxxRank)
      
      SxxRank <- JFreq * sum((QxxColRank-QxxMeanRank)^2)
      
      const <- ITime * (ITime+1) / 12
      
      TestxxRank <- SxxRank / const
      
      # %%%%%%% chi-square test %%%%%%
      threRank <- stats::qchisq(1-alpha, df=ITime-1)
      
      if (TestxxRank < threRank){
        
        stationary <- T
        
      }else{ 
        
        stationary <- F
        
      }
    
  }else{
    
    stop('method type must be either "parametric" or "nonparametric"!')
    
  }
  
  stationary
  
}
