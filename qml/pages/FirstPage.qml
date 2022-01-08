import QtQuick 2.0
import Sailfish.Silica 1.0
import QtLocation 5.0
import QtPositioning 5.3
import MapboxMap 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    MapboxMap {
        id: map
        z: 1
        accessToken: ""
        cacheDatabaseDefaultPath: true

        anchors.fill: parent

        Component.onCompleted: {
            // Paris, Hotel de Ville.
            center = QtPositioning.coordinate(48.85604723, 2.35390723);
            zoomLevel = 16

            map.addSource("location",
              {"type": "geojson",
                  "data": {
                      "type": "Feature",
                      "properties": { "name": "location" },
                      "geometry": {
                          "type": "Point",
                          "coordinates": [(48.85604723), (2.35390723)]
                      }
                  }
              })

            map.addLayer("location-uncertainty", {"type": "circle", "source": "location"}, "waterway-label")
            map.setPaintProperty("location-uncertainty", "circle-radius", 20)
            map.setPaintProperty("location-uncertainty", "circle-color", "#87cefa")
            map.setPaintProperty("location-uncertainty", "circle-opacity", 0.25)

            map.addLayer("location-case", {"type": "circle", "source": "location"}, "waterway-label")
            map.setPaintProperty("location-case", "circle-radius", 10)
            map.setPaintProperty("location-case", "circle-color", "white")

            map.addLayer("location", {"type": "circle", "source": "location"}, "waterway-label")
            map.setPaintProperty("location", "circle-radius", 5)
            map.setPaintProperty("location", "circle-color", "blue")

            map.addLayer("location-label", {"type": "symbol", "source": "location"})
            map.setLayoutProperty("location-label", "text-field", "{name}")
            map.setLayoutProperty("location-label", "text-justify", "left")
            map.setLayoutProperty("location-label", "text-anchor", "top-left")
            map.setLayoutPropertyList("location-label", "text-offset", [0.2, 0.2])
            map.setPaintProperty("location-label", "text-halo-color", "white")
            map.setPaintProperty("location-label", "text-halo-width", 2)
        }

        MapboxMapGestureArea {
            id: mouseArea
            map: map
            activeClickedGeo: true
            activeDoubleClickedGeo: true
            activePressAndHoldGeo: true

            onClicked: console.log("Click: " + mouse)
            onDoubleClicked: console.log("Double click: " + mouse)
            onPressAndHold: console.log("Press and hold: " + mouse)

            onClickedGeo: console.log("Click geo: " + geocoordinate + " sensitivity: " + degLatPerPixel + " " + degLonPerPixel)
            onDoubleClickedGeo: console.log("Double click geo: " + geocoordinate + " sensitivity: " + degLatPerPixel + " " + degLonPerPixel)
            onPressAndHoldGeo: console.log("Press and hold geo: " + geocoordinate + " sensitivity: " + degLatPerPixel + " " + degLonPerPixel)
        }
    }
}
