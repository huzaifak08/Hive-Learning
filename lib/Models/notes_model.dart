import 'package:hive/hive.dart';
part 'notes_model.g.dart'; // Must use this
//  and then run the following command: flutter packages pub run build_runner build

@HiveType(typeId: 0) // TypeId is just like normal Id (next model id will be 1)
class NotesModel extends HiveObject {
  // Please Focus on Hive Field and Type:

  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? description;

  NotesModel({this.title, this.description});
}
