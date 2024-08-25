import 'package:cloud_firestore/cloud_firestore.dart';

//update stats only when the app goes to termination state
class UserStatsModel {
  String? userId;
  double? timeSpent;
  double? avgSpeed;
  double? totalDistance;
  double? avgPulse;

  UserStatsModel({
    required this.userId,
    required this.timeSpent,
    required this.avgSpeed,
    required this.totalDistance,
    required this.avgPulse,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'timeSpent': timeSpent,
      'avgSpeed': avgSpeed,
      'totalDistance': totalDistance,
      'avgPulse': avgPulse,
    };
  }

  factory UserStatsModel.fromJson(DocumentSnapshot map) {
    return UserStatsModel(
      userId: map['userId'],
      timeSpent: map['timeSpent'],
      avgSpeed: map['avgSpeed'],
      totalDistance: map['totalDistance'],
      avgPulse: map['avgPulse'],
    );
  }
}
