import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ApiService.dart';

class Follower extends StatefulWidget {
  const Follower({super.key});

  @override
  State<Follower> createState() => _FollowedState();
}

class _FollowedState extends State<Follower> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiService>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Follower",
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF395077),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Card(
                child: ListTile(
                  title: Text(
                    value.followerUserList[index].userName,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    value.followerUserList[index].userEmail,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
          itemCount: value.followerUserList.length,
        ),
      );
    });
  }
}
