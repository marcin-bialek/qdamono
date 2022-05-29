import 'package:analysis_tool/models/code.dart';
import 'package:analysis_tool/models/json_encodable.dart';
import 'package:analysis_tool/models/note.dart';
import 'package:analysis_tool/models/observable.dart';
import 'package:analysis_tool/models/text_file.dart';
import 'package:uuid/uuid.dart';

class Project implements JsonEncodable {
  final String id;
  final String name;
  final textFiles = Observable<Set<TextFile>>({});
  final codes = Observable<Set<Code>>({});
  final notes = Observable<Set<Note>>({});

  Project({
    required this.id,
    required this.name,
  });

  factory Project.withId({
    required String name,
  }) {
    final id = const Uuid().v4();
    return Project(id: id, name: name);
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    final id = json[ProjectJsonKeys.id];
    final name = json[ProjectJsonKeys.name];
    final project = Project(id: id, name: name);
    final codes = json[ProjectJsonKeys.codes] as List;
    project.codes.value.addAll(codes.map((e) => Code.fromJson(e)));
    final notes = json[ProjectJsonKeys.notes] as List;
    project.notes.value.addAll(notes.map((e) => Note.fromJson(e)));
    final textFiles = json[ProjectJsonKeys.textFiles] as List;
    project.textFiles.value.addAll(textFiles.map((e) => TextFile.fromJson(
          e,
          project.codes.value,
          project.notes.value,
        )));
    return project;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ProjectJsonKeys.id: id,
      ProjectJsonKeys.name: name,
      ProjectJsonKeys.textFiles:
          textFiles.value.map((e) => e.toJson()).toList(),
      ProjectJsonKeys.codes: codes.value.map((e) => e.toJson()).toList(),
      ProjectJsonKeys.notes: notes.value.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(covariant Project other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ProjectJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const textFiles = 'textFiles';
  static const codes = 'codes';
  static const notes = 'notes';
}
