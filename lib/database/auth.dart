import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sociachatv2/models/users/userConfig.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmail(String email, String password) async {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<void> createUserWithEmail(String email,String username, String password)async{
   UserCredential userCredential=  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
   String userID = userCredential.user!.uid;
   print("userId $userID");
UserConfig().addUser(userID, username, email);
  }
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          // Check if user's email is already in the database
          final bool emailExists = await UserConfig().checkIfEmailExists(user.email);

          if (emailExists) {
            print("User is logged in: ${user.displayName}");
          } else {
            await UserConfig().createUserRecord(user);
            print("New user signed up and logged in");
          }
        }
      }
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
    return null;
  }
  void signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

}