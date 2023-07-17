// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../textbox_widget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextboxWidgetAdapter extends TypeAdapter<TextboxWidget> {
  @override
  final int typeId = 1;

  @override
  TextboxWidget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextboxWidget(
      x: fields[0] as double,
      y: fields[1] as double,
      page: fields[2] as int,
      currString: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TextboxWidget obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.currString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextboxWidgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
