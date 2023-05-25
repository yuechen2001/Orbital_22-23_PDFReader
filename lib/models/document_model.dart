class Document {
  String? doc_title;
  String? doc_url;
  String? doc_date;
  int? page_num;

  Document(this.doc_title, this.doc_url, this.doc_date, this.page_num);

  static List<Document> doc_list = [
    Document(
        "Crime and Punishment",
        "http://giove.isti.cnr.it/demo/eread/Libri/angry/Crime.pdf",
        "25-05-2023",
        42),
    Document(
        "Pain and Suffering",
        "https://www.math.pku.edu.cn/teachers/anjp/textbook.pdf",
        "25-05-2023",
        42),
    Document(
        "Cool Book",
        "https://dl.ebooksworld.ir/books/Introduction.to.Algorithms.4th.Leiserson.Stein.Rivest.Cormen.MIT.Press.9780262046305.EBooksWorld.ir.pdf",
        "25-05-2023",
        42),
  ];
}
