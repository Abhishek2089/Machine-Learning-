import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:machine_learning_flutter/camera.dart';
import 'package:machine_learning_flutter/recognitions.dart';
import 'package:tflite/tflite.dart';
import 'models.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imagewidth  = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imagewidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('ML'),),
      body: _model == "" ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(onPressed: () => onSelect(ssd),
          child: const Text(ssd),),
          RaisedButton(onPressed: () => onSelect(yolo),
          child: const Text(yolo),),
          RaisedButton(onPressed: () => onSelect(mobilenet),
          child: const Text(mobilenet),),
          RaisedButton(onPressed: () => onSelect(posenet),
          child: const Text(posenet),),
        ],
      ),
      ) : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                Recognitions(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageHeight),
                    math.min(_imageHeight, _imagewidth),
                    screen.height,
                    screen.width,
                    _model
                    ),
              ],
            ),
    );
  }
}
