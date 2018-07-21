#' Contours from a 2d density estimate.
#'
#' Perform a 2D kernel density estimation using kde2d and display the
#' results with contours. This can be useful for dealing with overplotting.
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggplot2Animint:::rd_aesthetics("a_geom", "density_2d")}
#'
#' @seealso \code{\link{a_geom_contour}} for contour drawing geom,
#'  \code{\link{a_stat_sum}} for another way of dealing with overplotting
#' @param a_geom,a_stat Use to override the default connection between
#'   \code{a_geom_density_2d} and \code{a_stat_density_2d}.
#' @inheritParams layer
#' @inheritParams a_geom_point
#' @inheritParams a_geom_path
#' @export
#' @examples
#' m <- a_plot(faithful, aes(x = eruptions, y = waiting)) +
#'  a_geom_point() +
#'  xlim(0.5, 6) +
#'  ylim(40, 110)
#' m + a_geom_density_2d()
#' \donttest{
#' m + a_stat_density_2d(aes(fill = ..level..), a_geom = "polygon")
#'
#' set.seed(4393)
#' dsmall <- diamonds[sample(nrow(diamonds), 1000), ]
#' d <- a_plot(dsmall, aes(x, y))
#' # If you map an aesthetic to a categorical variable, you will get a
#' # set of contours for each value of that variable
#' d + a_geom_density_2d(aes(colour = cut))
#'
#' # If we turn contouring off, we can use use geoms like tiles:
#' d + a_stat_density_2d(a_geom = "raster", aes(fill = ..density..), contour = FALSE)
#' # Or points:
#' d + a_stat_density_2d(a_geom = "point", aes(size = ..density..), n = 20, contour = FALSE)
#' }
a_geom_density_2d <- function(mapping = NULL, data = NULL,
                            a_stat = "density2d", position = "identity",
                            ...,
                            lineend = "butt",
                            linejoin = "round",
                            linemitre = 1,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    a_stat = a_stat,
    a_geom = a_GeomDensity2d,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      lineend = lineend,
      linejoin = linejoin,
      linemitre = linemitre,
      na.rm = na.rm,
      ...
    )
  )
}

#' @export
#' @rdname a_geom_density_2d
#' @usage NULL
a_geom_density2d <- a_geom_density_2d


#' @rdname ggplot2Animint-ggproto
#' @format NULL
#' @usage NULL
#' @export
a_GeomDensity2d <- a_ggproto("a_GeomDensity2d", a_GeomPath,
  default_aes = aes(colour = "#3366FF", size = 0.5, linetype = 1, alpha = NA)
)
