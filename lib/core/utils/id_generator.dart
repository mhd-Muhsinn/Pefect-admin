import 'package:uuid/uuid.dart';

class IdGenerator {
  static String uuid() => const Uuid().v4();
}
