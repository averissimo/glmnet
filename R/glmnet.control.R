glmnet.control <-
  function (fdev = 1e-05, devmax = 0.999, eps = 1e-06, big = 9.9e+35, 
            mnlam = 5, pmin = 1e-09, exmx = 250, prec = 1e-10, mxit = 100, 
            factory = FALSE) 
{
  inquiry=!nargs()
   if (factory) 
    invisible(glmnet.control(fdev = 1e-05, devmax = 0.999, 
                             eps = 1e-06, big = 9.9e+35, mnlam = 5, pmin = 1e-09, 
                             exmx = 250, prec = 1e-10, mxit = 100))
  else {
    if (!missing(fdev)) 
      .Fortran("chg_fract_dev", as.double(fdev), PACKAGE = "glmnet.mclapply")
    if (!missing(devmax)) 
      .Fortran("chg_dev_max", as.double(devmax), PACKAGE = "glmnet.mclapply")
    if (!missing(eps)) 
      .Fortran("chg_min_flmin", as.double(eps), PACKAGE = "glmnet.mclapply")
    if (!missing(big)) 
      .Fortran("chg_big", as.double(big), PACKAGE = "glmnet.mclapply")
    if (!missing(mnlam)) 
      .Fortran("chg_min_lambdas", as.integer(mnlam), PACKAGE = "glmnet.mclapply")
    if (!missing(pmin)) 
      .Fortran("chg_min_null_prob", as.double(pmin), PACKAGE = "glmnet.mclapply")
    if (!missing(exmx)) 
      .Fortran("chg_max_exp", as.double(exmx), PACKAGE = "glmnet.mclapply")
    if (!missing(prec) | !missing(mxit)) 
      .Fortran("chg_bnorm", as.double(prec), as.integer(mxit), 
               PACKAGE = "glmnet.mclapply")
    value=c(.Fortran("get_int_parms", fdev = double(1), 
                         eps = double(1), big = double(1), mnlam = integer(1), 
                         devmax = double(1), pmin = double(1), exmx = double(1), 
                         PACKAGE = "glmnet.mclapply"), .Fortran("get_bnorm", prec = double(1), 
                           mxit = integer(1), PACKAGE = "glmnet.mclapply"))
    if(inquiry)value else invisible(value)
  }
}
