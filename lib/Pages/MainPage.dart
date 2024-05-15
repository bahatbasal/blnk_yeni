import 'package:blnk_yeni/Pages/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../ApiService.dart';
import '../Modals/Job.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  final nameController = TextEditingController();
  final bodyController = TextEditingController();

  void createNote(ApiService value) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    controller: nameController,
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Describtion",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    controller: bodyController,
                  ),
                ),
              ],
            ),
            actions: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.blue,
                  child: Text(
                    "Create",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Job job = Job(
                        name: nameController.text,
                        body: bodyController.text,
                        giverId: value.mainUserId);
                    await value.PostJob(job);
                    await value.getJobs();
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
    TextEditingController priceControler = TextEditingController();
    return Consumer<ApiService>(builder: (context, value, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createNote(value);
            print("bahat");
          },
          backgroundColor: Color(0xFF395077),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFF395077),
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Center(
                    child: ListTile(
                      title: Text(
                        "Blnk It",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Get blnk jobs!",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          value.followedUserList.clear();
                          value.followerUserList.clear();
                          await value.getFollowings();
                          await value.getFollowers();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                        },
                        child: Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: Text(
                "Recommended User",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF395077),
                    fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: Color(0xFF395077),
                                    size: 50,
                                  ),
                                  Text('Bahat Başal'),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        Text('1/5'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Color(0xFF87A2B6),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Text(
                                                "Follow",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )),

            //Categories
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 15),
              child: Text(
                "Available",
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF395077),
                    fontWeight: FontWeight.bold),
              ),
            ),

            //List The Job on the screen
            Expanded(
              flex: 15,
              child: FutureBuilder(
                future: Future.value(value.jobListOnScreen),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (value.jobListOnScreen.isNotEmpty) {
                      return ListView.builder(
                          itemCount: value.jobListOnScreen.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: Stack(
                                      children: [

                                    Icon(
                                      Icons.account_circle_rounded,
                                      size: 60,
                                      color: Color(0xFF395077),
                                    ),
                                        value.isFollowedJob(value.jobListOnScreen[index])
                                            ?
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 25,
                                        ):SizedBox(),
                                  ]
                                  ),
                                  title: Text(
                                    value.jobListOnScreen[index].name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  subtitle:
                                      Text(value.jobListOnScreen[index].body),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Container(
                                                    height: 400,
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              priceControler,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "What is your price offer?",
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'[0-9]')),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    MaterialButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                        color: Colors.blue,
                                                        child: Text(
                                                          "Apply",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () async {
                                                          int? job_id = value
                                                              .jobListOnScreen[
                                                                  index]
                                                              .id;
                                                          print(job_id);
                                                          await value
                                                              .createApplication(
                                                                  job_id!,
                                                                  double.parse(
                                                                      priceControler
                                                                          .text));
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                    MaterialButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        color: Colors.grey,
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          print("cancel");
                                                          Navigator.pop(
                                                              context);
                                                        })
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color(0xFF87A2B6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Apply",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
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
                              'There is no job',
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
            ),
          ],
        ),
      );
    });
  }
}
