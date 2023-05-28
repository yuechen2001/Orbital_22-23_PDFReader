// ignore_for_file: non_constant_identifier_names

class Document {
  String? doc_title;
  String? doc_path;
  String? doc_date;

  Document(this.doc_title, this.doc_path, this.doc_date);

  static List<Document> docList = [];
  // static Map<Document, int> docSet = HashMap();

  // todo: find faster way to do this
  // method that updates the doclist
  static void update(Document document) {
    // case where inside the doclist already => remove the old entry
    if (docList.contains(document)) {
      docList.remove(document);
    }
    Document.docList.insert(0, document);
  }

  // check whether two documents are equal to each other
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document && doc_path == other.doc_path);

  // returns the hashcode of a document
  @override
  int get hashCode => doc_path.hashCode;
}
