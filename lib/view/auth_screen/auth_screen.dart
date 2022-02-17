import 'dart:io';

import 'package:chat_app/view/auth_screen/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _islaoding = false.obs;

  void _submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      _islaoding(true);
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(userCredential.user!.uid + '.jpg');

      await ref.putFile(image);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'image_url':url,
      });
    } catch (e) {
      var message = e.toString().substring(e.toString().indexOf(']') + 1);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
      _islaoding(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _islaoding.value),
    );
  }
}
