# Generate simulated single-cell RNA-seq count data

Generates synthetic single-cell RNA-seq count data with multiple cell
groups using the Splatter simulation framework.

## Usage

``` r
generate_clusters(
  n_genes,
  n_cells,
  group_prob,
  de_prob,
  dropout_mid,
  random_state
)
```

## Arguments

- n_genes:

  Integer. Number of genes to simulate.

- n_cells:

  Integer. Number of cells to simulate.

- group_prob:

  Numeric vector. Relative probabilities of the simulated cell groups.

- de_prob:

  Numeric scalar. Probability that a gene is differentially expressed
  between simulated groups.

- dropout_mid:

  Numeric scalar. Midpoint parameter controlling the
  expression-dependent dropout model used by Splatter.

- random_state:

  Integer. Random seed used for reproducible simulation.

## Value

A numeric matrix of simulated raw counts, with genes as rows and cells
as columns.

## Details

The function configures a Splatter model using the specified number of
genes and cells, group probabilities, differential-expression
probability, and dropout parameters. Simulation is performed with the
\`"groups"\` method.

The returned matrix contains simulated raw count values, with genes in
rows and cells in columns.

## Examples

``` r
counts <- generate_clusters(
  n_genes = 100,
  n_cells = 200,
  group_prob = c(0.5, 0.5),
  de_prob = 0.1,
  dropout_mid = 0,
  random_state = 0
)
```
