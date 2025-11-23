library;

part 'src/result_ext.dart';

/// if (result case Success(value: String v)) {
///   println("value ", v);
/// }
sealed class Result<T> {
  bool get success => this is Success;

  bool get failed => this is Failure;

  T? tryValue() {
    if (this case Success(value: T v)) {
      return v;
    }
    return null;
  }

  R? onSuccess<R>(R? Function(T) callback) {
    if (this case Success(value: T v)) {
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
