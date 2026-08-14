class TacheException implements Exception {
  final String message;

  TacheException(this.message);

  @override
  String toString() {
    return "TacheException: $message";
  }
}

class TacheNotFoundException extends TacheException {
  TacheNotFoundException(String message) : super(message);

  @override
  String toString() {
    return "TacheNotFoundException: $message";
  }
}

class TacheValidationException extends TacheException {
  TacheValidationException(String message) : super(message);

  @override
  String toString() {
    return "TacheValidationException: $message";
  }
}

class TacheStorageException extends TacheException {
  TacheStorageException(String message) : super(message);

  @override
  String toString() {
    return "TacheStorageException: $message";
  }
}
