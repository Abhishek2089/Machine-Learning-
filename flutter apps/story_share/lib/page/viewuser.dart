
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:story_share/variable.dart';

class ViewUser extends StatefulWidget {
  final String uid;
  ViewUser(this.uid);

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {

  Stream userStream;
  String onlineuser;
  String username;
  int following;
  int followers;
  String profilepic;
  bool isFollowing;
  bool dataisthere = false;

  @override
  void initState() {
    super.initState();
    getcurrentUserid();
    getStream();
    getuserinfo();
  }

  getuserinfo() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userdoc  = await  usercollection.document(widget.uid.trim()).get();
    var followersdocument = await usercollection.document(widget.uid).collection('followers').getDocuments();
    var followingdocument = await usercollection.document(widget.uid).collection('following').getDocuments();
    usercollection.document(widget.uid).collection('followers').document(firebaseuser.uid).get().then((document){
      if(document.exists){
        setState(() {
          isFollowing = true;
        });
      }else{
        setState(() {
          isFollowing = false;
        });
      }
    });

    setState(() {
      username = userdoc['username'];
      profilepic = userdoc['profilepic'];
      following = followingdocument.documents.length;
      followers = followersdocument.documents.length;
      dataisthere = true;
    });
  }

  getStream() async {
    setState(() {
      userStream = tweetcollection.where("uid", isEqualTo: widget.uid.trim()).snapshots();
    });
  }

  getcurrentUserid() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      onlineuser = firebaseuser.uid;
    });
  }

  followuser() async {
    var document = await usercollection.document(widget.uid).collection('followers').document(onlineuser).get();
    if(!document.exists){
      usercollection.document(widget.uid).collection('followers').document(onlineuser).setData({});
      usercollection.document(onlineuser).collection('following').document(widget.uid).setData({});
      setState(() {
        followers++;
        isFollowing = true;
      });
    }

    else{
      usercollection.document(widget.uid).collection('followers').document(onlineuser).delete();
      usercollection.document(onlineuser).collection('following').document(widget.uid).delete();
      setState(() {
        followers--;

        isFollowing = false;
      });
    }
  }

  likePost(String documentid) async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot document = await tweetcollection.document(documentid).get();

    if(document['likes'].contains(firebaseuser.uid)){
      tweetcollection.document(documentid).updateData({
        'likes': FieldValue.arrayRemove([firebaseuser.uid])
      });
    } else {
      tweetcollection.document(documentid).updateData({
        'likes': FieldValue.arrayUnion([firebaseuser.uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(exampleimage)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 190,
                      child: InkWell(
                        onTap: ()=> followuser(),
                        child: Container(
                          width: 80.0,
                          height: 20.0,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: new Border.all(color: Colors.grey, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Center(
                            child: new Text(
                              isFollowing == false ? 'Follow' : 'Unfollow',
                              style: new TextStyle(
                                  color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 125,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 100,
                                decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Theme.of(context).primaryColor),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: DecoratedBox(
                                    decoration: ShapeDecoration(
                                      shape: CircleBorder(),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              exampleimage)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(
                            username,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Text(
                            '@' + username,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15, left: 10),
                                  child: Text(
                                    'Following :',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15, left: 15,),
                                  child: Text(
                                    following.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    'Followers :',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 15,),
                                  child: Text(
                                    followers.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )

                      ],
                    )
                  ],
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                stream: userStream,
                builder: (context, snapshot){
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index){
                      DocumentSnapshot tweetdoc = snapshot.data.documents[index];
                      return Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(tweetdoc['profilepic']),
                                    ),
                                  ),
                                ),),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(tweetdoc['username'], style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Text(
                                                  "@${tweetdoc['username']}",
                                                  style: TextStyle(
                                                      color: Colors.grey
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Icon(Icons.arrow_drop_down,
                                            color: Colors.grey,)
                                        ],
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 0, bottom: 8),
                                          child: Column(
                                            children: <Widget>[
                                              if(tweetdoc['type'] == 1)
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(tweetdoc['tweet'],
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ),
                                              if(tweetdoc['type'] == 2)
                                                Image(image: NetworkImage(tweetdoc['image']),),

                                              if(tweetdoc['type'] == 3)
                                                Column(
                                                  children: <Widget>[
                                                    Text(tweetdoc['tweet'],
                                                      style: TextStyle(
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Image(image: NetworkImage(tweetdoc['image']),),
                                                  ],
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                          width: 18,
                                                          child: IconButton(
                                                            padding: new EdgeInsets.all(0),
                                                            icon: Icon(
                                                              Icons.chat_bubble_outline,
                                                              size: 18,
                                                              color: Colors.grey,
                                                            ),
                                                            onPressed: (){},
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 58),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                              width: 18,
                                                              child: IconButton(
                                                                padding: new EdgeInsets.all(0),
                                                                icon: Icon(Icons.replay, size: 18, color: Colors.grey,),
                                                                onPressed: (){},
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 58),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                  width: 18,
                                                                  child: IconButton(
                                                                    padding: EdgeInsets.all(0),
                                                                    icon: Icon(Icons.favorite_border, size: 18, color: Colors.grey,),
                                                                    onPressed: (){},
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(left: 58),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                  width: 18,
                                                                  child: IconButton(
                                                                    padding: EdgeInsets.all(0),
                                                                    icon: Icon(Icons.share, size: 18, color: Colors.grey,),
                                                                    onPressed: (){},
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(left: 38),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    }
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}