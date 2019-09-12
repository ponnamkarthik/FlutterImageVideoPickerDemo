import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File _image;
  File _cameraImage;
  File _video;
  File _cameraVideo;

  VideoPlayerController _videoPlayerController;
  VideoPlayerController _cameraVideoPlayerController;

  // This funcion will helps you to pick and Image from Gallery
  _pickImageFromGallery() async {
    File image = await  ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;    
    });
  }

  
  // This funcion will helps you to pick and Image from Camera
  _pickImageFromCamera() async {
    File image = await  ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _cameraImage = image;    
    });
  }

  
  // This funcion will helps you to pick a Video File
  _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
     _video = video; 
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });
  }

   // This funcion will helps you to pick a Video File from Camera
  _pickVideoFromCamera() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
     _cameraVideo = video; 
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_) {
      setState(() { });
      _cameraVideoPlayerController.play();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image / Video Picker"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(

              children: <Widget>[
                if(_image != null) 
                  Image.file(_image)
                else
                  Text("Click on Pick Image to select an Image", style: TextStyle(fontSize: 18.0),),
                RaisedButton(
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                  child: Text("Pick Image From Gallery"),
                ),
                SizedBox(
                  height: 16.0,
                ),
                if(_cameraImage != null) 
                  Image.file(_cameraImage)
                else
                  Text("Click on Pick Image to select an Image", style: TextStyle(fontSize: 18.0),),
                RaisedButton(
                  onPressed: () {
                    _pickImageFromCamera();
                  },
                  child: Text("Pick Image From Camera"),
                ),
                if(_video != null) 
                      _videoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : Container()
                else
                  Text("Click on Pick Video to select video", style: TextStyle(fontSize: 18.0),),
                RaisedButton(
                  onPressed: () {
                    _pickVideo();
                  },
                  child: Text("Pick Video From Gallery"),
                ),
                if(_cameraVideo != null) 
                      _cameraVideoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio: _cameraVideoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_cameraVideoPlayerController),
                    )
                  : Container()
                else
                  Text("Click on Pick Video to select video", style: TextStyle(fontSize: 18.0),),
                RaisedButton(
                  onPressed: () {
                    _pickVideoFromCamera();
                  },
                  child: Text("Pick Video From Camera"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}