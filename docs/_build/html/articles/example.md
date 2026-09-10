# BioDOE Vignette

## This is a Mock Vignette

- Manuscripts written within `biodoe_rtools` are converted to HTML using
  `pkgdown` and published at
  <https://biodoe.readthedocs.io/en/latest/r_api/>.
- Because these files are somewhat isolated from the documentation built
  by Sphinx, we do not actively recommend creating vignettes other than
  standard `.R` script documentation (e.g., using `roxygen2`). (You can
  achieve the same functionality using `.ipynb` files, which can be
  integrated and built seamlessly with Sphinx).
- However, as demonstrated in this file, you can still add a vignette by
  creating an `.Rmd` file including YAML header tags.
- Like any other `.Rmd` file, you can write your content using standard
  Markdown (`.md`) syntax while embedding R code inside code blocks.
  Please use this feature for purposes such as creating tutorials for
  your R scripts.

## Example

### Polynomial Ring

\
`sca_`` ``<-`` ``function``(``a``, ``f``)`` ``{`\
`  ``function``(``x``)`` ``a`` ``*`` ``f``(``x``)`\
`}`\
\
`add_`` ``<-`` ``function``(``fp``, ``fq``)`` ``{`\
`  ``function``(``x``)`` ``fp``(``x``)`` ``+`` ``fq``(``x``)`\
`}`\
\
`mul_`` ``<-`` ``function``(``fp``, ``fq``)`` ``{`\
`  ``function``(``x``)`` ``fp``(``x``)`` ``*`` ``fq``(``x``)`\
`}`\
\
`f1`` ``<-`` ``function``(``x``)`` ``{`\
`  ``x`\
`}`\
\
`f2`` ``<-`` ``function``(``x``)`` ``{`\
`  ``x``^``2`\
`}`\
\
`f3`` ``<-`` ``function``(``x``)`` ``{`\
`  ``x``^``3`\
`}`\
\
`v`` ``<-`` ``1234`\
`w`` ``<-`` ``5678`

#### Scalar Multiplication

##### Closure

\
[`typeof`](https://rdrr.io/r/base/typeof.html)`(``sca_``(``w``, ``f2``)``(``v``)``)`\
`#> [1] "double"`\
[`typeof`](https://rdrr.io/r/base/typeof.html)`(``sca_``(``v``, ``f2``)``(``w``)``)`\
`#> [1] "double"`

#### Summation

##### Closure

\
[`typeof`](https://rdrr.io/r/base/typeof.html)`(``add_``(``f1``, ``f2``)``(``v``)``)`\
`#> [1] "double"`\
[`typeof`](https://rdrr.io/r/base/typeof.html)`(``add_``(``f1``, ``f2``)``(``w``)``)`\
`#> [1] "double"`

##### Commutativity

\
`add_``(``f1``, ``f2``)``(``v``)`` ``==`` ``add_``(``f2``, ``f1``)``(``v``)`\
`#> [1] TRUE`\
`add_``(``f1``, ``f2``)``(``w``)`` ``==`` ``add_``(``f2``, ``f1``)``(``w``)`\
`#> [1] TRUE`

##### Associativity

\
`add_``(``add_``(``f1``, ``f2``)``, ``f3``)``(``v``)`` ``==`` ``add_``(``f1``, ``add_``(``f2``, ``f3``)``)``(``v``)`\
`#> [1] TRUE`\
`add_``(``add_``(``f1``, ``f2``)``, ``f3``)``(``w``)`` ``==`` ``add_``(``f1``, ``add_``(``f2``, ``f3``)``)``(``w``)`\
`#> [1] TRUE`

##### Identity Element

\
`fis`` ``<-`` ``function``(``x``)`` ``{`\
`  ``0`\
`}`\
`add_``(``f1``, ``fis``)``(``v``)`` ``==`` ``f1``(``v``)`\
`#> [1] TRUE`\
`add_``(``f1``, ``fis``)``(``w``)`` ``==`` ``f1``(``w``)`\
`#> [1] TRUE`\
`add_``(``f2``, ``fis``)``(``v``)`` ``==`` ``f2``(``v``)`\
`#> [1] TRUE`\
`add_``(``f2``, ``fis``)``(``w``)`` ``==`` ``f2``(``w``)`\
`#> [1] TRUE`

##### Inverse Element

\
`get_inverse`` ``<-`` ``function``(``f``)`` ``{`\
`  ``sca_``(``-``1``, ``f``)`\
`}`\
`add_``(``f1``, ``get_inverse``(``f1``)``)``(``v``)`` ``==`` ``fis``(``v``)`\
`#> [1] TRUE`\
`add_``(``f1``, ``get_inverse``(``f1``)``)``(``w``)`` ``==`` ``fis``(``w``)`\
`#> [1] TRUE`\
`add_``(``f2``, ``get_inverse``(``f2``)``)``(``v``)`` ``==`` ``fis``(``v``)`\
`#> [1] TRUE`\
`add_``(``f2``, ``get_inverse``(``f2``)``)``(``w``)`` ``==`` ``fis``(``w``)`\
`#> [1] TRUE`

#### Multiplication

##### Closure

\
[`typeof`](https://rdrr.io/r/base/typeof.html)`(``mul_``(``f1``, ``f2``)``(``v``)``)`\
`#> [1] "double"`\
[`typeof`](https://rdrr.io/r/base/typeof.html)`(``mul_``(``f1``, ``f2``)``(``w``)``)`\
`#> [1] "double"`

##### Commutativity

\
`mul_``(``f1``, ``f2``)``(``v``)`` ``==`` ``mul_``(``f2``, ``f1``)``(``v``)`\
`#> [1] TRUE`\
`mul_``(``f1``, ``f2``)``(``w``)`` ``==`` ``mul_``(``f2``, ``f1``)``(``w``)`\
`#> [1] TRUE`

##### Associativity

\
`mul_``(``mul_``(``f1``, ``f2``)``, ``f3``)``(``v``)`` ``==`` ``mul_``(``f1``, ``mul_``(``f2``, ``f3``)``)``(``v``)`\
`#> [1] TRUE`\
`mul_``(``mul_``(``f1``, ``f2``)``, ``f3``)``(``w``)`` ``==`` ``mul_``(``f1``, ``mul_``(``f2``, ``f3``)``)``(``w``)`\
`#> [1] TRUE`

##### Identity Element

\
`fim`` ``<-`` ``function``(``x``)`` ``{`\
`  ``1`\
`}`\
`mul_``(``f1``, ``fim``)``(``v``)`` ``==`` ``f1``(``v``)`\
`#> [1] TRUE`\
`mul_``(``f1``, ``fim``)``(``w``)`` ``==`` ``f1``(``w``)`\
`#> [1] TRUE`\
`mul_``(``f2``, ``fim``)``(``v``)`` ``==`` ``f2``(``v``)`\
`#> [1] TRUE`\
`mul_``(``f2``, ``fim``)``(``w``)`` ``==`` ``f2``(``w``)`\
`#> [1] TRUE`

------------------------------------------------------------------------

This project was created with
[Cookiecutter](https://github.com/cookiecutter/cookiecutter) and
[BasalCell](https://github.com/yo-aka-gene/BasalCell) version 0.4.5
