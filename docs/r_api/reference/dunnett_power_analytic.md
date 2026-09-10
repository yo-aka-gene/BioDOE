# Calculate analytical power for Dunnett's multiple-comparison test

Calculates per-comparison and familywise statistical power for multiple
treatment-versus-control comparisons using Dunnett's test.

## Usage

``` r
dunnett_power_analytic(mu0, mu_t, n0, nt, sigma, alpha)
```

## Arguments

- mu0:

  Numeric scalar. Expected mean of the control group.

- mu_t:

  Numeric vector. Expected means of the treatment groups.

- n0:

  Integer. Sample size of the control group.

- nt:

  Integer. Sample size of each treatment group.

- sigma:

  Numeric scalar. Common residual standard deviation.

- alpha:

  Numeric scalar. Familywise type I error rate.

## Value

A named list containing:

- df:

  Residual degrees of freedom.

- crit:

  Two-sided Dunnett critical value.

- per_comparison_power:

  Numeric vector of power values for individual treatment-versus-control
  comparisons.

- familywise_power:

  Numeric scalar giving the probability that at least one comparison
  exceeds the Dunnett critical threshold.

## Details

The function assumes a single control group and multiple treatment
groups with a common residual standard deviation. Each treatment group
is assumed to have the same sample size specified by \`nt\`.

Correlations among treatment-versus-control contrasts are explicitly
accounted for because all contrasts share the same control group. The
two-sided Dunnett critical value is obtained from the multivariate t
distribution using \`mvtnorm::qmvt()\`.

Per-comparison power is calculated from the corresponding noncentral t
distributions. Familywise power is defined as the probability that at
least one treatment-versus-control comparison exceeds the Dunnett
critical threshold.

## Examples

``` r
dunnett_power_analytic(
  mu0 = 0,
  mu_t = c(0.5, 1.0, 1.5),
  n0 = 5,
  nt = 5,
  sigma = 1,
  alpha = 0.05
)
#> $df
#> [1] 16
#>
#> $crit
#> [1] 2.590428
#>
#> $per_comparison_power
#> [1] 0.05528608 0.18898921 0.43625421
#>
#> $familywise_power
#> [1] 0.4818826
#>
```
