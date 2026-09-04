import 'package:flutter/material.dart';

class StudyRoom {
  final String name;
  final Color iconColor;
  final int studyingCount;
  final int maxCapacity;
  final String status;
  final Color statusColor;
  final String category;

  final String description;
  final String createdBy;
  final String createdAgo;

  const StudyRoom({
    required this.name,
    required this.iconColor,
    required this.studyingCount,
    required this.maxCapacity,
    required this.status,
    required this.statusColor,
    required this.category,
    required this.description,
    required this.createdBy,
    required this.createdAgo,
  });
}