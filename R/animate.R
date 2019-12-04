#' Create an animated weather image from a NOAA station
#'
#' @param station the abbreviated station name. See [stations].
#' @export
animate_radar <- function(station = "GYX") {

  station <- toupper(as.character(station[1]))

  if (!(station %in% stations$station)) stop("Could not locate station '", station, "'.", call.=FALSE)

  county_overlay <- system.file(
    sprintf("overlays/%s_County_Short.gif", station),
    package = "rradar"
  )

  county <- image_read(county_overlay)

  ir <- possibly(image_read, NULL)

  st_dir <- stations[stations$station == station,][["dir"]]

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

  image_animate(both)

}
