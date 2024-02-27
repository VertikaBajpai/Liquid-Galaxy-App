import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';

class KMLGenerator {
  static generateKML(data, filename) async {
    try {
      // Directory dir = Directory('/storage/emulated/0/Download');
      var savePath = (await DownloadsPath.downloadsDirectory())?.path;
      final file = File("$savePath/$filename.kml");
      await file.writeAsString(data);
      return file;
    } catch (e) {
      if (kDebugMode) {
        print("Error in generateKML ${e}");
      }
    }
  }

  static String orbitLookAtLinear(double latitude, double longitude,
          double altitude, double zoom, double tilt, double bearing) =>
      '<gx:duration>2</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><altitude>$altitude</altitude><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
}
