import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned(
                      top: 40,
                        child: Padding(
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
                                            image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/9/9a/Mahesh_Babu_in_Spyder_%28cropped%29.jpg")),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      border: new Border.all(color: Colors.grey, width: 2.0),
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child: Text("Raghav"),
                                  ),
                                )

                              ],
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}