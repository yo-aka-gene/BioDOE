from pathlib import Path

import numpy as np
import rpy2.robjects as ro
from rpy2.robjects import numpy2ri

from ._abstract import DOE, DesignMatrix
from ._fullfact import FullFactorial

numpy2ri.activate()


R_SCRIPT = Path(__file__).with_name("d_optimization.R")
R_FUNC_NAME = "d_optimize_core"

_R_FUNC = None


# Load the R implementation.
with R_SCRIPT.open() as f:
    ro.r(f.read())


def _initialize_r_func():
    """Initialize the R function lazily."""
    global _R_FUNC

    if _R_FUNC is None:
        _R_FUNC = ro.r[R_FUNC_NAME]


def d_optimize(
    dsmatrix: DesignMatrix,
    n_add: int = 0,
    n_total: int | None = None,
    random_state: int = 0,
) -> np.ndarray:
    """Augment a design matrix using D-optimal design.

    Parameters
    ----------
    dsmatrix
        Original design matrix.
    n_add
        Number of additional trials to select.
    n_total
        Total number of trials after augmentation. Used only when
        ``n_add == 0``.
    random_state
        Random seed passed to the R implementation.

    Returns
    -------
    np.ndarray
        D-optimized design matrix.
    """
    if n_add == 0 and n_total is not None and isinstance(n_total, int):
        assert n_total >= dsmatrix.shape[0], (
            f"Invalid n_total value: n_total={n_total} should be an integer "
            "larger than or equal to the original number of trials "
            f"(>={dsmatrix.shape[0]})."
        )
        n_add = n_total - dsmatrix.shape[0]

    assert (
        isinstance(n_add, (int, np.integer)) and n_add >= 0
    ), f"Invalid n_add value: n_add={n_add} should be an integer >= 0."

    n_factor = dsmatrix.shape[1]

    _initialize_r_func()

    optimized = _R_FUNC(
        dsmatrix=dsmatrix.values,
        candidate=FullFactorial().get_exmatrix(n_factor).values,
        n_add=n_add,
        random_state=random_state,
    )

    # NOTE:
    # The historical implementation transposes the matrix returned through
    # rpy2. This behavior is preserved here to maintain compatibility with
    # the analysis used for the manuscript.
    #
    # Whether the transpose is intrinsically required by the R/Python matrix
    # conversion should be validated separately before changing this behavior.
    return np.asarray(optimized).T


class DOptimization(DOE):
    def __init__(self, base: DOE, name: str | None = None):
        super().__init__(name="D-optimized " + base().name if name is None else name)
        self.base = base

    def get_exmatrix(
        self,
        n_factor: int,
        n_add: int = 0,
        n_total: int | None = None,
        random_state: int = 0,
        **kwargs,
    ) -> DesignMatrix:
        optimized = d_optimize(
            self.base().get_exmatrix(n_factor),
            n_add=n_add,
            n_total=n_total,
            random_state=random_state,
        )

        self.title = (
            f"{self.name} design with {len(optimized)} trials " f"(n={n_factor})"
        )

        return DesignMatrix(optimized)

    def __call__(self):
        return super().__call__()


def d_criterion(X: np.ndarray) -> float:
    """Calculate the D-optimality criterion."""
    return np.linalg.det(np.linalg.inv(X.T @ X))
