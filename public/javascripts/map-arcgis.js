// dojo.require("dijit.dijit"); // optimize: load dijit layer
// dojo.require("dijit.layout.BorderContainer");
// dojo.require("dijit.layout.ContentPane");
// dojo.require("esri.map");
// dojo.require("esri.tasks.query");
// dojo.require("esri.tasks.identify");
// dojo.require("esri.toolbars.draw");
// dojo.require("esri.layers.agstiled");
// dojo.require("esri.layers.agsdynamic");
// dojo.require("esri.toolbars.navigation");//pan javascrpt
// dojo.require("esri.dijit.BasemapGallery");
// dojo.require("dijit.Tooltip");
// dojo.require("dijit.form.Button");
// dojo.require("dijit.Menu");

var djConfig = {parseOnLoad: true};
var map;

// See the ArcGIS Online site for services:
// http://arcgisonline/home/search.html?t=content&f=typekeywords:service    
var basemap = new esri.layers.ArcGISTiledMapServiceLayer(
	"http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer");
var imagemap = new esri.layers.ArcGISTiledMapServiceLayer(
	"http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"));

// Washington, DC
var initExtent = new esri.geometry.Extent(
	{"xmin":-8591189.922223657,
	 "ymin":4695514.45486338,
	 "xmax":-8557557.629778225,
	 "ymax":4726089.266177409,
	 "spatialReference":{"wkid":102100}
	});

function addPoint(evt) {
  map.infoWindow.setTitle("Coordinates");
  //Need to convert the coordinates from the map's spatial reference (web mercator) to geographic to display lat/lon values
  var geoPt = esri.geometry.webMercatorToGeographic(evt.mapPoint);
  map.infoWindow.setContent("lat/lon : " + geoPt.y.toFixed(2) + ", " + geoPt.x.toFixed(2) +
    "<br />screen x/y : " + evt.screenPoint.x + ", " + evt.screenPoint.y);
  map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
}

// function init() {
// 	map = new esri.Map("mapDiv", {
// 	nav : true
//     });
//     startExtent = new esri.geometry.Extent(-104.1, 36.2, -88.4, 44.7, spatialRef);
//     map.setExtent(startExtent);
//     map.addLayer(new esri.layers.ArcGISTiledMapServiceLayer("http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_StreetMap_World_2D/MapServer"));
//     var dataLayer = map.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer(mapAddress));
//     dataLayer.onLoad = buildLayerList;
//   
//     navToolbar = new esri.toolbars.Navigation(map);
//     dojo.connect(map, "onLoad", function() {
//         dojo.connect(map, "onMouseMove", showCoordinates);
//         dojo.connect(map, "onMouseDrag", showCoordinates);
// 	dojo.connect(map, "onClick", runIdentifyQuery);
//         setZoom();
//     });
// 
// 
//     dojo.connect(map.infoWindow, "onHide", function() {
//         map.graphics.clear();
//     });
//     
// }
