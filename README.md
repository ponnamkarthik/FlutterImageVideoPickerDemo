# What’s Inside material.dart #3 — Flutter

Hello All Flutter Developers

All of you know that flutter 1.9 has release and supports many new widgets. To know more what added (release notes here)[https://github.com/flutter/flutter/wiki/Release-Notes-Flutter-1.9.1]

Today we are gonna see how to use `image_picker` plugin to get Image & Video file from Gallery & Camera

Here how it the flow will 
1) Add `image_picker` plugin in `pubspec.yaml`
2) Add Requied Permissions if any
3) Call `ImagePicker.pick*` and this will return you a file
4) Display your file or perform the action you needed.

So lets get started

## Adding Depedencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^0.1.2
  # Dependency for image picker
  image_picker: ^0.6.1+4
```

## Adding Permissions

As the plugins specified you dont need to any permission for android but for iOS we need to specify some permissions

Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

NSPhotoLibraryUsageDescription - describe why your app needs permission for the photo library. This is called Privacy - Photo Library Usage Description in the visual editor.
NSCameraUsageDescription - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.
NSMicrophoneUsageDescription - describe why your app needs access to the microphone, if you intend to record videos. This is called Privacy - Microphone Usage Description in the visual editor.

```plist
	<!-- Add these permissions for ios -->
	<key>NSCameraUsageDescription</key>
	<string>Used to demonstrate image picker plugin</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>Used to capture audio for image picker plugin</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Used to demonstrate image picker plugin</string>
```
We are done with the permission.

## Calling Plugin

Inorder to pick an image from gallery

We use a method provided by the plugin i.e., `ImagePicker.pickImage` which accepts multiple parameters

`source`: This can be `ImageSource.gallery` or `ImageSource.camera`
`imageQuality`: This will speciy at what quality you want the file to be, this property accepts `double` from `0 to 100`
For example if your file is to big then we might get error when displaying the image so it better to use `imageQuality`
`maxWidth`: What is the maximum width you want the image to be
`maxHeight`: What is the maximum Height you want the image to be

If specified, the image will be at most `maxWidth` wide and `maxHeight` tall. Otherwise the image will be returned at it's original width and height.

```dart
File  _image;
// This funcion will helps you to pick and Image from Gallery
_pickImageFromGallery() async {
    File image = await  ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
        _image = image;    
    });
}
```

Inorder to pick an image from camera

```dart
File _cameraImage;
// This funcion will helps you to pick and Image from Camera
_pickImageFromCamera() async {
    File image = await  ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _cameraImage = image;    
    });
}
```

Here we got a functions where we can call the funciton and get the image now where to call it and how to display image

```dart
Conatiner(
    child: Column(
        children: <Widget>[
            if(_image != null) 
                Image.file(_image)
            else
                Text("Click on Pick Image to select an Image", style: TextStyle(fontSize: 18.0),),
            RaisedButton(
                onPressed: () {
                _pickImageFromGallery();
                // or
                // _pickImageFromCamera(); 
                // use the variables accordingly
                },
                child: Text("Pick Image From Gallery"),
            ),
        ]
    )
)
```

Now we have got how to pick an Image from Gallery and Camera by a single line of Code.

Let's see how to pick the video from Gallery and Camera

The only change we can see from Picking image and video is `pickVideo` insted of `pickImage`

`ImagePicker.pickVideo` accepts only one property i.e., `source` than can `ImageSource.gallery` or `ImageSource.camera`

Inorder to display and play a video we need to depend on third party becuse Flutter doesn't support video playback by default

So for Displaing videos we use `video_player` plugin

Add this dependency in `pubspec.yaml`

```yaml
# Dependency for video player
video_player: ^0.10.2+1
```

Now the below function will call the plugin to pick a video file and returns us a File or null

If `source` is specified as `ImageSource.gallery` It is promprt you to pick from gallery

```dart
File _video;
// This funcion will helps you to pick a Video File
_pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
     _video = video; 
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });
}
```

If `source` is specified as `ImageSource.camera` It is promprt you to pick from Camera


```dart
File _cameraVideo;
// This funcion will helps you to pick a Video File from Camera
_pickVideoFromCamera() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
     _cameraVideo = video; 
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_) {
      setState(() { });
      _cameraVideoPlayerController.play();
    });
}
```


Inorder to play a video we are using `video_player` plugin this plugin needs `VideoPlayerController`.

```dart
_cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)..initialize().then((_) {
    setState(() { });
    _cameraVideoPlayerController.play();
});
```

Above code we have already written in the `_pickVideo()` and `_pickVideoFromCamera()` functions 

This piece of code will first sets that we are playing video from a file and then we call `initialize` once the `initialize` is done then we cann the `setState(() {})` and then we start playing the video by using `_controller.play()`

We also have 
`VideoPlayerController.file` to play video from a file
`VideoPlayerController.asset` to play video from a assets
`VideoPlayerController.network` to play video from a Network


```dart
Container(
    child: Column(
        children: <Widget>[
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
        ],
    ),
),
```

```dart
AspectRatio(
    aspectRatio: _videoPlayerController.value.aspectRatio,
    child: VideoPlayer(_videoPlayerController),
)
```
Above piece of code we will use `AspectRatio` resize the widget according to the video size.

We call `_pickImage`, `_pickVideo` methods whenever we press a button

This is how we pick an Image or Video from gallery or camera



**Thanks for your time.**

<a href="https://www.buymeacoffee.com/EX7G1VjOu" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

Hope you like it, if yes **clap & share.**
