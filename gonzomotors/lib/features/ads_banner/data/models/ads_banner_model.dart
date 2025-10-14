
import 'package:equatable/equatable.dart';

class AdsBannerModel extends Equatable {
  final int? id;
  final String? imageUrl;
  final String? linkUrl;
  final String? title;
  final String? description;
  final int? order;
  final bool? isActive;
  final String? startsAt;
  final String? endsAt;
  final String? lang;
  final int? clicksCount;
  final int? viewsCount;

  const AdsBannerModel({
    this.id,
    this.imageUrl,
    this.linkUrl,
    this.title,
    this.description,
    this.order,
    this.isActive,
    this.startsAt,
    this.endsAt,
    this.lang,
    this.clicksCount,
    this.viewsCount,
  });


  factory AdsBannerModel.fromJson(Map<String, dynamic> json) {
    return AdsBannerModel(
      id: json['id'] as int?,
      imageUrl: json['image_url'] as String?,
      linkUrl: json['link_url'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      order: json['order'] as int?,
      isActive: json['is_active'] as bool?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      lang: json['lang'] as String?,
      clicksCount: json['clicks_count'] as int?,
      viewsCount: json['views_count'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    id, imageUrl, linkUrl, title, description, order, isActive,
    startsAt, endsAt, lang, clicksCount, viewsCount
  ];

}