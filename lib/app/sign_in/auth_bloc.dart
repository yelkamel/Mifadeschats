import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mifadeschats/app/sign_in/auth_validators.dart';
import 'package:mifadeschats/app/sign_in/repository.dart';

import 'package:rxdart/rxdart.dart';

// Define all possible states for the auth form.
enum AuthStatus { emailAuth, phoneAuth, emailLinkSent, smsSent, isLoading }

class AuthBloc with AuthValidators {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _authStatus = BehaviorSubject<AuthStatus>();
  final _verificationId = BehaviorSubject<String>();

// Add data to stream, validate inputs
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get verificationID => _verificationId.stream;
  Stream<AuthStatus> get authStatus => _authStatus.stream;

// get value
  String get getEmail => _email.value;
  String get getVerificationId => _verificationId.value;
  AuthStatus get getAuthStatus => _authStatus.value;

// change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changeVerificationId => _verificationId.sink.add;
  Function(AuthStatus) get changeAuthStatus => _authStatus.sink.add;

// remove accidental spaces from the input
  Future<void> sendSignInWithEmailLink() {
    return _repository
        .sendSignInWithEmailLink(_email.value.replaceAll(" ", ""));
  }

  Future<void> signOut() {
    return _repository.signOut();
  }

  Future<AuthResult> signInWIthEmailLink(email, link) {
    return _repository.signInWithEmailLink(email, link);
  }

  Future<FirebaseUser> getCurrentUser() {
    return _repository.getCurrentUser();
  }

  Stream<FirebaseUser> onAuthStateChanged() {
    return _repository.onAuthStateChanged();
  }

  Future<void> storeUserEmail() {
    return _repository.setEmail(_email.value.replaceAll(" ", ""));
  }

  Future<void> clearUserEmailFromStorage() {
    return _repository.clearEmail();
  }

  Future<String> getUserEmailFromStorage() {
    return _repository.getEmail();
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) {
    return _repository.signInWithCredential(credential);
  }

  dispose() async {
    await _email.drain();
    _email.close();
    await _authStatus.drain();
    _authStatus.close();
    await _verificationId.drain();
    _verificationId.close();
  }
}
