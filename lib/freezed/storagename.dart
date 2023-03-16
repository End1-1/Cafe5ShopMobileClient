import 'package:freezed_annotation/freezed_annotation.dart';

part 'storagename.freezed.dart';

part 'storagename.g.dart';

@freezed
class StorageItem with _$StorageItem {
  const factory StorageItem(
      {required String groupname,
      required String name,
      required double qty}) = _StorageItem;

  factory StorageItem.fromJson(Map<String, dynamic> json) =>
      _$StorageItemFromJson(json);
}

@freezed
class StorageItems with _$StorageItems {
  const factory StorageItems({required List<StorageItem> items}) =
      _StorageItems;

  factory StorageItems.fromJson(Map<String, dynamic> json) =>
      _$StorageItemsFromJson(json);
}

@freezed
class StorageName with _$StorageName {
  const factory StorageName({required int id, required String name}) =
      _StorageName;

  factory StorageName.fromJson(Map<String, dynamic> json) =>
      _$StorageNameFromJson(json);
}

@freezed
class StorageNames with _$StorageNames {
  const factory StorageNames({required List<StorageName> storages}) =
      _StorageNames;

  factory StorageNames.fromJson(Map<String, dynamic> json) =>
      _$StorageNamesFromJson(json);
}
