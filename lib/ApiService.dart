import 'dart:convert';
import 'package:blnk_yeni/LoginAndSignup/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'LoginAndSignup/api_connection.dart';
import 'Modals/Job.dart';
import 'Modals/Comment.dart';
import 'Modals/RecommendedUserModal.dart';
import 'Modals/UserCommenter.dart';
import 'Modals/Application.dart';
import 'Modals/FollowUserModal.dart';

class ApiService extends ChangeNotifier {

  late int mainUserId;
  late String mainUserName;
  late String mainUserMail;
  late double mainUserRate;

  int selectedCategory=0;
  int selectedCategoryonApplication=0;

  int selectedCategoryOnProfile=0;

  List<Job> jobList = [];
  List<Comment> myComments = [];

  List<Job> jobListOnScreen=[];

  List<Job> jobListOnProfile=[];

  List<Application> appliactionListOnPage=[];

  List<FollowUserModal> followedUserList=[];
  List<FollowUserModal> followerUserList=[];

  List<RecommendedUserModal> recommendedUserOnScreen=[];


  void generateAvailableJob() {
    List<Job> dummyJobs=jobList;
    List<Job> availableJobs = [];
    if(dummyJobs.isNotEmpty){
      for (int i = 0; i < dummyJobs.length; i++) {
        if (dummyJobs[i].giverId != mainUserId && dummyJobs[i].accepterId==1) {
          availableJobs.add(dummyJobs[i]);
        }
      }
    }
    jobListOnScreen=availableJobs;
    notifyListeners();
  }

  //GET
  Future getJobs() async {
    var url = API.JobUrl;
    var response = await http.get(Uri.parse(url));
    var jsonData= jsonDecode(response.body);
    List<Job> list=[];
    for(var eachJob in jsonData){
      Job jos=Job(
          id: int.parse(eachJob['job_id']),
          name: eachJob['job_name'],
          body: eachJob['job_body'],
          giverId: int.parse(eachJob['giver_id']),
          accepterId: int.parse(eachJob['excepter_id']),
        isDoneAccepter:int.parse(eachJob['isDoneExcepter']),
        isDoneGiver:int.parse(eachJob['isDoneGiver']),
      );
      list.add(jos);
    }

    jobList=list;
    generateAvailableJob();
  }
  //Demet Get


  Future getRecievedApplication() async{
  var url =API.recievedApplicationUrl;

  Map<String,dynamic> jsonMap={
    "user_id": mainUserId
  };

  var jsonBody=jsonEncode(jsonMap);
  var response = await http.post(Uri.parse(url),body:jsonBody);

   if (response.statusCode == 200) {

    var jsonData = jsonDecode(response.body);
    List<Application> receivedapplicationlist=[];//bundan emin değilim tüm applicantlar listelenmeli mi?

    for(var eachApplication in jsonData){
       Application application =Application.fromJson(eachApplication);
      receivedapplicationlist.add(application);
      }


    appliactionListOnPage=receivedapplicationlist;
    notifyListeners();

  } else {
    print('Failed to load application');
  }
}

  Future getAppliedApplication() async{
    var url =API.appliedApplicationUrl;

    Map<String,dynamic> jsonMap={
      "applicant_id": mainUserId
    };

    var jsonBody=jsonEncode(jsonMap);
    var response = await http.post(Uri.parse(url),body:jsonBody);

    if (response.statusCode == 200) {

      var jsonData = jsonDecode(response.body);
      List<Application> appliedapplicationlist=[];//bundan emin değilim tüm applicantlar listelenmeli mi?

      for(var eachApplication in jsonData){
        Application application =Application.fromJsonWithStatue(eachApplication);
        appliedapplicationlist.add(application);
      }

      print(appliedapplicationlist.length);
      appliactionListOnPage=appliedapplicationlist;
      notifyListeners();

    } else {
      print('Failed to load application');
    }
  }

  //Create application
  Future createApplication(int job_id, double price) async{
    var url =API.createApplicationUrl;


    Map<String,dynamic> jsonMap={
      'applicant_id':mainUserId,
      'job_id':job_id,
      'price':price
    };

    var jsonBody=jsonEncode(jsonMap);
    var response = await http.post(Uri.parse(url),body:jsonBody);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "You applied the job succesfully!");

    } else {
      print('Failed to load application');
    }
  }

  //Accept application
  Future acceptApplication(int application_id) async{
    var url =API.acceptApplicationUrl;


    Map<String,dynamic> jsonMap={
      'application_id': application_id
    };

    var jsonBody=jsonEncode(jsonMap);
    var response = await http.post(Uri.parse(url),body:jsonBody);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "You accepted the application succesfully!");

    } else {
      print('Error occured');
    }
  }
//Reject application
  Future rejectApplication(int application_id) async{
    var url =API.rejectApplicationUrl;


    Map<String,dynamic> jsonMap={
      'application_id': application_id
    };

    var jsonBody=jsonEncode(jsonMap);
    var response = await http.post(Uri.parse(url),body:jsonBody);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "You rejected the application succesfully!");

    } else {
      print('Error occured');
    }
  }


  Future getComments() async {
    var url = API.CommentUrl+"$mainUserId";
    var response = await http.get(Uri.parse(url));
    var jsonData= jsonDecode(response.body);


    List<Comment> commentList=[];

    for(var eachComment in jsonData){

      var commenterId=int.parse(eachComment["userfrom_id"]);

      var jobId=int.parse(eachComment["job_id"]);

      UserCommenter user =await getUserByID(commenterId);

      String job = await getJobByID(jobId);
      Comment comment= Comment(
        job: job,
        comment: eachComment["comment"],
        userFrom: user
      );

      commentList.add(comment);
    }
    myComments=commentList;
  }

  
  Future<UserCommenter> getUserByID(int commenterId) async {
    var url = API.UserByIdUrl+commenterId.toString();

    var response = await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);


    UserCommenter commenter=UserCommenter("","");
    for(var eachCommenter in jsonData){
      commenter=UserCommenter.fromJson(eachCommenter);
    }

    return commenter;
  }

  Future<String> getJobByID(int jobId) async {

    var url = API.JobByIdUrl+jobId.toString();

    var response = await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);

    var str = "";
    for(var eachName in jsonData){
      str=eachName["job_name"];
    }

    return str ;
  }



  //PUT
  Future AcceptJob(Job job) async {
    var url = API.JobUrl;
    var response = await http.put(Uri.parse(url), body: jsonEncode(job.toJsonPut()));

    if (response.statusCode == 200) {
      print("Succesfuly Done the job");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  Future DoneJob(Job job) async {
    if(job.accepterId==mainUserId){
    var url = API.AccepterDoneJobUrl;
    var response = await http.put(Uri.parse(url), body: "{\"job_id\":${job.id}}");

    if (response.statusCode == 200) {
      print("Succesfuly Done the job");
    } else {
      print("Başarısız");
    }
    }
    if(job.giverId==mainUserId){
      var url = API.GiverDoneJobUrl;
      var response = await http.put(Uri.parse(url), body: "{\"job_id\":${job.id}}");

      if (response.statusCode == 200) {
        print("Succesfuly Done the job");
      } else {
        print("Başarısız");
      }
    }
    notifyListeners();
  }


  //POST
  Future PostJob(Job job) async {
    var url = API.JobUrl;
    var response = await http.post(Uri.parse(url), body: jsonEncode(job.toJsonPost()));

    if (response.statusCode == 200) {
      print("Succesfuly posted the job");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }


  Future PostComment(String? comment,int? userfrom_id,int? userto_id, int? job_id,int rating ) async {
    var url = API.CommentUrl;

    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'userfrom_id': userfrom_id,
              'userto_id':userto_id,
              'job_id': job_id,
              'comment': comment,
              'ratio': rating
            }
    ));

    if (response.statusCode == 200) {
      print("Succesfuly posted the comment");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  void generateAcceptedJobOnProfile() {
    List<Job> dummyJobs=jobList;
    List<Job> acceptedJobs = [];
    if(dummyJobs.isNotEmpty){
      for (int i = 0; i < dummyJobs.length; i++) {
        if (dummyJobs[i].accepterId == mainUserId&&dummyJobs[i].isDoneGiver==0&&dummyJobs[i].isDoneAccepter==0) {
          acceptedJobs.add(dummyJobs[i]);
        }
      }
    }
    jobListOnProfile=acceptedJobs;
    notifyListeners();
  }
  void generatePostedJobOnProfile() async {
    List<Job> dummyJobs=jobList;
    List<Job> postedJobs = [];
    if(dummyJobs.isNotEmpty){
      for (int i = 0; i < dummyJobs.length; i++) {
        if (dummyJobs[i].giverId == mainUserId&&dummyJobs[i].isDoneGiver==0&&dummyJobs[i].isDoneAccepter==0) {
          postedJobs.add(dummyJobs[i]);
        }
      }
    }
    jobListOnProfile=postedJobs;

    notifyListeners();
  }

  void generateDoneJobOnProfile() {
    List<Job> dummyJobs=jobList;
    List<Job> doneJobs = [];
    if(dummyJobs.isNotEmpty){
      for (int i = 0; i < dummyJobs.length; i++) {
        if ((dummyJobs[i].accepterId == mainUserId||dummyJobs[i].giverId == mainUserId)&&dummyJobs[i].isDoneGiver==1&&dummyJobs[i].isDoneAccepter==1) {
          doneJobs.add(dummyJobs[i]);
        }
      }
    }
    jobListOnProfile=doneJobs;
    notifyListeners();
  }

  //Get Follower User

  Future getFollowers() async {
    var url = API.followersUrl;
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'user_id':mainUserId
            }
        ));

    print(response.body);

    var jsonData= jsonDecode(response.body);

    for(var eachUser in jsonData){
      FollowUserModal user = FollowUserModal.fromJson(eachUser);
      followerUserList.add(user);
    }

    if (response.statusCode == 200) {
      print("Succesfuly Got the followed user");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }


  //Get followed user
  Future getFollowings() async {
    var url = API.followingsUrl;
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'user_id':mainUserId
            }
        ));
    print(response.body);
    var jsonData= jsonDecode(response.body);
    for(var eachUser in jsonData){
      FollowUserModal user = FollowUserModal.fromJson(eachUser);
      followedUserList.add(user);
    }
    if (response.statusCode == 200) {
      print("Succesfuly Got the followed user");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  //unfollow user
  Future UnfollowUser(int id) async {
    var url = API.UnfollowUrl;
    var response = await http.delete(
        Uri.parse(url),
        body: jsonEncode(
            {
              'user_id':mainUserId,
              'followed_id': id,
            }
        ));
    var jsonData= jsonDecode(response.body);
    for(var eachUser in jsonData){
      FollowUserModal user = FollowUserModal.fromJson(eachUser);
      followedUserList.add(user);
    }
    if (response.statusCode == 200) {
      print("Succesfuly Got the followed user");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  //follow user

  Future followUser(int followed_id) async {
    var url = API.followUrl;
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'follower_id':mainUserId,
              'followed_id':followed_id,
            }
        ));

    if (response.statusCode == 200) {
      print("Succesfuly follow user");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  //get main user rate
  Future getMyRate() async {
    var url = API.getAvgUrl;
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'user_id':mainUserId,
            }
        )
    );

    var jsonData=jsonDecode(response.body);

    if(jsonData.length==0) {
      mainUserRate = 0;
    }
    else{
      double rate = double.parse(jsonData[0]['avg_ratio']);
      mainUserRate=rate;
    }
    if (response.statusCode == 200) {
      print("Succesfuly get ratio");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  bool isFollowedJob(Job job){
    for(FollowUserModal user in followedUserList){
      if(int.parse(user.userId)==job.giverId){
        return true;
      }
    }
    return false;
  }

  //get main user rate
  Future getRecommendedUsers() async {
    var url = API.getRecommendedUsers;
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'user_id':mainUserId,
            }
        )
    );
    var jsonData=jsonDecode(response.body);

    for(var eachUser in jsonData){

      var userId=eachUser['user_id'];
      print(userId);
      double userRatio = await getRateById(int.parse(userId));

      RecommendedUserModal user = await RecommendedUserModal(
        userId: eachUser['user_id'],
        userName: eachUser['user_name'],
        userEmail:eachUser['user_email'],
        userRatio: userRatio,
      );
     if(followedUserList.length!=0) {
       bool isFollowedCheck=false;
       for (var eachUser in followedUserList) {
         if (int.parse(eachUser.userId )== int.parse(user.userId)) {
           isFollowedCheck=true;
         }
       }
       if(!isFollowedCheck){
         recommendedUserOnScreen.add(user);
       }
     }
     else{
       recommendedUserOnScreen.add(user);
     }
    }
    print(recommendedUserOnScreen.length);
    if (response.statusCode == 200) {
      print("Succesfuly get RecommendedUser");
    } else {
      print("Başarısız");
    }
    notifyListeners();
  }

  Future<double> getRateById(int id) async {
    var url = API.getAvgUrl;
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'user_id':id,
            }
        )
    );

    var jsonData=jsonDecode(response.body);


    if (response.statusCode == 200) {
      print("Succesfuly get ratio");
    } else {
      print("Başarısız");
    }


    if(jsonData.length==0){
      return 0;
    }
    else{
      double rate = double.parse(jsonData[0]['avg_ratio']);
      return rate;
    }

  }


}
