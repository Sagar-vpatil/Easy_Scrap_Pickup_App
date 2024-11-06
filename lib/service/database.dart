import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod{
  Future addUserDetails(Map<String,dynamic> userInfoMap,String phone) async{
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .set(userInfoMap);
  }

  Future updateUserDetails(Map<String, dynamic> updatedInfoMap,String phone) async{
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .update(updatedInfoMap);
  }

  Future deleteUserDetails(String phone) async{
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .delete();
  }

  Future addPickupDetails(Map<String,dynamic> pickupInfoMap,String orderId) async{
    return await FirebaseFirestore.instance
        .collection('Pickups')
        .doc(orderId)
        .set(pickupInfoMap);
  }

  Future<Stream<QuerySnapshot>> getScheduledPickups(String phone) async{
    return FirebaseFirestore.instance
        .collection('Pickups')
        .where('Phone',isEqualTo: phone)
        .where('Status',isEqualTo: 'Scheduled')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getCompletedPickups(String phone) async{
    return FirebaseFirestore.instance
        .collection('Pickups')
        .where('Phone',isEqualTo: phone)
        .where('Status',isEqualTo: 'Completed')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllScheduledPickups() async{
    return FirebaseFirestore.instance
        .collection('Pickups')
        .where('Status',isEqualTo: 'Scheduled')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllCompletedPickups() async{
    return FirebaseFirestore.instance
        .collection('Pickups')
        .where('Status',isEqualTo: 'Completed')
        .snapshots();
  }

  Future updatePickupStatus(String orderId) async{
    return await FirebaseFirestore.instance
        .collection('Pickups')
        .doc(orderId)
        .update({'Status': 'Completed'});
  }

  Future updatePickupPhone(String newPhone,String oldPhone) async{
    return await FirebaseFirestore.instance
        .collection('Pickups')
        .where('Phone',isEqualTo: oldPhone)
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('Pickups')
            .doc(doc.id)
            .update({'Phone': newPhone});
      });
    });
  }

  Future deletePickup(String orderId) async{
    return await FirebaseFirestore.instance
        .collection('Pickups')
        .doc(orderId)
        .delete();
  }

}