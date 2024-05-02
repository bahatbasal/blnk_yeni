class UserCommenter {
  String user_name;
  String user_email;

  UserCommenter(
      this.user_name,
      this.user_email,
      );

  factory UserCommenter.fromJson(Map<String, dynamic> json) => UserCommenter(
    json["user_name"],
    json["user_email"],
  );

  @override
  String toString() {
    return 'UserCommenter{user_name: $user_name, user_email: $user_email}';
  }
}
