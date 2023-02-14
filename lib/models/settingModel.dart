class Setting {
  int _id;
  String _urlservice;
  String _username;
  String _password;
  String _acaccount;
  String _acpass;
  String _pattern;
  String _serial;

  Setting(this._urlservice, this._username, this._password, this._acaccount, this._acpass, this._pattern, this._serial);
  Setting.WithId(this._id,this._urlservice, this._username, this._password, this._acaccount, this._acpass, this._pattern, this._serial);

  String get serial => _serial;

  String get pattern => _pattern;

  String get acpass => _acpass;

  String get acaccount => _acaccount;

  String get password => _password;

  String get username => _username;

  String get urlservice => _urlservice;

  int get id => _id;

  set serial(String value) {
    if(value.length <= 255){
      this._serial = value;
    }
  }

  set pattern(String value) {
    if(value.length <= 255){
      this._pattern = value;
    }
  }

  set acpass(String value) {
    if(value.length <= 255){
      this._acpass = value;
    }
  }

  set acaccount(String value) {

    if(value.length <= 255){
      this._acaccount = value;
    }
  }

  set password(String value) {
    if(value.length <= 255){
      this._password = value;
    }

  }

  set username(String value) {

    if(value.length <= 255){
      this._username = value;
    }
  }

  set urlservice(String value) {

    if(value.length <= 255){
      this._urlservice = value;
    }
  }

  set id(int value) {
    this._id = value;
  }


  Map<String,dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(_id != null){
      map['id'] = _id;
    }
    map['url_service'] = _urlservice;
    map['username'] = _username;
    map['password'] = _password;
    map['acaccount'] = _acaccount;
    map['acpass'] = _acpass;
    map['pattern'] = _pattern;
    map['serial'] = _serial;
    return map;
  }

  Setting.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._urlservice = map['url_service'];
    this._username = map['username'];
    this._password = map['password'];
    this._acaccount = map['acaccount'];
    this._acpass = map['acpass'];
    this._pattern = map['pattern'];
    this._serial = map['serial'];
  }
}