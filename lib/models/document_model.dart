class Document {
  String? doc_title;
  String? doc_path;
  String? doc_date;

  Document(this.doc_title, this.doc_path, this.doc_date);

  static List<Document> docList = [];

  // method that updates the doclist
  static void update(Document document) {
    Document.docList.insert(0, document);
  }
}
