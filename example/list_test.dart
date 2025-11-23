import 'package:entao_result/entao_result.dart';
import 'package:println/println.dart';

void main() {
  // String j = """["a","b","c"]""";
  // dynamic v = json.decode(j );
  // Success ok = Success(v);
  // Result r = ok ;
  // println(ok.tryValue());
  // List<String> ls = ok.list();
  // println(ls);

  List<String> strList = ["a", "ab", "abc"];
  Result<List<String>> rs = Success(strList);
  println(rs.tryValue());
  rs.onSuccess((ls) {
    println(ls);
  });
}
