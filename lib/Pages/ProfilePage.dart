import 'package:blnk_yeni/Pages/ApplicationPage.dart';
import 'package:blnk_yeni/Pages/Followed.dart';
import 'package:blnk_yeni/Pages/MainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../ApiService.dart';
import 'Follower.dart';
import 'ProfileJobsPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiService>(builder: (context, value, index) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                value.selectedCategoryOnProfile = 0;
                value.generateAcceptedJobOnProfile();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileJobsPage()));
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF87A2B6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Jobs",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
          backgroundColor: Color(0xFF395077),
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 50,
                    color: Color(0xFF395077),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApplicationPage()));
                  },
                ),
                SizedBox(
                  width: 30,
                )
              ],
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.account_circle_rounded,
                    size: 100,
                    color: Color(0xFF395077),
                  ),
                  Center(
                    child: Text(
                      value.mainUserName,
                      style: TextStyle(color: Color(0xFF395077), fontSize: 40),
                    ),
                  ),
                  Center(
                    child: Text(
                      value.mainUserMail,
                      style: TextStyle(color: Color(0xFF395077), fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star,color:Colors.amber,size: 30,),
                        Text("${value.mainUserRate}/5")
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: ()async {
                                value.followedUserList.clear();
                                await value.getFollowings();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Followed()));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    value.followedUserList.length.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF395077),
                                    ),
                                  ),
                                  Text(
                                    "Followed",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF395077),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap:()async{
                                  value.followerUserList.clear();
                                  await value.getFollowers();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Follower()));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    value.followerUserList.length.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF395077),
                                    ),
                                  ),
                                  Text(
                                    "Follower",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF395077),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Comments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF395077)),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: value.getComments(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (value.myComments.isNotEmpty) {
                            return ListView.builder(
                              itemCount: value.myComments.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "From: ${value.myComments[index].userFrom.user_name} ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color:
                                                          Color(0xFF395077))),
                                              Text(
                                                  "For: ${value.myComments[index].job}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color:
                                                          Color(0xFF395077))),
                                            ],
                                          ),
                                          Text(value.myComments[index].comment,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF87A2B6)))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 80,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'There is no Comment',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
/*
ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("From: User ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF395077))),
                                      Text("For: Job",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF395077))),
                                    ],
                                  ),
                                  Text(
                                      "Buraya yorumlar gelicek",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF87A2B6)))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
 */
