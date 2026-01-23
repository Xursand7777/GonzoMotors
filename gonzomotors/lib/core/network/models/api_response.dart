class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T? Function(dynamic) fromJsonT,
      ) {
    final statusCode = json['statusCode'] ?? 0;


    final error = json['error'];
    final result = json['result'];

    final success = (error == null) && (statusCode >= 200 && statusCode < 300);


    final message = error is String
        ? error
        : (error is Map<String, dynamic> ? (error['message']?.toString() ?? '') : '');

    return ApiResponse<T>(
      success: success,
      statusCode: statusCode,
      message: message,
      data: fromJsonT(result),
    );
  }
}