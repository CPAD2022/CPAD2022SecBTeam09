import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class AppUser extends Equatable {
  const AppUser({
    @required this.email,
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.imagePath,
  });

  @HiveField(0)
  final String email;

  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String dateOfBirth;

  @HiveField(4)
  final String gender;

  @HiveField(5)
  final String imagePath;

  static const empty = AppUser(
    email: '',
    id: '',
    firstName: '',
    lastName: '',
    dateOfBirth: '',
    gender: '',
    imagePath: '',
  );

  @override
  List<Object> get props =>
      [email, id, firstName, lastName, dateOfBirth, gender, imagePath];
}
