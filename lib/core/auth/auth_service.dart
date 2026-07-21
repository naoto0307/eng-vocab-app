import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Authenticationの「Google」プロバイダ設定で自動生成されたWebクライアントID。
/// GoogleSignInのIDトークンをFirebase Authが検証する際のaudienceとして必要。
const _googleWebClientId =
    '1080324077531-mna8j9ocp2ptc6guk14abfatc5obu4gv.apps.googleusercontent.com';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
});

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;
  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize(serverClientId: _googleWebClientId);
    _googleSignInInitialized = true;
  }

  Future<void> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw Exception('Googleログインに失敗しました（IDトークンを取得できません）');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _ensureGoogleSignInInitialized();
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
