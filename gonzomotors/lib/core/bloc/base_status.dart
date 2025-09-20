enum StatusType {
  initial,
  loading,
  refreshing,
  paging,
  filtering,
  success,
  error,
  noInternet,
}

/// BaseStatus with [StatusType] and [String] message
class BaseStatus {
  final StatusType type;
  final String? message;

  const BaseStatus({
    required this.type,
    this.message,
  });


  @override
  String toString() {
    return 'BaseStatus{type: $type, message: $message}';
  }

  BaseStatus copyWith({
    StatusType? type,
    String? message,
  }) {
    return BaseStatus(
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }

  factory BaseStatus.initial() {
    return const BaseStatus(
      type: StatusType.initial,
    );
  }

  factory BaseStatus.loading() {
    return const BaseStatus(
      type: StatusType.loading,
    );
  }

  factory BaseStatus.success() {
    return const BaseStatus(
      type: StatusType.success,
    );
  }

  factory BaseStatus.completed() => BaseStatus.success();

  factory BaseStatus.refreshing() {
    return const BaseStatus(
      type: StatusType.refreshing,
    );
  }

  factory BaseStatus.paging() {
    return const BaseStatus(
      type: StatusType.paging,
    );
  }

  factory BaseStatus.filtering() {
    return const BaseStatus(
      type: StatusType.filtering,
    );
  }

  factory BaseStatus.noInternet() {
    return const BaseStatus(
      type: StatusType.noInternet,
    );
  }





  factory BaseStatus.errorWithMessage({
    required String? message,
  }) {
    return BaseStatus(
      type: StatusType.error,
      message: message,
    );
  }

  bool isLoading() => type == StatusType.loading;

  bool isRefreshing() => type == StatusType.refreshing;

  bool isPaging() => type == StatusType.paging;

  bool isSuccess() => type == StatusType.success;

  bool isError() => type == StatusType.error;

  bool isInitial() => type == StatusType.initial;

  bool isFiltering() => type == StatusType.filtering;

  bool isNoInternet() => type == StatusType.noInternet;
}