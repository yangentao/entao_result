part of '../entao_result.dart';

extension ResultMapExt on Result {
  Result<V> casted<V>() {
    switch (this) {
      case Success ok:
        if (ok.value is V) return Success(ok.value as V, extra: ok.extra);
        _typeError(V, ok.value);
      case Failure e:
        return e;
    }
  }

  Result<R> map<R, T>(R Function(T) mapper) {
    switch (this) {
      case Failure e:
        return e;
      case Success(value: T v, extra: dynamic ex):
        return Success(mapper(v), extra: ex);
      case Success ok:
        if (null is R && ok.value == null) return Success(null as R, extra: ok.extra);
        _typeError(T, ok.value);
    }
  }

  Result<List<R>> mapList<R, T>(R Function(T) mapper) {
    switch (this) {
      case Failure e:
        return e;
      case Success ok:
        if (ok.value == null) return Success([], extra: ok.extra);
        List<R> ls = ok.listValue(mapper);
        return Success(ls, extra: ok.extra);
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
      Iterable<T> ts = ls.map((e) {
        if (e is T) return e;
        _typeError(T, e);
      });
      return ts.map(itemMaper).toList();
    }
    if (value == null) return [];
    _typeError(T, value);
  }

  R mapValue<R, T>(R Function(T) maper) {
    if (this case Success(value: T v)) {
      return maper(v);
    }
    if (null is R && value == null) return null as R;
    _typeError(T, value);
  }

  R getValue<R>() {
    if (this case Success(value: R v)) {
      return v;
    } else {
      _typeError(R, value);
    }
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

Never _typeError(Type type, dynamic value) {
  throw "Type error. target type: $type, value: $value";
}
