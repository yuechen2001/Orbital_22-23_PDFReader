import 'package:hive/hive.dart';

part 'hiveModels/document_model.g.dart';

@HiveType(typeId: 0)
class Document extends HiveObject {
  @HiveField(0)
  String docTitle;
  @HiveField(1)
  String docPath;
  @HiveField(2)
  String docDate;
  @HiveField(3)
  DateTime lastOpened;
  @HiveField(4)
  bool favourited;
  @HiveField(5)
  List<List<dynamic>> annotations;
  @HiveField(6)
  List<String> folders;
  @HiveField(7)
  int lastPageOpened;

  Document({
    required this.docTitle,
    required this.docPath,
    required this.docDate,
    required this.lastOpened,
    required this.favourited,
    required this.annotations,
    required this.folders,
    required this.lastPageOpened,
  });

  // check whether two documents are equal to each other
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Document && docPath == other.docPath);

  // returns the hashcode of a document
  @override
  int get hashCode => docPath.hashCode;
}
