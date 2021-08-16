class DataModel {
  String? name;
  String? price;
  String? image;

  DataModel({this.name, this.price, this.image});

  DataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    return data;
  }
}
