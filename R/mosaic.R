#' Create an animated weather radar mosaic for the the conterminus U.S.
#'
#' @param size one of "`small`" or "`large`". The large mosaic takes a bit to download.
#' @export
animate_conus_mosaic <- function(size = c("small", "large")) {

  size <- match.arg(tolower(size[1]), c("small", "large"))

  pre <- if (size == "small") "Nat_" else "NAT_"

  ir <- possibly(magick::image_read, NULL)

  res <- httr::GET("https://radar.weather.gov/ridge/Conus/RadarImg/")
  out <- httr::content(res)
  out <- rvest::html_nodes(out, xpath = sprintf(".//a[contains(., '%s')]", pre))
  out <- rvest::html_attr(out, "href")
  out <- sprintf("https://radar.weather.gov/ridge/Conus/RadarImg/%s", out)
  out <- lapply(out, ir)
  out <- out[lengths(out) > 0]

  radar_imgs <- do.call(c, out)

  magick::image_animate(radar_imgs)

}