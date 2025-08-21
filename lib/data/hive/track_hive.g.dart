// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackHiveAdapter extends TypeAdapter<TrackHive> {
  @override
  final int typeId = 0;

  @override
  TrackHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackHive(
      name: fields[0] as String,
      artist: fields[1] as String,
      imageUrl: fields[2] as String,
      linkUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrackHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.linkUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
