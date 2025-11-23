import 'dart:convert';

ErrorModel responseErrorFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String responseErrorToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
    this.errorCode,
    this.message,
    this.arguments,
  });

  String? errorCode;
  String? message;
  List<dynamic>? suppressed;
  List<dynamic>? arguments;

  ErrorModel copyWith({
    String? errorCode,
    String? fullMessage,
    String? message,
    List<dynamic>? suppressed,
    List<dynamic>? arguments,
  }) =>
      ErrorModel(
        errorCode: errorCode ?? this.errorCode,
        message: message ?? this.message,
        arguments: arguments ?? this.arguments,
      );

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        errorCode: json["errorCode"],
        message: json["message"],
        arguments: json["arguments"] == null
            ? []
            : List<dynamic>.from(json["arguments"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "message": message,
        "suppressed": suppressed == null
            ? []
            : List<dynamic>.from(suppressed!.map((x) => x)),
        "arguments": arguments == null
            ? []
            : List<dynamic>.from(arguments!.map((x) => x)),
      };
}
