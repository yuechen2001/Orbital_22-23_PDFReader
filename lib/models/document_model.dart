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

  Document(this.docTitle, this.docPath, this.docDate, this.lastOpened, this.favourited);

  // check whether two documents are equal to each other
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Document && docPath == other.docPath);

  // returns the hashcode of a document
  @override
  int get hashCode => docPath.hashCode;
}
