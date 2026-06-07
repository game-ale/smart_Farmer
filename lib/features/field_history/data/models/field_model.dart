import 'package:hive/hive.dart';
import 'package:smart_gps_area/features/field_history/data/models/coordinate_model.dart';

part 'field_model.g.dart';

@HiveType(typeId: 0)
class FieldModel extends HiveObject {
  FieldModel({
    required this.id,
    required this.name,
    required this.areaSqMeters,
    required this.perimeterMeters,
    required this.points,
    required this.createdAt,
    this.isDeleted = false,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double areaSqMeters;

  @HiveField(3)
  final double perimeterMeters;

  @HiveField(4)
  final List<CoordinateModel> points;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  bool isDeleted;
}
