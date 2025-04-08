class User {
  final String userSunetId;
  final String userFirstName;
  final String userLastName;
  int? userId;
  String? userEmail;
  String? userStatus;
  String? jobId;
  String? jobTime;

  User(this.userSunetId, this.userFirstName, this.userLastName);

  User.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        userSunetId = json['user_sunet_id'],
        userFirstName = json['user_first_name'],
        userLastName = json['user_last_name'],
        userEmail = json['user_email'],
        userStatus = json['user_status'],
        jobId = json['job_id'],
        jobTime = json['job_time'];

  Map<String, dynamic> toJson() => {
        'user_sunet_id': userSunetId,
        'user_first_name': userFirstName,
        'user_last_name': userLastName,
      };
}
