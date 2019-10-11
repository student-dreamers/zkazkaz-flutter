import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    checkIfUsed();
    super.initState();
  }

  checkIfUsed() async {
    final prefs = await SharedPreferences.getInstance();

    bool registered = prefs.getBool("used") ?? false;
    if(!registered) {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  Future<bool> checkIfSignedIn() async {
    final prefs = await SharedPreferences.getInstance();

    bool signedIn = prefs.getBool("signed_in") ?? false;
    return signedIn;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zkazkaz'),
      ),

      body: Column(
        children: <Widget>[
          Container(
            child: Text("Vitejte..."),
          ),
          Container(
            //settings button
          ),
          Container(
            //big add new thing button
          ),
          Container(
            //big tutorial button
          ),
        ],
      ),
    );
  }
}
