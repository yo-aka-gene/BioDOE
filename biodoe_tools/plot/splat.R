### splat.R ###

#' Generate simulated single-cell RNA-seq count data
#'
#' @description
#' Generates synthetic single-cell RNA-seq count data with multiple cell groups
#' using the Splatter simulation framework.
#'
#' @details
#' The function configures a Splatter model using the specified number of genes
#' and cells, group probabilities, differential-expression probability, and
#' dropout parameters. Simulation is performed with the `"groups"` method.
#'
#' The returned matrix contains simulated raw count values, with genes in rows
#' and cells in columns.
#'
#' @param n_genes Integer. Number of genes to simulate.
#' @param n_cells Integer. Number of cells to simulate.
#' @param group_prob Numeric vector. Relative probabilities of the simulated
#'   cell groups.
#' @param de_prob Numeric scalar. Probability that a gene is differentially
#'   expressed between simulated groups.
#' @param dropout_mid Numeric scalar. Midpoint parameter controlling the
#'   expression-dependent dropout model used by Splatter.
#' @param random_state Integer. Random seed used for reproducible simulation.
#'
#' @return A numeric matrix of simulated raw counts, with genes as rows and
#'   cells as columns.
#'
#' @export
#'
#' @examples
#' counts <- generate_clusters(
#'   n_genes = 100,
#'   n_cells = 200,
#'   group_prob = c(0.5, 0.5),
#'   de_prob = 0.1,
#'   dropout_mid = 0,
#'   random_state = 0
#' )
generate_clusters <- function(
    n_genes,
    n_cells,
    group_prob,
    de_prob,
    dropout_mid,
    random_state) {
  set.seed(random_state)

  params <- splatter::newSplatParams()

  params <- splatter::setParams(
    params,
    nGenes = n_genes,
    batchCells = n_cells,
    group.prob = as.numeric(group_prob),
    de.prob = de_prob,
    dropout.type = "experiment",
    dropout.mid = dropout_mid,
    dropout.shape = -1
  )

  sim <- splatter::splatSimulate(
    params,
    method = "groups",
    verbose = FALSE
  )

  as.matrix(
    SummarizedExperiment::assay(sim, "counts")
  )
}
