#' Create an animated weather image from a NOAA station
#'
#' @param station the abbreviated station name. See [stations].
#' @param ridge image type
#' - "`base`" for Base Reflectivity (out to 124 nm). **The default**.
#' - "`storm`" for Storm Relative Motion
#' - "`hour`" for One-Hour Precipitation
#' - "`composite`" for Composite Reflectivity
#' - "`storm_total`" for Storm Total Precipitation
#' - "`base_extended`" for Base Reflectivity (out to 248 nmi)
#' @param include_legend `TRUE` (default) if you want the legend
#' @export
animate_radar <- function(station = "GYX",
                          ridge = c("base", "storm", "hour", "composite", "storm_total", "base_extended"),
                          include_legend = TRUE) {

  ridge <- match.arg(tolower(ridge[1]), c("base", "storm", "hour", "composite", "storm_total", "base_extended"))

  station <- toupper(as.character(station[1]))

  if (!(station %in% stations$station)) stop("Could not locate station '", station, "'.", call.=FALSE)

  county_overlay <- system.file(
    sprintf("overlays/%s_County_Short.gif", station),
    package = "rradar"
  )

  county <- image_read(county_overlay)

  ir <- possibly(image_read, NULL)

  st_dir <- switch(
    ridge,
    base = "N0R",
    storm = "N0S",
    hour = "N1P",
    composite = "NCR",
    storm_total = "NTP",
    base_extended = "N0Z"
  )

  frames_dir_url <- sprintf("https://radar.weather.gov/ridge/RadarImg/%s/%s/", st_dir, station)

  res <- httr::GET(url = frames_dir_url)
  out <- httr::content(res)
  out <- rvest::html_nodes(out, xpath = sprintf(".//a[contains(@href, '%s_')]", station))
  out <- rvest::html_attr(out, "href")
  out <- sprintf("https://radar.weather.gov/ridge/RadarImg/%s/%s/%s", st_dir, station, out)
  out <- lapply(out, ir)
  out <- out[lengths(out) > 0]

  radar_imgs <- do.call(c, out)

  back <- image_background(county, "black", flatten = TRUE)
  both <- image_composite(back, radar_imgs)

  if (include_legend) {
    legend_overlay <- image_read(
      sprintf("https://radar.weather.gov/ridge/Legend/%s/%s_%s_Legend_0.gif",
              st_dir, station, st_dir)
    )
    both <- image_composite(both, legend_overlay, "over")
  }

  image_animate(both)

}
