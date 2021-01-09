import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetngreet/models/users.dart';
import 'package:meetngreet/pages/activity_feed.dart';
import 'package:meetngreet/pages/comments.dart';
import 'package:meetngreet/pages/home.dart';
import 'package:meetngreet/widgets/custom_image.dart';
import 'package:meetngreet/widgets/progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes
});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username : doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    if(likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if(val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    likesCount: getLikeCount(this.likes),
  );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  Map likes;
  int likesCount;
  bool isLiked;
  bool showHeart = false;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likesCount,
    this.likes
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {}),
        );
      },
    );
  }

  handleLikesPosts() {
    bool _isLiked = likes[currentUserId] == true;

    if(_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likesCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if(!_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': true});
      addLikeToActivity();
      setState(() {
        likesCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  addLikeToActivity() {
    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikesPosts,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cachedNetworkImage(mediaUrl),
          showHeart ? Icon(Icons.favorite, size: 80, color: Colors.red,) : Text(""),
        ]
      ),
    );
  }



  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, left: 20.0),
            ),
            GestureDetector(
              onTap: handleLikesPosts,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl
              ),
              child: Icon(
                Icons.comment,
                size: 28.0,
                color: Colors.blue,
              ),
            )]
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$likesCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$username",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(description),
            )
          ],
        ),
      ],
    );
  }





  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if(isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feed")
          .document(postId)
          .get().then((doc){
        if(doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}

showComments(BuildContext context, {String postId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
