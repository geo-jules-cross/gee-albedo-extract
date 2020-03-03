/*
MODIS Albedo Visualizaton Slider
A script to collect and filter MODIS v006 MOD10A1 Daily Snow Albedo images.
Also visualizes the results spatially and graphically with a slider to 
control the date range for image collection filtering.
By: Julian Cross 8-10-18
*/

// Import MODIS albedo collection
var albedo_collection = ee.ImageCollection("MODIS/006/MOD10A1").select(["Snow_Albedo_Daily_Tile"]); 

// Import features
var glacs = ee.FeatureCollection('ft:14_eNPAAfAStqwSGXQxShLA11iO5Fh_sJquw7rxPF'); // Glacier Centroids
var met_stations = ee.FeatureCollection("users/jucross/met-stations"); // Met stations
var caa_station = ee.Feature(ee.Geometry.Point([162.96345, -77.612709])); // CAA Met Station

// Define TV ROI
var roi = ee.Geometry.Polygon([
  [[160, -77.25],
  [160, -78],
  [165, -78], 
  [165, -77.25], 
  [165, -77.25]]]);
  
// Filter based on ROI
var albedo_clip = albedo_collection.map(function(image) { return image.clip(roi); });

// Begin User Interface

// Define function for selection utility
function redraw(name){
  Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
  
  // Get the selected met station and center
  var selectedStation = ee.Feature(met_stations.filter(ee.Filter.eq('METLOCID', name)).first());
  print(selectedStation);
  Map.centerObject(selectedStation, 10);
  
    // Define showChart{} function for slider utility
  function showChart(year) {

    // Clear previous layer and chart
    Map.layers().reset();
    panel1.clear();

    // Setup season date range
    var date = ee.Date.fromYMD(year, 7, 1); // year-07-01
    var dateRange = ee.DateRange(date, date.advance(1, 'year'));
    
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
    Map.addLayer(glacs, {color: 'FF0000'}, 'Glacier Centroids');
    Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
    //Map.addLayer(caa_station, {color: 'CE5903'}, 'CAA Station');

    // Create a chart for selected met station
    var albedoSelectedChart = ui.Chart.image.series(albedo, selectedStation)
        .setChartType('LineChart')
        .setOptions({
            title: ee.String('Albedo Time Series at' + name),
            vAxis: {title: 'Albedo'}
    });

    // Create a chart for ALL met stations
    var albedoAllChart = ui.Chart.image.seriesByRegion(
      albedo, met_stations, ee.Reducer.mean(), 'Snow_Albedo_Daily_Tile', 200, 'system:time_start', 'label')
          .setChartType('LineChart')
          .setOptions({
            title: 'Albedo Time Series at All Met Stations',
            vAxis: {title: 'Albedo'},
            lineWidth: 1,
            pointSize: 4
    });
    
    // Add chart to panel
    panel1.add(albedoSelectedChart);
    panel1.add(albedoAllChart);

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
    min: 2001,
    max: 2015,
    value: 2001, // Set a default value.
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
  Map.add(select); // Add the drop-down 'select' widget to the map
}

// Get the met station names
var names = ee.List(met_stations.aggregate_array('METLOCID'));
print(names.getInfo());

// Initialize met station selector
var select = ui.Select({
  items: names.getInfo(), 
  onChange: redraw,
  style: {position: 'top-center', padding: '7px'}}
  );

select.setPlaceholder('Choose a Met Station ...'); 
 
// Mapping
Map.addLayer(met_stations, {color: 'CE5903'}, 'Met Stations');
Map.setCenter(162.75, -77.5, 7); // Set map center
Map.add(select); // Add the drop-down 'select' widget to the map  