## Features
Result, success, failure.  mostly used for json.
 
## Basic
```dart  
void main() {
  Success<int> intResult = Success(9);
  print(intResult.value);

  Success r2 = intResult;
  int v = r2.getValue();

  Result r = Success("Hello", extra: {"offset": 9});
  if (r case Success(value: String v, extra: {"offset": int offset})) {
    print("value: $v, offset: $offset ");
  }
  if (r case Failure e) {
    print("error: $e ");
  }
}
``` 

## Transform value
```dart  
test('transform', () async {
  Success r = Success(223);
  String s = r.transform((int n) => n.toString());
  println(s);
  expect(s, equals("223"));
});
```

## List

```dart  
test('list', () async {
  Success r = Success([1, 2, 3]);
  List<int> ls = r.list();
  println(ls);
  expect(ls, equals([1, 2, 3]));
});
```
## List And Transform
```dart  
test('listValue', () async {
  Success r = Success([4, 5, 6]);
  List<String> ls = r.listValue((int n) => n.toString());
  println(ls);
  expect(ls, equals(["4", "5", "6"]));
});
```
## Model
* define a model  
```dart 
class Person {
  Map<String, dynamic> model;
  Person(this.model);

  int get id => model["id"];
  String get name => model["name"];
  @override
  String toString() {
    return model.toString();
  }
}

```
* mapt to model
```dart  
test('model', () async {
  Success r = Success({"id": 9, "name": "entao"});
  Person p = r.model(Person.new);
  println(p);
  expect(p.id, equals(9));
  expect(p.name, equals("entao"));
});
```
* mapt to model list
```dart  
test('listModel', () async {
  Success r = Success([
    {"id": 9, "name": "entao"},
    {"id": 10, "name": "yang"}
  ]);
  List<Person> ps = r.listModel(Person.new);
  println(ps);
  expect(ps[0].id, equals(9));
  expect(ps[0].name, equals("entao"));
  expect(ps[1].id, equals(10));
  expect(ps[1].name, equals("yang"));
});
```

## Table
like 'csv' format , first row is column names , rest is column data.  
```dart  
  test('table', () async {
    Success r = Success([
      ["id", "name"],
      [9, "entao"],
      [10, "yang"],
    ]);
    List<Person> ps = r.table(Person.new);
    println(ps);
    expect(ps[0].id, equals(9));
    expect(ps[0].name, equals("entao"));
    expect(ps[1].id, equals(10));
    expect(ps[1].name, equals("yang"));
  });
```


