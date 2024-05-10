class API
{
  static const hostConnect="http://www.blnkjobs.com.tr";
  static const hostConnectUser = "$hostConnect/user";

  //signUp user
  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const signUp = "$hostConnect/user/signup.php";
  static const login = "$hostConnect/user/login.php";

  //Jobs
  static const JobUrl = "$hostConnect/jobs/jobs_crud.php";
  static const DoneJobUrl = "$hostConnect/jobs/jobsMakeDone.php";

  //Comments

  static const CommentUrl= "$hostConnect/my_comments.php?userto_id=";
  static const UserByIdUrl= "$hostConnect/user_by_id.php?user_id=";
  static const JobByIdUrl= "$hostConnect/job_by_id.php?job_id=";

  //Application
  static const recievedApplicationUrl= "$hostConnect/takenapplications.php";
  static const appliedApplicationUrl= "$hostConnect/appliedapplications.php";
  static const createApplicationUrl= "$hostConnect/createapplication.php";
  static const rejectApplicationUrl= "$hostConnect/rejectapplication.php";
  static const acceptApplicationUrl= "$hostConnect/acceptapplication.php";


}