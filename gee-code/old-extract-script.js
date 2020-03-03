// Imports //

// MODIS Albedo Daily L3 Global 500m Grid
var collection_albedo = ee.ImageCollection("MODIS/006/MOD10A1").select(["Snow_Albedo_Daily_Tile"]);

// Model Cells
var cells = ee.FeatureCollection("users/jucross/model-cells");

// Glacier Centroids
var glacs = ee.FeatureCollection('ft:14_eNPAAfAStqwSGXQxShLA11iO5Fh_sJquw7rxPF');

// Met Stations
// var met_stations = ee.FeatureCollection('');

// CAA Met Station
var caa_station = ee.Feature(ee.Geometry.Point([162.96345, -77.612709]));

// CAA Alt Sample Point
var caa_alternate =  ee.Feature(ee.Geometry.Point([162.9753, -77.626]));

// Filtering //

//Filter based on date
var collection_albedo_date = collection_albedo.filterDate('2000-01-01','2015-12-31');
//var collection_snow_date = collection_snow.filterDate('2004-11-01','2005-03-31');


// Filter based on ROI
var roi = ee.Geometry.Polygon([
  [[160, -77.25], [160, -78],[165, -78], [165, -77.25], [165, -77.25]]]); //Taylor Valley

var clip_collection_albedo = collection_albedo_date.map(function(image) { return image.clip(roi); });

// Analysis //

// Reduce Image Collections
var albedo_mean = clip_collection_albedo.reduce(ee.Reducer.mean()); // mean snow cover
print(albedo_mean);

// Zonal Statistics for Model Cells on Albedo Mean
var cell_mean_stats = albedo_mean.reduceRegions({
  reducer: ee.Reducer.mean(),
  collection: cells,
  scale: 500
});

print(ee.Feature(cell_mean_stats.first()).select(albedo_mean.bandNames()));

// Zonal Statistics for CAA on Snow Cover Mean
var caa_mean_stats = albedo_mean.reduceRegions({
  reducer: ee.Reducer.mean(),
  collection: caa_station,
  scale: 500
});

print(ee.Feature(caa_mean_stats.first()).select(albedo_mean.bandNames()));

// Zonal Statistics for CAA Alt on Snow Cover Mean
var alt_mean_stats = albedo_mean.reduceRegions({
  reducer: ee.Reducer.mean(),
  collection: caa_alternate,
  scale: 500
});

print(ee.Feature(alt_mean_stats.first()).select(albedo_mean.bandNames()));

// CAA Station empty Collection to fill
var ft_caa = ee.FeatureCollection(ee.List([]));
// Function
var fill_caa = function(img, ini) {
  // type cast
  var inift = ee.FeatureCollection(ini);

  // gets the values for the points in the current img
  var ft2 = img.reduceRegions(caa_station, ee.Reducer.first(),30);

  // gets the date of the img
  var date = img.date().format();

  // writes the date in each feature
  var ft3 = ft2.map(function(f){return f.set("date", date)});

  // merges the FeatureCollections
  return inift.merge(ft3);
};
// Iterates over the ImageCollection
var caa_extract = ee.FeatureCollection(clip_collection_albedo.iterate(fill_caa, ft_caa));

// CAA Alternate empty Collection to fill with values
var ft_alt = ee.FeatureCollection(ee.List([]));
// Function
var fill_alt = function(img, ini) {
  // type cast
  var inift = ee.FeatureCollection(ini);

  // gets the values for the points in the current img
  var ft2 = img.reduceRegions(caa_alternate, ee.Reducer.first(),30);

  // gets the date of the img
  var date = img.date().format();

  // writes the date in each feature
  var ft3 = ft2.map(function(f){return f.set("date", date)});

  // merges the FeatureCollections
  return inift.merge(ft3);
};
// Iterates over the ImageCollection
var alt_extract = ee.FeatureCollection(clip_collection_albedo.iterate(fill_alt, ft_alt));

// Glacs empty Collection to fill with values
var ft_glacs = ee.FeatureCollection(ee.List([]));
// Function
var fill_glacs = function(img, ini) {
  // type cast
  var inift = ee.FeatureCollection(ini);

  // gets the values for the points in the current img
  var ft2 = img.reduceRegions(glacs, ee.Reducer.first(),30);

  // gets the date of the img
  var date = img.date().format();

  // writes the date in each feature
  var ft3 = ft2.map(function(f){return f.set("date", date)});

  // merges the FeatureCollections
  return inift.merge(ft3);
};
// Iterates over the ImageCollection
var glacs_extract = ee.FeatureCollection(clip_collection_albedo.iterate(fill_glacs, ft_glacs));

// Mapping //

Map.setCenter(162.5, -77.75, 6);

// Visualization Parameters
var visAlbedoMean = {"opacity":1,"min":1,"max":100,"gamma":1};

Map.addLayer(albedo_mean, visAlbedoMean, 'MODIS Albedo Mean');

//Map.addLayer(cells);

print(glacs);
Map.addLayer(glacs, {color: 'FF0000'}, 'Glacier Centroids');

Map.addLayer(caa_station, {color: 'FF0000'}, 'CAA Station');

// Chart //

// Define a chart with one series in the ROI, averaged by DOY.
var series1 = ui.Chart.image.doySeries(
    clip_collection_albedo, caa_station, ee.Reducer.mean(), 500);

// Display the three charts.
print(series1);

// Export //

//Export.table.toDrive({
  //collection: cell_mean_stats,
  //description: 'TV_cell_mean_2004',
  //fileFormat: 'CSV'
//});

//Export.table.toDrive({
  //collection: caa_mean_stats,
  //description: 'TV_caa_mean_2004',
  //fileFormat: 'CSV'
//});

//Export.table.toDrive({
  //collection: caa_extract,
  //description: 'caa_extract_2004',
  //fileFormat: 'CSV'});
  
//Export.table.toDrive({
  //collection: alt_extract,
  //description: 'alt_extract_2004',
  //fileFormat: 'CSV'});
  
//Export.table.toDrive({
  //collection: glacs_extract,
  //description: 'glacs_extract_2004',
  //fileFormat: 'CSV'});