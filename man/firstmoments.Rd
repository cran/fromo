% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{sd3}
\alias{sd3}
\alias{skew4}
\alias{kurt5}
\alias{cent_moments}
\alias{std_moments}
\alias{cent_cumulants}
\alias{std_cumulants}
\title{Compute first K moments}
\usage{
sd3(v, na_rm = FALSE, wts = NULL, sg_df = 1, check_wts = FALSE,
  normalize_wts = TRUE)

skew4(v, na_rm = FALSE, wts = NULL, sg_df = 1, check_wts = FALSE,
  normalize_wts = TRUE)

kurt5(v, na_rm = FALSE, wts = NULL, sg_df = 1, check_wts = FALSE,
  normalize_wts = TRUE)

cent_moments(v, max_order = 5L, used_df = 0L, na_rm = FALSE, wts = NULL,
  check_wts = FALSE, normalize_wts = TRUE)

std_moments(v, max_order = 5L, used_df = 0L, na_rm = FALSE, wts = NULL,
  check_wts = FALSE, normalize_wts = TRUE)

cent_cumulants(v, max_order = 5L, used_df = 0L, na_rm = FALSE,
  wts = NULL, check_wts = FALSE, normalize_wts = TRUE)

std_cumulants(v, max_order = 5L, used_df = 0L, na_rm = FALSE,
  wts = NULL, check_wts = FALSE, normalize_wts = TRUE)
}
\arguments{
\item{v}{a vector}

\item{na_rm}{whether to remove NA, false by default.}

\item{wts}{an optional vector of weights. Weights are \sQuote{replication}
weights, meaning a value of 2 is shorthand for having two observations
with the corresponding \code{v} value. If \code{NULL}, corresponds to
equal unit weights, the default. Note that weights are typically only meaningfully defined
up to a multiplicative constant, meaning the units of weights are
immaterial, with the exception that methods which check for minimum df will,
in the weighted case, check against the sum of weights. For this reason,
weights less than 1 could cause \code{NA} to be returned unexpectedly due
to the minimum condition. When weights are \code{NA}, the same rules for checking \code{v}
are applied. That is, the observation will not contribute to the moment
if the weight is \code{NA} when \code{na_rm} is true. When there is no
checking, an \code{NA} value will cause the output to be \code{NA}.}

\item{sg_df}{the number of degrees of freedom consumed in the computation of
the variance or standard deviation. This defaults to 1 to match the 
\sQuote{Bessel correction}.}

\item{check_wts}{a boolean for whether the code shall check for negative
weights, and throw an error when they are found. Default false for speed.}

\item{normalize_wts}{a boolean for whether the weights should be
renormalized to have a mean value of 1. This mean is computed over elements
which contribute to the moments, so if \code{na_rm} is set, that means non-NA
elements of \code{wts} that correspond to non-NA elements of the data
vector.}

\item{max_order}{the maximum order of the centered moment to be computed.}

\item{used_df}{the number of degrees of freedom consumed, used in the denominator
of the centered moments computation. These are subtracted from the number of
observations.}
}
\value{
a vector, filled out as follows:
\describe{
\item{sd3}{A vector of the (sample) standard devation, mean, and number of elements (or the total weight when \code{wts}
are given).}
\item{skew4}{A vector of the (sample) skewness, standard devation, mean, and number of elements (or the total weight when 
\code{wts} are given).}
\item{kurt5}{A vector of the (sample) excess kurtosis, skewness, standard devation, mean, and number of elements (or the
total weight when \code{wts} are given).}
\item{cent_moments}{A vector of the (sample) \eqn{k}th centered moment, then \eqn{k-1}th centered moment, ..., 
 then the \emph{variance}, the mean, and number of elements (total weight when \code{wts} are given).}
\item{std_moments}{A vector of the (sample) \eqn{k}th standardized (and centered) moment, then 
 \eqn{k-1}th, ..., then standard devation, mean, and number of elements (total weight).}
\item{cent_cumulants}{A vector of the (sample) \eqn{k}th (centered, but this is redundant) cumulant, then the \eqn{k-1}th, ...,
 then the \emph{variance} (which is the second cumulant), then \emph{the mean}, then the number of elements (total weight).}
\item{std_cumulants}{A vector of the (sample) \eqn{k}th standardized (and centered, but this is redundant) cumulant, then the \eqn{k-1}th, ...,
 down to the third, then \emph{the variance}, \emph{the mean}, then the number of elements (total weight).}
}
}
\description{
Compute the (standardized) 2nd through kth moments, the mean, and the number of elements.
}
\details{
Computes the number of elements, the mean, and the 2nd through kth
centered standardized moment, for \eqn{k=2,3,4}{k=2,3,4}. These
are computed via the numerically robust one-pass method of Bennett \emph{et. al.}
In general they will \emph{not} match exactly with the 'standard'
implementations, due to differences in roundoff.

These methods are reasonably fast, on par with the 'standard' implementations.
However, they will usually be faster than calling the various standard implementations
more than once.

Moments are computed as follows, given some values \eqn{x_i} and optional weights \eqn{w_i},
defaulting to 1, the weighted mean is computed as
\deqn{\mu = \frac{\sum_i x_i w_i}{\sum w_i}.}
The weighted kth central sum is computed as
\deqn{\mu = \sum_i \left(x_i - \mu\right)^k w_i.}
Let \eqn{n = \sum_i w_i} be the sum of weights (or number of observations in the unweighted case).
Then the weighted kth central moment is computed as that weighted sum divided by the
adjusted sum weights:
\deqn{\mu_k = \frac{\sum_i \left(x_i - \mu\right)^k w_i}{n - \nu},}
where \eqn{\nu} is the \sQuote{used df}, provided by the user to adjust the denominator.
(Typical values are 0 or 1.)
The weighted kth standardized moment is the central moment divided by the second central moment
to the \eqn{k/2} power:
\deqn{\tilde{\mu}_k = \frac{\mu_k}{\mu_2^{k/2}}.}
The (centered) rth cumulant, for \eqn{r \ge 2} is then computed using the formula of Willink, namely
\deqn{\kappa_r = \mu_r - \sum_{j=0}^{r - 2} {r - 1 \choose j} \mu_j \kappa {r-j}.}
The standardized rth cumulant is the rth centered cumulant divided by \eqn{\mu_2^{r/2}}.
}
\note{
The first centered (and standardized) moment is often defined to be identically 0. Instead \code{cent_moments}
and \code{std_moments} returns the mean. 
Similarly, the second standardized moments defined to be identically 1; \code{std_moments} instead returns the standard
deviation. The reason is that a user can always decide to ignore the results and fill in a 0 or 1 as they need, but 
could not efficiently compute the mean and standard deviation from scratch if we discard it.
The antepenultimate element of the output of \code{std_cumulants} is not a one, even though that \sQuote{should} be
the standardized second cumulant.

The antepenultimate element of the output of \code{cent_moments}, \code{cent_cumulants} and \code{std_cumulants} is the \emph{variance},
not the standard deviation. All other code return the standard deviation in that place.

The kurtosis is \emph{excess kurtosis}, with a 3 subtracted, and should be nearly zero
for Gaussian input.

The term 'centered cumulants' is redundant. The intent was to avoid possible collision with existing code named 'cumulants'.

The moment computations provided by fromo are 
numerically robust, but will often \emph{not} provide the
same results as the 'standard' implementations,
due to differences in roundoff. We make every attempt to balance
speed and robustness. User assumes all risk from using
the fromo package.

Note that when weights are given, they are treated as replication weights.
This can have subtle effects on computations which require minimum
degrees of freedom, since the sum of weights will be compared to
that minimum, not the number of data points. Weight values
(much) less than 1 can cause computations to return \code{NA}
somewhat unexpectedly due to this condition, while values greater
than one might cause the computation to spuriously return a value
with little precision.
}
\examples{
x <- rnorm(1e5)
sd3(x)[1] - sd(x)
skew4(x)[4] - length(x)
skew4(x)[3] - mean(x)
skew4(x)[2] - sd(x)
if (require(moments)) {
  skew4(x)[1] - skewness(x)
}


# check 'robustness'; only the mean should change:
kurt5(x + 1e12) - kurt5(x)
# check speed
if (require(microbenchmark) && require(moments)) {
  dumbk <- function(x) { c(kurtosis(x) - 3.0,skewness(x),sd(x),mean(x),length(x)) }
  set.seed(1234)
  x <- rnorm(1e6)
  print(kurt5(x) - dumbk(x))
  microbenchmark(dumbk(x),kurt5(x),times=10L)
}
y <- std_moments(x,6)
cml <- cent_cumulants(x,6)
std <- std_cumulants(x,6)

# check that skew matches moments::skewness
if (require(moments)) {
    set.seed(1234)
    x <- rnorm(1000)
    resu <- fromo::skew4(x)

    msku <- moments::skewness(x)
    stopifnot(abs(msku - resu[1]) < 1e-14)
}

# check skew vs e1071 skewness, which has a different denominator
if (require(e1071)) {
    set.seed(1234)
    x <- rnorm(1000)
    resu <- fromo::skew4(x)

    esku <- e1071::skewness(x,type=3)
    nobs <- resu[4]
    stopifnot(abs(esku - resu[1] * ((nobs-1)/nobs)^(3/2)) < 1e-14)

    # similarly:
    resu <- fromo::std_moments(x,max_order=3,used_df=0)
    stopifnot(abs(esku - resu[1] * ((nobs-1)/nobs)^(3/2)) < 1e-14)
}

}
\references{
Terriberry, T. "Computing Higher-Order Moments Online."
\url{http://people.xiph.org/~tterribe/notes/homs.html}

J. Bennett, et. al., "Numerically Stable, Single-Pass, 
Parallel Statistics Algorithms," Proceedings of IEEE
International Conference on Cluster Computing, 2009.
\url{https://www.semanticscholar.org/paper/Numerically-stable-single-pass-parallel-statistics-Bennett-Grout/a83ed72a5ba86622d5eb6395299b46d51c901265}

Cook, J. D. "Accurately computing running variance."
\url{http://www.johndcook.com/standard_deviation.html}

Cook, J. D. "Comparing three methods of computing 
standard deviation."
\url{http://www.johndcook.com/blog/2008/09/26/comparing-three-methods-of-computing-standard-deviation}

Willink, R.  "Relationships Between Central Moments and Cumulants, with Formulae for the Central Moments of Gamma Distributions."
Communications in Statistics - Theory and Methods, 32 no 4 (2003): 701-704.
\url{https://doi.org/10.1081/STA-120018823}
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}
}
