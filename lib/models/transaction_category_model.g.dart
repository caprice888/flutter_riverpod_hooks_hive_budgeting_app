// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionCategoryModelAdapter
    extends TypeAdapter<TransactionCategoryModel> {
  @override
  final int typeId = 0;

  @override
  TransactionCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionCategoryModel(
      name: fields[0] as String,
      colour: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionCategoryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.colour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
