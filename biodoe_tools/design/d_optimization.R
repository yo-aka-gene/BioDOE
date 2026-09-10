### d_optimization.R ###

d_optimize_core <- function(
    dsmatrix,
    candidate,
    n_add,
    random_state) {
  set.seed(random_state)

  optimized <- AlgDesign::optFederov(
    ~.,
    data = rbind(dsmatrix, candidate),
    nTrials = nrow(dsmatrix) + n_add,
    criterion = "D",
    augment = TRUE,
    rows = seq_len(nrow(dsmatrix)),
    maxIteration = choose(nrow(candidate), n_add)
  )

  optimized$design
}
