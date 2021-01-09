import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:story_share/page/add_tweets.dart';
import 'package:story_share/page/chat.dart';
import 'package:story_share/page/profile.dart';
import 'package:story_share/variable.dart';

class TweetsPage extends StatefulWidget {
  final String uid;
  TweetsPage(this.uid);
  @override
  _TweetsPageState createState() => _TweetsPageState();
}

class _TweetsPageState extends State<TweetsPage> {
  Stream PostStream;
  String uid;
  String username;
  String profilepic;
  String OnlineUser;
  String followingtweet;
  bool dataisthere = false;

  initState() {
    super.initState();
    getcurrentuserid();
    getUserInfo();
    getPost();
    getfollowinguid();
  }

  getUserInfo() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userdoc  = await  usercollection.document(firebaseuser.uid).get();
    setState(() {
      username = userdoc['username'];
      profilepic = userdoc['profilepic'];
      dataisthere = true;
    });
  }

  getfollowinguid() async {
    var followinguser = await usercollection.document(OnlineUser).collection("following").getDocuments();
    setState(() {
      followingtweet = followinguser.toString();
    });
  }

  getPost() async {
    setState(() {
      PostStream = tweetcollection.where('uid', isEqualTo: followingtweet).snapshots();
    });
  }


  getcurrentuserid() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser();
    setState(() {
      OnlineUser = firebaseuser.uid;
    });
  }


  /*likePost(String documentid) async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddTweets())),
      child: Icon(Icons.edit), backgroundColor: Theme.of(context).accentColor,),
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){},
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(profilepic),
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Chat())),
            child: Icon(Icons.send),
          )
        ],
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(16.0, 40.0, 0.0, 8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
                },
                child: Container(
                  width: 75.0,
                  height: 75.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(profilepic)
                    )
                  ),
                ),
              ),),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      username,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  '@$username',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.grey,
                height: 0.5,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Lists',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.list,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Bookmarks',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.bookmark_border,
                          color: Colors.grey,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Moments',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.apps,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.grey,
                        height: 0.5,
                      ),
                      ListTile(
                        title: Text(
                          'Settings and Privacy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Help center',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.grey,
                height: 0.5,
              ),
              Padding(padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(padding: new EdgeInsets.all(0.0), icon: Icon(Icons.wb_sunny), onPressed: null),
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                      padding: new EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.camera_alt,
                        size: 32.0,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),)
            ],
          ),
        ),
      ),
      /*appBar: AppBar(
        actions: <Widget>[
          Icon(Icons.star, size: 32,),
        ],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Stories", style: mystyle(20, Colors.black, FontWeight.w700),),
            SizedBox(
              width: 5.0,
            ),
            Image(width: 45, height: 54,image: AssetImage("assets/images/23931.png"))
          ],
        ),
      ),*/
      body: StreamBuilder<QuerySnapshot>(
        stream: tweetcollection.snapshots(),
        builder: (BuildContext context, snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
            shrinkWrap: true,
               itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index){
                 DocumentSnapshot tweetdoc = snapshot.data.documents[index];
                 if(!snapshot.hasData){
                   return CircularProgressIndicator();
                 }
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
                 /*return Card(
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
                 );*/
              });
        }
      ),
    );
  }
}
