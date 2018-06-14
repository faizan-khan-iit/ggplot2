#' @export
#' @rdname position_stack
position_fill <- function() {
  a_PositionFill
}

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
a_PositionFill <- ggproto("a_PositionFill", a_Position,
  required_aes = c("x", "ymax"),

  setup_data = function(self, data, params) {
    if (!is.null(data$ymin) && !all(data$ymin == 0))
      warning("Filling not well defined when ymin != 0", call. = FALSE)

    ggproto_parent(a_Position, self)$setup_data(data)
  },

  compute_panel = function(data, params, scales) {
    collide(data, NULL, "position_fill", pos_fill)
  }
)
