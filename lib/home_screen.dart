import 'package:doodh_hive_app/Boxes/boxes.dart';
import 'package:doodh_hive_app/Models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
      body: FutureBuilder(
        future: Hive.openBox('hunny'),
        builder: (context, snapshot) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(snapshot.data!.get('age').toString()),
            ),
            title: Text(snapshot.data!.get('name')),
            subtitle: Text(snapshot.data!.get('details')['pro']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showOurDialog();
        },
      ),
    );
  }

  Future<void> _showOurDialog() async {
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
                data.save();

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
}
