### dunnett_power.R ###

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
