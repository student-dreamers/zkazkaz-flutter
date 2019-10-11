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

  signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("signed_in", false);
    prefs.remove("signed_in_id");
  }


  @override
  Widget build(BuildContext context) {
    Widget signButton(bool signedIn) {
      if(signedIn) {
        return Column(children: <Widget>[
          Container(
            child: Text("Jste přihlášený jako"),
          ),
          Container(
            child:
            RaisedButton(
              onPressed: () {
                signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text(
                  'Odhlásit se',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
        ],);
      }
      else {
        return Container(
          child:
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
            child: const Text(
                'Přihlásit se',
                style: TextStyle(fontSize: 20)
            ),
          ),
        );
      }
    }
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
          FutureBuilder(
              future: checkIfSignedIn(),
              builder: (BuildContext context, snapshot) {
                return snapshot.hasData ? signButton(snapshot.data) : Center(child: CircularProgressIndicator());
              }
          ),
        ],
      ),
    );
  }
}
