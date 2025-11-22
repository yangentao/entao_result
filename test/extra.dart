import 'package:entao_result/entao_result.dart';
import 'package:println/println.dart';
import 'package:test/test.dart';

void main() {
  test('extraValue1', () async {
    Success r = Success(1, extra: 9);
    int e = r.extraValue();
    println(e);
    expect(e, equals(9));
  });
  test('extraValue-List', () async {
    Success r = Success(1, extra: [1, 2]);
    int e = r.extraValue(index: 1);
    println(e);
    expect(e, equals(2));
  });
  test('extraValue-Map', () async {
    Success r = Success(1, extra: {"offset": 100, "total": 200});
    int e = r.extraValue(key: "offset");
    println(e);
    expect(e, equals(100));
  });

  test('extraValue-transform', () async {
    Success r = Success(1, extra: {"Content-Length": "100"});
    int? e = r.extraTransform((String s) {
      return int.tryParse(s);
    }, key: "Content-Length");
    println(e);
    expect(e, equals(100));
  });
}
