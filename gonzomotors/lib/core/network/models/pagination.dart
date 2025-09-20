// Pagination model
class Pagination<T> {
  final List<T> items;
  final int total;
  final int page;
  final int limit;

  Pagination({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory Pagination.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    final rawItems = json['data'] as List?;
    return Pagination<T>(
      items: rawItems?.map((e) => fromJsonT(e)).toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }

  // Helper methods
  bool get hasMore => (page * limit) < total;
  int get totalPages => (total / limit).ceil();
  bool get isEmpty => items.isEmpty;
  bool get isFirstPage => page == 1;
}