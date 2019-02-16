import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Authentication {

  static final Authentication _authentication = new Authentication._internal();

  factory Authentication() {
    return _authentication;
  }
  Authentication._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  SharedPreferences prefs;
  bool isLoggedIn = false;
  final isLoading = ValueNotifier(false);
  FirebaseUser currentUser;

  Future<Null> isSignedIn(BuildContext context) async {
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    isLoading.value = false;
    if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  Future<Null> signIn(BuildContext context) async {
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn()
        .catchError((onError) {
      print('Error $onError');
    });
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication authentication = await googleSignInAccount
          .authentication;
      final FirebaseUser user = await _auth.signInWithGoogle(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken
      ).catchError((onError) {
        print('Error $onError');
      });
      isLoggedIn = await googleSignIn.isSignedIn();
      if (user != null && isLoggedIn) {
        final QuerySnapshot result =
        await Firestore.instance.collection('users').where(
            'email', isEqualTo: user.email).getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          Firestore.instance
              .collection('users')
              .document(user.email)
              .setData({
            'id': user.uid,
            'name': user.displayName,
            'email': user.email,
            'photoUrl': user.photoUrl,
            'classesLearned': [],
            'classesProficient': [],
            'classesMastered': []
          });
          await prefs.setString('id', user.uid);
          await prefs.setString('email', user.email);
          await prefs.setString('name', user.displayName);
          await prefs.setString('photoUrl', user.photoUrl);

          currentUser = user;
          isLoading.value = false;
        } else {
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('email', documents[0]['email']);
          await prefs.setString('name', documents[0]['name']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
          isLoading.value = false;
        }
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    }
    isLoading.value = false;
  }

  Future<Null> signOut(BuildContext context) async {
    isLoading.value = true;
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    isLoggedIn = false;
    isLoading.value = false;
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}