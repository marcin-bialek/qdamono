import 'package:analysis_tool/models/code.dart';
import 'package:analysis_tool/models/json_encodable.dart';
import 'package:analysis_tool/models/note.dart';
import 'package:analysis_tool/models/server_events/event_clients.dart';
import 'package:analysis_tool/models/server_events/event_code_add.dart';
import 'package:analysis_tool/models/server_events/event_code_remove.dart';
import 'package:analysis_tool/models/server_events/event_code_update.dart';
import 'package:analysis_tool/models/server_events/event_coding_add.dart';
import 'package:analysis_tool/models/server_events/event_coding_remove.dart';
import 'package:analysis_tool/models/server_events/event_coding_version_add.dart';
import 'package:analysis_tool/models/server_events/event_coding_version_remove.dart';
import 'package:analysis_tool/models/server_events/event_note_add.dart';
import 'package:analysis_tool/models/server_events/event_note_add_to_line.dart';
import 'package:analysis_tool/models/server_events/event_note_remove.dart';
import 'package:analysis_tool/models/server_events/event_note_remove_from_line.dart';
import 'package:analysis_tool/models/server_events/event_note_update.dart';
import 'package:analysis_tool/models/server_events/event_project.dart';
import 'package:analysis_tool/models/server_events/event_published.dart';
import 'package:analysis_tool/models/server_events/event_text_file_add.dart';
import 'package:analysis_tool/models/server_events/event_text_file_remove.dart';
import 'package:analysis_tool/models/text_file.dart';

abstract class ServerEvent implements JsonEncodable {
  static ServerEvent? parse(
    dynamic event, {
    Iterable<TextFile>? textFiles,
    Iterable<Code>? codes,
    Iterable<Note>? notes,
  }) {
    if (!(event is Map<String, dynamic> &&
        event.containsKey(ServerEventJsonKeys.name) &&
        event[ServerEventJsonKeys.name] is String)) {
      return null;
    }
    final name = event[ServerEventJsonKeys.name] as String;
    try {
      switch (name) {
        case EventClients.name:
          return EventClients.fromJson(event);
        case EventProject.name:
          return EventProject.fromJson(event);
        case EventPublished.name:
          return EventPublished.fromJson(event);

        // TextFile events
        case EventTextFileAdd.name:
          return codes != null && notes != null
              ? EventTextFileAdd.fromJson(event, codes, notes)
              : null;
        case EventTextFileRemove.name:
          return EventTextFileRemove.fromJson(event);

        // TextCodingVersion events
        case EventCodingVersionAdd.name:
          return codes != null && textFiles != null && notes != null
              ? EventCodingVersionAdd.fromJson(event, textFiles, codes, notes)
              : null;
        case EventCodingVersionRemove.name:
          return EventCodingVersionRemove.fromJson(event);

        // TextCoding events
        case EventCodingAdd.name:
          return codes != null ? EventCodingAdd.fromJson(event, codes) : null;
        case EventCodingRemove.name:
          return codes != null
              ? EventCodingRemove.fromJson(event, codes)
              : null;

        // Code events
        case EventCodeAdd.name:
          return EventCodeAdd.fromJson(event);
        case EventCodeRemove.name:
          return EventCodeRemove.fromJson(event);
        case EventCodeUpdate.name:
          return EventCodeUpdate.fromJson(event);

        // Note events
        case EventNoteAdd.name:
          return EventNoteAdd.fromJson(event);
        case EventNoteRemove.name:
          return EventNoteRemove.fromJson(event);
        case EventNoteUpdate.name:
          return EventNoteUpdate.fromJson(event);
        case EventNoteAddToLine.name:
          return EventNoteAddToLine.fromJson(event);
        case EventNoteRemoveFromLine.name:
          return EventNoteRemoveFromLine.fromJson(event);

        // unknown event
        default:
          print('Unknown event: $name');
          return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class ServerEventJsonKeys {
  static const name = 'name';
}
