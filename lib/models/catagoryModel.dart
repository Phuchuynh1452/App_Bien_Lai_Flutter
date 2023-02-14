class Category {
 int _id;
 String _title;
 double _price;
 Category(this._title, this._price);
 Category.WithId(this._id, this._title, this._price);

 double get price => _price;

 String get title => _title;

 int get id => _id;

 set title(String value) {
  if(value.length <= 255){
   this._title = value;
  }
 }

 set id(int value) {
  this._id = value;
 }

 set price(double value) {
  if(value >= 0){
   this._price = value;
  }
 }

 Map<String,dynamic> toMap() {
  var map = Map<String, dynamic>();
  if(_id != null){
   map['id'] = _id;
  }
  map['title'] = _title;
  map['price'] = _price;
  return map;
 }

 Category.fromMapObject(Map<String, dynamic> map) {
  this._id = map['id'];
  this._title = map['title'];
  this._price = map['price'];
 }
}