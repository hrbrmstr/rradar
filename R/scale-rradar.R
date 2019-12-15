#' Continuous fill scale for use with NWS raster radar data
#'
#' The dBZ values associated with the base reflectivity radar images/data represent
#' the strength of the energy returned to the radar from the precipitation. Values lower than 20 dBZ
#' are generally when there is actual light rain. The NWS tends to use a light gray alpha for values
#' below ~5 dBZ since there are particles in the air but they really aren't something that constitutes
#' precipitation.\cr
#' \cr
#' This `{ggplot2}` continuous fill scale is an adaptation of the `{viridis}` color palette scales
#' where the viridis scale mappings only start when dBZ values are around 5 dBZ. Values lower than that
#' receive light gray with a 5% alpha (see the `low_dbz` parameter).
#'
#' @param option,direction passed on to [viridis::viridis_pal()]; defaults to "`plasma`" and `-1`, respectively.
#' @param low_dbz color to be uses the dbZ values are lower than ~5 dBZ. Defaults to "`#00000010`"
#' @param name The name of the scale
#' @param na.value Missing values will be replaced with this value. Defaults to a fully transparent color.
#' @param limits scale limits; defaults to NWS dBZ limits [-30, 70]
#' @param breaks scale breaks; defaults to the NWS every 5 sequence from -30 to 70
#' @param ... passed on to [ggplot2::scale_fill_gradientn()]
#' @return a `{ggplot2}` continuous fill scale
#' @export
#' @examples \dontrun{
#' library(sf)
#' library(stars)
#' library(rradar)
#' library(rnaturalearth)
#' library(hrbrthemes)
#' library(tidyverse)
#'
#' us <- ne_states(country = "united states of america", returnclass = "sf")
#'
#' ne_radar <- latest_radar("northeast")
#'
#' ne_us <- st_crop(us, st_bbox(ne_radar))
#'
#' ggplot() +
#'   geom_sf(data = ne_us, size = 0.125, fill = '#fefefe') +
#'   geom_stars(data = ne_radar) +
#'   coord_sf(datum = NA) +
#'   scale_fill_rradar() +
#'   labs(
#'     x = NULL, y = NULL,
#'     title = "NWS Radar Mosaic — Northeast Sector",
#'     subtitle = "1538 UTC 2019-12-07"
#'   ) +
#'   theme_ipsum_es(grid="") +
#'   theme(legend.key.height = unit(5, "lines"))
#' }
scale_fill_rradar <- function(option = "plasma", direction = -1, name = "dBZ", na.value = "#00000000",
                         limits = c(-30, 70), breaks = seq(-30, 70, 5), low_dbz = "#00000010", ...) {

  dbz <- seq(-30, 70, 1)
  dbzrs <- scales::rescale(dbz)

  ggplot2::scale_fill_gradientn(
    colours = c(rep(low_dbz, 38), viridis::viridis_pal(option = option, direction = direction)(63)),
    values = dbzrs, limits = limits, breaks = breaks,
    na.value = na.value, name = name, ...
  )

}