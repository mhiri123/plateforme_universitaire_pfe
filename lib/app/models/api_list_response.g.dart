// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiListResponse<T> _$ApiListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiListResponse<T>(
      status: ApiListResponse._boolFromJson(json['success']),
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$ApiListResponseToJson<T>(
  ApiListResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.status,
      'data': instance.data.map(toJsonT).toList(),
    };
