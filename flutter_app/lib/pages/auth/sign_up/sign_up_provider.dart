import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
import '../../../services/firestore_service.dart';
import '../../../models/user_model.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';

class SignUpProvider extends BaseViewModel {
  SignUpProvider(super.context);

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController(); // Needed for Radio buttons
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  Future<void> saveUserToFirebase({
    required BuildContext context,
    required String name,
    required int age,
    required String gender,
    required String skinType,
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCred.user!.uid;

      final newUser = UserModel(
        uid: uid,
        name: name,
        age: age,
        gender: gender,
        skinType: skinType,
        email: email,
        currentUVIndex: 0.0,
        createdAt: DateTime.now(),
      );

      await FirestoreService().addUser(newUser);

      if (context.mounted) {
        SnackBarUtil.showSuccess(context, 'Account created successfully!');
        Navigator.of(context).popAndPushNamed('/signIn');
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtil.showSnack(context, 'Sign up failed: ${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
// import 'package:flutter/widgets.dart';
// import '../../../services/firestore_service.dart';
// import '../../../models/user_model.dart';
// import 'package:flareline_uikit/utils/snackbar_util.dart';

// class SignUpProvider extends BaseViewModel {
//   late TextEditingController nameController;
//   late TextEditingController ageController;
//   late TextEditingController genderController;
//   late TextEditingController skinTypeController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController rePasswordController;

//   SignUpProvider(super.context) {
//     nameController = TextEditingController();
//     ageController = TextEditingController();
//     genderController = TextEditingController();
//     skinTypeController = TextEditingController();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     rePasswordController = TextEditingController();
//   }

//   Future<void> signUp(BuildContext context) async {
//     final name = nameController.text.trim();
//     final age = int.tryParse(ageController.text.trim()) ?? 0;
//     final gender = genderController.text.trim();
//     final skinType = skinTypeController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//     final rePassword = rePasswordController.text.trim();

//     if (name.isEmpty ||
//         age <= 0 ||
//         gender.isEmpty ||
//         skinType.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         password != rePassword) {
//       if (context.mounted) {
//         SnackBarUtil.showSnack(context, 'Please fill all fields correctly.');
//       }
//       return;
//     }

//     if (password.length < 6) {
//       if (context.mounted) {
//         SnackBarUtil.showSnack(context, 'Password must be at least 6 characters.');
//       }
//       return;
//     }

//     try {
//       final userCred = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       final uid = userCred.user!.uid;

//       final newUser = UserModel(
//         uid: uid,
//         name: name,
//         age: age,
//         gender: gender,
//         skinType: skinType,
//         email: email,
//         currentUVIndex: 0.0,
//         createdAt: DateTime.now(),
//       );

//       await FirestoreService().addUser(newUser);

//       if (context.mounted) {
//         SnackBarUtil.showSuccess(context, 'Account created successfully!');
//         Navigator.of(context).popAndPushNamed('/signIn');
//       }

//     } catch (e) {
//       if (context.mounted) {
//         SnackBarUtil.showSnack(context, 'Sign up failed: ${e.toString()}');
//       }
//     }
//   }
// }


