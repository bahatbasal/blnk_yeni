
class Job{

  late int? id;
  String name;
  String body;
  int giverId;
  late int? accepterId;
  late int? isDone;

  Job({required this.name,this.id,this.accepterId,required this.giverId, required this.body,this.isDone});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['job_id'],
      name: json['job_name'],
      body:json['job_body'],
      giverId: json['giver_id'],
      accepterId: json['excepter_id'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJsonPost() {
    return {
      'job_name': this.name,
      'job_body': this.body,
      'giver_id': giverId.toString(),
    };
  }

  Map<String, dynamic> toJsonPut() {
    return {
      'job_id': id.toString(),
      'excepter_id': accepterId.toString(),
    };
  }
  String toString(){
    String str="name:"+this.name+"body:"+this.body;
        return str;
  }
}