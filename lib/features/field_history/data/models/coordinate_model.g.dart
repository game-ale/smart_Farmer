// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoordinateModelAdapter extends TypeAdapter<CoordinateModel> {
  @override
  final int typeId = 1;

  @override
  CoordinateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoordinateModel(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      altitude: fields[2] as double?,
      accuracy: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, CoordinateModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.altitude)
      ..writeByte(3)
      ..write(obj.accuracy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
