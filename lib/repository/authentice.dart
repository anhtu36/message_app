import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_app/pages/groupchat/group_chat_screen.dart';
import 'package:message_app/services/login/login_screen.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return GroupChatScreen();
    } else {
      return LoginScreen();
    }
    
  }
}
