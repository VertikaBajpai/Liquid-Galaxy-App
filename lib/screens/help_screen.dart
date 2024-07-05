import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text(
              'Help',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: SingleChildScrollView(
              child: Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Expanded(
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 100,
                    child: const Text(
                      'This app has basic functionalities to control Liquid galaxy.\nFirst of all connect the device with the LG rig by filling in the details in the Connection Page on the App Bar ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('assets/images/connection.png',
                          height: 200, width: 500)),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Now according to the task following functinalities can be performed: \n1.LOCATE HOMECITY \n2.ORBIT  HOMECITY\n3.REBOOT LG \n4.RELAUNCH LG\n5.SHUTDOWN LG \n6.PRINT HTML BUBBLE ON RIGHTMOST SLAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]),
          ))),
    );
  }
}
