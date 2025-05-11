import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flareline/pages/auth/sign_up/sign_up_provider.dart';

class SkinDetectionPhotoPage extends StatefulWidget {
  const SkinDetectionPhotoPage({super.key});

  @override
  State<SkinDetectionPhotoPage> createState() => _SkinDetectionPhotoPageState();
}

class _SkinDetectionPhotoPageState extends State<SkinDetectionPhotoPage> {
  File? _selectedImage;
  bool _isDetecting = false;
  String? _predictedLabel;
  String? _predictedCode;

  final List<String> classLabels = [
    'Type I/II', 'Type III', 'Type IV', 'Type V', 'Type VI'
  ];

  final Map<String, String> labelToCode = {
    'Type I/II': '2',
    'Type III': '3',
    'Type IV': '4',
    'Type V': '5',
    'Type VI': '6',
  };

  final Map<String, String> labelDescriptions = {
    'Type I/II': 'Very fair skin, burns easily, rarely tans.',
    'Type III': 'Fair to beige skin, may burn mildly, tans uniformly.',
    'Type IV': 'Light brown skin, burns minimally, tans more.',
    'Type V': 'Brown skin, rarely burns, tans well.',
    'Type VI': 'Dark brown to black skin, never burns, tans very easily.',
  };

  Future<void> _pickAndDetectSkinType() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _isDetecting = true;
      _predictedLabel = null;
      _predictedCode = null;
    });

    final label = await _runInference(pickedFile.path);

    setState(() {
      _isDetecting = false;
      _predictedLabel = label;
      _predictedCode = labelToCode[label];
    });
  }

  // Future<String> _runInference(String imagePath) async {
  //   final interpreter = await Interpreter.fromAsset('assets/model/skin_type_model.tflite');
  //
  //   final imageBytes = File(imagePath).readAsBytesSync();
  //   img.Image? oriImage = img.decodeImage(imageBytes);
  //   img.Image resizedImage = img.copyResize(oriImage!, width: 224, height: 224);
  //
  //   var input = List.generate(1, (i) => List.generate(224, (y) => List.generate(224, (x) => List.filled(3, 0.0))));
  //   for (int y = 0; y < 224; y++) {
  //     for (int x = 0; x < 224; x++) {
  //       final pixel = resizedImage.getPixel(x, y); // Pixel object
  //
  //       input[0][y][x][0] = ((pixel.r / 255.0) - 0.5) * 2.0;
  //       input[0][y][x][1] = ((pixel.g / 255.0) - 0.5) * 2.0;
  //       input[0][y][x][2] = ((pixel.b / 255.0) - 0.5) * 2.0;
  //     }
  //   }
  //
  //   var output = List.filled(1 * classLabels.length, 0.0).reshape([1, classLabels.length]);
  //   interpreter.run(input, output);
  //
  //   final scores = List<double>.from(output[0]);
  //   final predictedIndex = scores.indexWhere((e) => e == scores.reduce((a, b) => a > b ? a : b));
  //
  //   // final predictedIndex = scores.indexWhere((e) => e == scores.reduce((a, b) => a > b ? a : b));
  //   return classLabels[predictedIndex];
  // }

  Future<String> _runInference(String imagePath) async {
    final interpreter = await Interpreter.fromAsset('assets/model/skin_type_model.tflite');

    final imageBytes = File(imagePath).readAsBytesSync();
    img.Image? oriImage = img.decodeImage(imageBytes);
    img.Image resizedImage = img.copyResize(oriImage!, width: 224, height: 224);

    var input = List.generate(1, (i) => List.generate(224, (y) => List.generate(224, (x) => List.filled(3, 0.0))));

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixelSafe(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        input[0][y][x][0] = r;
        input[0][y][x][1] = g;
        input[0][y][x][2] = b;
      }
    }



    var output = List.filled(1 * classLabels.length, 0.0).reshape([1, classLabels.length]);
    interpreter.run(input, output);

    final scores = List<double>.from(output[0]);
    debugPrint('Model scores: $scores');

    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final predictedIndex = scores.indexOf(maxScore);

    // final predictedIndex = scores.indexWhere((e) => e == scores.reduce((a, b) => a > b ? a : b));
    return classLabels[predictedIndex];
  }

  void _submitSkinType() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null || _predictedCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing information or skin type not detected.')),
      );
      return;
    }

    final provider = SignUpProvider(context);
    await provider.saveUserToFirebase(
      context: context,
      name: args['name'],
      age: args['age'],
      gender: args['gender'],
      skinType: _predictedCode!, // backend-safe code
      email: args['email'],
      password: args['password'],
    );

    if (context.mounted) {
      Navigator.popUntil(context, ModalRoute.withName('/signIn'));
    }
  }

  void _takeSurveyInstead() {
    Navigator.pushNamed(context, '/skintypeSurvey');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Skin Type Detection")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Upload a clear, well-lit image of your skin (preferably your face)',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _pickAndDetectSkinType,
              child: const Text('Choose Image'),
            ),
            const SizedBox(height: 24),

            if (_selectedImage != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all()),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            const SizedBox(height: 24),

            if (_isDetecting)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Detecting skin type...'),
                ],
              ),

            if (_predictedLabel != null)
              Column(
                children: [
                  Text(
                    'Detected Skin Type: $_predictedLabel',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labelDescriptions[_predictedLabel!] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _submitSkinType,
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                  ),
                  TextButton(
                    onPressed: _takeSurveyInstead,
                    child: const Text("Not accurate? Take Survey Instead"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
