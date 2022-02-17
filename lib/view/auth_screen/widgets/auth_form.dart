import 'dart:io';

import 'package:chat_app/view/auth_screen/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthForm extends StatelessWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitFn;

  final _formKey = GlobalKey<FormState>();
  final _isLogin = true.obs;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please pick an image.',
          ),
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile as File,
        _isLogin.value,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => !_isLogin.value
                      ? UserImagePicker(_pickedImage)
                      : Container()),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (newValue) {
                      _userEmail = newValue.toString();
                    },
                  ),
                  Obx(
                    () => !_isLogin.value
                        ? TextFormField(
                            key: const ValueKey('username'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Please enter at least four characters';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            onSaved: (newValue) {
                              _userName = newValue.toString();
                            },
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 3) {
                        return 'Password must be at least 8 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (newValue) {
                      _userPassword = newValue.toString();
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _trySubmit(context),
                              child: Obx(
                                () => Text(_isLogin.value ? 'Login' : 'Signup'),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _isLogin.value = !_isLogin.value;
                              },
                              child: Obx(
                                () => Text(
                                  _isLogin.value
                                      ? 'Create new account'
                                      : 'I already have an account',
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
