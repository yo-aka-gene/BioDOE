import numpy as np
from sklearn.metrics import accuracy_score, cohen_kappa_score


def aptitude_score(res, gt):
    if res.isna().all():
        return np.nan
    elif gt.unique().size == 1:
        return accuracy_score(res, gt)
    else:
        return cohen_kappa_score(res, gt, weights="linear")


kappa = aptitude_score
