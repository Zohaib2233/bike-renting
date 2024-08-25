import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection("users");

CollectionReference userStatsCollection =
    FirebaseFirestore.instance.collection("userStats");

CollectionReference friendsCollection =
    FirebaseFirestore.instance.collection("friends");

CollectionReference requestCollection =
    FirebaseFirestore.instance.collection("requests");

CollectionReference communityCollection =
    FirebaseFirestore.instance.collection("communities");

CollectionReference postsCollection =
    FirebaseFirestore.instance.collection("posts");

CollectionReference postsCommentsCollection =
    FirebaseFirestore.instance.collection("postsComments");

CollectionReference userFavPostsCollection =
    FirebaseFirestore.instance.collection("userFavPosts");

CollectionReference postReportsCollection =
    FirebaseFirestore.instance.collection("postReports");

CollectionReference userReportedPostsCollection =
    FirebaseFirestore.instance.collection("userReportedPosts");
