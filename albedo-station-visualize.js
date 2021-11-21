/*
MODIS Albedo Visualizaton Slider
A script to collect and filter MODIS v006 MOD10A1 Daily Snow Albedo and MCD43A3 Albedo Model images.
Also visualizes the results spatially and graphically with a slider to 
control the date range for image collection filtering.
By: Julian Cross 8-10-18
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

// Import features
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

// Begin User Interface

// Define function for selection utility
function redraw(name){
  Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
  
  // Get the selected met station and center
  var selectedStation = ee.Feature(met_stations.filter(ee.Filter.eq('METLOCID', name)).first());
  Map.centerObject(selectedStation, 10);
  
  // Define showChart{} function for slider utility
  function showChart(year) {

    // Clear previous layer and chart
    Map.layers().reset();
    panel1.clear();

    // Setup season date range
    var date = ee.Date.fromYMD(year, 7, 1); // year-07-01
    var dateRange = ee.DateRange(date, date.advance(5, 'year'));
    
    //Filter based on date
    var albedo = albedo_clip.filterDate(dateRange);
    
    // Reduce image collection to mean albedo
    var albedo_mean = albedo.reduce(ee.Reducer.mean());

    //Add mean albedo layer to map
    Map.addLayer({
      eeObject: ee.Image(albedo_mean),
      visParams: {opacity:1, min:1, max:100, gamma:1},
      name: 'MODIS Albedo Mean ' + String(year)
    });

    // Add layers
    Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');

    // Create a chart for selected met station
    var selectedMetChart = ui.Chart.image.series(albedo, selectedStation)
        .setChartType('LineChart')
        .setOptions({
            title: name,
            vAxis: {title: 'Albedo'}
    });
    
    // Add chart to panel
    panel1.add(selectedMetChart);

    //Add panel to map
    Map.add(panel1);
  }
  
  // Create a panel that contains the chart
  var panel1 = ui.Panel({
  layout: ui.Panel.Layout.flow('vertical'),
  style: {position: 'top-left', padding: '7px'}
  });

  // Create a label and slider.
  var label = ui.Label('MODIS Mean Seasonal Albedo');
  var slider = ui.Slider({
    min: 2000,
    max: 2015,
    value: 2000, // Set a default value.
    step: 1,
    onChange: showChart,
    style: {stretch: 'horizontal'}});

  // Create a panel that contains the label and slider
  var panel2 = ui.Panel({
    widgets: [label, slider],
    layout: ui.Panel.Layout.flow('vertical'),
    style: {position: 'bottom-center', padding: '7px'}
    });
  
  Map.add(panel2); // Add slider panel to the map
  Map.add(selectMet); // Add the drop-down 'select' widget to the map
}

// Get the met station names
var names = ee.List(met_stations.aggregate_array('METLOCID'));

// Initialize met station selector
var selectMet = ui.Select({
  items: names.getInfo(), 
  onChange: redraw,
  style: {position: 'top-center', padding: '7px'}}
  );

selectMet.setPlaceholder('Choose a Met Station ...');
 
// Mapping
Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
Map.setCenter(162.75, -77.5, 7); // Set map center
Map.add(selectMet); // Add the drop-down 'select' widget to the map