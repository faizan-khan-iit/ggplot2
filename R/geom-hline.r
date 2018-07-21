#' @include stat-.r
NULL

#' @export
#' @rdname a_geom_abline
a_geom_hline <- function(mapping = NULL, data = NULL,
                       ...,
                       yintercept,
                       na.rm = FALSE,
                       show.legend = NA) {

  # Act like an annotation
  if (!missing(yintercept)) {
    data <- data.frame(yintercept = yintercept)
    mapping <- aes(yintercept = yintercept)
    show.legend <- FALSE
  }

  layer(
    data = data,
    mapping = mapping,
    a_stat = a_StatIdentity,
    a_geom = a_GeomHline,
    position = a_PositionIdentity,
    show.legend = show.legend,
    inherit.aes = FALSE,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggplot2Animint-ggproto
#' @format NULL
#' @usage NULL
#' @export
a_GeomHline <- a_ggproto("a_GeomHline", a_Geom,
  draw_panel = function(data, panel_scales, a_coord) {
    ranges <- a_coord$range(panel_scales)

    data$x    <- ranges$x[1]
    data$xend <- ranges$x[2]
    data$y    <- data$yintercept
    data$yend <- data$yintercept

    a_GeomSegment$draw_panel(unique(data), panel_scales, a_coord)
  },

  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),
  required_aes = "yintercept",

  draw_key = a_draw_key_path
)
