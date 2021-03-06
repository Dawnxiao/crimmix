#' doSGCCA
#'
#' @param data List of matrices.
#' @param K Number of clusters
#' @param C A design matrix that describes the relationships between blocks (default: complete design).
#' @param c1 Either a \code{1*J vector or a max(ncomp) * J} matrix encoding
#' the L1 constraints applied to the outer weight vectors.
#' Elements of c1 vary between 1/sqrt(p_j) and 1
#' (larger values of c1 correspond to less penalization)
#' @param scheme The value is "horst", "factorial", "centroid"
#' or any diffentiable convex scheme function g designed by
#' the user (default: "centroid").
#' @param ncomp A 1 * J vector that contains the numbers of c
#' omponents for each block (default: \code{rep(1, length(data}),
#' which gives one component per block.)
#'
#' @return a list of \code{clust} the clustering of samples and
#' \code{fit} the results of the method SGCCA
#'
#' @examples
#' set.seed(333)
#' c_1 <- simulateY(J=100, prop=0.1, noise=1)
#' c_2 <- simulateY(J=200, prop=0.1, noise=1)
#' c_3 <- simulateY(J=50, prop=0.1,  noise=0.5)
#' data <- list(c_1$data , c_2$data , c_3$data)
#' res <- doSGCCA(data,K=4)
#' @importFrom RGCCA sgcca
#' @export
doSGCCA <- function (data, K, C=1-diag(length(data)),c1= rep(1, length(data)),
                     ncomp=rep(1, length(data)), scheme="centroid"){
  ## rgcca algorithm using the dual formulation for X1 and X2
  ## and the dual formulation for X3
  result.sgcca = data %>%sgcca(C, c1, ncomp = ncomp, scheme = scheme,
                               verbose = FALSE, scale = TRUE)
  resDat <- do.call(cbind, result.sgcca$Y)
  clust.sgcca <- resDat %>% dist %>% hclust(method="ward.D2") %>% cutree(k=K)
  res <- list(clust=clust.sgcca, fit = result.sgcca)
  return(res)
}
