import 'dart:async';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:liquid_galaxy_kiss_app/kml/kml.dart';
import 'package:liquid_galaxy_kiss_app/kml/kmlGenerator.dart';
import 'package:liquid_galaxy_kiss_app/kml/mykml.dart';
import 'package:liquid_galaxy_kiss_app/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  Future<void> initConnection() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool?> connectToLG() async {
    await initConnection();

    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port),
          timeout: Duration(seconds: 5));
      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );
      final sftp = await _client?.sftp();
      await sftp?.open('/var/www/html/connection.txt',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.truncate |
              SftpFileOpenMode.write);
      print("Sftp done");
      if (kDebugMode) {
        print(
            'IP: $_host, port: $_port, username: $_username, noOfRigs: $_numberOfRigs');
      }
      connection = true;
      return true;
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Failed to connect: $e');
      }
      return false;
    }
  }

  Future<SSHSession?> searchplace(String place) async {
    try {
      if (_client == null) {
        if (kDebugMode) {
          print('SSH client is not initialized.');
        }
        return null;
      }
      print('search place between');
      await connectToLG();
      final execResult =
          await _client!.execute('echo "search=$place" >/tmp/query.txt');
      print('Search successful');
      return execResult;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while executing the command: $e');
      }
      return null;
    }
  }

  Future<void> shutdownLG() async {
    try {
      await connectToLG();
      for (var i = int.parse(_numberOfRigs); i >= 0; i--) {
        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S poweroff"');
      }
    } catch (e) {
      print('Error in shut down: $e');
    }
  }

  Future<void> rebootLG() async {
    try {
      print('Reached here out of nowhere');
      await connectToLG();

      for (var i = int.parse(_numberOfRigs); i > 0; i--) {
        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot"');
        print('Reboot successsful');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> relaunchLG() async {
    try {
      await connectToLG();
      for (var i = 1; i <= int.parse(_numberOfRigs); i++) {
        await connectToLG();
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo $_passwordOrKey | sudo -S service \\\${SERVICE} start
          else
            echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p $_passwordOrKey ssh -x -t lg@lg$i "\$RELAUNCH_CMD\""""
            "";
        await _client?.run(
            '"/home/$_username/bin/lg-relaunch" > /home/$_username/log.txt');
        await _client?.run(cmd);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> refresh() async {
    await connectToLG();
    try {
      const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
      const replace =
          '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
      final command =
          'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

      final clear =
          'echo $_passwordOrKey | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';
      await connectToLG();
      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        final clearCmd = clear.replaceAll('{{slave}}', i.toString());
        final cmd = command.replaceAll('{{slave}}', i.toString());
        String query = 'sshpass -p $_passwordOrKey} ssh -t lg$i \'{{cmd}}\'';

        await _client?.execute(query.replaceAll('{{cmd}}', clearCmd));
        await _client?.execute(query.replaceAll('{{cmd}}', cmd));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<SSHSession?> orbit_location() async {
    try {
      await connectToLG();
      myKML mykml = myKML();
      await mykml.createMyKML();

      final res =
          await _client?.execute('echo "playtour=Orbit" > /tmp/query.txt');
      if (res != null) print('Orbit successful');
      return res;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<SSHSession?> stopOrbit() async {
    try {
      await connectToLG();
      return await _client?.execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  flyTo(context, double latitude, double longitude, double altitude,
      double zoom, double tilt, double bearing) async {
    try {
      await connectToLG();
      // Future.delayed(Duration.zero).then((x) async {
      //   ref.read(lastGMapPositionProvider.notifier).state = CameraPosition(
      //     target: LatLng(latitude, longitude),
      //     zoom: zoom,
      //     tilt: tilt,
      //     bearing: bearing,
      //   );
      // });
      await _client?.run(
          'echo "flytoview=${KML.lookAtLinear(latitude, longitude, altitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      print(error);
    }
  }

  flyToOrbit(context, double latitude, double longitude, double altitude,
      double zoom, double tilt, double bearing) async {
    try {
      await connectToLG();
      await _client?.run(
          'echo "flytoview=${KMLGenerator.orbitLookAtLinear(latitude, longitude, altitude, zoom, tilt, bearing)}" > /tmp/query.txt');
    } catch (error) {
      print(error);
      await flyToOrbit(
          context, latitude, longitude, altitude, zoom, tilt, bearing);
    }
  }

  // flyToOrbit(context, double latitude, double longitude, double zoom,
  //     double tilt, double bearing) async {
  //   try {
  //     await connectToLG();
  //     await _client?.run(
  //         'echo "flytoview=${KMLMakers.orbitLookAtLinear(latitude, longitude, zoom, tilt, bearing)}" > /tmp/query.txt');
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print(error);
  //     }
  //     await flyToOrbit(context, latitude, longitude, zoom, tilt, bearing);
  //   }
  // }

  setRefresh() async {
    try {
      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
    } catch (error) {
      print(error);
    }
  }

  resetRefresh() async {
    try {
      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        String search =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
    } catch (error) {
      print(error);
    }
  }

  makeFile(String filename, String content) async {
    try {
      var localPath = await getApplicationDocumentsDirectory();
      await Permission.storage.request();

      File localFile = File('${localPath.path}/filename.kml');
      await localFile.writeAsString(content);
      return localFile;
    } catch (e) {
      print("Error in makeFile $e");
    }
  }

  // imageUpload() async {
  //   try {
  //     await connectToLG();
  //     await _client?.run(
  //         'echo "put assets/images/htmlbubble.png" | sshpass -p ${_passwordOrKey} sftp -oBatchMode=no -b - lg@lg2:assets/images/htmlbubble');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  uploadKml(File inputFile, String filename) async {
    SSHClient client = SSHClient(
      await SSHSocket.connect(_host, int.parse(_port)),
      username: _username,
      onPasswordRequest: () => _passwordOrKey,
    );
    // final pw = _passwordOrKey;
    // final user = _username;
    // final screenAmount = int.parse(_numberOfRigs);
    // final sftp = await client.sftp();
    // double anyKindofProgressBar;

    // final file = await sftp.open('/var/www/html/$filename',
    //     mode: SftpFileOpenMode.create |
    //         SftpFileOpenMode.truncate |
    //         SftpFileOpenMode.write);

    // var fileSize = await inputFile.length();
    // await file.write(inputFile.openRead().cast(), onProgress: (progress) {
    //   anyKindofProgressBar = progress / fileSize;
    // });
    final sftp = await client.sftp();
    double anyKindofProgressBar;
    final file = await sftp.open('/var/www/html/$filename',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);
    var fileSize = await inputFile.length();
    await file.write(inputFile.openRead().cast(), onProgress: (progress) {
      anyKindofProgressBar = progress / fileSize;
    });
  }

  renderInSlave(context) async {
    try {
      String openLogoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>VolTrac</name>
 <open>1</open>
 <description>The logo it located in the bottom left hand corner</description>
 <Folder>
   <name>tags</name>
   <Style>
     <ListStyle>
       <listItemType>checkHideChildren</listItemType>
       <bgColor>00ffffff</bgColor>
       <maxSnippetLines>2</maxSnippetLines>
     </ListStyle>
   </Style>
   <ScreenOverlay id="abc">
     <name>VolTrac</name>
     <Icon>
       <href>https://raw.githubusercontent.com/VertikaBajpai/kml-images/master/logo_slave2.png</href>
     </Icon>
     <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
     <screenXY x="0" y="0.98" xunits="fraction" yunits="fraction"/>
     <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
     <size x="0" y="0" xunits="pixels" yunits="fraction"/>
   </ScreenOverlay>
 </Folder>
</Document>
</kml>
 ''';
      await connectToLG();
      await _client!
          .execute("echo '$openLogoKML' > /var/www/html/kml/slave_2.kml");
    } catch (e) {
      return Future.error(e);
    }
  }

  cleanSlaves(context) async {
    try {
      await connectToLG();
      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        await _client?.run("echo '' > /var/www/html/kml/slave_$i.kml");
      }
    } catch (error) {
      print(error);
    }
  }
}
