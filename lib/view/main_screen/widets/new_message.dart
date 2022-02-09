import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMessage extends StatelessWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _enteredMessage = ''.obs;
    final _controller = TextEditingController();

    void _sendMessage() async {
      FocusScope.of(context).unfocus();
      final user = FirebaseAuth.instance.currentUser;
      final userData =
          await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
      FirebaseFirestore.instance.collection('chat').add({
        'text': _enteredMessage.value,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username':userData['username'],
      });

      _controller.clear();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send message...'),
              onChanged: (value) {
                _enteredMessage.value = value;
              },
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
