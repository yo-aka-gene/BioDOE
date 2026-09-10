# Augment an existing design using D-optimality

Selects additional experimental runs from a candidate set to augment an
existing design matrix using D-optimal experimental design.

## Usage

``` r
d_optimize_core(dsmatrix, candidate, n_add, random_state)
```

## Arguments

- dsmatrix:

  A matrix or data frame containing the existing design runs that must
  be retained.

- candidate:

  A matrix or data frame containing candidate runs that may be added to
  the existing design.

- n_add:

  Integer. Number of candidate runs to add to the existing design.

- random_state:

  Integer. Random seed used by the optimization procedure.

## Value

A data frame containing the augmented D-optimal design returned by
\`AlgDesign::optFederov()\`.

## Details

The existing design matrix is treated as fixed, and \`n_add\` additional
runs are selected from \`candidate\` using \`AlgDesign::optFederov()\`.

Optimization uses the D-optimality criterion, which seeks a design that
maximizes the information content of the fitted linear model through the
determinant of its information matrix. The existing rows are retained
during optimization by using augmented-design mode.

## Examples

``` r
existing <- data.frame(
  x1 = c(-1, 1),
  x2 = c(-1, 1)
)

candidate <- data.frame(
  x1 = c(-1, -1, 1, 1),
  x2 = c(-1, 1, -1, 1)
)

d_optimize_core(
  dsmatrix = existing,
  candidate = candidate,
  n_add = 1,
  random_state = 0
)
#>   x1 x2
#> 1 -1 -1
#> 2  1  1
#> 5  1 -1
```
