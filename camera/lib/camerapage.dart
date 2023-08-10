import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class Camerapage extends StatefulWidget {
  const Camerapage({super.key});

  @override
  State<Camerapage> createState() => _CamerapageState();
}

class _CamerapageState extends State<Camerapage> {
  File? _imageFile;

  @override
  void initState() {
    _captureImage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) ...[
              Image.file(
                _imageFile!,
                height: 200,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cropImage,
                child: const Text('Crop Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveToGallery,
                child: const Text('Save to Gallery'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendToWhatsApp,
                child: const Text('Send to WhatsApp'),
              ),
            ],
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     _captureImage();
            //   },
            //   child: const Text('Capture Image'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _cropImage() async {
    if (_imageFile == null) return;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFile!.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    if (croppedFile != null) {
      setState(() {
        _imageFile = croppedFile as File?;
      });
    }
  }

  Future<void> _saveToGallery() async {
    if (_imageFile == null) return;
    
  }

  void _sendToWhatsApp() {
    if (_imageFile == null) return;

    const link = WhatsAppUnilink(
      phoneNumber: '+1234567890',
      text: 'Check out this image!',
    );

    launch(link.toString());
  }

  Future<void> launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
