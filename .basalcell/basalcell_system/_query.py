from typing import List

import polars as pl

from ._read import predetermined_pkg_groups, read_database, read_lookup


def resolve(key: List[str]) -> List[str]:
    return read_lookup().filter(pl.col("query").is_in(key))["name"].to_list()


def query(key: List[str]) -> pl.DataFrame:
    return read_database().filter(pl.col("name").is_in(resolve(key)))


def query_essentials() -> pl.DataFrame:
    master = predetermined_pkg_groups()
    key = master["env"] + master["pypkgs"]
    devs = master["pydevs"] + master["rdevs"]
    return read_database().filter(
        (pl.col("name").is_in(key))
        & (~pl.col("name").is_in(devs))
        & (pl.col("language") != "System")
    )


def print_renv_targets() -> None:
    pkgs = read_database().filter(pl.col("installation") == "renv")["name"].to_list()
    print(" ".join(pkgs))
