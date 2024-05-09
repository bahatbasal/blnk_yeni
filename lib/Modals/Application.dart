class Application {
  String applicationId;
  String userName;
  String jobName;
  double price;
  late int? statue;

  Application({
    required this.applicationId,
    required this.userName,
    required this.jobName,
    required this.price,
    this.statue
  });
//factory mapi alır objeye çeviren bir fabrika
  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['application_id'],
      userName: json['user_name'],
      jobName: json['job_name'],
      price: double.parse(json['price']),
    );
  }
  factory Application.fromJsonWithStatue(Map<String, dynamic> json) {
    return Application(
      applicationId: json['application_id'],
      userName: json['user_name'],
      jobName: json['job_name'],
      price: double.parse(json['price']),
      statue: int.parse(json['price']),
    );
  }


//bu da tojSoN FACTORYNİN TERSİNİ YAPIYOR
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['application_id'] = this.applicationId;
    data['user_name'] = this.userName;
    data['job_name'] = this.jobName;
    data['price'] = this.price.toString();
    return data;
  }
  Map<String, dynamic> toJsonWithStatue() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['application_id'] = this.applicationId;
    data['user_name'] = this.userName;
    data['job_name'] = this.jobName;
    data['price'] = this.price.toString();
    data['statue'] = this.statue.toString();
    return data;
  }
}