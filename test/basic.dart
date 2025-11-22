import 'package:entao_result/entao_result.dart';
import 'package:test/test.dart';

void main() {
  test('First Test', () {
    Success<int> r = Success(9);
    expect(r.value, equals(9));

    Success r2 = r;
    int v = r2.getValue();
    expect(v, equals(9));
  });
}
