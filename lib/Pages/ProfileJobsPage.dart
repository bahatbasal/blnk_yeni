import 'package:blnk_yeni/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../LoginAndSignup/api_connection.dart';

class ProfileJobsPage extends StatefulWidget {
  const ProfileJobsPage({super.key});

  @override
  State<ProfileJobsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileJobsPage> {
  final commentController = TextEditingController();
  double _rating = 3.0;

  void writeComment(ApiService value, int index) {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Comment",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    controller: commentController,
                  ),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 40.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.blue,
                  child: Text(
                    "Send Comment",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    int? userto_id = 0;
                    if (value.mainUserId ==
                        value.jobListOnProfile[index].giverId) {
                      userto_id = value.jobListOnProfile[index].accepterId;
                    } else if (value.mainUserId ==
                        value.jobListOnProfile[index].accepterId) {
                      userto_id = value.jobListOnProfile[index].giverId;
                    }
                    print(commentController.text);
                    print(value.mainUserId);
                    print(userto_id);
                    print(value.jobListOnProfile[index].id);

                    await value.PostComment(
                        commentController.text,
                        value.mainUserId,
                        userto_id,
                        value.jobListOnProfile[index].id,
                      _rating.toInt(),
                    );
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.grey,
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    print("cancel");
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiService>(builder: (context, value, index) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF395077),
          centerTitle: true,
          title: Text(
            "My Jobs",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40,
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
                  )),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                value.selectedCategoryOnProfile = 0;
                                value.generateAcceptedJobOnProfile();
                              });
                            },
                            child: accepted(value)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                value.selectedCategoryOnProfile = 1;
                                value.generatePostedJobOnProfile();
                              });
                            },
                            child: posted(value)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                value.selectedCategoryOnProfile = 2;
                                value.generateDoneJobOnProfile();
                              });
                            },
                            child: done(value)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: ListView.builder(
                    itemCount: value.jobListOnProfile.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                            leading: Icon(
                              Icons.account_circle_rounded,
                              size: 40,
                              color: Color(0xFF395077),
                            ),
                            title: Text(value.jobListOnProfile[index].name),
                            subtitle: Text(value.jobListOnProfile[index].body),
                            trailing: value.selectedCategoryOnProfile != 2
                                ? doneAlert(context, index, value)
                                : value.selectedCategoryOnProfile == 2
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          //
                                          GestureDetector(
                                            onTap: () {
                                              writeComment(value, index);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Color(0xFF87A2B6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  "Comment",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox()),
                      );
                    }))
          ],
        ),
      );
    });
  }

  Column doneAlert(BuildContext context, int index, ApiService value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Center(
                      child: Text("Do you want to mark done this job?"),
                    ),
                    actions: [
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.blue,
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await value.DoneJob(value.jobListOnProfile[index]);

                            await value.getJobs();
                            value.selectedCategoryOnProfile = 0;
                            value.generateAcceptedJobOnProfile();

                            Navigator.pop(context);
                          }),
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.grey,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            print("cancel");
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFF87A2B6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container posted(ApiService value) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: value.selectedCategoryOnProfile == 1
            ? Color(0xFF395077)
            : Color(0xFF87A2B6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Posted",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
      )),
    );
  }

  Container accepted(ApiService value) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: value.selectedCategoryOnProfile == 0
            ? Color(0xFF395077)
            : Color(0xFF87A2B6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Accepted",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
      )),
    );
  }
}

Container done(ApiService value) {
  return Container(
    width: 90,
    decoration: BoxDecoration(
      color: value.selectedCategoryOnProfile == 2
          ? Color(0xFF395077)
          : Color(0xFF87A2B6),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Done",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
      ),
    )),
  );
}
