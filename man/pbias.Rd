% File pbias.Rd
%% Part of the hydroGOF R package, https://github.com/hzambran/hydroGOF ; 
%%                                 https://cran.r-project.org/package=hydroGOF
%%                                 http://www.rforge.net/hydroGOF/
%% Copyright 2011-2014 Mauricio Zambrano-Bigiarini
%% Distributed under GPL 2 or later

\name{pbias}
\Rdversion{1.1}
\alias{pbias}
\alias{pbias.default}
\alias{pbias.matrix}
\alias{pbias.data.frame}
\alias{pbias.zoo}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Percent Bias
}
\description{
Percent Bias between \code{sim} and \code{obs}, with treatment of missing values.
}
\usage{
pbias(sim, obs, ...)

\method{pbias}{default}(sim, obs, na.rm=TRUE, dec=1, fun=NULL, ..., 
               epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
               epsilon.value=NA)

\method{pbias}{data.frame}(sim, obs, na.rm=TRUE, dec=1, fun=NULL, ..., 
               epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
               epsilon.value=NA)

\method{pbias}{matrix}(sim, obs, na.rm=TRUE, dec=1, fun=NULL, ..., 
               epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
               epsilon.value=NA)

\method{pbias}{zoo}(sim, obs, na.rm=TRUE, dec=1, fun=NULL, ..., 
               epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
               epsilon.value=NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{sim}{
numeric, zoo, matrix or data.frame with simulated values
}
  \item{obs}{
numeric, zoo, matrix or data.frame with observed values
}
  \item{na.rm}{
a logical value indicating whether 'NA' should be stripped before the computation proceeds. \cr
When an 'NA' value is found at the i-th position in \code{obs} \bold{OR} \code{sim}, the i-th value of \code{obs} \bold{AND} \code{sim} are removed before the computation.
}
  \item{dec}{
numeric, specifying the number of decimal places used to rounf the output object. Default value is 1.
}
  \item{fun}{
function to be applied to \code{sim} and \code{obs} in order to obtain transformed values thereof before computing this goodness-of-fit index.

The first two arguments of \code{fun} MUST BE NAMED \kbd{sim} and \kbd{obs} (in that specific order), and additional arguments are passed using \code{\dots}.
}
  \item{\dots}{
arguments passed to \code{fun}, in addition to the mandatory \kbd{sim} and \kbd{obs}.
}
  \item{epsilon.type}{
argument used to define a numeric value to be added to both \code{sim} and \code{obs} before applying \code{fun}. 

It is was  designed to allow the use of logarithm and other similar functions that do not work with zero values.

Valid values of \code{epsilon.type} are:

1) \kbd{"none"}: \code{sim} and \code{obs} are used by \code{fun} without the addition of any numeric value. This is the default option.

2) \kbd{"Pushpalatha2012"}: one hundredth (1/100) of the mean observed values is added to both \code{sim} and \code{obs} before applying \code{fun}, as described in Pushpalatha et al. (2012). 

3) \kbd{"otherFactor"}: the numeric value defined in the \code{epsilon.value} argument is used to multiply the the mean observed values, instead of the one hundredth (1/100) described in Pushpalatha et al. (2012). The resulting value is then added to both \code{sim} and \code{obs}, before applying \code{fun}.

4) \kbd{"otherValue"}: the numeric value defined in the \code{epsilon.value} argument is directly added to both \code{sim} and \code{obs}, before applying \code{fun}.
}
  \item{epsilon.value}{
numeric value to be added to both \code{sim} and \code{obs} when \code{epsilon.type="otherValue"}.
}
}
\details{
\deqn{PBIAS = 100 \frac{  \sum_{i=1}^N { \left( S_i - O_i \right) } } { \sum_{i=1}^N O_i} }{%
PBIAS = 100 * [ sum( sim - obs ) / sum( obs ) ] } 

Percent bias (PBIAS) measures the average tendency of the simulated values to be larger or smaller than their observed ones. \cr

The optimal value of PBIAS is 0.0, with low-magnitude values indicating accurate model simulation. Positive values indicate overestimation bias, whereas negative values indicate model underestimation bias
}
\value{
Percent bias between \code{sim} and \code{obs}. The result is given in percentage (\%) \cr

If \code{sim} and \code{obs} are matrixes, the returned value is a vector, with the percent bias between each column of \code{sim} and \code{obs}.
}
\references{
\cite{Yapo, P. O.; Gupta, H. V.; Sorooshian S. (1996). Automatic calibration of conceptual rainfall-runoff models: sensitivity to calibration data. Journal of Hydrology. v181 i1-4. 23--48. doi:10.1016/0022-1694(95)02918-4} \cr

\cite{Sorooshian, S., Q. Duan, and V. K. Gupta. 1993. Calibration of rainfall-runoff models: Application of global optimization to the Sacramento Soil Moisture Accounting Model, Water Resources Research, 29 (4), 1185-1194, doi:10.1029/92WR02617}.
}
\author{
Mauricio Zambrano Bigiarini <mzb.devel@gmail.com>
}
\note{
\code{obs} and \code{sim} has to have the same length/dimension \cr

The missing values in \code{obs} and \code{sim} are removed before the computation proceeds, and only those positions with non-missing values in \code{obs} and \code{sim} are considered in the computation
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{gof}}, \code{\link{ggof}}
}
\examples{
obs <- 1:10
sim <- 1:10
pbias(sim, obs)

obs <- 1:10
sim <- 2:11
pbias(sim, obs)

##################
# Loading daily streamflows of the Ega River (Spain), from 1961 to 1970
data(EgaEnEstellaQts)
obs <- EgaEnEstellaQts

# Generating a simulated daily time series, initially equal to the observed series
sim <- obs 

# Computing the 'pbias' for the "best" case
pbias(sim=sim, obs=obs)

# Randomly changing the first 2000 elements of 'sim', by using a normal distribution 
# with mean 10 and standard deviation equal to 1 (default of 'rnorm').
sim[1:2000] <- obs[1:2000] + rnorm(2000, mean=10)

# Computing the new 'pbias'
pbias(sim=sim, obs=obs)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ math }
