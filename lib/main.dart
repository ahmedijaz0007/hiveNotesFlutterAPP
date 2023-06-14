import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/node_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();  //Initiate Hive
  Hive.registerAdapter(NoteModelAdapter());   //register adaptor here, best practices
  await Hive.openBox<NoteModel>('notes'); //Open box here than can be reused by just using Hive.box command, no need to open again.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  //  getHive() async{
  //   box = await Hive.openBox('login').then((value) {print('done');});
  //   return box;
  // }

  void _deleteNote(NoteModel note) async {
    await note.delete();
  }

  void _editNote(NoteModel note) async {
    _descController.text = note.desc;
    _titleController.text = note.title;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (text) {},
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            title: const Text('Edit Feilds'),
            actions: [
              TextButton(
                onPressed: () {
                  note.title = _titleController.text;
                  note.desc = _descController.text;
                  note.save();
                  _titleController.clear();
                  _descController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future<void> _showNotesDailog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (text) {},
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            title: const Text('Add Feilds'),
            actions: [
              TextButton(
                onPressed: () {
                  var data = NoteModel(
                      title: _titleController.text, desc: _descController.text);
                  var box = Hive.box<NoteModel>('notes');
                  box.add(data);
                  //  data.save();
                  _titleController.clear();
                  _descController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('I am here');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hive Demo'),
        ),
        body: ValueListenableBuilder<Box<NoteModel>>(
          valueListenable: Hive.box<NoteModel>('notes').listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NoteModel>();
            data = data.reversed.toList();
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString()),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  _editNote(data[index]);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  _deleteNote(data[index]);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(data[index].desc.toString()),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showNotesDailog();
          },
          child: const Icon(Icons.add),
        ));
  }
}
