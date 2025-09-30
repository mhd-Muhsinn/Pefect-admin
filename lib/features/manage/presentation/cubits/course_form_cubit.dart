import 'package:flutter_bloc/flutter_bloc.dart';

class CourseFormState {
  final String name;
  final String description;
  final String price;

  CourseFormState({
    required this.name,
    required this.description,
    required this.price,
  });

  CourseFormState copyWith({
    String? name,
    String? description,
    String? price,
  }) {
    return CourseFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}

class CourseFormCubit extends Cubit<CourseFormState> {
  CourseFormCubit({
    required String initialName,
    required String initialDescription,
    required String initialPrice,
  }) : super(CourseFormState(
          name: initialName,
          description: initialDescription,
          price: initialPrice,
        ));

  void updateName(String newName) => emit(state.copyWith(name: newName));
  void updateDescription(String newDesc) => emit(state.copyWith(description: newDesc));
  void updatePrice(String newPrice) => emit(state.copyWith(price: newPrice));
}
