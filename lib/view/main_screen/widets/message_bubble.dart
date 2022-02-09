import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isMe,
    required this.userName,
    required this.key,
  });

  final Key key;
  final String message;
  final bool isMe;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  userName,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Colors.purple,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: !isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Text(
                message,
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
