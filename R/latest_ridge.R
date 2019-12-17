#' Read latest NWS ridge as a stars object
#'
#' @param station the abbreviated station name. See [stations].
#' @param ridge image type
#' - "`base`" for Base Reflectivity (out to 124 nm). **The default**.
#' - "`storm`" for Storm Relative Motion
#' - "`hour`" for One-Hour Precipitation
#' - "`composite`" for Composite Reflectivity
#' - "`storm_total`" for Storm Total Precipitation
#' - "`base_extended`" for Base Reflectivity (out to 248 nmi)
#' @param quiet passed on to [utils::download.file()]
#' @return `stars` object with the raster composite with a CRS of EPSG:4326
#' @export
latest_ridge <- function(station = "GYX",
                         ridge = c("base", "storm", "hour", "composite", "storm_total", "base_extended"),
                         quiet = TRUE) {

  ridge <- match.arg(tolower(ridge[1]), c("base", "storm", "hour", "composite", "storm_total", "base_extended"))

  station <- toupper(as.character(station[1]))

  if (!(station %in% stations$station)) stop("Could not locate station '", station, "'.", call.=FALSE)

  st_dir <- switch(
    ridge,
    base = "N0R",
    storm = "N0S",
    hour = "N1P",
    composite = "NCR",
    storm_total = "NTP",
    base_extended = "N0Z"
  )

  td <- tempdir()
  if (!dir.exists(td)) dir.create(td)

  on.exit(unlink(td))

  download.file(
    c(
      sprintf("https://radar.weather.gov/ridge/RadarImg/%s/%s_%s_0.gif", st_dir, station, st_dir),
      sprintf("https://radar.weather.gov/ridge/RadarImg/%s/%s_%s_0.gfw", st_dir, station, st_dir)
    ),
    file.path(td, paste(station, c(".gif", ".gfw"), sep = "")),
    method = "libcurl",
    quiet = quiet
  )

  if (!all(file.exists(file.path(td, sprintf("%s.gif", station))))) {
    stop("Something went wrong. File(s) do not appear to have downloaded or there is a permissions problem.", call.=FALSE)
  }

  out <- stars::read_stars(file.path(td, sprintf("%s.gif", station)))

  sf::st_set_crs(out, 4326)

}

