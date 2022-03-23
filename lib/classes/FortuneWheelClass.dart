class FortuneData{
  String name;
  List<String> data;

  FortuneData(this.name, this.data);

  Map toJson() => {
    'name': name,
    'data': data,
  };
}