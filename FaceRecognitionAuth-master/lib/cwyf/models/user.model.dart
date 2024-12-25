class UserModel{
  String? username;
  String? password;
  String? name;

  UserModel({
    this.username,
    this.password,
    this.name,
  });

  factory UserModel.formJson(Map<String, dynamic> parsedJson){
    try{
      return UserModel(
        username: parsedJson['username'],
        password: parsedJson['password'],
        name: parsedJson['name'],
      );
    } catch(ex) {
      print('UserModel ==> $ex');
      throw('factory UserModel.fromJson ==> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'name': name,
  };
}