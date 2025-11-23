part of '../entao_result.dart';

extension ResultMapExt on Result {
  Result<R> map<R, T>(R Function(T) mapper) {
    switch (this) {
      case Failure e:
        return e;
      case Success(value: T v, extra: dynamic ex):
        return Success(mapper(v), extra: ex);
      case Success<dynamic>(value: null):
        throw "Value is null";
      case Success<dynamic>(value: Object v):
        throw "type does not match: $v";
    }
  }

  Result<List<R>> mapList<R, T>(R Function(T) mapper, {bool nullToEmpty = true}) {
    switch (this) {
      case Failure e:
        return e;
      case Success(value: List<dynamic> v, extra: dynamic ex):
        List<R> ls = v.map((a) => a as T).map(mapper).toList();
        return Success(ls, extra: ex);
      case Success<dynamic>(value: Object v):
        throw "Type does not match: $v";
      case Success<dynamic>(value: null):
        if (nullToEmpty) return Success([]);
        throw "Value is null";
    }
  }
}

extension SuccessTransformEx on Success {
  /// ["id", "name", "score"]
  /// [1000, "Tom", 90]
  /// [1001, "Jerry", 80]
  /// like csv format, first line is column names , rest is data
  List<T> table<T>(T Function(Map<String, dynamic>) itemMaper) {
    List<List<dynamic>> rows = list();
    return _dataTableFromList(rows: rows, maper: itemMaper);
  }

  R model<R>(R Function(Map<String, dynamic>) mapper) {
    return mapValue(mapper);
  }

  List<R> listModel<R>(R Function(Map<String, dynamic>) itemMaper) {
    return listValue(itemMaper);
  }

  List<R> list<R>() {
    return listValue((R e) => e);
  }

  List<R> listValue<R, T>(R Function(T) itemMaper) {
    if (this case Success(value: List<dynamic> ls)) {
      Iterable<T> ts = ls.map((e) => e as T);
      return ts.map(itemMaper).toList();
    }
    throw "Bad type";
  }

  R mapValue<R, T>(R Function(T) maper) {
    if (this case Success(value: T v)) {
      return maper(v);
    }
    throw "Bad type";
  }

  R getValue<R>() {
    if (this case Success(value: R v)) {
      return v;
    }
    throw "Bad type";
  }
}

extension SuccessExtraEx on Success {
  R? extraValue<R>({int? index, String? key}) {
    if (key != null) {
      if (this case Success(extra: Map<String, dynamic> map)) {
        return map[key];
      }
      return null;
    }
    if (index != null) {
      if (this case Success(extra: List<dynamic> ls)) {
        return index >= 0 && index < ls.length ? ls[index] : null;
      }
      return null;
    }
    if (this case Success(extra: R v)) {
      return v;
    }
    return null;
  }

  R? extraTransform<R, T>(R? Function(T) callback, {int? index, String? key}) {
    if (key != null) {
      if (this case Success(extra: Map<String, dynamic> map)) {
        if (map[key] case T vv) {
          return callback(vv);
        }
      }
      return null;
    }
    if (index != null) {
      if (this case Success(extra: List<dynamic> ls)) {
        if (index >= 0 && index < ls.length) {
          if (ls[index] case T v) {
            return callback(v);
          }
        }
      }
      return null;
    }
    if (this case Success(extra: T v)) {
      return callback(v);
    }
    return null;
  }
}

//  ["id", "name", "score"]
//  [1000, "Tom", 90]
//  [1001, "Jerry", 80]
/// 第一行是列名, 第二行开始是数据, 类似csv格式
List<T> _dataTableFromList<T>({required List<List<dynamic>> rows, required T Function(Map<String, dynamic>) maper}) {
  if (rows.length <= 1) return [];
  List<String> rowKey = rows.first.map((e) => e as String).toList();
  List<T> models = [];
  for (int i = 1; i < rows.length; ++i) {
    Map<String, dynamic> map = {};
    List<dynamic> row = rows[i];
    for (int c = 0; c < rowKey.length; ++c) {
      map[rowKey[c]] = row[c];
    }
    models.add(maper(map));
  }
  return models;
}
