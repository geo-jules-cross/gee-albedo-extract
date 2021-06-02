 /*
MODIS Albedo Visualizaton Slider
A script to collect and filter MODIS v006 MCD43A3 BRDF Albedo and MOD10A1 Daily Snow images.
Also visualizes the results spatially and graphically with a slider to 
control the date range for image collection filtering.
By: Julian Cross 10-8-18
*/

// Import MODIS albedo collection
var MCD43A3 = ee.ImageCollection("MODIS/006/MCD43A3").select(["Albedo_WSA_shortwave", 
                                                              "Albedo_BSA_shortwave", 
                                                              "Albedo_BSA_vis", 
                                                              "BRDF_Albedo_Band_Mandatory_Quality_shortwave"]);

// Import MODIS snow albedo collection
var MOD10A1 = ee.ImageCollection("MODIS/006/MOD10A1").select(["Snow_Albedo_Daily_Tile",
                                                              "NDSI_Snow_Cover",
                                                              "NDSI",
                                                              "NDSI_Snow_Cover_Class",
                                                              "Snow_Albedo_Daily_Tile_Class"]);
                                                              
// Merge collections
var albedo_merged = MOD10A1.combine(MCD43A3);

// Update the collection with snow and ice mask.
var albedo_masked = albedo_merged.map(
  function(img){ var mask = img.select('NDSI_Snow_Cover').lt(100);
  //function(img){ var mask = img.select('NDSI_Snow_Cover').lte(100).and(img.select('NDSI_Snow_Cover').gte(50));
  //function(img){ var mask = img.select('NDSI').lte(10000).and(img.select('NDSI').gte(3000));
  return img.updateMask(mask)});

// Import features
var glacs = ee.FeatureCollection("users/jucross/glacier-groups"); // Glacier extract groups

var modelGlacs = ee.FeatureCollection("users/jucross/glacier-model"); // Model glacier polygons
var glacOutlines = ee.FeatureCollection("users/jucross/glacier-outlines"); // Glacier outlines
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
var date = ee.Date.fromYMD(2000, 7, 1); // year-07-01
var dateRange = ee.DateRange(date, date.advance(1, 'year'));
    
//Filter based on date
var albedo = albedo_clip.filterDate(dateRange);
    
// Reduce image collection to mean albedo
var albedo_mean = albedo.reduce(ee.Reducer.mean());

// Reduce image collection to min 
var albedo_min = albedo.reduce(ee.Reducer.min());
    
//Reproject image (use cautiously)
var mean_reproj = albedo_mean
  .reproject('EPSG:4326', null, 250);
  
var min_reproj = albedo_min
  .reproject('EPSG:4326', null, 250);

// Mapping

// Visualization Parameters
var swirVisParam = {"opacity":1,
"bands":["Albedo_BSA_shortwave_min"],
"min":1,"max":1000,
"palette":["68492f","ffe8be","3f61a1","c4e9ff","ffffff"]};

//Add mean albedo layer to map
Map.addLayer({
  eeObject: ee.Image(min_reproj),
  visParams: swirVisParam,
  name: 'MODIS Albedo Mean '
});

Map.addLayer(glacs, {color: 'FF0000'}, 'Glaciers');
Map.addLayer(glacs, {color: 'FF0000'}, 'Glacier Centroids');
Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
Map.setCenter(162.75, -77.5, 7); // Set map center