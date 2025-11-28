import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CategoryLoadRequested extends CategoryEvent {}

class CategoryCreateRequested extends CategoryEvent {
  final String libelle;
  final String description;
  final File? image;

  const CategoryCreateRequested({
    required this.libelle,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [libelle, description, image];
}

class CategoryUpdateRequested extends CategoryEvent {
  final String uuid;
  final String libelle;
  final String description;
  final File? image;

  const CategoryUpdateRequested({
    required this.uuid,
    required this.libelle,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [uuid, libelle, description, image];
}

class CategoryDeleteRequested extends CategoryEvent {
  final String uuid;

  const CategoryDeleteRequested(this.uuid);

  @override
  List<Object?> get props => [uuid];
}
