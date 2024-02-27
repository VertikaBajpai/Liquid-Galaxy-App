class KML {
  String name;
  String content;

  KML(this.name, this.content);

  mount() {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
            <name>Network Links</name>
          <visibility>0</visibility>
          <open>0</open>
          <description>Network link example 2</description>
          <NetworkLink>
            <name>View Centered Placemark</name>
            <visibility>0</visibility>
            <open>0</open>
            <description>The view-based refresh allows the remote server to calculate
                the center of your screen and return a placemark.</description>
            <refreshVisibility>0</refreshVisibility>
            <flyToView>0</flyToView>
            <Link>
              <href>http://lg1/cgi-bin/viewCenteredPlacemark.py</href>
              <refreshInterval>2</refreshInterval>
              <viewRefreshMode>onStop</viewRefreshMode>
              <viewRefreshTime>1</viewRefreshTime>
            </Link>
          </NetworkLink>
      <name>$name</name>
        $content
    </Document>
  </kml>
''';
  }

  static String orbitLookAtLinear(double latitude, double longitude,
          double altitude, double zoom, double tilt, double bearing) =>
      '<gx:duration>2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><altitude>$altitude</altitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

  static String lookAtLinear(double latitude, double longitude, double altitude,
          double zoom, double tilt, double bearing) =>
      '<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><altitude>$altitude</altitude><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
}
