part of '../entao_result.dart';

extension SuccessTransformEx on Success {
  /// ["id", "name", "score"]
  /// [1000, "Tom", 90]
  /// [1001, "Jerry", 80]
  /// like csv format, first line is column names , rest is data
  List<T> table<T>(T Function(Map<String, dynamic>) maper) {
    return transform((List<List<dynamic>> rows) {
      return _dataTableFromList(rows: rows, maper: maper);
    });
  }

  R model<R>(R Function(Map<String, dynamic>) mapper) {
    return transform(mapper);
  }

  List<R> listModel<R>(R Function(Map<String, dynamic>) mapper) {
    return transform((List<Map<String, dynamic>> ls) {
      return ls.map(mapper).toList();
    });
  }

  List<R> listValue<R, T>(R Function(T) mapper) {
    return transform((List<T> ls) {
      return ls.map(mapper).toList();
    });
  }

  List<R> list<R>() {
    return transform((List<R> ls) => ls);
  }

  R transform<R, T>(R Function(T) maper) {
    if (this case Success(value: T v)) {
      return maper(v);
    }
    throw Exception("Bad type");
  }

  R getValue<R>() {
    if (this case Success(value: R v)) {
      return v;
    }
    throw Exception("Bad type");
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
