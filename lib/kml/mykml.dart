import 'dart:io';

import 'package:liquid_galaxy_kiss_app/connection/ssh.dart';
import 'package:liquid_galaxy_kiss_app/kml/LookAt.dart';
import 'package:liquid_galaxy_kiss_app/kml/kml.dart';
import 'package:liquid_galaxy_kiss_app/kml/kmlGenerator.dart';
import 'package:liquid_galaxy_kiss_app/kml/orbit.dart';

class myKML {
  LookAt lookAtobj = LookAt(
      80.33231151633366, 26.41091658808481, '10', '66.768762', '1736.948935');

  createMyKML() async {
    SSH ssh = SSH();
    await ssh.connectToLG();
    final orbit = Orbit.generateOrbitTag(lookAtobj);
    final kmlorbit = Orbit.buildOrbit(orbit);
    print("Hello 1");
    final kmldata = KML('Kanpur', kmlorbit).mount();
    final kmlfile =
        await KMLGenerator.generateKML(kmldata.toString(), 'Homecity');
    print("Hello 2");
    File myfile = await ssh.makeFile('Homecity', kmlfile.toString());

    print("Hello 3");
    await ssh.uploadKml(myfile, 'LG_KML_file');
    print("Hello 4");
  }
}
