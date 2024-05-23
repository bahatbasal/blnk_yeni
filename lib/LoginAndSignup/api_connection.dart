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
  static const AccepterDoneJobUrl = "$hostConnect/jobs/jobsMakeDoneAccepter.php";
  static const GiverDoneJobUrl = "$hostConnect/jobs/jobsMakeDoneGiver.php";

  //Comments
  static const CommentUrl= "$hostConnect/my_comments.php?userto_id=";
  static const UserByIdUrl= "$hostConnect/user_by_id.php?user_id=";
  static const JobByIdUrl= "$hostConnect/job_by_id.php?job_id=";
  static const getAvgUrl= "$hostConnect/getAvgRate.php";

  //Application
  static const recievedApplicationUrl= "$hostConnect/takenapplications.php";
  static const appliedApplicationUrl= "$hostConnect/appliedapplications.php";
  static const createApplicationUrl= "$hostConnect/createapplication.php";
  static const rejectApplicationUrl= "$hostConnect/rejectapplication.php";
  static const acceptApplicationUrl= "$hostConnect/acceptapplication.php";

  //Follow
  static const followingsUrl= "$hostConnect/follow/followings.php";
  static const followersUrl= "$hostConnect/follow/getFollowers.php";
  static const UnfollowUrl= "$hostConnect/follow/unfollow.php";
  static const followUrl= "$hostConnect/follow/toFollow.php";
  static const getRecommendedUsers= "$hostConnect/follow/reccomendeduser.php";


}