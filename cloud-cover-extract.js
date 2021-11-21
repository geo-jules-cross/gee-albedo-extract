 /*
MODIS Cloud Cover Extract
A script to collect and filter MODIS v006 MOD10A1 Daily Snow images.
By: Julian Cross 7-19-19
*/

// Import MODIS snow albedo collection
var MOD10A1 = ee.ImageCollection("MODIS/006/MOD10A1").select(["NDSI_Snow_Cover_Class",
                                                              "Snow_Albedo_Daily_Tile_Class"]);
                                                              
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
var clouds_clip = MOD10A1.map(function(image) { return image.clip(roi); });

// Setup season date range
var date = ee.Date.fromYMD(2000, 7, 1); // year-07-01
var dateRange = ee.DateRange(date, date.advance(5, 'year'));

//Filter based on date
var clouds = clouds_clip.filterDate(dateRange);
 
print(clouds);
 
// Mapping
Map.addLayer(glacs, {color: 'FF0000'}, 'Glacier Centroids');
Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
Map.setCenter(162.75, -77.5, 7); // Set map center