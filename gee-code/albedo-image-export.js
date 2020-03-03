/*
MODIS Albedo Image Export
A script to collect and filter MODIS v006 MOD10A1 Daily Snow Albedo and MCD43A3 Albedo Model images.
Images are filtered by ROI and date range to generate an image collection. 
The image collection is sampled from using different feature collections to
extract a MODIS albedo timeseries.
By: Julian Cross 10-8-18
*/

// Import MODIS albedo collection
var MCD43A3 = ee.ImageCollection("MODIS/006/MCD43A3").select(["Albedo_WSA_shortwave", 
                                                              "Albedo_BSA_shortwave", 
                                                              "Albedo_BSA_vis", 
                                                              "BRDF_Albedo_Band_Mandatory_Quality_shortwave"]);

// Import MODIS snow albedo collection
var MOD10A1 = ee.ImageCollection("MODIS/006/MOD10A1").select(["Snow_Albedo_Daily_Tile",
                                                              "Snow_Albedo_Daily_Tile_Class"]); 

// Merge collections
var albedo_merged = MOD10A1.combine(MCD43A3);

// Import features
var glacs = ee.FeatureCollection("users/jucross/glacier-outlines"); // Glacier polygons
var met_stations = ee.FeatureCollection("users/jucross/met-stations"); // Met stations

// Define TV ROI
var roi = ee.Geometry.Polygon([
  [[160, -77.25],
  [160, -78],
  [165, -78], 
  [165, -77.25], 
  [165, -77.25]]]);
  
// Filter based on ROI
var albedo_clip = albedo_merged.map(function(image) { return image.clip(roi); });

// Setup season date range
var date = ee.Date.fromYMD(2015, 11, 20); // year-07-01
var dateRange = ee.DateRange(date, date.advance(1, 'day'));

//Filter based on date
var albedo_filter = albedo_clip.filterDate(dateRange);


// Reduce image collection
var albedo_swir = albedo_filter.reduce(ee.Reducer.first());
print(albedo_swir);
var albedo_swir = albedo_swir.select(["Albedo_BSA_shortwave_first"]);


// Reduce image collection to mean albedo
//var albedo_mean = albedo_filter.mean();
//print(albedo_mean);

// Select first
//var albedo_first = ee.Image(albedo_filter.first());
// print(albedo_first);

//Reproject image (use cautiously)
var albedo_swir_proj = albedo_swir
    .reproject('EPSG:4326', null, 500);

// Mapping
Map.setCenter(162.75, -77.5, 7); // Set map center

//Add mean swir albedo layer to map
var swirVisParam = {"opacity":1,"bands":["Albedo_BSA_shortwave_first"],
"min":1,"max":1000,
"palette":["fff6cd","fdfdfd","1365ab"]};


Map.addLayer({
  eeObject: ee.Image(albedo_swir),
  visParams: swirVisParam,
  name: 'MODIS Albedo Black-sky SWIR'
});

Map.addLayer({
  eeObject: ee.Image(albedo_swir_proj),
  visParams: swirVisParam,
  name: 'MODIS Albedo Black-sky SWIR Re-projected'
});

// Add layers
Map.addLayer(glacs, {color: 'FF0000'}, 'Glaciers');
Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');

// Export //

Export.image.toDrive({
  image: albedo_swir,
  description: 'MODIS_albedo_img_export',
  scale: 500,
  region: roi
});

Export.image.toDrive({
  image: albedo_swir_proj,
  description: 'MODIS_albedo_proj_img_export',
  scale: 500,
  region: roi
});