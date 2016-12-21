GLMNET (averissimo fork)
================

-   [Load local glmnet for tests](#load-local-glmnet-for-tests)
    -   [x1](#x1)
    -   [x10](#x10)
    -   [x100](#x100)
-   [Load glmnet and doMC library](#load-glmnet-and-domc-library)
    -   [x1](#x1-1)
    -   [x10](#x10-1)
    -   [x100](#x100-1)
-   [Session Information](#session-information)

This is a fork that implements mclapply instead of foreach in cv.glmnet. With `~21%` gains when adding parallization to `cv.coxnet`.

The big improvement that can be seen in the tests below, is when adding `mclapply` in `cv.coxnet` for calculating deviances. It goes from `55s` to `43s` with this test dataset (`21%` average improvement).

Load local glmnet for tests
===========================

    ## Loading glmnet

    ## Re-compiling glmnet

    ## '/usr/local/lib/R/bin/R' --no-site-file --no-environ --no-save  \
    ##   --no-restore --quiet CMD INSTALL  \
    ##   '/home/averissimo/work/rpackage-glmnet'  \
    ##   --library='/tmp/RtmpgZWBdJ/devtools_install_203476d55d73' --no-R  \
    ##   --no-data --no-help --no-demo --no-inst --no-docs --no-exec  \
    ##   --no-multiarch --no-test-load --preclean

    ## 

    ## Loading required package: Matrix

    ## Loading required package: parallel

    ## Loaded glmnet 3.0-99

Use dataset from glmnet package
-------------------------------

``` r
data("CoxExample")
ntimes <- 10
```

x1
--

``` r
new.x <- matrix(rep(x, 1), nrow = 1000, ncol = 30)
microbenchmark::microbenchmark(
  glmnet::cv.glmnet(new.x, y, family = 'cox', mc.cores = 14)
  , times = 100)
```

    ## Unit: milliseconds
    ##                       r      min      lq     mean   median       uq      max neval
    ##  glmnet::cv.glmnet(...) 170.2662 174.367 181.2784 179.5234 184.1079 218.6926   100

x10
---

``` r
new.x <- matrix(rep(x, 10), nrow = 1000, ncol = 300)
new.x <- new.x + rnorm(length(new.x))
microbenchmark::microbenchmark(
  glmnet::cv.glmnet(new.x, y, family = 'cox', mc.cores = 14)
  , times = ntimes)
```

    ## Unit: seconds
    ##                    expr      min       lq     mean   median       uq      max neval
    ##  glmnet::cv.glmnet(...) 1.262886 1.408038 1.478927 1.433793 1.572727 1.793015    10

x100
----

``` r
new.x <- matrix(rep(x, 100), nrow = 1000, ncol = 3000)
new.x <- new.x + rnorm(length(new.x))
microbenchmark::microbenchmark(
  glmnet::cv.glmnet(new.x, y, family = 'cox', mc.cores = 14)
  , times = ntimes)
```

    ## Unit: seconds
    ##                    expr      min       lq     mean   median       uq      max neval
    ##  glmnet::cv.glmnet(...) 41.66963 41.96889 42.92629 43.02708 43.37187 44.70409    10

Unload libraries
----------------

``` r
devtools::unload('.')
```

Load glmnet and doMC library
============================

Dataset is the same as before.

``` r
library(doMC)
```

    ## Loading required package: foreach

    ## Loading required package: iterators

``` r
registerDoMC(cores=14)
library(glmnet)
```

    ## Loaded glmnet 2.0-5

x1
--

``` r
new.x <- matrix(rep(x, 1), nrow = 1000, ncol = 30)
microbenchmark::microbenchmark(
  glmnet::cv.glmnet(new.x, y, family = 'cox', parallel = T)
  , times = 100)
```

    ## Unit: milliseconds
    ##                    expr      min       lq     mean  median      uq      max neval
    ##  glmnet::cv.glmnet(...) 277.5171 283.9814 288.4373 287.139 291.233 323.2931   100

x10
---

``` r
new.x <- matrix(rep(x, 10), nrow = 1000, ncol = 300)
new.x <- new.x + rnorm(length(new.x))
microbenchmark::microbenchmark(
  glmnet::cv.glmnet(new.x, y, family = 'cox', parallel = T)
  , times = ntimes)
```

    ## Unit: seconds
    ##                    expr      min       lq     mean   median       uq      max neval
    ##  glmnet::cv.glmnet(...) 1.654761 1.682095 1.727815 1.726412 1.772485 1.796287    10

x100
----

``` r
new.x <- matrix(rep(x, 100), nrow = 1000, ncol = 3000)
new.x <- new.x + rnorm(length(new.x))
microbenchmark::microbenchmark(
  glmnet::cv.glmnet(new.x, y, family = 'cox', parallel = T)
  , times = ntimes)
```

    ## Unit: seconds
    ##                    expr      min      lq     mean   median       uq      max neval
    ##  glmnet::cv.glmnet(...) 54.16612 54.9759 57.67544 55.78311 61.68253 65.28653    10

Unload glmnet
-------------

``` r
unload(inst('glmnet'))
```

Session Information
===================

``` r
sessionInfo()
```

    ## R version 3.3.2 (2016-10-31)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Debian GNU/Linux 8 (jessie)
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=C             
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] parallel  stats     graphics  grDevices utils     datasets  methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ## [1] doMC_1.3.4             iterators_1.0.8        foreach_1.4.3         
    ## [4] Matrix_1.2-7.1         futile.logger_1.4.3    devtools_1.12.0       
    ## [7] microbenchmark_1.4-2.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.8          compiler_3.3.2       plyr_1.8.4          
    ##  [4] futile.options_1.0.0 tools_3.3.2          digest_0.6.10       
    ##  [7] evaluate_0.10        memoise_1.0.0        tibble_1.2          
    ## [10] gtable_0.2.0         lattice_0.20-34      yaml_2.1.14         
    ## [13] mvtnorm_1.0-5        withr_1.0.2          stringr_1.1.0       
    ## [16] knitr_1.15.1         roxygen2_5.0.1       rprojroot_1.1       
    ## [19] grid_3.3.2           survival_2.40-1      rmarkdown_1.2       
    ## [22] multcomp_1.4-6       TH.data_1.0-7        ggplot2_2.2.0       
    ## [25] lambda.r_1.1.9       magrittr_1.5         MASS_7.3-45         
    ## [28] backports_1.0.4      scales_0.4.1         codetools_0.2-15    
    ## [31] htmltools_0.3.5      splines_3.3.2        assertthat_0.1      
    ## [34] colorspace_1.3-1     sandwich_2.3-4       stringi_1.1.2       
    ## [37] lazyeval_0.2.0       munsell_0.4.3        zoo_1.7-13
