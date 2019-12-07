set_names <- function(object = nm, nm) {
  names(object) <- nm
  object
}

set_names(
  c("alaska", "centgrtlakes_radaronly", "hawaii_radaronly",
    "latest_radaronly", "northeast_radaronly", "northrockies_radaronly",
    "pacnorthwest_radaronly", "pacsouthwest_radaronly",
    "southeast_radaronly", "southmissvly_radaronly",
    "southplains_radaronly", "southrockies_radaronly",
    "uppermissvly_radaronly"),

  c("alaska", "centgrtlakes", "hawaii",
    "latest", "northeast", "northrockies",
    "pacnorthwest", "pacsouthwest",
    "southeast", "southmissvly",
    "southplains", "southrockies",
    "uppermissvly")

) -> .reg_trans

#' Read latest NWS regional or ConUS radar mosaics as a `stars` object
#'
#' @param regional_mosaic one of the supported mosaics from [the official NWS list](https://radar.weather.gov/ridge/):
#' - "`alaska`": Alaska
#' - "`centgrtlakes`": Central Great Lakes
#' - "`hawaii`": Hawaii
#' - "`latest`": ConUS
#' - "`northeast`": Northeast
#' - "`northrockies`": Northern Rockies
#' - "`pacnorthwest`": Pacific Northwest
#' - "`pacsouthwest`": Pacific Southwest
#' - "`southeast`": Southeast
#' - "`southmissvly`": Southern Mississippi Valley
#' - "`southplains`": Southern Plains
#' - "`southrockies`": Southern Rockies
#' - "`uppermissvly`": Upper Mississippi Valley
#' @param quiet passed on to [utils::download.file()]
#' @return `stars` object with the raster composite with a CRS of EPSG:4326
#' @export
latest_radar <- function(regional_mosaic = c("alaska", "centgrtlakes", "hawaii",
                                             "latest", "northeast", "northrockies",
                                             "pacnorthwest", "pacsouthwest",
                                             "southeast", "southmissvly",
                                             "southplains", "southrockies",
                                             "uppermissvly"), quiet = TRUE) {

  regional_mosaic <- match.arg(tolower(regional_mosaic[1]), c("alaska", "centgrtlakes", "hawaii",
                                                              "latest", "northeast", "northrockies",
                                                              "pacnorthwest", "pacsouthwest",
                                                              "southeast", "southmissvly",
                                                              "southplains", "southrockies",
                                                              "uppermissvly"))
  regional_mosaic <- .reg_trans[[regional_mosaic]]

  td <- tempdir()
  on.exit(unlink(td))

  download.file(
    c(
      sprintf("https://radar.weather.gov/ridge/Conus/RadarImg/%s.gif", regional_mosaic),
      sprintf("https://radar.weather.gov/ridge/Conus/RadarImg/%s.gfw", regional_mosaic)
    ),
    file.path(td, paste(regional_mosaic, c(".gif", ".gfw"), sep = "")),
    method = "libcurl",
    quiet = quiet
  )

  out <- stars::read_stars(file.path(td, sprintf("%s.gif", regional_mosaic)))

  sf::st_set_crs(out, 4326)

}

