import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'TakePhotoScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId;

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
    if(signedIn) {
      setState(() {
        this.userId = prefs.getString("signed_in_id");
      });
    }
    return signedIn;
  }

  signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("signed_in", false);
    prefs.remove("signed_in_id");
  }

  prepareCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    return firstCamera;
  }


  @override
  Widget build(BuildContext context) {
    Widget signButton(bool signedIn) {
      if(signedIn) {
        return Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 100.0),
            child: Text("ID uživatele: " + this.userId, style: TextStyle(fontSize: 20),),
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
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
          height: 60,
          margin: const EdgeInsets.only(top: 100.0, bottom: 10.0),
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
        title: Text('Zkazkaz'),
      ),

      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0, bottom: 20.0),
            child: Text("Vítejte", style: TextStyle(fontSize: 40)),
          ),
          Container(
            //settings button
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
          Container(
            height: 60,
            margin: const EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                prepareCamera().then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TakePhotoScreen(camera: value)));
                });
                Navigator.pushReplacementNamed(context, '/take-photo');
              },
              child: const Text(
                  'Vyfotit',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
          Container(
            child: RaisedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/between');
                })
          )
        ],
      ),
    );
  }
}
