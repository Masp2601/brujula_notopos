import 'dart:io';
import 'dart:math';

import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:brujula_notopos/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
  }

  @override
  Widget build(BuildContext context) {
    //String imageARUrl = widget.argument["image3D"]["imageARUrl"];
    String imageARUrl =
        "https://github.com/TuanVuuuu/tuanvu_assets/blob/tuanvu_03022023/assets/3d_images/satellite/animated_moon.glb?raw=true";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          ARView(
              onARViewCreated: ((arSessionManager, arObjectManager,
                  arAnchorManager, arLocationManager) {
                this.arSessionManager = arSessionManager;
                this.arObjectManager = arObjectManager;
                this.arSessionManager!.onInitialize(
                      showFeaturePoints: false,
                      showPlanes: true,
                      customPlaneTexturePath: "Images/triangle.png",
                      showWorldOrigin: showWorldOrigin,
                      handleTaps: false,
                    );
                this.arObjectManager!.onInitialize();
                //Download model to file system
                httpClient = HttpClient();
                // _downloadFile("https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb", "LocalDuck.glb");
                //_downloadFile("https://github.com/TuanVuuuu/tuanvuAR/blob/TuanVu-Assets/assets/3D_model/earth.glb", "LocalDuck.glb");
                setState(() {
                  //onFileSystemObjectAtOriginButtonPressed();
                  onWebButton(imageARUrl);
                });
              }),
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical),
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
        ]));
  }

  Widget _buildButtonTrans() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                if (webObjectNode != null) {
                  setState(() {
                    _subTransAmountY();
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
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (webObjectNode != null) {
                      setState(() {
                        _subTransAmountZ();
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
                    angle: -135 * pi / 180,
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
                  )),
              Container(
                height: 70,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ),
              ElevatedButton(
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
                  ))
            ],
          ),
          ElevatedButton(
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
              )),
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
            ElevatedButton(
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
                    color: Colors.grey.withOpacity(0.4),
                    shape: BoxShape.circle),
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
            )
          ],
        ),
        // _build Button Trans X
        const SizedBox(height: 30),
        Column(
          children: [
            ElevatedButton(
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
                        color: Colors.grey.withOpacity(0.4),
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
                )),
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
        ElevatedButton(
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
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, elevation: 0),
          onPressed: () {
            if (webObjectNode != null) {
              setState(() {
                _addScale();
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
              child: const Icon(Icons.zoom_in, size: 30)),
        ),
      ],
    );
  }

  // void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
  //   this.arSessionManager = arSessionManager;
  //   this.arObjectManager = arObjectManager;
  //   this.arSessionManager!.onInitialize(
  //         showFeaturePoints: false,
  //         showPlanes: true,
  //         customPlaneTexturePath: "assets/triangle.png",
  //         showWorldOrigin: false,
  //         handleTaps: false,
  //       );
  //   this.arObjectManager!.onInitialize();
  //   //Download model to file system
  //   httpClient = new HttpClient();
  //   _downloadFile("https://github.com/TuanVuuuu/tuanvuAR/blob/TuanVu-01/assets/3D_model/earth.glb?raw=true", "LocalDuck.glb");
  //   setState(() {
  //     onFileSystemObjectAtOriginButtonPressed();
  //   });
  //   // Alternative to use type fileSystemAppFolderGLTF2:
  //   //_downloadAndUnpack(
  //   //    "https://drive.google.com/uc?export=download&id=1fng7yiK0DIR0uem7XkV2nlPSGH9PysUs",
  //   //    "Chicken_01.zip");
  // }

  // Future<void> onTakeScreenshot() async {
  //   var image = await arSessionManager!.snapshot();
  //   await showDialog(
  //       context: context,
  //       builder: (_) => Dialog(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height * 0.8,
  //               width: MediaQuery.of(context).size.width * 0.8,
  //               decoration: BoxDecoration(image: DecorationImage(image: image, fit: BoxFit.cover)),
  //             ),
  //           ));
  // }

  // Future<File> _downloadFile(String url, String filename) async {
  //   var request = await httpClient!.getUrl(Uri.parse(url));
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = new File('$dir/$filename');
  //   await file.writeAsBytes(bytes);
  //   print("Downloading finished, path: " + '$dir/$filename');
  //   return file;
  // }

  // Future<void> _downloadAndUnpack(String url, String filename) async {
  //   var request = await httpClient!.getUrl(Uri.parse(url));
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = new File('$dir/$filename');
  //   await file.writeAsBytes(bytes);
  //   print("Downloading finished, path: " + '$dir/$filename');
  //   // To print all files in the directory: print(Directory(dir).listSync());
  //   try {
  //     await ZipFile.extractToDirectory(zipFile: File('$dir/$filename'), destinationDir: Directory(dir));
  //     print("Unzipping successful");
  //   } catch (e) {
  //     print("Unzipping failed: " + e.toString());
  //   }
  // }

  // Future<void> onLocalObjectAtOriginButtonPressed() async {
  //   if (localObjectNode != null) {
  //     arObjectManager!.removeNode(localObjectNode!);
  //     localObjectNode = null;
  //   } else {
  //     var newNode = ARNode(type: NodeType.localGLTF2, uri: "assets/localModel/scene.gltf", scale: Vector3(0.2, 0.2, 0.2), position: Vector3(0.0, 0.0, 0.0), rotation: Vector4(1.0, 0.0, 0.0, 0.0));
  //     bool? didAddLocalNode = await arObjectManager!.addNode(newNode);
  //     localObjectNode = (didAddLocalNode!) ? newNode : null;
  //   }
  // }

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

  // Future<void> onFileSystemObjectAtOriginButtonPressed() async {
  //   if (fileSystemNode != null) {
  //     arObjectManager!.removeNode(fileSystemNode!);
  //     fileSystemNode = null;
  //   } else {
  //     var newNode = ARNode(type: NodeType.fileSystemAppFolderGLB, uri: "LocalDuck.glb", scale: Vector3(0.2, 0.2, 0.2));
  //     //Alternative to use type fileSystemAppFolderGLTF2:
  //     //var newNode = ARNode(
  //     //    type: NodeType.fileSystemAppFolderGLTF2,
  //     //    uri: "Chicken_01.gltf",
  //     //    scale: Vector3(0.2, 0.2, 0.2));
  //     bool? didAddFileSystemNode = await arObjectManager!.addNode(newNode);
  //     fileSystemNode = (didAddFileSystemNode!) ? newNode : null;
  //   }
  // }

  // Future<void> onLocalObjectShuffleButtonPressed() async {
  //   if (localObjectNode != null) {
  //     var newScale = Random().nextDouble() / 3;
  //     //var newScale = scale + 1;
  //     var newTranslationAxis = Random().nextInt(3);
  //     var newTranslationAmount = Random().nextDouble() / 3;
  //     var newTranslation = Vector3(0, 0, 0);
  //     newTranslation[newTranslationAxis] = newTranslationAmount;
  //     var newRotationAxisIndex = Random().nextInt(3);
  //     var newRotationAmount = Random().nextDouble();
  //     var newRotationAxis = Vector3(0, 0, 0);
  //     newRotationAxis[newRotationAxisIndex] = 1.0;
  //     final newTransform = Matrix4.identity();
  //     //newTransform.setTranslation(newTranslation);
  //     //newTransform.rotate(newRotationAxis, newRotationAmount);
  //     newTransform.scale(newScale);
  //     localObjectNode!.transform = newTransform;
  //   }
  // }

  // Future<void> onWebObjectShuffleButtonPressed(bool? sub, bool? add) async {
  //   if (webObjectNode != null) {
  //     // var newScale = Random().nextDouble() / 3;
  //     // var newTranslationAxis = Random().nextInt(3);
  //     // var newTranslationAmount = Random().nextDouble() / 3;
  //     // var newTranslation = Vector3(0, 0, 0);
  //     // newTranslation[newTranslationAxis] = newTranslationAmount;
  //     // var newRotationAxisIndex = Random().nextInt(3);
  //     // var newRotationAmount = Random().nextDouble();
  //     // var newRotationAxis = Vector3(0, 0, 0);
  //     // newRotationAxis[newRotationAxisIndex] = 1.0;
  //     final newTransform = Matrix4.identity();
  //     // newTransform.setTranslation(newTranslation);
  //     // newTransform.rotate(newRotationAxis, newRotationAmount);
  //     newTransform.scale(scale);
  //     webObjectNode!.transform = newTransform;
  //   }
  // }
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
