# VoteWell

![image](https://user-images.githubusercontent.com/3444/66625862-fb5f7d00-ebc3-11e9-9c57-51cde77fae06.png)

## Running locally

```console
# install
nvm use
npm install

# run
npm start
```

### build:
```console
npm run dist
```

## Sources

[Poll data (Ontario 2018)](http://www.calculatedpolitics.com/project/2018-ontario/)
[Poll data (Canada 2019)](https://www.calculatedpolitics.com/project/2019-canada-election/)

[Ward boundaries (Ontario 2018)](https://www.elections.on.ca/en/voting-in-ontario/electoral-districts/current-electoral-district-maps.html)
[Ward boundaries (Canada 2019)](https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0)


## Converting boundary Shapefiles to geoJson

### install `ogr2ogr` for coordinate conversion

- download & install GDAL from https://www.kyngchaos.com/software/frameworks/
```bash
echo 'export PATH=/Library/Frameworks/GDAL.framework/Programs:$PATH' >> ~/.bash_profile
source ~/.bash_profile
 ```

### convert coordinates:
```bash
cd data
ogr2ogr -t_srs EPSG:4326 -f geoJSON -lco COORDINATE_PRECISION=7 ridings.json path/to/your_shapefile.shp
```

### simplify the shape (for faster lookups)
- go to https://mapshaper.org/
- upload `ridings.json`
- simplify (6-12% is a good starting range)
- export, overwrite original file
