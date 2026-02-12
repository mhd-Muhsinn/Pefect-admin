import 'package:perfect_super_admin/features/communication/data/repositories/call_repository.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_action/call_action_bloc.dart';

class CallActionBlocFactory {
  static CallActionBloc create() {
    return CallActionBloc(CallRepository());
  }
}
