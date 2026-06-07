import 'package:hive/hive.dart';

part 'coordinate_model.g.dart';

@HiveType(typeId: 1)
class CoordinateModel extends HiveObject {
  CoordinateModel({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
  });

  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final double? altitude;

  @HiveField(3)
  final double? accuracy;
}
