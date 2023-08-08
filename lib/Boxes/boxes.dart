import 'package:doodh_hive_app/Models/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<NotesModel> getData() =>
      Hive.box<NotesModel>('notes'); // assign it in "main"
}
