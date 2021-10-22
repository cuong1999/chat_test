import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/model/userClient.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserClient _clientFromFirebase(User user){
    return user != null ? UserClient(userID: user.uid) : null;
  }

  Future initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    print('Initialized default app $app');
  }

  Future signIn(String email, String password) async {
    try{
      UserCredential userCredential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
    
        return _clientFromFirebase(user);
      
    }catch(e){
      print(e.toString());
    }
  }

  Future signUp(String email, String password) async {
    try {
      UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _clientFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateProfile(String email) async {
    try {
      return await _auth.currentUser.updateEmail(email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut()async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}