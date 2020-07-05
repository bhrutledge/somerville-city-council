wards_geojson := somerville_wards.geojson
wards_shz := somerville_wards.shz
council_geojson := somerville_council.geojson
council_csv := somerville_council.csv

.PHONY: all
all: $(wards_geojson) $(council_geojson)

$(wards_geojson): $(wards_shz) $(council_csv)
	ogr2ogr /dev/stdout $< -f GeoJSON \
		-sql "\
			SELECT Ward, Name as Councilor, Email, Phone, Websites, URL \
			FROM Wards AS wards \
			JOIN '$(word 2, $^)'.$(basename $(word 2, $^)) AS council \
			ON wards.Ward = council.ward \
			ORDER BY Ward\
		" \
		-t_srs EPSG:4326 -lco RFC7946=YES \
		-nln "Somerville Wards" \
		| python3 -m json.tool > $@

$(wards_shz):
	curl -L -o $@ https://data.somervillema.gov/download/ym5n-phxd/application%2Fzip

$(council_geojson): $(council_csv)
	ogr2ogr /dev/stdout $< -f GeoJSON \
		-oo X_POSSIBLE_NAMES=Longitude -oo Y_POSSIBLE_NAMES=Latitude \
		-nln "Somerville City Council" \
		| python3 -m json.tool > $@

$(council_csv):
	curl -L \
		https://docs.google.com/spreadsheets/d/e/2PACX-1vRCu1dHFqjvWvgix9BZzkumdiOKBATUghucaYpgZTzhC1g4fuVOwg-_IMH3HWoEGKlC1CWiymXB6HfV/pub?output=csv \
		| tr -d '\r' > $@

.PHONY: clean
clean:
	rm -f *.csv *.geojson *.shz
