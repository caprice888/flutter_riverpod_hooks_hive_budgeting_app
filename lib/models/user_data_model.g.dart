// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataModelAdapter extends TypeAdapter<UserDataModel> {
  @override
  final int typeId = 1;

  @override
  UserDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataModel(
      transactions: (fields[0] as List).cast<TransactionModel>(),
      dateJoined: fields[1] as DateTime,
      username: fields[2] as String,
      savedCategoryTags: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.transactions)
      ..writeByte(1)
      ..write(obj.dateJoined)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.savedCategoryTags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
