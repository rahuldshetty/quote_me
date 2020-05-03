class Quote{
  String quote, author;

  Quote({this.quote, this.author});

  String getQuote(){
    return quote;
  }

  String getAuthor(){
    return author;
  }

  factory Quote.fromJson(Map<String, dynamic> json){
    return new Quote(
      quote: json['quote'].toString(),
      author: json['author'].toString()
    );
  }
}