class StudentModel{
  String? idstudent;
  String? code;
  String? name;

  StudentModel({
    this.idstudent,
    this.code,
    this.name,
  });

  factory StudentModel.formJson(Map<String, dynamic> parsedJson){
    try{
      return StudentModel(
        idstudent: parsedJson['_id'],
        code: parsedJson['code_student'],
        name: parsedJson['name'],
      );
    } catch(ex) {
      print('StudentModel ==> $ex');
      throw('factory StudentModel.fromJson ==> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
    '_id': idstudent,
    'code_student': code,
    'name': name,
  };
}