import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final signInController = TextEditingController();
  final databaseReference = Firestore.instance;

  @override
  void dispose() {
    signInController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkIfSignedIn() async {
    final prefs = await SharedPreferences.getInstance();

    bool signedIn = prefs.getBool("signed_in") ?? false;
    return signedIn;
  }



  signIn(String signedInId) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool("signed_in", true);
    prefs.setString("signed_in_id", signedInId);
    databaseReference.collection("users").document(signedInId).setData({
      'user_id' : signedInId,
      'last_signed_in' : DateTime.now().toString(),
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Přihlásit se'),
      ),

      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 150.0, bottom: 20.0, right: 20.0, left: 20.0),
            height: 80,
            child: TextField(
              decoration: InputDecoration(

                  hintText: 'Zadejte své ID'
              ),
              controller: signInController,
            ),
          ),
          Container(
            height: 60,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if(signInController.text.length > 0) {
                  signIn(signInController.text);
                  Navigator.pushReplacementNamed(context, '/');
                }


              },
              child: const Text(
                  'Přihlásit se',
                  style: TextStyle(fontSize: 20)
              ),
            ),
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
