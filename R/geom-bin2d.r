#' Add heatmap of 2d bin counts.
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggplot2Animint:::rd_aesthetics("a_stat", "bin2d")}
#'
#' @export
#' @inheritParams layer
#' @inheritParams a_geom_point
#' @param a_geom,a_stat Use to override the default connection between
#'   \code{a_geom_bin2d} and \code{a_stat_bin2d}.
#' @seealso \code{\link{a_stat_binhex}} for hexagonal binning
#' @examples
#' d <- a_plot(diamonds, aes(x, y)) + xlim(4, 10) + ylim(4, 10)
#' d + a_geom_bin2d()
#'
#' # You can control the size of the bins by specifying the number of
#' # bins in each direction:
#' d + a_geom_bin2d(bins = 10)
#' d + a_geom_bin2d(bins = 30)
#'
#' # Or by specifying the width of the bins
#' d + a_geom_bin2d(binwidth = c(0.1, 0.1))
a_geom_bin2d <- function(mapping = NULL, data = NULL,
                       a_stat = "bin2d", position = "identity",
                       ...,
                       na.rm = FALSE,
                       show.legend = NA,
                       inherit.aes = TRUE) {

  layer(
    data = data,
    mapping = mapping,
    a_stat = a_stat,
    a_geom = a_GeomTile,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}
