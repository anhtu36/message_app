import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/services/login/login_screen.dart';

Future<User?> createAccount(String name,String phoneNum, String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    UserCredential userCrendetial = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(auth.currentUser!.uid).set({
      "name": name,
      "phoneNum":phoneNum,
      "email": email,
      "status": "Unavalible",
      "uid": auth.currentUser!.uid,
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> signIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfull");
    _firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future signOut(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut().then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ));
    });
  } catch (e) {
    print('error');
  }
}
