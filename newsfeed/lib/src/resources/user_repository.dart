import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:news/src/models/user/user.dart';

class LogInWithEmailAndPasswordFailure implements Exception {}

class SignUpFailure implements Exception {}

class LogOutFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<AppUser> get user {
    return _firebaseAuth.idTokenChanges().map((firebaseUser) {
      return firebaseUser == null ? AppUser.empty : toUser(firebaseUser);
    });
  }

  Future<void> sendVerificationEmail() async {
    if (_firebaseAuth.currentUser != null &&
        !_firebaseAuth.currentUser.emailVerified) {
      await _firebaseAuth.currentUser.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
    await _firebaseAuth.currentUser.reload();
    return _firebaseAuth.currentUser.emailVerified;
  }

  bool checkEmailVerification() {
    if (!isEmailProvider()) {
      return true;
    } else {
      if (_firebaseAuth.currentUser != null) {
        return _firebaseAuth.currentUser.emailVerified;
      }
      return false;
    }
  }

  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      UserCredential user;

      if (!kIsWeb) {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        user = await _firebaseAuth.signInWithCredential(credential);
      } else {
        user =
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      }

      if (user.additionalUserInfo.isNewUser) {
        Box<AppUser> box = Hive.box<AppUser>('user');

        box.put(
          _firebaseAuth.currentUser.email,
          AppUser(
            id: _firebaseAuth.currentUser.uid,
            firstName: _firebaseAuth.currentUser.displayName,
            lastName: 'Last name',
            dateOfBirth: DateTime.now().toString(),
            email: _firebaseAuth.currentUser.email,
            gender: 'Male',
            imagePath: _firebaseAuth.currentUser.photoURL,
          ),
        );
      }
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> resetPassword({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signUp({
    @required String email,
    @required String password,
    @required String firstName,
    @required String lastName,
    @required String dateOfBirth,
    @required String gender,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Box<AppUser> box = Hive.box<AppUser>('user');

      box.put(
        email,
        AppUser(
            id: _firebaseAuth.currentUser.uid,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            email: email,
            gender: gender),
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  void updateUser({
    String firstName,
    String lastName,
    String dateOfBirth,
    String email,
    String gender,
    String imagePath,
  }) {
    Box<AppUser> box = Hive.box<AppUser>('user');
    box.put(
      email,
      AppUser(
        id: _firebaseAuth.currentUser.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        imagePath: imagePath,
      ),
    );
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception {
      throw LogOutFailure();
    }
  }

  AppUser toUser(User firebaseUser) {
    return AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      firstName: '',
      lastName: '',
      dateOfBirth: '',
      gender: '',
    );
  }

  bool isEmailProvider() {
    return _firebaseAuth.currentUser.providerData[0].providerId == 'password';
  }
}
