% File rNSE.Rd
%% Part of the hydroGOF R package, http://www.rforge.net/hydroGOF/ ; 
%%                                 http://cran.r-project.org/web/packages/hydroGOF/
%% Copyright 2011-2016 Mauricio Zambrano-Bigiarini
%% Distributed under GPL 2 or later


\name{rNSE}
\Rdversion{1.1}
\alias{rNSeff}
\alias{rNSE}
\alias{rNSE.default}
\alias{rNSE.matrix}
\alias{rNSE.data.frame}
\alias{rNSE.zoo}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Relative Nash-Sutcliffe efficiency
}
\description{
Relative Nash-Sutcliffe efficiency between \code{sim} and \code{obs}, with treatment of missing values. \cr
}
\usage{
rNSE(sim, obs, ...)

\method{rNSE}{default}(sim, obs, na.rm=TRUE, fun=NULL, ...,
              epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
              epsilon.value=NA)

\method{rNSE}{data.frame}(sim, obs, na.rm=TRUE, fun=NULL, ...,
              epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
              epsilon.value=NA)

\method{rNSE}{matrix}(sim, obs, na.rm=TRUE, fun=NULL, ...,
              epsilon.type=c("none", "Pushpalatha2012", "otherFactor", "otherValue"), 
              epsilon.value=NA)

\method{rNSE}{zoo}(sim, obs, na.rm=TRUE, fun=NULL, ...,
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
  \item{fun}{
function to be applied to \code{sim} and \code{obs} in order to obtain transformed values thereof before computing the relative Nash-Sutcliffe efficiency.

The first two arguments of \code{fun} MUST BE NAMED \kbd{sim} and \kbd{obs} (in that specific order), and addtional arguments are passed using \code{\dots}.
}
  \item{\dots}{
arguments passed to \code{fun}, in addition to the mandatory \kbd{sim} and \kbd{obs}.
}
  \item{epsilon.type}{
argument used to define a numeric value to be added to both \code{sim} and \code{obs} before applying \code{fun}. 

It is was  designed to allow the use of logarithm and other similar functions that do not work with zero values.

Valid values of \code{epsilon.type} are:

1) \kbd{"none"}: \code{sim} and \code{obs} are used by \code{fun} without the addition of any nummeric value.

2) \kbd{"Pushpalatha2012"}: one hundredth (1/100) of the mean observed values is added to both \code{sim} and \code{obs} before applying \code{fun}, as described in Pushpalatha et al. (2012). 

3) \kbd{"otherFactor"}: the numeric value defined in the \code{epsilon.value} argument is used to multiply the the mean observed values, instead of the one hundredth (1/100) described in Pushpalatha et al. (2012). The resulting value is then added to both \code{sim} and \code{obs}, before applying \code{fun}.

4) \kbd{"otherValue"}: the numeric value defined in the \code{epsilon.value} argument is directly added to both \code{sim} and \code{obs}, before applying \code{fun}.
}
  \item{epsilon.value}{
 numeric value to be added to both \code{sim} and \code{obs} when \code{epsilon.type="otherValue"}.
}
}
\details{

\deqn{ rNSE = 1 -\frac { \sum_{i=1}^N { ( \frac{ S_i - O_i }{O_i} )^2 } } { \sum_{i=1}^N { ( \frac{ O_i - \bar{O} }{\bar{O}} )^2 } }  }{%
rNSE = 1 - ( sum( ( (obs - sim)/ obs )^2 ) / sum( abs( (obs - mean(obs)) / mean(obs) )^2 )}
}
\value{
Relative Nash-Sutcliffe efficiency between \code{sim} and \code{obs}. \cr

If \code{sim} and \code{obs} are matrixes, the returned value is a vector, with the relative Nash-Sutcliffe efficiency between each column of \code{sim} and \code{obs}.
}
\references{
\cite{Krause, P., Boyle, D. P., and Base, F.: Comparison of different efficiency criteria for hydrological model assessment, Adv. Geosci., 5, 89-97, 2005} \cr

\cite{Legates, D. R., and G. J. McCabe Jr. (1999), Evaluating the Use of "Goodness-of-Fit" Measures in Hydrologic and Hydroclimatic Model Validation, Water Resour. Res., 35(1), 233-241}. 
}
\author{
Mauricio Zambrano Bigiarini <mzb.devel@gmail.com>
}
\note{
\code{obs} and \code{sim} has to have the same length/dimension \cr

The missing values in \code{obs} and \code{sim} are removed before the computation proceeds, and only those positions with non-missing values in \code{obs} and \code{sim} are considered in the computation \cr

If some of the observed values are equal to zero (at least one of them), this index can not be computed.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{NSE}}, \code{\link{mNSE}}, \code{\link{gof}}, \code{\link{ggof}}
}
\examples{
sim <- 1:10
obs <- 1:10
rNSE(sim, obs)

sim <- 2:11
obs <- 1:10
rNSE(sim, obs)

##################
# Loading daily streamflows of the Ega River (Spain), from 1961 to 1970
data(EgaEnEstellaQts)
obs <- EgaEnEstellaQts

# Generating a simulated daily time series, initially equal to the observed series
sim <- obs 

# Computing the 'rNSE' for the "best" (unattainable) case
rNSE(sim=sim, obs=obs)

# Randomly changing the first 2000 elements of 'sim', by using a normal distribution 
# with mean 10 and standard deviation equal to 1 (default of 'rnorm').
sim[1:2000] <- obs[1:2000] + rnorm(2000, mean=10)

# Computing the new 'rNSE'
rNSE(sim=sim, obs=obs)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ math }
