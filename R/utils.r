#' pair_dist
#'
#' vectorized pair-wise distance calculation
#'
#' @param A numeric matrix
#' @param B numeric matrix
#'
.pair_dist <- function(A, B) {

  an <- rowSums(A^2)
  bn <- rowSums(B^2)

  m <- nrow(A)
  n <- nrow(B)

  tmp <- matrix(rep(an, n), nrow=m)
  tmp <- tmp + matrix(rep(bn, m), nrow=m, byrow=TRUE)

  sqrt( tmp - 2 * tcrossprod(A,B) )

}
