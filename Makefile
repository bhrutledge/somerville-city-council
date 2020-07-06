wards_geojson := somerville_wards.geojson
wards_shz := somerville_wards.shz
council_geojson := somerville_council.geojson
council_csv := somerville_council.csv

.PHONY: all
all: $(wards_geojson) $(council_geojson)

$(wards_geojson): $(wards_shz) $(council_geojson)
	$(eval council = $(word 2, $^))
	$(eval council_table = '$(council)'.$(basename $(council)))
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-sql "\
			SELECT Ward, Name as Councilor \
			FROM Wards AS wards \
			JOIN $(council_table) AS council \
			ON wards.Ward = council.ward \
			ORDER BY Ward \
		" \
		-t_srs EPSG:4326 -lco RFC7946=YES \
		-nln wards \
	| ogr2ogr -f GeoJSON /vsistdout/ /vsistdin/ \
		-sql " \
			SELECT * FROM wards \
			UNION ALL SELECT * FROM $(council_table) \
		" \
		-lco RFC7946=YES -lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(wards_shz):
	curl -L -o $@ https://data.somervillema.gov/download/ym5n-phxd/application%2Fzip

$(council_geojson): $(council_csv)
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-oo X_POSSIBLE_NAMES=Longitude -oo Y_POSSIBLE_NAMES=Latitude \
		-lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(council_csv):
	curl -L \
		https://docs.google.com/spreadsheets/d/e/2PACX-1vRCu1dHFqjvWvgix9BZzkumdiOKBATUghucaYpgZTzhC1g4fuVOwg-_IMH3HWoEGKlC1CWiymXB6HfV/pub?output=csv \
	| tr -d '\r' > $@

.PHONY: clean
clean:
	rm -f *.csv *.geojson *.shz
