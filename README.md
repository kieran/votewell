# VoteWell

[Blog post](https://kieran.ca/projects/votewell)

![image](https://user-images.githubusercontent.com/3444/66625862-fb5f7d00-ebc3-11e9-9c57-51cde77fae06.png)

## Running locally

```console
# install & run
nvm use
make run
```

### build:
```console
make dist
```

## Sources

[Poll data](https://338canada.com)

[Ward boundaries (Canada 2021)](https://open.canada.ca/data/en/dataset/47a0f098-7445-41bb-a147-41686b692887/resource/67002bb4-3934-49e6-aa37-0e57a6af12f9)


## Converting boundary Shapefiles to geoJson

### install `ogr2ogr` for coordinate conversion

- run a GDAL docker container
```bash
docker run -it ghcr.io/osgeo/gdal:ubuntu-small-latest
 ```

### copy the shapefile directory into the container

### convert coordinates:
```bash
cd data
ogr2ogr -t_srs EPSG:4326 -f geoJSON -lco COORDINATE_PRECISION=7 ridings.json your_shapefile.shp
```

import that geojson into mongo

### if you want to simplify the shape (for faster lookups)
- go to https://mapshaper.org/
- upload `ridings.json`
- simplify (6-12% is a good starting range)
- export, overwrite original file
