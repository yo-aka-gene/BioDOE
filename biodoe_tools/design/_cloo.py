import numpy as np

from ._abstract import DOE, DesignMatrix


class CLOO(DOE):
    def __init__(self, name: str = "C+LOO"):
        super().__init__(name=name)

    def get_exmatrix(self, n_factor: int) -> DesignMatrix:
        super().get_exmatrix(n_factor=n_factor)
        res = np.vstack(
            [
                np.ones(n_factor),
                np.ones((n_factor, n_factor)) - 2 * np.eye(n_factor),
            ]
        )
        return DesignMatrix(res)

    def __call__(self):
        return super().__call__()
