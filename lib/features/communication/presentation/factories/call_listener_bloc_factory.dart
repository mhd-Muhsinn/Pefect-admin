import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/communication/data/repositories/call_repository.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_listener/call_listener_bloc.dart';

class CallListenerBlocFactory {
  static CallListenerBloc create() {
    return CallListenerBloc(repo: CallRepository());
  }
}
