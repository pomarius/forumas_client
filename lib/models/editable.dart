import 'package:equatable/equatable.dart';

class Editable extends Equatable {
  final String name;
  final String description;

  const Editable({required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [name, description];
}
