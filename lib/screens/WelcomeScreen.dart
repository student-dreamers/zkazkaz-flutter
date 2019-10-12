import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    writeUsed();
  }


  writeUsed() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("used", true);

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
            height: 80,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
                  onPressed: () {
                    signOut();
                Navigator.pushReplacementNamed(context, '/welcome');
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
          margin: const EdgeInsets.all(20.0),
          height: 80,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
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
        title: Text('Vítejte'),
      ),

      body: Column(
        children: <Widget>[
          Container(
            //Bla bla
          ),
          Container(
            //Bla bla bla bla bla
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
