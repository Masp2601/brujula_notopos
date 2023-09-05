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

class LocalAndWebObjectsWidget extends StatefulWidget {
  const LocalAndWebObjectsWidget({
    Key? key,
    // required this.argument,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  // final argument;
  @override
  _LocalAndWebObjectsWidgetState createState() =>
      _LocalAndWebObjectsWidgetState();
}

class _LocalAndWebObjectsWidgetState extends State<LocalAndWebObjectsWidget> {
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

  /* @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  void _subScale() {
    if (scale >= 0.02) {
      scale = scale - 0.02;
    }
  }

  void _addScale() {
    scale = scale + 0.02;
  }

  void _subAmount() {
    newRotationAmount = newRotationAmount - 0.2;
  }

  void _addAmount() {
    newRotationAmount = newRotationAmount + 0.2;
  }

  void _subTransAmountX() {
    newTransX = newTransX - 0.02;
  }

  void _subTransAmountY() {
    newTransY = newTransY - 0.02;
  }

  void _subTransAmountZ() {
    newTransZ = newTransZ - 0.02;
  }

  void _addTransAmountX() {
    newTransX = newTransX + 0.02;
  }

  void _addTransAmountY() {
    newTransY = newTransY + 0.02;
  }

  void _addTransAmountZ() {
    newTransZ = newTransZ + 0.02;
  }*/

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
              _buildButtonRotation(),
            ],
          ),
        ]),
        _buildButtonTrans(),
      ]),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    //_addSphere();
    //_addCylindre();
    _addCube();
    _addCube1();
    _addCube2();
  }

  /*Future _addSphere() async {
    final ByteData textureBytes = await rootBundle.load('assets/linea.png');

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

  void _addCylindre() {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylindre,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    arCoreController?.addArCoreNode(node);
  }*/

  void _addCube() {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-10.5, 10.5, -13.5),
    );
    arCoreController?.addArCoreNode(node);
  }

  void _addCube1() {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 223, 7, 90),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-10.5, 10.5, -13.5),
    );
    arCoreController?.addArCoreNode(node);
  }

  void _addCube2() {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 72, 231, 23),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(-10.5, 10.5, -13.5),
    );
    arCoreController?.addArCoreNode(node);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

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
              /* ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (webObjectNode != null) {
                      setState(() {
                        _addTransAmountZ();
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
                  child: Transform.rotate(
                    angle: 45 * pi / 180,
                    child: ClipPath(
                      clipper: CustomTriangleClipper(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ))*/
            ],
          ),
          /* ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                if (webObjectNode != null) {
                  setState(() {
                    _addTransAmountY();
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
              child: Transform.rotate(
                angle: 135 * pi / 180,
                child: ClipPath(
                  clipper: CustomTriangleClipper(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
              )),*/
        ],
      ),
    );
  }

  Widget _buildButtonRotation() {
    return Column(
      children: [
        //_build Button Rotation
        Column(
          children: [
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: (() {
                if (webObjectNode != null) {
                  setState(() {
                    _addAmount();
                  });

                  //var newRotationAxisIndex = Random().nextInt(3);
                  //var newRotationAmount = Random().nextDouble();
                  var newRotationAxis = vector.Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  var newTranslation = vector.Vector3(0, 0, 0);
                  newTranslation[0] = newTransZ;
                  newTranslation[1] = newTransX;
                  newTranslation[2] = newTransY;

                  final newTransform = Matrix4.identity();
                  newTransform.setTranslation(newTranslation);
                  newTransform.rotate(newRotationAxis, newRotationAmount);
                  newTransform.scale(scale);

                  webObjectNode!.transform = newTransform;
                }
              }),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.4), shape: BoxShape.circle),
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.settings_backup_restore,
                  size: 30,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: (() {
                if (webObjectNode != null) {
                  setState(() {
                    _subAmount();
                  });

                  //var newRotationAxisIndex = Random().nextInt(3);
                  //var newRotationAmount = Random().nextDouble();
                  var newRotationAxis = vector.Vector3(0, 0, 0);
                  newRotationAxis[1] = 1.0;
                  var newTranslation = vector.Vector3(0, 0, 0);
                  newTranslation[0] = newTransZ;
                  newTranslation[1] = newTransX;
                  newTranslation[2] = newTransY;

                  final newTransform = Matrix4.identity();
                  newTransform.setTranslation(newTranslation);
                  newTransform.rotate(newRotationAxis, newRotationAmount);
                  newTransform.scale(scale);

                  webObjectNode!.transform = newTransform;
                }
              }),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    shape: BoxShape.circle),
                height: 60,
                width: 60,
                child: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.settings_backup_restore,
                    size: 30,
                  ),
                ),
              ),
            )*/
          ],
        ),
        // _build Button Trans X
        const SizedBox(height: 30),
        Column(
          children: [
            /*ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: () {
                  if (webObjectNode != null) {
                    setState(() {
                      _addTransAmountX();
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
                child: Transform.rotate(
                  angle: -45 * pi / 180,
                  child: ClipPath(
                    clipper: CustomTriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                      ),
                    ),
                  ),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: () {
                  if (webObjectNode != null) {
                    setState(() {
                      _subTransAmountX();
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
                child: Transform.rotate(
                  angle: 135 * pi / 180,
                  child: ClipPath(
                    clipper: CustomTriangleClipper(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                )),*/
          ],
        ),
      ],
    );
  }

  Widget _buildButtonScale() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //ElevatedButton(onPressed: onLocalObjectShuffleButtonPressed, child: Text("Shuffle Local\nobject at Origin")),
        /*ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () {
            if (webObjectNode != null) {
              setState(() {
                _subScale();
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
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
            height: 60,
            width: 60,
            child: const Icon(
              Icons.zoom_out,
              size: 30,
            ),
          ),
        ),*/
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
