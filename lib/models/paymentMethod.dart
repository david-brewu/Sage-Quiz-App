class PaymentMethod{
  String _id;
  String _type;
  String _number;
  DateTime _date;
  String _provider;
  //final PaymentType _paymentType;

  PaymentMethod(this._id, this._type, this._number, this._date, this._provider);

  String get type => _type;
  String get number => _number;
  DateTime get date => _date;
  String get provider => _provider;

  set type(String newType){
    this._type = newType;
  }
  set number(String newNumber){
    this._number = newNumber;
  }
  set date(DateTime newDate){
    this._date = newDate;
  }
  set provider(String newProvider){
    this._provider = newProvider;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map<String, dynamic>();
    if(_id != null) {
      map["id"] = _id;
    }
      map["type"] = _type;
      map["date"] = _date;
      map["provider"] = _provider;

    return map;
  }
  PaymentMethod.fromMap(Map<String, dynamic> map){
    this._id =  map["id"];
    this._provider = map["provider"];
    this._date = map["date"];
    this._type = map["type"];
    this._number = map["number"];
  }
}