wards_geojson := somerville_wards.geojson
wards_shz := somerville_wards.shz
councilors_geojson := somerville_councilors.geojson
councilors_csv := somerville_councilors.csv
council_geojson := somerville_city_council.geojson

.PHONY: all
all: $(council_geojson)

$(council_geojson): $(wards_geojson) $(councilors_geojson)
	$(eval wards_table = $(basename $<))
	$(eval councilors = $(word 2, $^))
	$(eval councilors_table = '$(councilors)'.$(basename $(councilors)))
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-sql " \
			SELECT * FROM $(councilors_table) \
			UNION ALL SELECT * FROM $(wards_table) \
		" \
		-lco RFC7946=YES -lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(wards_geojson): $(wards_shz)
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-t_srs EPSG:4326 \
		-sql "SELECT Ward FROM Wards ORDER BY Ward" \
		-lco RFC7946=YES -lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(wards_shz):
	curl -L -o $@ https://data.somervillema.gov/download/ym5n-phxd/application%2Fzip

$(councilors_geojson): $(councilors_csv)
	$(eval councilors_table = $(basename $<))
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-a_srs EPSG:4326 \
		-oo X_POSSIBLE_NAMES=Longitude -oo Y_POSSIBLE_NAMES=Latitude \
		-dialect SQLITE -sql "\
			SELECT *, CASE Ward WHEN 'At-Large' THEN 'a' ELSE Ward END AS 'marker-symbol' \
			FROM $(councilors_table) \
		" \
		-lco RFC7946=YES -lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(councilors_csv):
	curl -L \
		https://docs.google.com/spreadsheets/d/e/2PACX-1vRCu1dHFqjvWvgix9BZzkumdiOKBATUghucaYpgZTzhC1g4fuVOwg-_IMH3HWoEGKlC1CWiymXB6HfV/pub?output=csv \
	| tr -d '\r' > $@

.PHONY: clean
clean:
	rm -f *.csv *.geojson *.shz
