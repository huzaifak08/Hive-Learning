import 'package:doodh_hive_app/Boxes/boxes.dart';
import 'package:doodh_hive_app/Models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Database"),
        centerTitle: true,
      ),
      // Show Box Data in UI:
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, child) {
          var data = box.values.toList().cast<NotesModel>();

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return ListTile(
                // Edit:

                onTap: () => _editNotesDialog(
                  data[index],
                  data[index].title.toString(),
                  data[index].description.toString(),
                ),
                title: Text(data[index].title.toString()),
                subtitle: Text(data[index].description.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteNote(data[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addNotesDialog();
        },
      ),
    );
  }

  Future<void> _addNotesDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Title',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final data = NotesModel(
                    title: titleController.text,
                    description: descriptionController.text);

                // Boxes Class:

                final box = Boxes.getData();
                box.add(data);

                // Must run this for save method: flutter packages pub run build_runner build
                // data.save();

                titleController.clear();
                descriptionController.clear();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Edit:
  Future<void> _editNotesDialog(
      NotesModel notesModel, String title, String desc) async {
    titleController.text = title;
    descriptionController.text = desc;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Title',
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                notesModel.title = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                await notesModel.save();

                titleController.clear();
                descriptionController.clear();
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Delete:
  void deleteNote(NotesModel notesModel) async {
    await notesModel.delete();
  }
}
