import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_share/page/logout.dart';

import '../variable.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream userStream;
  String uid;
  String username;
  int following;
  int followers;
  bool isFollowing;
  String profilepic;
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
    DocumentSnapshot userdoc  = await  usercollection.document(firebaseuser.uid).get();
    var followersdocument = await usercollection.document(firebaseuser.uid).collection('followers').getDocuments();
    var followingdocument = await usercollection.document(firebaseuser.uid).collection('following').getDocuments();
    usercollection.document(firebaseuser.uid).collection('followers').document(firebaseuser.uid).get().then((document){
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
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      userStream = tweetcollection.where("uid", isEqualTo: firebaseuser.uid).snapshots();
    });
  }

  getcurrentUserid() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      uid = firebaseuser.uid;
    });
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
                      child: Container(
                        width: 80.0,
                        height: 20.0,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          border: new Border.all(color: Colors.grey, width: 2.0),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Center(
                          child: InkWell(
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Logout()));},
                            child: new Text(
                              'Edit Profile',
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

      /* dataisthere == true ? SingleChildScrollView(
        physics: ScrollPhysics(),
      child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/4,
              decoration: BoxDecoration(
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height/6,
                left: MediaQuery.of(context).size.width / 2 - 64
              ),
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(profilepic),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.7,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    username,
                    style: mystyle(30, Colors.black, FontWeight.w600),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Following", style: mystyle(20, Colors.black, FontWeight.w600),),
                      Text("Following", style: mystyle(20, Colors.black, FontWeight.w600),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("12", style: mystyle(20, Colors.black, FontWeight.w600),),
                      Text("1", style: mystyle(20, Colors.black, FontWeight.w600),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lightBlue,
                      ),
                      child: Center(
                        child: Text("Edit Profile", style: mystyle(25, Colors.white, FontWeight.w700)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("User Tweets", style: mystyle(25, Colors.black, FontWeight.w700),),
                  StreamBuilder(
                      stream: userStream,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return CircularProgressIndicator();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index){
                              DocumentSnapshot tweetdoc = snapshot.data.documents[index];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(tweetdoc['profilepic']),
                                  ),
                                  title: Text(tweetdoc['username'], style: mystyle(20, Colors.black, FontWeight.w600),),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if(tweetdoc['type'] == 1)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(tweetdoc['tweet'],
                                            style: mystyle(20, Colors.black, FontWeight.w400),
                                          ),
                                        ),
                                      if(tweetdoc['type'] == 2)
                                        Image(image: NetworkImage(tweetdoc['image']),),

                                      if(tweetdoc['type'] == 3)
                                        Column(
                                          children: <Widget>[
                                            Text(tweetdoc['tweet'],
                                              style: mystyle(20, Colors.black, FontWeight.w400),
                                            ),
                                            SizedBox(height: 10,),
                                            Image(image: NetworkImage(tweetdoc['image']),),
                                          ],
                                        ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              InkWell(
                                                  onTap: ()=> Navigator.push(context, MaterialPageRoute(
                                                    builder: (context)=> CommentPage(),
                                                  )),
                                                  child: Icon(Icons.comment)
                                              ),
                                              SizedBox(width: 10.0,),
                                              Text(
                                                tweetdoc['commentcount'].toString(),
                                                style: mystyle(18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: ()=> likePost(tweetdoc['id']),
                                                child: tweetdoc['likes'].contains(uid) ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                tweetdoc['likes'].length.toString(),
                                                style: mystyle(18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.share),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                  ),
                ],
              ),
            )
          ],
        ),
      ) : Center(child: CircularProgressIndicator(),),*/
    );
  }
}

