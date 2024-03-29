import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

// A screen that takes in a list of cameras and the Directory to store images.
class TakePhotoScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePhotoScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePhotoScreenState createState() => TakePhotoScreenState();
}

class TakePhotoScreenState extends State<TakePhotoScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,

    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
    height: 100.0,
    width: 100.0,
    child: FittedBox(
    child: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            String imageName;
            String dateTime = DateTime.now().toString();
            imageName = "${dateTime}_${randomAlphaNumeric(10)}.png";
            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.


              (await getTemporaryDirectory()).path,
              imageName,
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path, image: File(path), imageName: imageName, dateTime: dateTime),
              ),
            );// */
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),)),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final File image;
  final String imageName;
  final String dateTime;

  const DisplayPictureScreen({Key key, this.imagePath, this.image, this.imageName, this.dateTime}) : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreenState extends State<DisplayPictureScreen> {

  final databaseReference = Firestore.instance;

  Future uploadPic() async {
    String user_id;

    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("signed_in")) {
      user_id = prefs.getString("signed_in_id");
    }
    else {
      user_id = "not_signed_in";
    }
    String fileName = basename(widget.imagePath);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(widget.image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;


    databaseReference.collection("photos").document(widget.imageName).setData({
      'user_id' : user_id,
      'image_name' : widget.imageName,
      'date_time' : widget.dateTime,
    });
    return true;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(children: <Widget>[Image.file(File(widget.imagePath)),
        RaisedButton(
          onPressed: () {
            uploadPic().then((value) {
              Navigator.pushReplacementNamed(context, '/between');
            });

          },
          child: const Text(
              'Nahrát fotku',
              style: TextStyle(fontSize: 20)
          ),
        ),
      ],),
    );
  }
}
class BetweenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Calculating')),
        body: GestureDetector(onTap: () {
          Navigator.pushReplacementNamed(context, '/result');
        },
            child: Center(child: CircularProgressIndicator())),
    );
  }
}

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result')),
      body: Column(children: <Widget>[
        Center(
            child: Container(
              margin: EdgeInsets.only(top: 200),
              child: GestureDetector(onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
                  child: Icon(IconData(0xe92d, fontFamily: 'MaterialIcons'), color: Colors.green, size: 200),),
      )
    ), Center (
          child: Container(
            child: Text("Vše v pořádku", style: TextStyle(fontSize: 20),),
          )
        )
      ],)
    );
  }
}