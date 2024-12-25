class CheckNameModel{
  String? idcheckname;
  String? date;
  int? status;

  CheckNameModel({
    this.idcheckname,
    this.date,
    this.status,
  });

  factory CheckNameModel.formJson(Map<String, dynamic> parsedJson){
    try{
      return CheckNameModel(
        idcheckname: parsedJson['_id'],
        date: parsedJson['date_check'],
        status: parsedJson['status'],
      );
    } catch(ex) {
      print('CheckNameModel ==> $ex');
      throw('factory CheckNameModel.fromJson ==> $ex');
    }
  }

  Map<String, dynamic> toJson() => {
    '_id': idcheckname,
    'date_check': date,
    'status': status,
  };
}