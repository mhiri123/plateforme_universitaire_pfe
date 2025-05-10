import 'package:json_annotation/json_annotation.dart';

part 'api_list_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiListResponse<T> {
  @JsonKey(name: 'success', fromJson: _boolFromJson)
  final bool status;

  // Si `data` est null, on initialise à une liste vide
  final List<T> data;

  ApiListResponse({
    required this.status,
    required this.data,
  });

  factory ApiListResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) {
    // Gère le cas où `data` est null
    final dataList = json['data'] as List? ?? [];  // Si `data` est null, utilise une liste vide

    return ApiListResponse(
      status: _boolFromJson(json['success']),
      data: dataList.map((e) => fromJsonT(e)).toList(),
    );
  }

  Map<String, dynamic> toJson(
      Object Function(T value) toJsonT,
      ) =>
      _$ApiListResponseToJson(this, toJsonT);

  // Custom converter to handle both bool and string
  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}
