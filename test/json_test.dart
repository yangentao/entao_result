import 'dart:convert';

import 'package:entao_result/entao_result.dart';
import 'package:println/println.dart';
import 'package:test/test.dart';

void main() {
  test('value', () async {
    dynamic jv = json.decode("12");
    Result r = Success(jv);
    println(r.tryValue());
    expect(r.tryValue(), equals(12));
  });

  test('transform', () async {
    dynamic jv = json.decode("223");
    Success ok = Success(jv);
    String s = ok.mapValue((int n) => n.toString());
    println(s);
    expect(s, equals("223"));

    Result r = Success(jv);
    Result<String> rs = r.map((e) => e.toString());
    println(rs.tryValue());
    expect(rs.tryValue(), equals("223"));
  });

  test('list', () async {
    dynamic jv = json.decode("[1,2,3]");
    Result r = Success(jv);
    Result<List<int>> nr = r.mapList((e) => e as int);
    println(nr.tryValue());
    expect(nr.tryValue(), equals([1, 2, 3]));

    if (r case Success ok) {
      List<int> ls = ok.list();
      println(ls);
      expect(ls, equals([1, 2, 3]));
      List<String> sls = ok.listValue((e) => e.toString());
      println(sls);
      expect(sls, equals(["1", "2", "3"]));

      List<int> vls = ok.listValue((int e) => e * e);
      println(vls);
      expect(vls, equals([1, 4, 9]));
    }
  });

  test('model', () async {
    String jstr = """{"id": 9, "name": "entao"}""";
    dynamic jv = json.decode(jstr);
    Success r = Success(jv);
    Person p = r.model(Person.new);
    println(p);
    expect(p.id, equals(9));
    expect(p.name, equals("entao"));
  });

  test('listModel', () async {
    String jstr = """[
      {"id": 9, "name": "entao"},
      {"id": 10, "name": "yang"}
    ]""";
    dynamic jv = json.decode(jstr);
    Success r = Success(jv);
    List<Person> ps = r.listModel(Person.new);
    println(ps);
    expect(ps[0].id, equals(9));
    expect(ps[0].name, equals("entao"));
    expect(ps[1].id, equals(10));
    expect(ps[1].name, equals("yang"));
  });

  test('table', () async {
    String jstr = """[
      ["id", "name"],
      [9, "entao"],
      [10, "yang"]
    ]""";
    dynamic jv = json.decode(jstr);
    Success r = Success(jv);

    List<Person> ps = r.table(Person.new);
    println(ps);
    expect(ps[0].id, equals(9));
    expect(ps[0].name, equals("entao"));
    expect(ps[1].id, equals(10));
    expect(ps[1].name, equals("yang"));
  });
}

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
