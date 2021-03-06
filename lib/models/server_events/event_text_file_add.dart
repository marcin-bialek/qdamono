import 'package:qdamono/models/code.dart';
import 'package:qdamono/models/note.dart';
import 'package:qdamono/models/server_events/server_event.dart';
import 'package:qdamono/models/text_file.dart';

class EventTextFileAdd extends ServerEvent {
  static const name = 'textFileAdd';
  final TextFile textFile;

  EventTextFileAdd({
    required this.textFile,
  });

  factory EventTextFileAdd.fromJson(
    Map<String, dynamic> json,
    Iterable<Code> codes,
    Iterable<Note> notes,
  ) {
    final textFile =
        json[EventTextFileAddJsonKeys.textFile] as Map<String, dynamic>;
    return EventTextFileAdd(
      textFile: TextFile.fromJson(
        textFile,
        codes,
        notes,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      EventTextFileAddJsonKeys.name: name,
      EventTextFileAddJsonKeys.textFile: textFile.toJson(),
    };
  }
}

class EventTextFileAddJsonKeys {
  static const name = 'name';
  static const textFile = 'textFile';
}
