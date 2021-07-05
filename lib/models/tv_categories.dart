class tvCategories {
  List<Records> records;

  tvCategories({this.records});

  tvCategories.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<Records>();
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String id;
  String name;
  String description;

  Records({this.id, this.name, this.description});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
