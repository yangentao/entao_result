## Features
Result, success, failure.  
 
## Usage

```dart  
void main() {
  Success<int> intResult = Success(9);
  print(intResult.value);

  Result a = Success("Hello", extra: {"offset": 9});
  if (a case Success(value: String v, extra: {"offset": int offset})) {
    print("value: $v, offset: $offset ");
  }
  if (a case Failure e) {
    print("error: $e ");
  }
}
``` 