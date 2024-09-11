import 'package:cloud_firestore/cloud_firestore.dart';

class InfoStore {

  Future<void> infoEmpADD(Map<String, dynamic> infoEmployee, String id) async {
    return await FirebaseFirestore.instance.collection('Employee Data').doc(id).set(infoEmployee);
  }

  Stream<DocumentSnapshot> infoEmpGet(String id) {
    return FirebaseFirestore.instance.collection('Employee Data').doc(id).snapshots();
  }


Future update(String id,Map<String,dynamic> updatedata)async
{
  return FirebaseFirestore.instance.collection('Employee Data').doc(id).update(updatedata);

}

Future delete(String id)async
{
  return FirebaseFirestore.instance.collection('Employee Data').doc(id).delete();

}
}
