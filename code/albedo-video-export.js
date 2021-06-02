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

// Import MODIS albedo collection
var MCD43A3 = ee.ImageCollection("MODIS/006/MCD43A3").select(["Albedo_BSA_shortwave"]);

// Filtering //

// Define TV ROI
var roi = ee.Geometry.Polygon([
  [[160, -77.25],
  [160, -78],
  [165, -78], 
  [165, -77.25], 
  [165, -77.25]]]);


// Clip based on ROI
var albedo_clip = MCD43A3.map(function(image) { return image.clip(roi); });

// Setup season date range
var date = ee.Date.fromYMD(2000, 7, 1); // year-07-01
var dateRange = ee.DateRange(date, date.advance(2, 'year'));

//Filter based on date
var albedo_filter = albedo_clip.filterDate(dateRange);

//Reproject mean image (use cautiously)
var albedo_reproj = albedo_filter.map(function(image) {return image.reproject('EPSG:4326', null, 250)});

// Exports //

// Force RGB format
var vid_collection_MCD43A3 =  albedo_reproj
.select(['Albedo_BSA_shortwave'])
  .map(function(image){
  return image.visualize({
    forceRgbOutput: true,
    min: 0,
    max: 1000,
    palette:["68492f","ffe8be","3f61a1","c4e9ff","ffffff"]
  });
});

// Export Videos
Export.video.toDrive({
  collection: vid_collection_MCD43A3,
  description: 'MCD43A3_vid_MODIS_Export_2000to2002',
  dimensions: 720,
  framesPerSecond: 10,
  region: roi,
  maxFrames: 20000
});