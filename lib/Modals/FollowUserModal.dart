class FollowUserModal {
  final String userId;
  final String userName;
  final String userEmail;

  FollowUserModal({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory FollowUserModal.fromJson(Map<String, dynamic> json) {
    return FollowUserModal(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
    };
  }
}
