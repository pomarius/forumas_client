class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException._(this.message, [this.code]);

  factory ApiException(String message, [int? code]) {
    switch (code) {
      case 400:
        return BadRequestException(message, code!);
      case 401:
        return UnauthorisedException(message, code!);
      case 403:
        return ForbiddenException(message, code!);
      case 404:
        return NotFoundException(message, code!);
      case 422:
        return UnprocessableEntityException(message, code!);
      case 500:
        return InternalServerException(message, code!);
      default:
        return ApiException._(message, code);
    }
  }

  @override
  String toString() => message;
}

class BadRequestException extends ApiException {
  BadRequestException(String message, int code) : super._(message, code);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException(String message, int code) : super._(message, code);
}

class ForbiddenException extends ApiException {
  ForbiddenException(String message, int code) : super._(message, code);
}

class NotFoundException extends ApiException {
  NotFoundException(String message, int code) : super._(message, code);
}

class UnprocessableEntityException extends ApiException {
  UnprocessableEntityException(
    String message,
    int code,
  ) : super._(message, code);
}

class InternalServerException extends ApiException {
  InternalServerException(String message, int code) : super._(message, code);
}
