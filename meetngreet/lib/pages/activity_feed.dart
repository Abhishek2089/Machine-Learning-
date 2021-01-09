import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetngreet/pages/home.dart';
import 'package:meetngreet/pages/post_screen.dart';
import 'package:meetngreet/pages/profile.dart';
import 'package:meetngreet/widgets/header.dart';
import 'package:meetngreet/widgets/progress.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef.document(currentUser.id).collection('feedItems')
        .orderBy('timestamp', descending: true).limit(50).getDocuments();
    List<ActivityFeedItems> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItems.fromDocument(doc));
    //  print('activity feed item: ${doc.data}');
    });
    return feedItems;
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: header(context, titleText: "Activity Feed"),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context,snapshot) {
            if(!snapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItems extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  const ActivityFeedItems({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp});

  factory ActivityFeedItems.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItems(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  showPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(
      postId: postId,
      userId: userId,
    )));
  }

  configureMediaPreview(context) {
    if(type == "like" || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(aspectRatio: 16 /9,
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider(mediaUrl),
                fit: BoxFit.cover),
              ),
          ),),
        ),
      );
    } else {
      mediaPreview =  Text('');
    }
    if(type == 'like') {
      activityItemText = "liked your post";
    } else if(type == 'follow') {
      activityItemText = "is following you";
    } else if(type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else {
      activityItemText = "Error: Unknoen Type '$type";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                 children: [
                   TextSpan(
                     text: username,
                     style: TextStyle(
                       fontWeight: FontWeight.bold
                     ),
                   ),
                   TextSpan(
                     text: ' $activityItemText',
                   )
                 ]
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(profileId: profileId,)));
}



