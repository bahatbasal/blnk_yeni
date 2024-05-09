import 'dart:convert';
import 'package:blnk_yeni/LoginAndSignup/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'LoginAndSignup/api_connection.dart';
import 'Modals/Job.dart';
import 'Modals/Comment.dart';
import 'Modals/UserCommenter.dart';
import 'Modals/Application.dart';

class ApiService extends ChangeNotifier {

  late int mainUserId;
  late String mainUserName;
  late String mainUserMail;

  int selectedCategory=0;
  int selectedCategoryonApplication=0;

  int selectedCategoryOnProfile=0;

  List<Job> jobList = [];
  List<Comment> myComments = [];

  List<Job> jobListOnScreen=[];

  List<Job> jobListOnProfile=[];

  List<Application> appliactionListOnPage=[];

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
        isDone:int.parse(eachJob['isDone'])
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

    print(receivedapplicationlist.length);
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
    var url = API.DoneJobUrl;
    var response = await http.put(Uri.parse(url), body: "{\"job_id\":${job.id}}");

    if (response.statusCode == 200) {
      print("Succesfuly Done the job");
    } else {
      print("Başarısız");
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

/*DEMET POST

Future PostApplicant(Applicant applicant) async{

   var url= API.Applicant.JobUrl;
   var response = await http.post(Uri.parse(url), body: jsonEncode(applicant.toJsonPost()));

  if (response.statusCode == 200) {
      print("Succesfuly applicant the job!");
    } else {
      print("You cannot applicant the job!");
    }
    notifyListeners();
  }


 */



  Future PostComment(String? comment,int? userfrom_id,int? userto_id, int? job_id, ) async {
    var url = API.CommentUrl;
    print(jsonEncode(
        {
          'userfrom_id': userfrom_id,
          'userto_id':userto_id,
          'job_id': job_id,
          'comment': comment,
        }
    ));
    var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
            {
              'userfrom_id': userfrom_id,
              'userto_id':userto_id,
              'job_id': job_id,
              'comment': comment,
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
        if (dummyJobs[i].accepterId == mainUserId&&dummyJobs[i].isDone==0) {
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
        if (dummyJobs[i].giverId == mainUserId&&dummyJobs[i].isDone==0) {
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
        if ((dummyJobs[i].accepterId == mainUserId||dummyJobs[i].giverId == mainUserId)&&dummyJobs[i].isDone==1) {
          doneJobs.add(dummyJobs[i]);
        }
      }
    }
    jobListOnProfile=doneJobs;
    notifyListeners();
  }

}
