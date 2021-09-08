import 'package:hive/hive.dart';

part 'User.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phoneNumber;

  User(this.name, this.phoneNumber);

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
