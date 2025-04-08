import './user.dart';

class UserMembership {
  final User user;
  final String piSunetId;

  UserMembership(this.user, this.piSunetId);

  UserMembership.fromJson(Map<String, dynamic> json)
      : user = json['user'],
        piSunetId = json['pi_sunet_id'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'pi_sunet_id': piSunetId,
      };
}
