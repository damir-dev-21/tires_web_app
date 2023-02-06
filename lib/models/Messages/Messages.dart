import 'package:hive/hive.dart';

part 'Messages.g.dart';

@HiveType(typeId: 3)
class Messages extends HiveObject {
  @HiveField(0)
  late List<Map<String, dynamic>> messages;

  Messages(this.messages);
}
