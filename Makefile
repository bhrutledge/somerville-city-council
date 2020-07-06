wards_geojson := somerville_wards.geojson
wards_shz := somerville_wards.shz
councilors_geojson := somerville_councilors.geojson
councilors_csv := somerville_councilors.csv

.PHONY: all
all: $(wards_geojson) $(councilors_geojson)

$(wards_geojson): $(wards_shz) $(councilors_geojson)
	$(eval councilors = $(word 2, $^))
	$(eval councilors_table = '$(councilors)'.$(basename $(councilors)))
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-sql "\
			SELECT Ward, Name as Councilor \
			FROM Wards AS wards \
			JOIN $(councilors_table) AS councilors \
			ON wards.Ward = councilors.ward \
			ORDER BY Ward \
		" \
		-t_srs EPSG:4326 -lco RFC7946=YES \
		-nln wards \
	| ogr2ogr -f GeoJSON /vsistdout/ /vsistdin/ \
		-sql " \
			SELECT * FROM wards \
			UNION ALL SELECT * FROM $(councilors_table) \
		" \
		-lco RFC7946=YES -lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(wards_shz):
	curl -L -o $@ https://data.somervillema.gov/download/ym5n-phxd/application%2Fzip

$(councilors_geojson): $(councilors_csv)
	ogr2ogr -f GeoJSON /vsistdout/ $< \
		-oo X_POSSIBLE_NAMES=Longitude -oo Y_POSSIBLE_NAMES=Latitude \
		-lco WRITE_NAME=NO \
	| python3 -m json.tool > $@

$(councilors_csv):
	curl -L \
		https://docs.google.com/spreadsheets/d/e/2PACX-1vRCu1dHFqjvWvgix9BZzkumdiOKBATUghucaYpgZTzhC1g4fuVOwg-_IMH3HWoEGKlC1CWiymXB6HfV/pub?output=csv \
	| tr -d '\r' > $@

.PHONY: clean
clean:
	rm -f *.csv *.geojson *.shz
