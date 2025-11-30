/// Универсальная модель пагинации
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

  /// Универсальный парсер под разные форматы JSON:
  /// 1) { "items": [...], "totalItems": 10, "page": 1, "pageSize": 20 }
  /// 2) { "data": [...], "total": 10, "page": 1, "limit": 20 }
  /// 3) { "data": { "items": [...], "totalItems": 10, "page": 1, "pageSize": 20 } }
  factory Pagination.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    // 1. Найти корневой объект с метаданными: сам json или json["data"]
    final root = _extractRoot(json);

    // 2. Достать массив элементов: root["items"] или root["data"]
    final rawItems = _extractItems(root);

    // 3. Преобразовать элементы в T
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(fromJsonT)
        .toList();

    // 4. Прочитать метаданные (total / page / limit) из разных ключей
    final total = _readInt(root, ['totalItems', 'total', 'count']) ?? items.length;
    final page = _readInt(root, ['page', 'currentPage']) ?? 1;
    final limit = _readInt(root, ['pageSize', 'limit', 'perPage']) ?? items.length;

    return Pagination<T>(
      items: items,
      total: total,
      page: page,
      limit: limit,
    );
  }

  /// Есть ли ещё страницы
  bool get hasMore => (page * limit) < total;

  /// Кол-во страниц
  int get totalPages => limit == 0 ? 0 : (total / limit).ceil();

  /// Пустая ли выборка
  bool get isEmpty => items.isEmpty;

  /// Первая ли страница
  bool get isFirstPage => page == 1;

  // ---------- Вспомогательные методы ----------

  /// Если бэк оборачивает в { "data": { items, totalItems, ... } },
  /// то вернём внутренний объект, иначе – сам json.
  static Map<String, dynamic> _extractRoot(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic> &&
        (data.containsKey('items') ||
            data.containsKey('totalItems') ||
            data.containsKey('page'))) {
      return data;
    }
    return json;
  }

  /// Ищем список элементов:
  /// - root["items"]
  /// - root["data"] (если это именно List)
  static List<dynamic> _extractItems(Map<String, dynamic> root) {
    if (root['items'] is List) {
      return root['items'] as List;
    }
    if (root['data'] is List) {
      return root['data'] as List;
    }
    // если ничего нет – пустой список
    return const [];
  }

  /// Читает int из первого существующего ключа в списке [keys]
  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}
