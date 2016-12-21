---
title: "glmnet (averissimo fork)"
output: 
  github_document:
    toc: true
    dev: png
---



This is a fork that implements mclapply instead of foreach in cv.glmnet. With `~21%` gains when adding parallization to `cv.coxnet`.

The big improvement that can be seen in the tests below, is when adding `mclapply` in `cv.coxnet` for calculating deviances. It goes from `55s` to `43s` with this test dataset (`21%` average improvement).

# Load a common dataset


```r
data("CoxExample", package = 'glmnet')
# number of repetitions
ntimes      <- list()
ntimes$x1   <- 100
ntimes$x10  <- 100
ntimes$x100 <- 20
#
new.x <- matrix(rep(x, 100), nrow = 1000, ncol = 3000)
new.x <- new.x + rnorm(length(new.x))
#
n.cores <- 8
```

# Local glmnet for tests


```
## Loading glmnet
```

```
## Re-compiling glmnet
```

```
## '/usr/local/lib/R/bin/R' --no-site-file --no-environ --no-save  \
##   --no-restore --quiet CMD INSTALL  \
##   '/home/averissimo/work/rpackage-glmnet'  \
##   --library='/tmp/RtmpSXmJfc/devtools_install_496662db073e' --no-R  \
##   --no-data --no-help --no-demo --no-inst --no-docs --no-exec  \
##   --no-multiarch --no-test-load --preclean
```

```
## 
```

```
## Loading required package: Matrix
```

```
## Loading required package: parallel
```

```
## Loaded glmnet 3.0-99
```

## x1


```r
microbenchmark::microbenchmark(using.mclapply(30), times = ntimes$x1)
```

```
## Unit: milliseconds
##                expr      min       lq    mean   median       uq      max
##  using.mclapply(30) 142.8705 156.0469 166.097 167.1017 173.4015 218.7764
##  neval
##    100
```

## x10


```r
microbenchmark::microbenchmark(using.mclapply(300), times = ntimes$x10)
```

```
## Unit: seconds
##                 expr      min       lq     mean   median       uq      max
##  using.mclapply(300) 1.233631 1.281213 1.373691 1.341584 1.452456 1.711056
##  neval
##    100
```

## x100


```r
microbenchmark::microbenchmark(using.mclapply(3000), times = ntimes$x100)
```

```
## Unit: seconds
##                  expr      min       lq     mean   median       uq
##  using.mclapply(3000) 50.88917 51.57448 53.39826 53.09225 54.93561
##       max neval
##  57.72451    20
```

__Clean environment of local glmnet__


```r
devtools::unload('.')
#
```

# Cran's glmnet


```r
library(glmnet)
```

```
## Loading required package: foreach
```

```
## foreach: simple, scalable parallel programming from Revolution Analytics
## Use Revolution R for scalability, fault tolerance and more.
## http://www.revolutionanalytics.com
```

```
## Loaded glmnet 2.0-5
```

```r
library(doMC)
```

```
## Loading required package: iterators
```

```r
registerDoMC(cores = n.cores)
using.foreach <- function(var.num) {cv.glmnet(new.x[,seq(var.num)], y, family = 'cox', parallel = T)}
```

## x1


```r
microbenchmark::microbenchmark(using.foreach(30), times = ntimes$x1)
```

```
## Unit: milliseconds
##               expr      min       lq     mean   median       uq      max
##  using.foreach(30) 258.9872 271.3767 276.0517 275.0501 281.2301 303.6961
##  neval
##    100
```

## x10


```r
microbenchmark::microbenchmark(using.foreach(300), times = ntimes$x10)
```

```
## Unit: seconds
##                expr      min       lq     mean   median       uq      max
##  using.foreach(300) 1.656703 1.703302 1.744548 1.727183 1.747746 1.974714
##  neval
##    100
```

## x100


```r
microbenchmark::microbenchmark(using.foreach(3000), times = ntimes$x100)
```

```
## Unit: seconds
##                 expr      min       lq     mean   median       uq     max
##  using.foreach(3000) 61.73773 62.67206 63.39671 63.04967 64.02753 66.2204
##  neval
##     20
```

__Unload glmnet__


```r
unload(inst('glmnet'))
```

# Session Information


```r
sessionInfo()
```

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
## [7] microbenchmark_1.4-2.1 knitr_1.15.1          
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.8          magrittr_1.5         roxygen2_5.0.1      
##  [4] MASS_7.3-45          splines_3.3.2        munsell_0.4.3       
##  [7] colorspace_1.3-1     lattice_0.20-34      multcomp_1.4-6      
## [10] stringr_1.1.0        plyr_1.8.4           tools_3.3.2         
## [13] grid_3.3.2           gtable_0.2.0         TH.data_1.0-7       
## [16] lambda.r_1.1.9       withr_1.0.2          survival_2.40-1     
## [19] lazyeval_0.2.0       assertthat_0.1       digest_0.6.10       
## [22] tibble_1.2           ggplot2_2.2.0        codetools_0.2-15    
## [25] futile.options_1.0.0 memoise_1.0.0        evaluate_0.10       
## [28] sandwich_2.3-4       stringi_1.1.2        compiler_3.3.2      
## [31] scales_0.4.1         mvtnorm_1.0-5        zoo_1.7-13
```

