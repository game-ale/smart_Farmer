import 'package:equatable/equatable.dart';
import 'package:smart_gps_area/core/gis/coordinate.dart';

class FieldEntity extends Equatable {
  const FieldEntity({
    required this.id,
    required this.name,
    required this.areaSqMeters,
    required this.perimeterMeters,
    required this.points,
    required this.createdAt,
  });

  final String id;
  final String name;
  final double areaSqMeters;
  final double perimeterMeters;
  final List<Coordinate> points;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    name,
    areaSqMeters,
    perimeterMeters,
    points,
    createdAt,
  ];
}
