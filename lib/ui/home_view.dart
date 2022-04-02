import 'dart:html';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:object_detection/tflite/recognition.dart';
import 'package:object_detection/tflite/stats.dart';
import 'package:object_detection/ui/box_widget.dart';

import 'camera_view.dart';

/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key key,
    this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
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
    // Fill this out in the next steps.
    return Container();
  }
}

class _HomeViewState extends State<HomeView> {
  /// Results to draw bounding boxes
  List<Recognition> results;

  /// Realtime stats
  Stats stats;

  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  get _initializeControllerFuture => null;

  CameraController get _controller => null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(

        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            final image = await _controller.takePicture();
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key,  this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
//       key: scaffoldKey,
//       backgroundColor: Colors.black,
//
//         children: <Widget>[
//           // Camera View
//           CameraView(resultsCallback, statsCallback),
//
//           // Bounding boxes
//           boundingBoxes(results),
//
//           // Heading
//           Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               padding: EdgeInsets.only(top: 20,left:10),
//               child: Text(
//                 'Realyou',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   fontSize: 28,
//                   // fontFamily: BrushScriptMT,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent.withOpacity(0.5),
//                 ),
//               ),
//             ),
//           ),
//
//           // Bottom Sheet
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: SizedBox(
//                 width: 1000,
//                 height: 160.0,
//                 child: const DecoratedBox(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                         boxShadow:[
//                           BoxShadow(
//                           color: Colors.black,
//                           spreadRadius: 3,
//                           blurRadius: 10,
//                           offset: Offset(0,5),),
//                         ],
//                         borderRadius: BORDER_RADIUS_BOTTOM_SHEET),
//                 ),
//               ),
//             ),
//           // You must wait until the controller is initialized before displaying the
//           // camera preview. Use a FutureBuilder to display a loading spinner until the
//           // controller has finished initializing.
//
//
//       Image.file(File('path/to/my/picture.png'));
//           // FloatingActionButton.extended(
//           // heroTag: {
//           //   positionDependentBox(
//           //       size: ,
//           //       childSize: ,
//           //       target: ,
//           //       preferBelow: ),
//           // }
//           // )
//         ],
//       ),
//     );
//   }
//
//   /// Returns Stack of bounding boxes
//   Widget boundingBoxes(List<Recognition> results) {
//     if (results == null) {
//       return Container();
//     }
//     return Stack(
//       children: results
//           .map((e) => BoxWidget(
//                 result: e,
//               ))
//           .toList(),
//     );
//   }
//
//   /// Callback to get inference results from [CameraView]
//   void resultsCallback(List<Recognition> results) {
//     setState(() {
//       this.results = results;
//     });
//   }
//
//   /// Callback to get inference stats from [CameraView]
//   void statsCallback(Stats stats) {
//     setState(() {
//       this.stats = stats;
//     });
//   }
//
//   static const BOTTOM_SHEET_RADIUS = Radius.circular(45.0);
//   static const BORDER_RADIUS_BOTTOM_SHEET = BorderRadius.only(
//       topLeft: BOTTOM_SHEET_RADIUS, topRight: BOTTOM_SHEET_RADIUS);
// }
//
// class File {
// }
//
// /// Row for one Stats field
// class StatsRow extends StatelessWidget {
//   final String left;
//   final String right;
//
//   StatsRow(this.left, this.right);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text(left), Text(right)],
//       ),
//     );
//   }
// }
