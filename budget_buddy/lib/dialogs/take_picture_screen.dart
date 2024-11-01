import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  // final Item item;
  final CameraDescription camera;
  @override
  State<StatefulWidget> createState() {
    return TakePictureScreenState();
  }
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    //initialize the controller. returns a Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    //dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Take a picture")),
        //You must wait until the controler is initialized before displaying the
        //camera preview. Use a FutureBuilder to display a loading spinner until the
        //controller has finished initializing
        body: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // if the Future is complete, display the preview
                return CameraPreview(_controller);
              } else {
                //otherwise, display a loading indicator
                return const Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
            //provide an onPressed callback
            onPressed: () async {
          // take the picture in a try / catch block. If anything goes wrong,
          //catch the error.
          try {
            //ensure that the camera is initialized
            await _initializeControllerFuture;

            //attempt to take a picture and get the file 'image'
            //where it was saved
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            //if the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(image: image)),
            );
          } catch (e) {
            //if an error occurs, log the error to the console.
            print(e);
          }
        }));
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final XFile image;
  // final Item item;

  const DisplayPictureScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Display the Picture")),
        body: Column(
          children: [
            Image.file(File(image.path)),
            ElevatedButton(
                onPressed: () {
                  //add image to item.
                  // item.addImagePath(I);
                  Navigator.pop(context); // pop the display picture screen
                  Navigator.pop(context, image); // pop the take picture screen
                },
                child: const Text("Confirm"))
          ],
        ));
  }
}
