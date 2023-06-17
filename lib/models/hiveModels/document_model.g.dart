// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../document_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 0;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.docTitle)
      ..writeByte(1)
      ..write(obj.docPath)
      ..writeByte(2)
      ..write(obj.docDate)
      ..writeByte(3)
      ..write(obj.lastOpened)
      ..writeByte(4)
      ..write(obj.favourited);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}