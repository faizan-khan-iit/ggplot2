#' Facet specification: a single panel.
#'
#' @inheritParams a_facet_grid
#' @export
#' @examples
#' # facet_null is the default facetting specification if you
#' # don't override it with facet_grid or facet_wrap
#' a_plot(mtcars, aes(mpg, wt)) + geom_point()
a_facet_null <- function(shrink = TRUE) {
  a_facet(shrink = shrink, subclass = "null")
}

#' @keywords internal
a_facet_train_layout.null <- function(a_facet, data) {
  data.frame(
    PANEL = 1L, ROW = 1L, COL = 1L,
    SCALE_X = 1L, SCALE_Y = 1L)
}

#' @keywords internal
a_facet_map_layout.null <- function(a_facet, data, layout) {
  # Need the is.waive check for special case where no data, but aesthetics
  # are mapped to vectors
  if (is.waive(data) || empty(data))
    return(cbind(data, PANEL = integer(0)))
  data$PANEL <- 1L
  data
}

#' @keywords internal
a_facet_render.null <- function(a_facet, panel, coord, theme, geom_grobs) {
  range <- panel$ranges[[1]]

  # Figure out aspect ratio
  aspect_ratio <- theme$aspect.ratio %||% coord$aspect(range)
  if (is.null(aspect_ratio)) {
    aspect_ratio <- 1
    respect <- FALSE
  } else {
    respect <- TRUE
  }

  fg <- coord$render_fg(range, theme)
  bg <- coord$render_bg(range, theme)

  # Flatten layers - we know there's only one panel
  geom_grobs <- lapply(geom_grobs, "[[", 1)

  if (theme$panel.ontop) {
    panel_grobs <- c(geom_grobs, list(bg), list(fg))
  } else {
    panel_grobs <- c(list(bg), geom_grobs, list(fg))
  }

  panel_grob <- gTree(children = do.call("gList", panel_grobs))
  axis_h <- coord$render_axis_h(range, theme)
  axis_v <- coord$render_axis_v(range, theme)

  all <- matrix(list(
    axis_v,     panel_grob,
    zeroGrob(), axis_h
  ), ncol = 2, byrow = TRUE)

  layout <- gtable_matrix("layout", all,
    widths = unit.c(grobWidth(axis_v), unit(1, "null")),
    heights = unit.c(unit(aspect_ratio, "null"), grobHeight(axis_h)),
    respect = respect, clip = c("off", "off", "on", "off"),
    z = matrix(c(3, 2, 1, 4), ncol = 2, byrow = TRUE)
  )
  layout$layout$name <- c("axis-l", "spacer", "panel", "axis-b")

  layout
}

#' @keywords internal
a_facet_vars.null <- function(a_facet) ""
