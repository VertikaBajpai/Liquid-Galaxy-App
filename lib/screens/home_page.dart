import 'package:flutter/material.dart';
import 'package:liquid_galaxy_kiss_app/components/connection_flag.dart';
import 'package:liquid_galaxy_kiss_app/connection/ssh.dart';
import 'package:liquid_galaxy_kiss_app/screens/connect.dart';
import 'package:liquid_galaxy_kiss_app/screens/help_screen.dart';
import 'package:liquid_galaxy_kiss_app/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool orbitPlaying = false;
  double latitude = 26.41091658808481;
  double longitude = 80.33231151633366;
  double altitude = 1000;
  SSH ssh = SSH();
  orbitPlay() async {
    setState(() {
      orbitPlaying = true;
    });
    ssh.flyTo(context, latitude, longitude, altitude, 1, 0, 0);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (int i = 0; i <= 360; i += 10) {
      if (!mounted) {
        return;
      }
      if (!orbitPlaying) {
        break;
      }

      ssh.flyToOrbit(
          context, latitude, longitude, altitude, 1, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    if (!mounted) {
      return;
    }

    ssh.flyTo(context, latitude, longitude, altitude, 1, 0, 0);
    setState(() {
      orbitPlaying = false;
    });
  }

  orbitStop() async {
    setState(() {
      orbitPlaying = false;
    });
    ssh.flyTo(context, 26.41091658808481, 80.33231151633366, 1000, 1, 0, 0);
  }

  @override
  void initState() async {
    super.initState();
    ssh = SSH();
    await _connectToLG();
  }

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connection = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Liquid Galaxy Functionalities',
                style: TextStyle(color: Colors.black, fontFamily: 'Serif')),
            backgroundColor: const Color.fromRGBO(227, 224, 224, 1),
            actions: <Widget>[
              ConnectionFlag(connectionStatus: connection),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Connect'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ConnectScreen(),
                        ),
                      );
                      setState(() async {
                        await _connectToLG();
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('About'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AboutPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ]),
        body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/space.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(
                padding: const EdgeInsets.all(50),
                width: double.infinity,
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column1(context),
                        const SizedBox(
                          width: 20,
                        ),
                        Column2(context)
                      ]),
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                      // height: 200,
                      // width: 1200,
                      // decoration: const BoxDecoration(
                      //   color: Color.fromARGB(255, 100, 126, 139),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Color.fromARGB(255, 220, 217, 217),
                      //       offset: Offset(
                      //         5.0,
                      //         5.0,
                      //       ),
                      //       blurRadius: 10.0,
                      //       spreadRadius: 2.0,
                      //     ), //BoxShadow
                      //     BoxShadow(
                      //       color: Color.fromARGB(255, 125, 124, 124),
                      //       offset: Offset(0.0, 0.0),
                      //       blurRadius: 0.0,
                      //       spreadRadius: 0.0,
                      //     ), //BoxShadow
                      //   ],
                      // ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            height: 150,
                            width: 350,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                              color: Color.fromRGBO(207, 238, 235, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            child: TextButton(
                                child: const Text(
                                  'PRINT HTML BUBBLE',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Serif',
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  await ssh.renderInSlave(context);
                                })),
                        const SizedBox(width: 50),
                        Container(
                            padding: const EdgeInsets.all(10),
                            height: 150,
                            width: 350,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ),
                                //BoxShadow
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: Color.fromRGBO(207, 238, 235, 1),
                            ),
                            child: TextButton(
                                child: const Text(
                                  'CLEAN LOGO',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Serif',
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  await ssh.cleanSlaves(context);
                                })),
                      ]))
                ]))));
  }

  Widget Column1(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 100, 126, 139),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 220, 217, 217),
              offset: Offset(
                5.0,
                5.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Color.fromARGB(255, 125, 124, 124),
              offset: Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxShadow
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: 300,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                  color: Color.fromRGBO(227, 224, 224, 1),
                ),
                child: TextButton(
                    child: const Text(
                      'Move Lg To HomeCity',
                      style:
                          TextStyle(fontFamily: 'Serif', color: Colors.black),
                    ),
                    onPressed: () async {
                      await ssh.searchplace('Kanpur');
                    })),
            const SizedBox(
              height: 30,
            )
          ]),
          Row(children: [
            const SizedBox(
              width: 100,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: 300,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
                  color: Color.fromRGBO(227, 224, 224, 1),
                ),
                child: TextButton(
                    child: const Text(
                      'Orbit HomeCity',
                      style:
                          TextStyle(fontFamily: 'Serif', color: Colors.black),
                    ),
                    onPressed: () async {
                      // await ssh.flyToOrbit(context, 26.41091658808481,
                      //     80.33231151633366, 10, 66.768762, 1736.948935);
                      await ssh.orbit_location();
                      await orbitPlay();
                    })),
          ]),
          Row(children: [
            const SizedBox(
              width: 200,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  width: 300,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                    color: Color.fromRGBO(227, 224, 224, 1),
                  ),
                  child: TextButton(
                      child: const Text(
                        'Stop Orbit',
                        style:
                            TextStyle(fontFamily: 'Serif', color: Colors.black),
                      ),
                      onPressed: () async {
                        await orbitStop();
                      })),
            )
          ]),
        ]));
  }

  Widget Column2(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 100, 126, 139),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 220, 217, 217),
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
          BoxShadow(
            color: Color.fromARGB(255, 125, 124, 124),
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(
              padding: const EdgeInsets.all(10),
              height: 100,
              width: 300,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
                color: Color.fromRGBO(227, 224, 224, 1),
              ),
              child: TextButton(
                  child: const Text(
                    'Relaunch Lg',
                    style: TextStyle(fontFamily: 'Serif', color: Colors.black),
                  ),
                  onPressed: () async {
                    await ssh.relaunchLG();
                  })),
          const SizedBox(
            height: 30,
          )
        ]),
        Row(children: [
          const SizedBox(
            width: 100,
          ),
          Container(
              padding: const EdgeInsets.all(10),
              height: 100,
              width: 300,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ), //BoxShadow
                ],
                color: Color.fromRGBO(227, 224, 224, 1),
              ),
              child: TextButton(
                  child: const Text(
                    'REBOOT LG',
                    style: TextStyle(fontFamily: 'Serif', color: Colors.black),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              backgroundColor:
                                  const Color.fromRGBO(227, 224, 224, 1),
                              title: const Text('Warning'),
                              content: const Text(
                                  'Are you sure you want to Reboot LG?'),
                              actions: [
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        SSH ssh = SSH();
                                        await ssh.connectToLG();
                                        ssh.rebootLG();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Reboot'),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'))
                                  ],
                                )
                              ]);
                        });
                  }))
        ]),
        Row(children: [
          const SizedBox(
            width: 200,
          ),
          Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  width: 300,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                    color: Color.fromRGBO(227, 224, 224, 1),
                  ),
                  child: TextButton(
                      child: const Text(
                        'SHUT DOWN LG',
                        style:
                            TextStyle(fontFamily: 'Serif', color: Colors.black),
                      ),
                      onPressed: () async {
                        await ssh.shutdownLG();
                      })))
        ]),
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}
