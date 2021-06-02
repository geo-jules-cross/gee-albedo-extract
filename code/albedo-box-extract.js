 /*
MODIS Albedo Comparion to Albedo Box Data
A script to collect and filter MODIS v006 MCD43A3 BRDF Albedo and MOD10A1 Daily Snow images.
These data are compared to 'albedo box' data acquired by Bergstrom et al 2019.
By: Julian Cross 11-15-19
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
// var albedo_merged = MOD10A1.combine(MCD43A3);
var albedo_merged = MCD43A3;

// Import features
var allFlights = ee.FeatureCollection("users/jucross/albedo-box-points");   // Albedo box points
var glaciers = ee.FeatureCollection("users/jucross/glacier-outlines");      // Glacier outlines
var met_stations = ee.FeatureCollection("users/jucross/met-stations");      // Met stations

// Define TV ROI
var roi = ee.Geometry.Polygon([
  [[160, -77.25],
  [160, -78],
  [165, -78], 
  [165, -77.25], 
  [165, -77.25]]]);
  
// Filter based on ROI
var albedo_clip = albedo_merged.map(function(image) { return image.clip(roi); });

//////////// Begin User Interface //////

// Define function for selection utility
function redraw(name){
  Map.addLayer(allFlights, {color: 'FF0000'}, 'Albedo Box Points');
  Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
  Map.addLayer(glaciers, {color: 'CE5903'}, 'Glaciers');
  
  // Center map on selected flight
  var Flight = ee.FeatureCollection(allFlights.filter(ee.Filter.eq('flight', name)));
  var centerFlight = ee.Feature(allFlights.filter(ee.Filter.eq('flight', name)).first());
  Map.centerObject(centerFlight, 10);
  
  Map.addLayer(Flight, {color: 'FF0000'}, 'Albedo Box Points');
  
  // Clear previous layer and chart
  Map.layers().reset();
  
  // Setup flight date filter
  var dateStr = centerFlight.get('time');
  var dateRaw = ee.Date.parse("MM/dd/YY k:m",dateStr);
  var year = dateRaw.get('year');
  var month = dateRaw.get('month');
  var day = dateRaw.get('day');
  var date = ee.Date.fromYMD(year, month, day);
  
  //Filter based on date
  var albedo = albedo_clip.filterDate(date).first();
  
  // Reproject mean image (use cautiously)
  var albedo_proj = albedo.reproject('EPSG:4326', null, 250);

  // Visualization Parameters
  var swirVisParam = {"opacity":1,
                      "bands":["Albedo_BSA_shortwave"],
                      "min":1,"max":1000,
                      "palette":["68492f","ffe8be","3f61a1","c4e9ff","ffffff"]};

  //Add mean albedo layer to map
  Map.addLayer({
    eeObject: ee.Image(albedo_proj),
    visParams: swirVisParam,
    name: 'MODIS Albedo Image this Date'
  });

  // Add layers
  Map.addLayer(glaciers, {color: 'CE5903'}, 'Glaciers');
  Map.addLayer(Flight, {color: 'FF0000'}, 'Albedo Box Points');
  Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
  
  // Image Reducer
  var albedoFlight =  albedo.reduceRegions({
                      collection: Flight,
                      reducer: ee.Reducer.mean(),
                      scale: 30,
                      });

  // Create a chart for selected flight
  //var flightChart = ui.Chart.image.regions(albedo, Flight, ee.Reducer.mean(), 30)
  //    .setChartType('ScatterChart')
  //    .setOptions({
  //         title: name,
  //         vAxis: {title: 'Albedo Values'}
  //});
  
  // Create a panel that contains the chart
  // var panel1 = ui.Panel({
  //                 layout: ui.Panel.Layout.flow('vertical'),
  //                 style: {position: 'top-left', padding: '7px'}
  // });
  
  // Add chart to panel
  // panel1.add(flightChart);

  // Add panel to map
  // Map.add(panel1);

  //Map.add(selectFlight);
  
  // Drop extra fields
  var albedoExport = albedoFlight.select(['.*'],null,false);
  
  // Table to Drive Export Example
  Export.table.toDrive({
    collection: albedoExport,
    description: name,
    folder: 'Albedo Box',
    fileFormat: 'CSV'
  }); 
  
}

// List all separate flights
var flight_date = ['run1_15', 'run2_15', 'run3_15', 'run4_15', 'run5_15', 'run1_16', 'run2_16',
                  'run3_16', 'run4_16', 'run5_16', 'run1_17', 'run2_17', 'run3_17', 'run4_17'];

// Initialize flight selector
var selectFlight = ui.Select({
  items: flight_date, 
  onChange: redraw,
  style: {position: 'top-center', padding: '7px'}}
  );

selectFlight.setPlaceholder('Choose a Flight Date ...'); 
 
// Mapping
Map.addLayer(glaciers, {color: 'CE5903'}, 'Glaciers');
Map.addLayer(allFlights, {color: 'FF0000'}, 'Albedo Box Points');
Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
Map.setCenter(162.75, -77.5, 7); // Set map center

Map.add(selectFlight);