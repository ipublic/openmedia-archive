
function addPoint(evt) {
  map.infoWindow.setTitle("Coordinates");
  //Need to convert the coordinates from the map's spatial reference (web mercator) to geographic to display lat/lon values
  var geoPt = esri.geometry.webMercatorToGeographic(evt.mapPoint);
  map.infoWindow.setContent("lat/lon : " + geoPt.y.toFixed(2) + ", " + geoPt.x.toFixed(2) +
    "<br />screen x/y : " + evt.screenPoint.x + ", " + evt.screenPoint.y);
  map.infoWindow.show(evt.screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
}
