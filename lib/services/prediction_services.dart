import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<int> getVotesStream(String matchId, String team) {
    return firestore
        .collection('predictions')
        .where(matchId, isEqualTo: team)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<bool> togglePrediction(
      String matchId, String team, String userId) async {
    DocumentReference docRef = firestore.collection('predictions').doc(userId);
    print(
        "Toggling prediction for user: $userId on match: $matchId with team: $team");

    try {
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (snapshot.exists) {
          Map<String, dynamic> predictions =
              snapshot.data() as Map<String, dynamic>;
          String? previousVote = predictions[matchId] as String?;
          print("Previous vote: $previousVote");

          if (previousVote != team) {
            transaction.update(docRef, {matchId: team});
          } else {
            transaction.update(docRef, {matchId: FieldValue.delete()});
          }
        } else {
          transaction.set(docRef, {
            matchId: team,
            'userId':
                userId 
          });
        }
      });
      return true;
    } catch (e) {
      print('Failed to toggle vote: $e');
      return false;
    }
  }

  Stream<String?> getCurrentVoteStream(String matchId, String userId) {
    return firestore
        .collection('predictions')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?[matchId] as String?);
  }

  Future<String?> getCurrentVote(String matchId, String userId) async {
    DocumentSnapshot snapshot =
        await firestore.collection('predictions').doc(userId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data[matchId] as String?;
    }
    return null;
  }

  Future<int> getVotes(String matchId, String team) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('predictions')
        .where(matchId, isEqualTo: team)
        .get();

    return querySnapshot.docs.length;
  }
}
