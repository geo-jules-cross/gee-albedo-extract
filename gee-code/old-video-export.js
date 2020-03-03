var ExportCol = function(col, folder, scale, type,
                         nimg, maxPixels, region) {
    type = type || "float";
    nimg = nimg || 500;
    scale = scale || 1000;
    maxPixels = maxPixels || 1e10;

    var colList = col.toList(nimg);
    var n = colList.size().getInfo();

    for (var i = 0; i < n; i++) {
      var img = ee.Image(colList.get(i));
      var id = img.id().getInfo();
      region = region || img.geometry().bounds().getInfo()["coordinates"];

      var imgtype = {"float":img.toFloat(), 
                     "byte":img.toByte(), 
                     "int":img.toInt(),
                     "double":img.toDouble()
                    }

      Export.image.toDrive({
        image:imgtype[type],
        description: id,
        folder: folder,
        fileNamePrefix: id,
        region: region,
        scale: scale,
        maxPixels: maxPixels})
    }
  }

// Imports //

// MODIS Snow Cover Daily L3 Global 500m Grid
var collection_snow = ee.ImageCollection("MODIS/006/MOD10A1");

// MODIS NDSI Daily 500m Grid
var collection_ndsi = ee.ImageCollection("MODIS/MOD09GA_NDSI");

// MODIS Aqua BDRF Daily 500m Grid
var collection_aqua = ee.ImageCollection("MODIS/006/MCD43A4");

// MODIS Aqua Daily 500m Grid
//var collection_aqua = ee.ImageCollection("MODIS/006/MOD09A1");


// Filtering //

//Filter based on date
var collection_snow_date = collection_snow.filterDate('2004-11-01','2005-03-31');
var collection_ndsi_date = collection_ndsi.filterDate('2004-11-01','2005-03-31');
var collection_aqua_date = collection_aqua.filterDate('2004-11-01','2005-03-31');

// Filter based on ROI
//Dry Valleys & McMurdo
var roi = ee.Geometry.Polygon([
  [[160, -77.25], [160, -78],[165, -78], [165, -77.25], [165, -77.25]]]);

var clip_collection_snow = collection_snow_date.map(function(image) { return image.clip(roi); });
var clip_collection_ndsi = collection_ndsi_date.map(function(image) { return image.clip(roi); });
var clip_collection_aqua = collection_aqua_date.map(function(image) { return image.clip(roi); });

var cells = ee.FeatureCollection("users/jucross/model_cells");

// Mapping //

Map.setCenter(162.5, -77.75, 7);
var visParams1 = {"opacity":1,"bands":["NDSI"],"min":0.25,"palette":["0c6dd2","84e1fd","fff8f3","bee1ff"]};
var visParams2 = {"opacity":1,"bands":["NDSI_Snow_Cover"],"min":1,"max":100,"gamma":1.072};
var visParams3 = {"opacity":1,"bands":["Nadir_Reflectance_Band1","Nadir_Reflectance_Band4","Nadir_Reflectance_Band3"]};
var visParams4 = {"opacity":1,"bands":["Nadir_Reflectance_Band1","Nadir_Reflectance_Band4","Nadir_Reflectance_Band3"],"min":500,"max":9000,"gamma":1};
var visParams5 = {"opacity":1,"bands":['sur_refl_b01', 'sur_refl_b04', 'sur_refl_b03'],"min":500,"max":9000,"gamma":1};
var visParams6 = {"opacity":1,"bands":["Snow_Albedo_Daily_Tile"],"min":1,"max":100,"gamma":1.072};

Map.addLayer(clip_collection_ndsi, visParams1, 'MODIS NDSI Daily');
Map.addLayer(clip_collection_snow, visParams2, 'MODIS Snow Daily');
Map.addLayer(clip_collection_snow, visParams6, 'MODIS Albedo Daily');
Map.addLayer(clip_collection_aqua, visParams4, 'MODIS Aqua Daily');

// Exports //

//import ExportCol from "users/jucross/default/ExportCollection";

// ExportCol(clip_collection, "MODIS-NDSI-daterange", 0);

// Convert Aqua collection for Video
var vid_collection_aqua = clip_collection_aqua
//.select(['sur_refl_b01', 'sur_refl_b04', 'sur_refl_b03'])
.select(['Nadir_Reflectance_Band1', 'Nadir_Reflectance_Band4', 'Nadir_Reflectance_Band3'])
  // Need to make the data 8-bit.
  .map(function(image) {
   return image.visualize({
   min:500,
   max:9000,
   gamma: 1 //or 0.75
   });
  //.map(function(image) {
    //return image.multiply(512).uint8();
  //});
});  
  
// Force RGB format
var vid_collection_ndsi =  clip_collection_ndsi
  .map(function(image){
  return image.visualize({
    forceRgbOutput: true,
    palette: ["0c6dd2","84e1fd","fff8f3","bee1ff"],
    min: 0.25,
    max: 1});
});

// Force RGB format
var vid_collection_snow =  clip_collection_snow
.select(['NDSI_Snow_Cover'])
  .map(function(image){
  return image.visualize({
    forceRgbOutput: true,
    gamma: 1.0,
    min: 0,
    max: 100});
});

// Force RGB format
var vid_collection_alb =  clip_collection_snow
.select(['Snow_Albedo_Daily_Tile'])
  .map(function(image){
  return image.visualize({
    forceRgbOutput: true,
    gamma: 1.0,
    min: 0,
    max: 100});
});

// Export Videos
//Export.video.toDrive({
  //collection: vid_collection_aqua,
  //description: 'MODIS_AQUA_vid',
  //dimensions: 1080,
  //framesPerSecond: 10,
  //region: roi
//});

//Export.video.toDrive({
  //collection: vid_collection_ndsi,
  //description: 'MODIS_NDSI_vid',
  //dimensions: 1080,
  //framesPerSecond: 10,
  //region: roi
//});

//Export.video.toDrive({
  //collection: vid_collection_snow,
  //description: 'MODIS_Snow_vid',
  //dimensions: 1080,
  //framesPerSecond: 10,
  //region: roi
//});

//Export.video.toDrive({
  //collection: vid_collection_alb,
  //description: 'MODIS_Alb_vid',
  //dimensions: 1080,
  //framesPerSecond: 10,
  //region: roi
//});