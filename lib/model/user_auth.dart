class UserAuth {
  String username;
  String password;
  String token;

  UserAuth({this.username, this.password, this.token});

  UserAuth.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}
