import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  File? imageFile;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imgTemporary = File(image.path);
      setState(() {
        this.imageFile = imgTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Photo Editor"),
      ),
      body: imageFile == null?
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg.png"),
                  fit: BoxFit.cover),
            ),
          ):
          ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Image.file(imageFile!, fit: BoxFit.cover),
                const SizedBox(height: 20,),
              ]
          ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.image),
              label: 'Gallery'),
        ],
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: (int index) async {
          if(index == _selectedIndex) {
            PermissionStatus cameraStatus = await Permission.camera.request();
            if (cameraStatus == PermissionStatus.granted) {
              pickImage(ImageSource.camera);
            } else if (cameraStatus == PermissionStatus.denied) {
              return;
            }
          }
          else{
            PermissionStatus galleryStatus = await Permission.storage.request();
            if (galleryStatus == PermissionStatus.granted) {
              pickImage(ImageSource.gallery);
            } else if (galleryStatus == PermissionStatus.denied) {
              return;
            }
          }
        },
      ),
    );
  }
}