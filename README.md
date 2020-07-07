# Somerville City Council Data

Geographic data for wards and city councilors with names and contact information.

Open any `.geojson` file on GitHub to view the data as a map. For example:

[Councilors and Wards](https://github.com/bhrutledge/somerville-city-council/blob/master/somerville_city_council.geojson)

## Build instructions

This uses the [ogr2ogr](https://gdal.org/programs/ogr2ogr.html) command-line tool from [GDAL](https://gdal.org/) to convert between formats. On macOS, you can install GDAL with Homebrew:

```
brew install gdal
```

Then, to re-download the data and rebuild the output, run:

```
make -B
```

## Data sources

The ward boundaries are available as a zipped [ESRI Shapefile](https://en.wikipedia.org/wiki/Shapefile) at <https://data.somervillema.gov/GIS-data/Wards/ym5n-phxd>.

I couldn't find information about the city council in a structured format. Scraping <https://www.somervillema.gov/citycouncil> was suprisingly difficult due to inconsistent HTML structure and [obfuscated emails](https://www.somervillema.gov/cdn-cgi/l/email-protection#4d3e393f2837222c39212c3f2a280d2a202c2421632e2220). I ended up entering the data manually into a Google Sheet, thinking that a CSV would be the easiest thing to work with.

[Google Sheet: Somerville City Council](https://docs.google.com/spreadsheets/d/1JCxK8rt9akj3HUKUE54cydyKgTsZnA9iSNZEGP_6d8Q)

The sheet includes other details, like website/Twitter/Facebook links, plus the latitude/longitude of each councilor's address, which was quick to add via a [Sheets add-on](https://gsuite.google.com/marketplace/app/geocode_by_awesome_table/904124517349) (but there's also an [open-source macro](https://github.com/nuket/google-sheets-geocoding-macro)).

## TODO

- [ ] Move these to GitHub issues

- [ ] Add license

- [ ] GeoJSON of councilors
    - Nested arrays for "Websites" and "Committees"?
        - Probably via Python
        - Displayed w/ commas on GitHub

- [ ] GeoJSON of wards
    - Add demographic data

- [x] GeoJSON of wards & councilors

- [ ] [Google Map of wards & councilors](https://www.google.com/maps/d/edit?mid=1NdzlUAOXIOcEXqEbAkA9X0g-auts70Ue)
    - Using imported KML
    - Include styling in KML

- [ ] Gist w/ `marker-color` to distinguish yes/no votes

- [ ] Find city council data source
    - [Mass Dept. of Revenue - DLS Gateway](https://dlsgateway.dor.state.ma.us/gateway/DLSPublic/Search#)
        - via Code For Boston
        - Not as complete as website
        - Requires form `POST` to download Excel w/ cumbersome layout
