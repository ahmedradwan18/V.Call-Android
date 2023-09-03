class VMeetingResponse {
  final bool isSuccess;
  final String? message;
  final dynamic error;

  VMeetingResponse({
    required this.isSuccess,
    this.message,
    this.error,
  });

  @override
  String toString() {
    return 'VMeetingResponse{isSuccess: $isSuccess, '
        'message: $message, error: $error}';
  }
}
