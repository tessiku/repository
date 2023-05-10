import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> checkCollectionExists(String cin) async {
  try {
    final collectionRef = _firestore.collection(cin);
    final collectionSnapshot = await collectionRef.get();
    if (collectionSnapshot.docs.isNotEmpty) {
      // Collection exists and has documents
      // Retrieve document IDs in collection
      final docs = collectionSnapshot.docs;
      final docIds = docs.map((doc) => doc.id).toList();
      return docIds;
    } else {
      // Collection exists but has no documents
      // Handle as desired
      return [];
    }
  } catch (e) {
    // Collection doesn't exist
    // Handle as desired
    return [];
  }
}

}
