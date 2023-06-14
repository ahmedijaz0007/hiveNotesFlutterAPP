import 'package:hive/hive.dart';
part 'node_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject{

@HiveField(0)
  String title;
@HiveField(1)
 String desc;
  NoteModel({required this.title,required this.desc});
}
