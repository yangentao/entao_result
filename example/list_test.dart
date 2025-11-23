import 'package:entao_result/entao_result.dart';
import 'package:println/println.dart';

void main() {
  dump(Success([A()]));
  dump(Success([B()]));
  dump(Success([C()]));
}

void dump(Success ok) {
  if (ok case Success(value: List<dynamic> ls)) {
    println("listDynamic: ", ls);
  }

  if (ok case Success(value: List<A> ls)) {
    println("listA: ", ls);
  }

  if (ok case Success(value: List<B> ls)) {
    println("listB: ", ls);
  }
  if (ok case Success(value: List<C> ls)) {
    println("listC: ", ls);
  }
  println("--------");
}

class A {
  @override
  String toString() {
    return "A";
  }
}

class B extends A {
  @override
  String toString() {
    return "B";
  }
}

class C extends A {
  @override
  String toString() {
    return "C";
  }
}
