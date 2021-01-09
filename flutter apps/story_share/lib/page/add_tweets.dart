import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_share/variable.dart';

class AddTweets extends StatefulWidget {
  @override
  _AddTweetsState createState() => _AddTweetsState();
}

class _AddTweetsState extends State<AddTweets> {
  File imagepath;
  TextEditingController tweetcontroller = TextEditingController();
  bool uploading = false;
  
  pickimage(ImageSource imgSource) async {
    final image = await ImagePicker().getImage(source: imgSource);
    setState(() {
      imagepath = File(image.path);
    });
    Navigator.pop(context);
  }

  optionsdialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: ()=> pickimage(ImageSource.gallery),
              child: Text("Image from gallery", style: mystyle(20),),
            ),
            SimpleDialogOption(
              onPressed: ()=> pickimage(ImageSource.camera),
              child: Text("Image from camera", style: mystyle(20),),
            ),
            SimpleDialogOption(
              onPressed: (){},
              child: Text("Cancel", style: mystyle(20),),
            ),
          ],
        );
      }
    );
  }

  uploadimage(String id) async {
    StorageUploadTask storageUploadTask = tweetpictures.child(id).putFile(imagepath);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  posttweet() async {
    setState(() {
      uploading = true;
    });
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userdoc = await usercollection.document(firebaseuser.uid).get();
    var alldocuments = await tweetcollection.getDocuments();
    int length = alldocuments.documents.length;

    if(tweetcontroller.text != '' && imagepath == null){
      tweetcollection.document('Tweet $length').setData({
        'username': userdoc['username'],
        'profilepic': userdoc['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'tweet': tweetcontroller.text,
        'likes': [],
        'commentscount': 0,
        'shares': 0,
        'type': 1,
      });
      Navigator.pop(context);
    }

    if(tweetcontroller.text == '' && imagepath != null){
      String imageurl = await uploadimage('Tweet $length');
      tweetcollection.document('Tweet $length').setData({
        'username': userdoc['username'],
        'profilepic': userdoc['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'image': imageurl,
        'likes': [],
        'commentscount': 0,
        'shares': 0,
        'type': 2,
      });
      Navigator.pop(context);
    }

    if(tweetcontroller.text != null && imagepath != null) {
      String imageurl = await uploadimage('Tweet $length');
      tweetcollection.document('Tweet $length').setData({
        'username': userdoc['username'],
        'profilepic': userdoc['profilepic'],
        'uid': firebaseuser.uid,
        'id': 'Tweet $length',
        'tweet': tweetcontroller.text,
        'image': imageurl,
        'likes': [],
        'commentscount': 0,
        'shares': 0,
        'type': 3,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()=> posttweet(),
      child: Icon(Icons.publish, size: 32),),
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=>Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 32,),
        ),
        centerTitle: true,
        title: Text(
          "Add Stories",
          style: mystyle(20),
        ),
        actions: <Widget>[
          InkWell(
            onTap: ()=> optionsdialog(),
            child: Icon(Icons.photo, size: 40,),
          ),
        ],
      ),
      body: uploading == false
          ? Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: tweetcontroller,
                    maxLines: null,
                    style: mystyle(20),
                    decoration: InputDecoration(
                        labelText: "What's happening now",
                        labelStyle: mystyle(25),
                        border: InputBorder.none),
                  ),
                ),
                imagepath == null
                    ? Container()
                    : MediaQuery.of(context).viewInsets.bottom > 0
                        ? Container()
                        : Image(
                            width: 200,
                            height: 200,
                            image: FileImage(imagepath),
                          )
              ],
            )
          : Center(
              child: Text(
                "Uploading....",
                style: mystyle(25),
              ),
            ),
    );
  }
}