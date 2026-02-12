import 'package:flutter_bloc/flutter_bloc.dart';

/// Simple cubit that holds the current search string.
class SearchCubit extends Cubit<String> {
  SearchCubit([String initial = '']) : super(initial);

  void setQuery(String q) => emit(q.toLowerCase());
  void clear() => emit('');
}