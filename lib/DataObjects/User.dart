import 'package:hive/hive.dart';

part 'User.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phoneNumber;

  final String? firebaseToken;

  User(this.name, this.phoneNumber, {this.firebaseToken});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => name.hashCode ^ phoneNumber.hashCode;
}
