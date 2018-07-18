#' Add a smoothed conditional mean.
#'
#' Aids the eye in seeing patterns in the presence of overplotting.
#' \code{geom_smooth} and \code{a_stat_smooth} are effectively aliases: they
#' both use the same arguments. Use \code{geom_smooth} unless you want to
#' display the results with a non-standard geom.
#'
#' Calculation is performed by the (currently undocumented)
#' \code{predictdf} generic and its methods.  For most methods the standard
#' error bounds are computed using the \code{\link{predict}} method - the
#' exceptions are \code{loess} which uses a t-based approximation, and
#' \code{glm} where the normal confidence interval is constructed on the link
#' scale, and then back-transformed to the response scale.
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggplot2Animint:::rd_aesthetics("geom", "smooth")}
#'
#' @inheritParams layer
#' @inheritParams geom_point
#' @param geom,a_stat Use to override the default connection between
#'   \code{geom_smooth} and \code{a_stat_smooth}.
#' @seealso See individual modelling functions for more details:
#'   \code{\link{lm}} for linear smooths,
#'   \code{\link{glm}} for generalised linear smooths,
#'   \code{\link{loess}} for local smooths
#' @export
#' @examples
#' a_plot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_smooth()
#'
#' # Use span to control the "wiggliness" of the default loess smoother
#' # The span is the fraction of points used to fit each local regression:
#' # small numbers make a wigglier curve, larger numbers make a smoother curve.
#' a_plot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_smooth(span = 0.3)
#'
#' # Instead of a loess smooth, you can use any other modelling function:
#' a_plot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_smooth(method = "lm", se = FALSE)
#'
#' a_plot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3), se = FALSE)
#'
#' # Smoothes are automatically fit to each group (defined by categorical
#' # aesthetics or the group aesthetic) and for each facet
#'
#' a_plot(mpg, aes(displ, hwy, colour = class)) +
#'   geom_point() +
#'   geom_smooth(se = FALSE, method = "lm")
#' a_plot(mpg, aes(displ, hwy)) +
#'   geom_point() +
#'   geom_smooth(span = 0.8) +
#'   ggplot2Animint:::a_facet_wrap(~drv)
#'
#' \donttest{
#' binomial_smooth <- function(...) {
#'   geom_smooth(method = "glm", method.args = list(family = "binomial"), ...)
#' }
#' # To fit a logistic regression, you need to coerce the values to
#' # a numeric vector lying between 0 and 1.
#' a_plot(rpart::kyphosis, aes(Age, Kyphosis)) +
#'   geom_jitter(height = 0.05) +
#'   binomial_smooth()
#'
#' a_plot(rpart::kyphosis, aes(Age, as.numeric(Kyphosis) - 1)) +
#'   geom_jitter(height = 0.05) +
#'   binomial_smooth()
#'
#' a_plot(rpart::kyphosis, aes(Age, as.numeric(Kyphosis) - 1)) +
#'   geom_jitter(height = 0.05) +
#'   binomial_smooth(formula = y ~ splines::ns(x, 2))
#'
#' # But in this case, it's probably better to fit the model yourself
#' # so you can exercise more control and see whether or not it's a good model
#' }
geom_smooth <- function(mapping = NULL, data = NULL,
                        a_stat = "smooth", position = "identity",
                        ...,
                        method = "auto",
                        formula = y ~ x,
                        se = TRUE,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {

  params <- list(
    na.rm = na.rm,
    ...
  )
  if (identical(a_stat, "smooth")) {
    params$method <- method
    params$formula <- formula
    params$se <- se
  }

  layer(
    data = data,
    mapping = mapping,
    a_stat = a_stat,
    geom = a_GeomSmooth,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = params
  )
}

#' @rdname ggplot2Animint-ggproto
#' @format NULL
#' @usage NULL
#' @export
a_GeomSmooth <- a_ggproto("a_GeomSmooth", a_Geom,
  draw_group = function(data, panel_scales, a_coord) {
    ribbon <- transform(data, colour = NA)
    path <- transform(data, alpha = NA)

    has_ribbon <- !is.null(data$ymax) && !is.null(data$ymin)

    gList(
      if (has_ribbon) a_GeomRibbon$draw_group(ribbon, panel_scales, a_coord),
      a_GeomLine$draw_panel(path, panel_scales, a_coord)
    )
  },

  draw_key = a_draw_key_smooth,

  required_aes = c("x", "y"),

  default_aes = aes(colour = "#3366FF", fill = "grey60", size = 1,
    linetype = 1, weight = 1, alpha = 0.4)
)
