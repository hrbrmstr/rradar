
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/rradar.svg?branch=master)](https://travis-ci.org/hrbrmstr/rradar)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.2.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# rradar

Animate NOAA NWS N0R Radar Images by Station Id

## Description

NOAA NWS has an array of National Doppler Radar Sites. Tools are
provided to to help you locate stations and create an animated composite
image of recent radar images.

## What’s Inside The Tin

The following functions are implemented:

  - `animate_radar`: Create an animated weather image from a NOAA
    station
  - `stations`: NOAA U.S. Radar Stations

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/rradar.git")
# or
remotes::install_git("https://git.sr.ht/~hrbrmstr/rradar")
# or
remotes::install_gitlab("hrbrmstr/rradar")
# or
remotes::install_bitbucket("hrbrmstr/rradar")
# or
remotes::install_github("hrbrmstr/rradar")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(rradar)

# current version
packageVersion("rradar")
## [1] '0.1.0'
```

### Stations

``` r
library(tidyverse)

filter(stations, state == "Maine")
## # A tibble: 2 x 4
##   state city     dir   station
##   <chr> <chr>    <chr> <chr>  
## 1 Maine Caribou  N0R   CBW    
## 2 Maine Portland N0R   GYX

filter(stations, state == "California")
## # A tibble: 11 x 4
##    state      city             dir   station
##    <chr>      <chr>            <chr> <chr>  
##  1 California Beale AFB        N0R   BBX    
##  2 California Edwards AFB      N0R   EYX    
##  3 California Eureka           N0R   BHX    
##  4 California Hanford          N0R   HNX    
##  5 California Los Angeles      N0R   VTX    
##  6 California Sacramento       N0R   DAX    
##  7 California San Diego        N0R   NKX    
##  8 California San Francisco    N0R   MUX    
##  9 California San Joaquin Vly. N0R   HNX    
## 10 California Santa Ana Mtns   N0R   SOX    
## 11 California Vandenberg AFB   N0R   VBX
```

``` r
animate_radar("GYX")
```

![](man/figures/README-unnamed-chunk-2-1.gif)<!-- -->

``` r
animate_radar("VBX")
```

![](man/figures/README-unnamed-chunk-3-1.gif)<!-- -->

## rradar Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines | (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | --: | -------: | ---: |
| R    |        6 | 0.86 | 152 | 0.92 |          14 | 0.4 |       29 | 0.45 |
| Rmd  |        1 | 0.14 |  13 | 0.08 |          21 | 0.6 |       35 | 0.55 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
