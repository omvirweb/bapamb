class dataModel {
  final String token;

  dataModel({required this.token});

  factory dataModel.fromJson(Map<String, dynamic> json) {
    return dataModel(
      token: json['token'],
    );
  }
}
