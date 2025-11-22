import 'package:entao_result/entao_result.dart';
import 'package:test/test.dart';

void main() {
  test('First Test', () {
    Success<int> r = Success(9);
    expect(r.value, equals(9));
  });
}
