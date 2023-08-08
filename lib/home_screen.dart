import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          var box = await Hive.openBox('hunny'); // Box is like a folder.

          box.put('name', 'Huzaifa');
          box.put('age', 23);
          box.put('details', {
            'pro': 'Flutter Developer',
            'cash': 3000,
          });

          print(box.get('name')); // Output: Huzaifa
          print(box.get('age')); // 23
          print(box.get('details')); // {pro: Flutter Developer, cash: 3000}

          // Get only one entry from 'details':
          print(box.get('details')['pro']);

          // Delete a value:
          // print(box.delete('age'));

          setState(() {});
        },
      ),
    );
  }
}
