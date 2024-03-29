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
      docTitle: fields[0] as String,
      docPath: fields[1] as String,
      docDate: fields[2] as String,
      lastOpened: fields[3] as DateTime,
      favourited: fields[4] as bool,
      annotations: (fields[5] as List)
          .map((dynamic e) => (e as List).cast<dynamic>())
          .toList(),
      folders: (fields[6] as List).cast<String>(),
      lastPageOpened: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.docTitle)
      ..writeByte(1)
      ..write(obj.docPath)
      ..writeByte(2)
      ..write(obj.docDate)
      ..writeByte(3)
      ..write(obj.lastOpened)
      ..writeByte(4)
      ..write(obj.favourited)
      ..writeByte(5)
      ..write(obj.annotations)
      ..writeByte(6)
      ..write(obj.folders)
      ..writeByte(7)
      ..write(obj.lastPageOpened);
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
