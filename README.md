# Somerville City Council Map

Goal: Create a map of wards with names and contact information for city councilors.

This uses the [ogr2ogr](https://gdal.org/programs/ogr2ogr.html) command-line tool from [GDAL](https://gdal.org/) to convert between formats. On macOS, you can install GDAL with Homebrew:

```
brew install gdal
```

Then, to re-download the data and rebuild the output, run:

```
make -B
```

## Data Sources

The ward boundaries are available as a zipped [ESRI Shapefile](https://en.wikipedia.org/wiki/Shapefile) at <https://data.somervillema.gov/GIS-data/Wards/ym5n-phxd>.

I couldn't find information about the city council in a structured format. Scraping <https://www.somervillema.gov/citycouncil> was suprisingly difficult due to inconsistent HTML structure and [obfuscated emails](https://www.somervillema.gov/cdn-cgi/l/email-protection#4d3e393f2837222c39212c3f2a280d2a202c2421632e2220). I ended up entering the data manually into a Google Sheet, thinking that a CSV would be the easiest thing to work with.

[Google Sheet: Somerville City Council](https://docs.google.com/spreadsheets/d/1JCxK8rt9akj3HUKUE54cydyKgTsZnA9iSNZEGP_6d8Q)

The sheet includes other details, like website/Twitter/Facebook links, plus the latitude/longitude of each councilor's address, which was quick to add via a [Sheets add-on](https://gsuite.google.com/marketplace/app/geocode_by_awesome_table/904124517349) (but there's also an [open-source macro](https://github.com/nuket/google-sheets-geocoding-macro)).

## TODO

- [x] [Google Map of wards & councilors](https://www.google.com/maps/d/edit?mid=1NdzlUAOXIOcEXqEbAkA9X0g-auts70Ue)
    - Proof of concept
    - Councilors imported from Sheet, but not connected
    - Wards imported from [KML converted from Shapefile](https://mygeodata.cloud/converter/shp-to-kml)
        - Unsorted, includes extra data

- [ ] JSON of councilors
    - From CSV
    - Nested properties instead of line breaks
    - Probably via Python

- [ ] GeoJSON of councilors
    - From JSON instead of CSV
    - How to handle line breaks on GitHub?
        - HTML, e.g. `<br>`
    - How does GitHub display nested JSON properties?

- [ ] GeoJSON of wards
    - With `Point` for each councilor

- [ ] Update/redo Google Map
    - Using KML from GeoJSON
    - Group by ward

- [ ] Share repo & Google Map
