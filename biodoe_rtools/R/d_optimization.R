### d_optimization.R ###

#' Augment an existing design using D-optimality
#'
#' @description
#' Selects additional experimental runs from a candidate set to augment an
#' existing design matrix using D-optimal experimental design.
#'
#' @details
#' The existing design matrix is treated as fixed, and `n_add` additional
#' runs are selected from `candidate` using `AlgDesign::optFederov()`.
#'
#' Optimization uses the D-optimality criterion, which seeks a design that
#' maximizes the information content of the fitted linear model through the
#' determinant of its information matrix. The existing rows are retained
#' during optimization by using augmented-design mode.
#'
#' @param dsmatrix A matrix or data frame containing the existing design runs
#'   that must be retained.
#' @param candidate A matrix or data frame containing candidate runs that may
#'   be added to the existing design.
#' @param n_add Integer. Number of candidate runs to add to the existing design.
#' @param random_state Integer. Random seed used by the optimization procedure.
#'
#' @return A data frame containing the augmented D-optimal design returned by
#'   `AlgDesign::optFederov()`.
#'
#' @export
#'
#' @examples
#' existing <- data.frame(
#'   x1 = c(-1, 1),
#'   x2 = c(-1, 1)
#' )
#'
#' candidate <- data.frame(
#'   x1 = c(-1, -1, 1, 1),
#'   x2 = c(-1, 1, -1, 1)
#' )
#'
#' d_optimize_core(
#'   dsmatrix = existing,
#'   candidate = candidate,
#'   n_add = 1,
#'   random_state = 0
#' )
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
