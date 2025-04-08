class Request {
  final int id;
  final String type;
  final String status;

  Request({
    required this.id,
    required this.type,
    required this.status,
  });

  Request copyWith({int? id, String? type, String? status}) {
    return Request(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
