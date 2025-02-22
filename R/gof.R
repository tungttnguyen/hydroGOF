# File gof.R
# Part of the hydroGOF R package, https://github.com/hzambran/hydroGOF
#                                 https://cran.r-project.org/package=hydroGOF
#                                 http://www.rforge.net/hydroGOF/ ;
# Copyright 2008-2023 Mauricio Zambrano-Bigiarini
# Distributed under GPL 2 or later

################################################################################
# Author: Mauricio Zambrano-Bigiarini                                          #
################################################################################
# Started: 15-Dic-2008 -> 03 Feb 2009;                                         #
# Updates: 06-Sep-09                                                           #
#          2010                                                                #
#          21-Jan-2011                                                         #
#          08-May-2012                                                         #
#          14-Jan-2023 ; 15-Jan-2023 ; 16-Jan-2023                             #
################################################################################

# It computes:
# 'me'        : Mean Error
# 'mae'       : Mean Absolute Error
# 'rms'       : Root Mean Square Error
# 'nrms'      : Normalized Root Mean Square Error
# 'r'         : Pearson Correlation coefficient ( -1 <= r <= 1 )
# 'r.Spearman': Spearman Correlation coefficient ( -1 <= r <= 1 ) 
# 'R2'        : Coefficient of Determination ( 0 <= r2 <= 1 )
#               Gives the proportion of the variance of one variable that
#               that is predictable from the other variable
# 'rSD'       : Ratio of Standard Deviations, rSD = SD(sim) / SD(obs)
# 'RSR'       : Ratio of the RMSE to the standard deviation of the observations
# 'NSE'       : Nash-Sutcliffe Efficiency ( -Inf <= NSE <= 1 )
# 'mNSE'      : Modified Nash-Sutcliffe Efficiency
# 'rNSE'      : Relative Nash-Sutcliffe Efficiency
# 'd'         : Index of Agreement( 0 <= d <= 1 )
# 'dr'        : Refined Index of Agreement( -1 <= dr <= 1 )
# 'md'        : Modified Index of Agreement( 0 <= md <= 1 )
# 'rd'        : Relative Index of Agreement( 0 <= rd <= 1 )
# 'cp'        : Coefficient of Persistence ( 0 <= cp <= 1 ) 
# 'PBIAS'     : Percent Bias ( -1 <= PBIAS <= 1 )
# 'bR2'       : weighted coefficient of determination
# 'KGE'       : Kling-Gupta efficiency (-Inf < KGE <= 1)
# 'sKGE'      : Split Kling-Gupta efficiency (-Inf < sKGE <= 1)
# 'KGElf'     : Kling-Gupta efficiency with focus on low values (-Inf < KGElf <= 1)
# 'KGEnp'     : Non-parametric Kling-Gupta efficiency (-Inf < KGEnp <= 1)
# 'VE'        : Volumetric efficiency

gof <-function(sim, obs, ...) UseMethod("gof")

gof.default <- function(sim, obs, na.rm=TRUE, do.spearman=FALSE, do.pbfdc=FALSE, 
                        j=1, norm="sd", s=c(1,1,1), method=c("2009", "2012"), 
                        lQ.thr=0.7, hQ.thr=0.2, start.month=1, 
                        digits=2, fun=NULL, ...,
                        epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
                        epsilon.value=NA){

     method        <- match.arg(method)
     epsilon.type  <- match.arg(epsilon.type)
     
     ME     <- me(sim, obs, na.rm=na.rm, fun=fun, ..., 
                  epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     MAE    <- mae(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     MSE    <- mse(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     RMSE   <- rmse(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value) 
     NRMSE  <- nrmse(sim, obs, na.rm=na.rm, norm=norm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     RSR    <- rsr(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     rSD    <- rSD(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)     
     PBIAS  <- pbias(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     NSE    <- NSE(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     mNSE   <- mNSE(sim, obs, na.rm=na.rm, j=j, fun=fun, ..., 
                    epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     rNSE   <- rNSE(sim, obs, na.rm=na.rm, fun=fun, ..., 
                    epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     d      <- d(sim, obs, na.rm=na.rm, fun=fun, ..., 
                 epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     dr     <- dr(sim, obs, na.rm=na.rm, fun=fun, ..., 
                  epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     md     <- md(sim, obs, na.rm=na.rm, fun=fun, ..., 
                  epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     rd     <- rd(sim, obs, na.rm=na.rm, fun=fun, ..., 
                  epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     cp     <- cp(sim, obs, na.rm=na.rm, fun=fun, ..., 
                  epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     r      <- .rPearson(sim, obs, fun=fun, ..., 
                         epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     bR2    <- br2(sim, obs, na.rm=na.rm, fun=fun, ..., 
                   epsilon.type=epsilon.type, epsilon.value=epsilon.value)     
     KGE    <- KGE(sim, obs, na.rm=na.rm, s=s, method=method, out.type="single", 
                    fun=fun, ..., epsilon.type=epsilon.type, epsilon.value=epsilon.value) 
     KGElf  <- KGElf(sim, obs, na.rm=na.rm, s=s, method=method, 
                     epsilon.type=epsilon.type, epsilon.value=epsilon.value) 
     if ( inherits(sim, "zoo") & inherits(obs, "zoo") ) {
       do.sKGE <- TRUE
       sKGE   <- sKGE(sim, obs, na.rm=na.rm, s=s, method=method, out.type="single", 
                      start.month=start.month, out.PerYear=FALSE, fun=fun, ..., 
                      epsilon.type=epsilon.type, epsilon.value=epsilon.value) 
     } else {
         do.sKGE <- FALSE
         sKGE <- NA
       } # ELSE end
 
       
     KGEnp  <- KGEnp(sim, obs, na.rm=na.rm, out.type="single", fun=fun, ..., 
                     epsilon.type=epsilon.type, epsilon.value=epsilon.value) 
     VE     <- VE(sim, obs, na.rm=na.rm, fun=fun, ..., 
                  epsilon.type=epsilon.type, epsilon.value=epsilon.value)     
     
     # 'R2' is the Coefficient of Determination
     # The coefficient of determination, R2, is useful because it gives the proportion of
     # the variance (fluctuation) of one variable that is predictable from the other variable.
     # It is a measure that allows us to determine how certain one can be in making
     # predictions from a certain model/graph.
     # The coefficient of determination is the ratio of the explained variation to the total
     # variation.
     # The coefficient of determination is such that 0 <  R2 < 1,  and denotes the strength
     # of the linear association between x and y. 
     R2 <- r^2
      
     if (do.spearman) {
       # index of those elements that are present both in 'sim' and 'obs' (NON- NA values)
       vi <- valindex(sim, obs)
   
       if (length(vi) > 0) {	 
         # Filtering 'obs' and 'sim', selecting only those pairs of elements 
         # that are present both in 'x' and 'y' (NON- NA values)
         obs <- obs[vi]
         sim <- sim[vi]

         if (!is.null(fun)) {
           fun1 <- match.fun(fun)
           new  <- preproc(sim=sim, obs=obs, fun=fun1, ..., 
                           epsilon.type=epsilon.type, epsilon.value=epsilon.value)
           sim  <- new[["sim"]]
           obs  <- new[["obs"]]
         } # IF end     

         r.Spearman <- cor(sim, obs, method="spearman", use="pairwise.complete.obs") 
     
         # if 'sim' and 'obs' were matrixs or data.frame, then the correlation
         # between observed and simulated values for each variable is given by the diagonal of 'r.Pearson' 
         if ( is.matrix(r.Spearman) | is.data.frame(r.Spearman) )
           r.Spearman <- diag(r.Spearman)

       } else {
           r.Spearman <- NA
           warning("There are no pairs of 'sim' and 'obs' without missing values !")
         } # ELSE end
        
     } # IF 'do.spearman' end
     
     if (do.pbfdc) 
       pbfdc  <- pbiasfdc(sim, obs, na.rm=na.rm, lQ.thr=lQ.thr, hQ.thr=hQ.thr, plot=FALSE, 
                          fun=fun, ..., epsilon.type=epsilon.type, epsilon.value=epsilon.value)
     
     gof <- rbind(ME, MAE, MSE, RMSE, NRMSE, PBIAS, RSR, rSD, NSE, mNSE, rNSE, d, dr, md, rd, cp, r, R2, bR2, KGE, KGElf, KGEnp, VE)     
     
     rownames(gof)[5] <- "NRMSE %"
     rownames(gof)[6] <- "PBIAS %"    
     
     if (do.spearman)
       gof <- rbind(gof, r.Spearman)
     
     if (do.pbfdc) { 
       gof <- rbind(gof, pbfdc) 
       rownames(gof)[length(rownames(gof))] <- "pbiasFDC %"
     } # IF end

     if (do.sKGE) { 
       gof <- c( gof[1:21], sKGE, gof[22:length(gof)] )
       rownames(gof)[22] <- "sKGE"
     } # IF end
     
     # Rounding the final results, ofr avoiding scientific notation
     gof <- round(gof, digits)
     
     return(gof)
     
} # 'gof.default' end


################################################################################
# Author: Mauricio Zambrano-Bigiarini                                          #
################################################################################
# Started: 15-Dic-2008 -> 03 Feb 2009;                                         #
# Updates: 06-Sep-09                                                           #
#          2010                                                                #
#          21-Jan-2011                                                         #
#          08-May-2012                                                         #
#          15-Jan-2023                                                         #
################################################################################
gof.matrix <- function(sim, obs, na.rm=TRUE, do.spearman=FALSE, do.pbfdc=FALSE, 
                       j=1, norm="sd", s=c(1,1,1), method=c("2009", "2012"), 
                       lQ.thr=0.7, hQ.thr=0.2, start.month=1, 
                       digits=2, fun=NULL, ...,
                       epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
                       epsilon.value=NA){
    
    # Temporal variable for some computations
    tmp <- gof(1:10,1:10)
    
    # Number of objective functions currently computed by gof
    ngof <- nrow(tmp) 
    
    # Name of the objective functions computed by 'gof'
    gofnames <- rownames(tmp)

    # Creating the matrix that will store the final results
    gof <- matrix(NA, ncol(obs), nrow=ngof)   
       
    # Computing the goodness-of-fit measures for each column of 'sim' and 'obs'      
    gof <- sapply(1:ncol(obs), function(i,x,y) { 
                 gof[, i] <- gof.default( x[,i], y[,i], na.rm=na.rm, 
                                        do.spearman=do.spearman, do.pbfdc=FALSE, 
                                        j=j, norm=norm, s=s, method=method, 
                                        lQ.thr=lQ.thr, hQ.thr=hQ.thr, 
                                        digits=digits, ... )
            }, x=sim, y=obs )            
     
    rownames(gof) <- gofnames
    colnames(gof) <- colnames(sim)
           
    return(gof)  
     
  } # 'gof.matrix' end
  

################################################################################
# Author: Mauricio Zambrano-Bigiarini                                          #
################################################################################
# Started: 15-Dic-2008 -> 03 Feb 2009;                                         #
# Updates: 06-Sep-09                                                           #
#          2010                                                                #
#          21-Jan-2011                                                         #
#          08-May-2012 ;                                                       #
#          15-Jan-2023                                                         #
################################################################################
gof.data.frame <- function(sim, obs, na.rm=TRUE, do.spearman=FALSE, do.pbfdc=FALSE, 
                           j=1, norm="sd", s=c(1,1,1), method=c("2009", "2012"), 
                           lQ.thr=0.7, hQ.thr=0.2, start.month=1, 
                           digits=2, fun=NULL, ...,
                           epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
                           epsilon.value=NA){ 
 
  sim <- as.matrix(sim)
  obs <- as.matrix(obs)
   
  gof.matrix(sim, obs, na.rm=na.rm, do.spearman=do.spearman, do.pbfdc=FALSE, 
             j=j, norm=norm, s=s, method=method, lQ.thr=lQ.thr, hQ.thr=hQ.thr,
             digits=digits, ...)
     
} # 'gof.data.frame' end 


################################################################################
# Author: Mauricio Zambrano-Bigiarini                                          #
################################################################################
# Started: 05-Nov-2012                                                         #
# Updates: 22-Mar-2013                                                         #
#          15-Jan-2023                                                         #
################################################################################
gof.zoo <- function(sim, obs, na.rm=TRUE, do.spearman=FALSE, do.pbfdc=FALSE, 
                    j=1, norm="sd", s=c(1,1,1), method=c("2009", "2012"), 
                    lQ.thr=0.7, hQ.thr=0.2, start.month=1, 
                    digits=2, fun=NULL, ...,
                    epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
                    epsilon.value=NA){
    
    sim <- zoo::coredata(sim)
    if (is.zoo(obs)) obs <- zoo::coredata(obs)
    
    if (is.matrix(sim) | is.data.frame(sim)) {
       gof.matrix(sim, obs, na.rm=na.rm, do.spearman=FALSE, do.pbfdc=FALSE, 
             j=j, norm=norm, s=s, method=method, lQ.thr=lQ.thr, hQ.thr=hQ.thr,
             digits=digits, ...)
    } else
        NextMethod(sim, obs, na.rm=na.rm, do.spearman=FALSE, do.pbfdc=FALSE, 
                   j=j, norm=norm, s=s, method=method, lQ.thr=lQ.thr, hQ.thr=hQ.thr,
                   digits=digits, ...)
     
  } # 'gof.zoo' end
  
