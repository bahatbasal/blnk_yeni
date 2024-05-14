import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ApiService.dart';

class Followed extends StatefulWidget {
  const Followed({super.key});

  @override
  State<Followed> createState() => _FollowedState();
}

class _FollowedState extends State<Followed> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiService>(builder: (context, value, child) {
      return Scaffold(
          appBar:AppBar(
            title: Text(
              "Followed",
            ),
            centerTitle: true,
            backgroundColor:  Color(0xFF395077),
          )


        ,
        body: ListView.builder(itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Card(
              child: ListTile(
               title: Text(value.followedUserList[index].userName,style: TextStyle(fontSize: 20),),
                subtitle: Text(value.followedUserList[index].userEmail,style: TextStyle(fontSize: 16),),
                trailing: GestureDetector(
                    onTap: (){
                      value.
                    },
                    child: Icon(Icons.delete)),
              ),
            ),
          );

        },
          itemCount: value.followedUserList.length,
        ),
      );
    });
  }
}
