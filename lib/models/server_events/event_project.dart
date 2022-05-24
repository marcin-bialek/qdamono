import 'package:analysis_tool/models/project.dart';
import 'package:analysis_tool/models/server_events/server_event.dart';

class EventProject extends ServerEvent {
  static const name = 'project';
  final Project project;

  EventProject({
    required this.project,
  });

  factory EventProject.fromJson(Map<String, dynamic> json) {
    final project = json[EventProjectJsonKeys.project] as Map<String, dynamic>;
    return EventProject(project: Project.fromJson(project));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      EventProjectJsonKeys.name: name,
      EventProjectJsonKeys.project: project.toJson(),
    };
  }
}

class EventProjectJsonKeys {
  static const name = 'name';
  static const project = 'project';
}