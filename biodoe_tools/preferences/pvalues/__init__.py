import numpy as np


def sign(x):
    return 2 * int(x >= 0) - 1


def select(arr):
    return [0, arr.max(), arr.min()][sign(arr.mean())]


def asterisk(p: float) -> str:
    if np.isnan(p):
        return "N/A"
    elif p >= 0.05:
        return "N.S."
    elif 0.01 <= p < 0.05:
        return "*"
    elif 0.001 <= p < 0.01:
        return "**"
    else:
        return "***"


def p_format(p: float, digit: int = 3) -> str:
    if np.isnan(p):
        return ""
    else:
        p_str = f"p={round(p, digit)}" if p >= 0.001 else "p<0.001"
        if len(p_str) != digit + len("p=0."):
            p_str = (p_str + "0" * (digit - 1))[: digit + len("p=0.")]
        return "\n(" + p_str + ")"


__all__ = [
    sign,
    select,
    asterisk,
    p_format,
]
