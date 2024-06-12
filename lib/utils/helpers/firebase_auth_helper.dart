import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthHelper{
 static AuthHelper authHelper=AuthHelper._();
  AuthHelper._();
  User? user;
  Future<String> signIn({required String emailAddress,required String password})
  async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password'){
        return 'Wrong password provided for that user.';
      }
      else{
        return 'SignIn Failed';
      }
    }
  }
  Future<String> signUp({required String emailAddress,required String password})
  async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      else{
        return 'Sign Up Failed';
      }
    }
  }

 Future<UserCredential> signInWithGoogle() async {
   // Trigger the authentication flow
   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

   // Obtain the auth details from the request
   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

   // Create a new credential
   final credential = GoogleAuthProvider.credential(
     accessToken: googleAuth?.accessToken,
     idToken: googleAuth?.idToken,
   );
   // Once signed in, return the UserCredential
   return await FirebaseAuth.instance.signInWithCredential(credential);
 }
 bool checkUser() {
   user = FirebaseAuth.instance.currentUser;
   return user != null;
 }

 Future<void> logOut() async {
   await FirebaseAuth.instance.signOut();
 }
 Future<String> guestLogIn()
 async {
   try {
     final userCredential =
         await FirebaseAuth.instance.signInAnonymously();
     return "Success";
   } on FirebaseAuthException catch (e) {
     switch (e.code) {
       case "operation-not-allowed":
         return "Anonymous auth hasn't been enabled for this project.";
       default:
        return  "Unknown error.";
     }
   }
 }
}