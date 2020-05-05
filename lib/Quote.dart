class Quote{
  String quote, author;
  Quote({this.quote, this.author});

  factory Quote.fromJson(Map<String, dynamic> json){
    return new Quote(
      quote: json['quote'].toString(),
      author: json['author'].toString(),
    );
  }
}