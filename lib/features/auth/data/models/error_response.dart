class ErrorResponse {
    final String? message;
    final String? error;
    final int? status;

    ErrorResponse({this.message, this.error, this.status});

    // Factory method to create an ErrorResponse from JSON
    factory ErrorResponse.fromJson(Map<String, dynamic> json) {
        return ErrorResponse(
                message: json['message'],
                error: json['error'],
                status: json['status'],
    );
    }
}
