import anndata as ad
import numpy as np
import rpy2.robjects as ro
from rpy2.robjects import numpy2ri

from biodoe_tools.preferences import R_TOOLS

R_SCRIPT = R_TOOLS / "splat.R"
R_FUNC_NAME = "generate_clusters"

_R_FUNC = None


numpy2ri.activate()


with R_SCRIPT.open() as f:
    ro.r(f.read())


def _initialize_r_func():
    global _R_FUNC

    if _R_FUNC is None:
        _R_FUNC = ro.r[R_FUNC_NAME]


def generate_clusters(
    n_genes: int,
    n_cells: int,
    group_prob: np.ndarray,
    de_prob: float,
    dropout_mid: float,
    random_state: int = 0,
) -> ad.AnnData:
    _initialize_r_func()

    if group_prob.sum() != 1:
        group_prob /= group_prob.sum()

    count = _R_FUNC(
        n_genes=n_genes,
        n_cells=n_cells,
        group_prob=group_prob,
        de_prob=de_prob,
        dropout_mid=dropout_mid,
        random_state=random_state,
    )

    return ad.AnnData(X=np.asarray(count).T)
