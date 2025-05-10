import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late UserModel _userModel;

  @override
  void initState() {
    super.initState();
    // Initialize user model with sample data
    _userModel = UserModel(
      uid: 'sampleUid',
      email: 'user@example.com',
      skinType: 'Type 2',
      cumulativeExposure: 50.0,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> _addUser() async {
    await _firestoreService.addUser(_userModel);
    print('User added!');
  }

  Future<void> _getUser() async {
    UserModel? user = await _firestoreService.getUser(_userModel.uid);
    if (user != null) {
      print('User data: ${user.email}, ${user.cumulativeExposure}');
    } else {
      print('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Testing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addUser,
              child: Text('Add User to Firestore'),
            ),
            ElevatedButton(
              onPressed: _getUser,
              child: Text('Get User from Firestore'),
            ),
            SizedBox(height: 20),
            Text(
              'Make sure to check the console for the test results.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: TestPage(),
  ));
}
