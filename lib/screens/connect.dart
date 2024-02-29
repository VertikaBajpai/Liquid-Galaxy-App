import 'package:flutter/material.dart';
import 'package:liquid_galaxy_kiss_app/components/connection_flag.dart';
import 'package:liquid_galaxy_kiss_app/connection/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);
  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool connectionStatus = false;
  bool passwordVisible = false;
  late SSH ssh;
  @override
  void initState() {
    super.initState();
    ssh = SSH();
    // saveSettings();
    // refresh();
  }

  void refresh() async {
    bool? connect = await ssh.connectToLG();

    if (connect == true) {
      setState(() {
        connectionStatus = true;
      });
    }
  }

  final TextEditingController ipController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController no_of_rigs_Controller = TextEditingController();

  Future<void> saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (ipController.text.isNotEmpty)
      await prefs.setString('ipAddress', ipController.text);
    // } else {
    //   ipController.text = prefs.getString('ipAddress') ?? '';
    // }
    if (usernameController.text.isNotEmpty)
      await prefs.setString('username', usernameController.text);
    // } else {
    //   usernameController.text = prefs.getString('username') ?? '';
    // }
    if (passwordController.text.isNotEmpty)
      await prefs.setString('password', passwordController.text);
    // } else {
    //   passwordController.text = prefs.getString('password') ?? '';
    // }
    if (portController.text.isNotEmpty)
      await prefs.setString('sshPort', portController.text);
    // } else {
    //   portController.text = prefs.getString('sshPort') ?? '';
    // }
    if (no_of_rigs_Controller.text.isNotEmpty)
      await prefs.setString('numberOfRigs', no_of_rigs_Controller.text);
    // } else {
    //   no_of_rigs_Controller.text = prefs.getString('numberOfRigs') ?? '';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Connect to Liquid Galaxy',
            style: TextStyle(color: Colors.black, fontFamily: 'Serif'),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Color.fromRGBO(227, 224, 224, 1),
          actions: <Widget>[ConnectionFlag(connectionStatus: connectionStatus)],
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color.fromARGB(255, 166, 166, 166),
              Color.fromARGB(255, 78, 76, 76),
            ])),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
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
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: ipController,
                          decoration: const InputDecoration(
                            labelText: 'IP address',
                            hintText: 'Enter Master IP',
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
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
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            // prefixIcon: Icon(Icons.computer),
                            labelText: 'LG Username',
                            hintText: 'Enter username',
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
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
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.computer),
                            labelText: 'LG Password',
                            hintText: 'Enter password',
                            border: const UnderlineInputBorder(),

                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible == false
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
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
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: portController,
                          decoration: const InputDecoration(
                            //   prefixIcon: Icon(Icons.computer),
                            labelText: 'SSH Port',
                            hintText: 'Enter port number',
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
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
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: no_of_rigs_Controller,
                          decoration: const InputDecoration(
                            labelText: 'Number of LG rigs',
                            hintText: 'Enter no of rigs',
                            border: UnderlineInputBorder(),
                          ),
                          // keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          ),
                          width: 10000,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              await saveSettings();
                              ssh = SSH();
                              bool? connect = await ssh.connectToLG();

                              if (connect == true) {
                                setState(() {
                                  refresh();
                                  connectionStatus = true;
                                });
                              }
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 227, 219, 219),
                              ),

                              // shape:MaterialStatePropertyAll(Rounded)
                            ),
                            child: const Text(
                              'Connect',
                              style: TextStyle(color: Colors.black),
                            ),
                          ))
                    ]),
              ),
            )));
  }
}
