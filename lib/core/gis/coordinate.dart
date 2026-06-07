import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  const Coordinate({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final int? timestamp;

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    altitude,
    accuracy,
    timestamp,
  ];
}
