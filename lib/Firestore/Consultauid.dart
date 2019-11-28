import 'package:cloud_firestore/cloud_firestore.dart';



class Consultas {
 consultaporUid (String uid){
 return Firestore.instance.collection("users").document(uid).get();
 
}
}