### splat.R ###

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
