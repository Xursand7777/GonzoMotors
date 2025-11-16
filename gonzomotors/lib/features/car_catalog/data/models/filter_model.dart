import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CarFilterModel extends Equatable {
  final int id;
  final String name;
  final Widget? icon;
  final dynamic value;
  final int? groupValue;
  final Gradient? backgroundGradient;
  final String queryKey;
  final bool isListQuery;

  const CarFilterModel({
    required this.id,
    required this.name,
    required this.queryKey,
    required this.value,
    this.icon,
    this.backgroundGradient,
    this.groupValue,
    this.isListQuery = false,
  });

  @override
  List<Object?> get props => [id, name, icon, backgroundGradient, queryKey, value, isListQuery, groupValue];
}