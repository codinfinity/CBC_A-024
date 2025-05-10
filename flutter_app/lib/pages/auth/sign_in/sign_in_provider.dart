import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignInProvider extends BaseViewModel {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  SignInProvider(BuildContext ctx) : super(ctx) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }


  Future<void> signIn(BuildContext context) async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || !email.contains('@') || password.length < 6) {
    if (context.mounted) {
      SnackBarUtil.showSnack(context, 'Please enter valid credentials.');
    }
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (context.mounted) {
      SnackBarUtil.showSuccess(context, 'Signed in successfully!');

      Navigator.of(context).pushNamed('/dashboard'); // Navigate to dashboard or home
    }
  } on FirebaseAuthException catch (e) {
    String message = 'Sign in failed.';
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password provided.';
    }
    if (context.mounted) {
      SnackBarUtil.showSnack(context, message);
    }
  } catch (e) {
    if (context.mounted) {
      SnackBarUtil.showSnack(context, 'An error occurred: ${e.toString()}');
    }
  }
}

}