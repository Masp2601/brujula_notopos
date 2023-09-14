import 'dart:io';
import 'dart:async';

import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:brujula_notopos/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import '../recorder/ed_screen_recorder.dart';

class LocalWidget extends StatefulWidget {
  const LocalWidget({
    Key? key,
    // required this.argument,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  // final argument;
  @override
  _LocalWidgetState createState() =>
      _LocalWidgetState();
}

class _LocalWidgetState extends State<LocalWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ArCoreController? arCoreController;
  //Inicio_Grabador
  EdScreenRecorder? screenRecorder;
  Map<String, dynamic>? _response;
  bool inProgress = false;
  @override
  void initState() {
    super.initState();
    screenRecorder = EdScreenRecorder();
  }

  Future<void> startRecord({required String fileName}) async {
    Directory? tempDir = await getApplicationDocumentsDirectory();
    String? tempPath = tempDir.path;
    try {
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: "",
        //Optional. It will save the video there when you give the file path with whatever you want.
        //If you leave it blank, the Android operating system will save it to the gallery.
        dirPathToSave: tempPath,
        audioEnable: true,
      );
      setState(() {
        _response = startResponse;
      });
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }
  }

  Future<void> stopRecord() async {
    try {
      var stopResponse = await screenRecorder?.stopRecord();
      setState(() {
        _response = stopResponse;
      });
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while stopping recording.")
          : null;
    }
  }

  Future<void> pauseRecord() async {
    try {
      await screenRecorder?.pauseRecord();
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while pause recording.")
          : null;
    }
  }

  Future<void> resumeRecord() async {
    try {
      await screenRecorder?.resumeRecord();
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while resume recording.")
          : null;
    }
  }

  //Fin_Grabador
  //String localObjectReference;
  ARNode? localObjectNode;
  //String webObjectReference;
  ARNode? webObjectNode;
  ARNode? fileSystemNode;
  HttpClient? httpClient;

  double scale = 0.2;
  double newRotationAmount = 0;
  double newTransX = 0;
  double newTransY = 0;
  double newTransZ = 0;

  bool showWorldOrigin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButtonScale(),
            ],
          ),
        ]),
        _buildButtonTrans(),
      ]),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addImage(arCoreController!);
    _addImage1(arCoreController!);
    _addImage2(arCoreController!);
  }

  Future<Uint8List> getImageBytes(String imageName) async {
    final ByteData data = await rootBundle.load('assets/$imageName');
    return data.buffer.asUint8List();
  }

  void _addImage(ArCoreController controller) async {
    final imagebytes = await getImageBytes("lineaGiron.png");
    final node = ArCoreNode(
      image:ArCoreImage(bytes:imagebytes,width:750,height:750),
      position: vector.Vector3(10.5,15.5,-10.5),
    );
    controller.addArCoreNode(node);
  }

  void _addImage1(ArCoreController controller) async {
    final imagebytes = await getImageBytes("lineaNacional.png");
    final node = ArCoreNode(
      image:ArCoreImage(bytes:imagebytes,width:650,height:650),
      position: vector.Vector3(-0.5, -0.5, -3.5),
    );
    controller.addArCoreNode(node);
  }

  void _addImage2(ArCoreController controller) async {
    final imagebytes = await getImageBytes("lineaZipaquira.png");
    final node = ArCoreNode(
      image:ArCoreImage(bytes:imagebytes,width:850,height:850),
      position: vector.Vector3(3.5, 5.5, -5.5),
    );
    controller.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
  /*void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addSphere();

  }

  Future _addSphere() async {
    final ByteData textureBytes = await rootBundle.load('assets/marcador_giron.jpg');

    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());


    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    arCoreController?.addArCoreNode(node);
  }


  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }*/

  Widget _buildButtonTrans() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "File: ${(_response?['file'] as File?)?.path}",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text("Status: ${(_response?['success']).toString()}"),
                    Text("Event: ${_response?['eventname']}"),
                    Text("Progress: ${(_response?['progressing']).toString()}"),
                    Text("Message: ${_response?['message']}"),
                    Text("Video Hash: ${_response?['videohash']}"),
                    Text("Start Date: ${(_response?['startdate']).toString()}"),
                    Text("End Date: ${(_response?['enddate']).toString()}"),
                    ElevatedButton(
                        onPressed: () => startRecord(fileName: ""),
                        child: const Text('START RECORD')),
                    ElevatedButton(
                        onPressed: () => resumeRecord(),
                        child: const Text('RESUME RECORD')),
                    ElevatedButton(
                        onPressed: () => pauseRecord(),
                        child: const Text('PAUSE RECORD')),
                    ElevatedButton(
                        onPressed: () => stopRecord(),
                        child: const Text('STOP RECORD')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildButtonScale() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, elevation: 0),
          onPressed: () {
            if (webObjectNode != null) {
              setState(() {
                //_addScale();
              });
              var newRotationAxis = vector.Vector3(0, 0, 0);
              newRotationAxis[1] = 1.0;
              final newTransform = Matrix4.identity();
              var newTranslation = vector.Vector3(0, 0, 0);
              newTranslation[0] = newTransZ;
              newTranslation[1] = newTransX;
              newTranslation[2] = newTransY;

              newTransform.setTranslation(newTranslation);
              newTransform.rotate(newRotationAxis, newRotationAmount);
              newTransform.scale(scale);
              webObjectNode!.transform = newTransform;
            }
          },
          //Localizador del mapa
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.4), shape: BoxShape.circle),
            height: 60,
            width: 60,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: const Icon(Icons.location_on, size: 30)),
          ),
        ),
      ],
    );
  }

  Future<void>? onWebButton(String imageARUrl) async {
    if (webObjectNode != null) {
      arObjectManager!.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri: imageARUrl,
          scale: vector.Vector3(0.02, 0.02, 0.02));
      bool? didAddWebNode = await arObjectManager!.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
