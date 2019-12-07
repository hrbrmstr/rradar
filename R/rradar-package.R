#' Animate NOAA NWSRadar Images by Station Id
#'
#' NOAA NWS has an array of National Doppler Radar Sites. Tools are provided to
#' to help you locate stations and create an animated composite image of recent radar
#' images.
#'
#' @md
#' @name rradar
#' @keywords internal
#' @author Bob Rudis (bob@@rud.is)
#' @import httr magick rvest
#' @importFrom stars read_stars
#' @importFrom sf st_set_crs
#' @importFrom utils download.file
"_PACKAGE"
