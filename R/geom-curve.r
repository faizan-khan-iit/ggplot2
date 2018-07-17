#' @inheritParams grid::curveGrob
#' @export
#' @rdname geom_segment
geom_curve <- function(mapping = NULL, data = NULL,
                       stat = "identity", position = "identity",
                       ...,
                       curvature = 0.5,
                       angle = 90,
                       ncp = 5,
                       arrow = NULL,
                       lineend = "butt",
                       na.rm = FALSE,
                       show.legend = NA,
                       inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = a_GeomCurve,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      arrow = arrow,
      curvature = curvature,
      angle = angle,
      ncp = ncp,
      lineend = lineend,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggplot2Animint-ggproto
#' @include geom-segment.r
#' @format NULL
#' @usage NULL
#' @export
a_GeomCurve <- a_ggproto("a_GeomCurve", a_GeomSegment,
  draw_panel = function(data, panel_scales, a_coord, curvature = 0.5, angle = 90,
                        ncp = 5, arrow = NULL, lineend = "butt", na.rm = FALSE) {
    if (!a_coord$is_linear()) {
      warning("geom_curve is not implemented for non-linear coordinates",
        call. = FALSE)
    }
    trans <- a_coord$transform(data, panel_scales)
    curveGrob(
      trans$x, trans$y, trans$xend, trans$yend,
      default.units = "native",
      curvature = curvature, angle = angle, ncp = ncp,
      square = FALSE, squareShape = 1, inflect = FALSE, open = TRUE,
      gp = gpar(
        col = alpha(trans$colour, trans$alpha),
        lwd = trans$size * .pt,
        lty = trans$linetype,
        lineend = trans$lineend),
      arrow = arrow
    )
  }
)
