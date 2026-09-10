import numpy as np
import pandas as pd
import rpy2.robjects as ro
from rpy2.robjects import numpy2ri

from biodoe_tools.preferences import R_TOOLS

from ._abstract import AbstractSimulator
from ._anova_power import sigma2
from ._dunnett import Dunnett

R_SCRIPT = R_TOOLS / "dunnett_power.R"
R_FUNC_NAME = "dunnett_power_analytic"

_R_FUNC = None


numpy2ri.activate()


with R_SCRIPT.open() as f:
    ro.r(f.read())


def _initialize_r_func():
    global _R_FUNC

    if _R_FUNC is None:
        _R_FUNC = ro.r[R_FUNC_NAME]


def dunnett_power(
    simulation: AbstractSimulator,
    alpha: float = 0.05,
    power_type: str = "per_comparison_power",
) -> pd.DataFrame:
    assert power_type in [
        "per_comparison_power",
        "familywise_power",
    ], (
        "power_type should be either "
        "'per_comparison_power' or 'familywise_power', "
        f"got {power_type}"
    )

    dunnett_model = Dunnett(simulation)

    if dunnett_model.n_rep > 1:
        dunnett_model.summary()
        _initialize_r_func()

        result = _R_FUNC(
            mu0=float(dunnett_model.baseline.y),
            mu_t=dunnett_model.coef.y.values.ravel(),
            n0=dunnett_model.n_rep,
            nt=dunnett_model.n_rep,
            sigma=np.sqrt(sigma2(dunnett_model.simulation).item()),
            alpha=alpha,
        )

        power_dict = dict(zip(result.names, result))

    else:
        power_dict = {
            "df": np.nan,
            "crit": np.nan,
            "per_comparison_power": ([np.nan] * (len(dunnett_model.group) - 1)),
            "familywise_power": np.nan,
        }

    terms = [value for value in dunnett_model.group if value != "all factors"]

    return pd.DataFrame(
        {
            "term": terms,
            "power": power_dict[power_type],
            "model": ["Dunnett"] * len(terms),
            "n_rep": [dunnett_model.n_rep] * len(terms),
        }
    )
