### dunnett_power.R ###

#' Calculate analytical power for Dunnett's multiple-comparison test
#'
#' @description
#' Calculates per-comparison and familywise statistical power for multiple
#' treatment-versus-control comparisons using Dunnett's test.
#'
#' @details
#' The function assumes a single control group and multiple treatment groups
#' with a common residual standard deviation. Each treatment group is assumed
#' to have the same sample size specified by `nt`.
#'
#' Correlations among treatment-versus-control contrasts are explicitly
#' accounted for because all contrasts share the same control group. The
#' two-sided Dunnett critical value is obtained from the multivariate
#' t distribution using `mvtnorm::qmvt()`.
#'
#' Per-comparison power is calculated from the corresponding noncentral
#' t distributions. Familywise power is defined as the probability that
#' at least one treatment-versus-control comparison exceeds the Dunnett
#' critical threshold.
#'
#' @param mu0 Numeric scalar. Expected mean of the control group.
#' @param mu_t Numeric vector. Expected means of the treatment groups.
#' @param n0 Integer. Sample size of the control group.
#' @param nt Integer. Sample size of each treatment group.
#' @param sigma Numeric scalar. Common residual standard deviation.
#' @param alpha Numeric scalar. Familywise type I error rate.
#'
#' @return A named list containing:
#' \describe{
#'   \item{df}{Residual degrees of freedom.}
#'   \item{crit}{Two-sided Dunnett critical value.}
#'   \item{per_comparison_power}{
#'     Numeric vector of power values for individual
#'     treatment-versus-control comparisons.
#'   }
#'   \item{familywise_power}{
#'     Numeric scalar giving the probability that at least one comparison
#'     exceeds the Dunnett critical threshold.
#'   }
#' }
#'
#' @export
#'
#' @examples
#' dunnett_power_analytic(
#'   mu0 = 0,
#'   mu_t = c(0.5, 1.0, 1.5),
#'   n0 = 5,
#'   nt = 5,
#'   sigma = 1,
#'   alpha = 0.05
#' )
dunnett_power_analytic <- function(
    mu0,
    mu_t,
    n0,
    nt,
    sigma,
    alpha) {
  k <- length(mu_t)
  ni <- rep(nt, k)

  se <- sqrt(1 / n0 + 1 / ni) * sigma
  ncp <- as.numeric((mu_t - mu0) / se)

  # Calculate the residual degrees of freedom from the total sample size
  # and the number of treatment groups, including the control group.
  df <- n0 + sum(ni) - (k + 1)

  # Construct the correlation matrix for treatment-versus-control
  # contrasts. Correlations arise because all contrasts share the same
  # control group.
  corr_matrix <- diag(k)

  for (i in seq_len(k)) {
    for (j in seq_len(k)) {
      if (i != j) {
        corr_matrix[i, j] <- (1 / n0) /
          sqrt(
            (1 / ni[i] + 1 / n0) *
              (1 / ni[j] + 1 / n0)
          )
      }
    }
  }

  # Determine the two-sided Dunnett critical value that controls the
  # familywise type I error rate at the specified alpha level.
  q <- mvtnorm::qmvt(
    p = 1 - alpha,
    tail = "both.tails",
    df = df,
    corr = corr_matrix
  )$quantile

  crit <- as.numeric(q)

  # Calculate the power of each individual treatment-versus-control
  # comparison under the corresponding noncentral t distribution.
  pc_power <- 1 - (
    stats::pt(crit, df, ncp) -
      stats::pt(-crit, df, ncp)
  )

  # Calculate familywise power as the probability that at least one
  # treatment-versus-control comparison exceeds the Dunnett threshold.
  keep_prob <- mvtnorm::pmvt(
    lower = rep(-crit, k),
    upper = rep(crit, k),
    df = df,
    corr = corr_matrix,
    delta = ncp
  )

  fw_power <- 1 - as.numeric(keep_prob)

  list(
    df = df,
    crit = crit,
    per_comparison_power = pc_power,
    familywise_power = fw_power
  )
}
