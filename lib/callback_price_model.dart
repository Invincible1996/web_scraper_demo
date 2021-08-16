class CallbackPriceModel {
  String? p;
  String? op;
  String? cbf;
  String? id;
  String? m;

  CallbackPriceModel({this.p, this.op, this.cbf, this.id, this.m});

  CallbackPriceModel.fromJson(Map<String, dynamic> json) {
    p = json['p'];
    op = json['op'];
    cbf = json['cbf'];
    id = json['id'];
    m = json['m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p'] = this.p;
    data['op'] = this.op;
    data['cbf'] = this.cbf;
    data['id'] = this.id;
    data['m'] = this.m;
    return data;
  }
}
