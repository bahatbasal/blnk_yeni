import '../LoginAndSignup/user.dart';
import 'Job.dart';
import 'UserCommenter.dart';

class Comment {
  final UserCommenter userFrom;
  final String job;
  final String comment;

  Comment({
    required this.userFrom,
    required this.job,
    required this.comment,
  });

  Map<String, dynamic> toJson(int job_id, int userfrom_id, int userto_id) {
    return {
      'userfrom_id': userfrom_id,
      'userto_id':userto_id,
      'job_id': job_id,
      'comment': comment,
    };
  }


}
