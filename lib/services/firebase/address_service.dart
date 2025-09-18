import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../model/address_model.dart';

@singleton
class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _addressRef =>
      _firestore.collection('users').doc(_uid).collection('addresses');

  Future<void> addAddress(Address address) async {
    final docRef = _addressRef.doc(); // generate random id
    final newAddress = address.copyWith(id: docRef.id);

    await docRef.set(newAddress.toJson());
  }

  Future<void> updateAddress(Address address) async {
    await _addressRef.doc(address.id).update(address.toJson());
  }

  Future<void> deleteAddress(Address address) async {
    await _addressRef.doc(address.id).delete();
  }

  Stream<List<Address>> get addressStream => _addressRef.snapshots().map(
    (snapshot) =>
        snapshot.docs
            .map((doc) => Address.fromJson(doc.id, doc.data()))
            .toList(),
  );

  Future<List<Address>> fetchAddresses() async {
    final query = await _addressRef.get();
    return query.docs
        .map((doc) => Address.fromJson(doc.id, doc.data()))
        .toList();
  }
}
