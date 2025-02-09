% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scale-rradar.R
\name{scale_fill_rradar}
\alias{scale_fill_rradar}
\title{Continuous fill scale for use with NWS raster radar data}
\usage{
scale_fill_rradar(
  option = "plasma",
  direction = -1,
  name = "dBZ",
  na.value = "#00000000",
  limits = c(-30, 70),
  breaks = seq(-30, 70, 5),
  low_dbz = "#00000010",
  ...
)
}
\arguments{
\item{option, direction}{passed on to \code{\link[viridis:viridis_pal]{viridis::viridis_pal()}}; defaults to "\code{plasma}" and \code{-1}, respectively.}

\item{name}{The name of the scale}

\item{na.value}{Missing values will be replaced with this value. Defaults to a fully transparent color.}

\item{limits}{scale limits; defaults to NWS dBZ limits \link{-30, 70}}

\item{breaks}{scale breaks; defaults to the NWS every 5 sequence from -30 to 70}

\item{low_dbz}{color to be uses the dbZ values are lower than ~5 dBZ. Defaults to "\verb{#00000010}"}

\item{...}{passed on to \code{\link[ggplot2:scale_fill_gradientn]{ggplot2::scale_fill_gradientn()}}}
}
\value{
a \code{{ggplot2}} continuous fill scale
}
\description{
The dBZ values associated with the base reflectivity radar images/data represent
the strength of the energy returned to the radar from the precipitation. Values lower than 20 dBZ
are generally when there is actual light rain. The NWS tends to use a light gray alpha for values
below ~5 dBZ since there are particles in the air but they really aren't something that constitutes
precipitation.\cr
\cr
This \code{{ggplot2}} continuous fill scale is an adaptation of the \code{{viridis}} color palette scales
where the viridis scale mappings only start when dBZ values are around 5 dBZ. Values lower than that
receive light gray with a 5\% alpha (see the \code{low_dbz} parameter).
}
\examples{
\dontrun{
library(sf)
library(stars)
library(rradar)
library(rnaturalearth)
library(hrbrthemes)
library(tidyverse)

us <- ne_states(country = "united states of america", returnclass = "sf")

ne_radar <- latest_radar("northeast")

ne_us <- st_crop(us, st_bbox(ne_radar))

ggplot() +
  geom_sf(data = ne_us, size = 0.125, fill = '#fefefe') +
  geom_stars(data = ne_radar) +
  coord_sf(datum = NA) +
  scale_fill_rradar() +
  labs(
    x = NULL, y = NULL,
    title = "NWS Radar Mosaic — Northeast Sector",
    subtitle = "1538 UTC 2019-12-07"
  ) +
  theme_ipsum_es(grid="") +
  theme(legend.key.height = unit(5, "lines"))
}
}
