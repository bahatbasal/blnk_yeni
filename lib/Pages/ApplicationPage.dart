import 'package:flutter/material.dart';
import 'package:blnk_yeni/Pages/ProfilePage.dart';
import 'package:provider/provider.dart';
import '../ApiService.dart';
import 'ProfilePage.dart';

void main() {
  runApp(ApplicationPage());
}

class ApplicationPage extends StatefulWidget {
  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiService>(builder: (context, value, index) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Application Page',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF395077),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        value.selectedCategoryonApplication=0;
                      });
                      print('Received');
                      await value.getRecievedApplication();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: value.selectedCategoryonApplication==0?Color(0xFF395077):Color(0xFF87A2B6),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      'Received',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: ()async {
                      setState(() {
                        value.selectedCategoryonApplication=1;
                      });
                      print('Applied');
                      await value.getAppliedApplication();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: value.selectedCategoryonApplication==1?Color(0xFF395077):Color(0xFF87A2B6),
                      textStyle: TextStyle(fontSize: 18), // Yazı boyutu
                    ),
                    child: Text(
                      'Applied',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 15,
                child: ListView.builder(
                  itemCount: value.appliactionListOnPage.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                      child: Card(
                        child: ListTile(
                            title: Text(
                          value.appliactionListOnPage[index].userName,
                        ),
                          subtitle: Text(value.appliactionListOnPage[index].jobName),
                          trailing: Container(
                          width: 150,
                            child: Row(
                              children: [
                                Text(value.appliactionListOnPage[index].price.toString()+"TL"),
                                IconButton(onPressed: (){}, icon: Icon(Icons.check_circle,color: Colors.green,)
                                ),
                                IconButton(onPressed: (){}, icon: Icon(Icons.cancel,color:Colors.red,))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
