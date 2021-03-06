import 'dart:async';

import 'package:qdamono/constants/keys.dart';
import 'package:qdamono/constants/routes.dart';
import 'package:qdamono/services/project/project_service.dart';
import 'package:flutter/material.dart';

class SideMenuSearch extends StatefulWidget {
  const SideMenuSearch({Key? key}) : super(key: key);

  @override
  State<SideMenuSearch> createState() => _SideMenuSearchState();
}

class _SideMenuSearchState extends State<SideMenuSearch> {
  final _projectService = ProjectService();
  StreamSubscription<TextSearchResult>? _searchResultSubscription;
  final List<TextSearchResult> _results = [];
  bool _searching = false;

  @override
  void dispose() {
    _searchResultSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Wyszukaj',
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _results.clear();
                      });
                    } else {
                      _search(value);
                    }
                  },
                ),
              ),
              if (_searching)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final result = _results[index];
              return ListTile(
                dense: true,
                leading: Text(
                  '${result.file.name.value}:${result.line.index}',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                title: Text(
                  result.line.text.substring(result.offset),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).primaryTextTheme.bodyText2,
                ),
                onTap: () {
                  mainViewNavigatorKey.currentState!.pushReplacementNamed(
                    MainViewRoutes.textEditor,
                    arguments: <dynamic>[result.file, result.line.index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _search(String text) {
    _searchResultSubscription?.cancel();
    setState(() {
      _results.clear();
      _searching = true;
    });
    final result = _projectService.searchText(text, ignoreCase: true);
    _searchResultSubscription = result.listen(
      (event) {
        setState(() {
          _results.add(event);
        });
      },
      onDone: () {
        setState(() {
          _searching = false;
        });
      },
    );
  }
}
