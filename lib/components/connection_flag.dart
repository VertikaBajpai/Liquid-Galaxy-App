import 'package:flutter/material.dart';
import 'package:liquid_galaxy_kiss_app/utils/constants.dart';

class ConnectionFlag extends StatelessWidget {
  bool connectionStatus;
  ConnectionFlag({super.key, required this.connectionStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        padding: const EdgeInsets.all(4),
        color: Color.fromRGBO(227, 224, 224, 1),
        child: Row(
          children: [
            Icon(
              Icons.flag,
              color: connectionStatus ? Colors.green : Colors.red,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              connectionStatus ? 'Connected' : 'Disconnected',
              style: TextStyle(
                  color: connectionStatus ? Colors.green : Colors.red),
            )
          ],
        ));
  }
}
