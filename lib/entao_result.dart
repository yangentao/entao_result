library;

/// if (result case Success(value: String v)) {
///   println("value ", v);
/// }
sealed class Result<T> {
  bool get success => this is Success;

  bool get failed => this is Failure;

  R? onValue<V, R>(R? Function(V) callback) {
    if (this case Success(value: V v)) {
      return callback(v);
    }
    return null;
  }

  R? onFailed<R>(R? Function(Failure) callback) {
    if (this case Failure e) {
      return callback(e);
    }
    return null;
  }
}

class Success<T> extends Result<T> {
  final T value;
  final dynamic extra;

  Success(this.value, {this.extra});

  @override
  String toString() {
    return "Success(value:$value, extra:$extra)";
  }
}

class Failure extends Result<Never> {
  final int code;
  final String message;
  final dynamic data;
  final dynamic error;

  Failure(this.message, {this.code = -1, this.error, this.data});

  @override
  String toString() {
    return "Failure(message: $message, code: $code, data: $data, error: $error)";
  }
}

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
