#' doCIMLR
#'
#' @param data List of matrices.
#' @param K Number of clusters
#' 
#' @return a list of \code{clust} the clustering of samples and
#' \code{fit} the results of the method CIMLR
#' 
#' @export
#'
#' @examples
#' set.seed(333)
#' c_1 <- simulateY(J=1000, prop=0.1, noise=1)
#' c_2 <- simulateY(J=2000, prop=0.1, noise=1)
#' c_3 <- simulateY(J=500, prop=0.1,  noise=0.5)
#' data <- list(c_1$data , c_2$data , c_3$data)
#' res <- doCIMLR(data,K=4)
#' @import CIMLR
#' @importFrom dplyr %>%
doCIMLR <- function (data, K){
  dat <- lapply(data, t)
  fit=CIMLR(dat, c= K, cores.ratio = 0)
  print("clustering done")
  input_dat <- do.call(rbind,lapply(seq(along=dat), function(dd){
    ddd <- dat[[dd]]
    rownames(ddd) <- sprintf("%s_dat%s", rownames(ddd), dd)
    ddd
  }))
  ranks = CIMLR_Feature_Ranking(A=fit$S,X=input_dat)
  ranks$names <- rownames(input_dat)[ranks$aggR]
  fit$selectfeatures <- ranks
  print("feature selection done")
  res <- list(clust= fit$y$cluster, fit=fit)
  return(res)
}
