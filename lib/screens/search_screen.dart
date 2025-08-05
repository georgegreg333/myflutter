import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final String _essay = '''
Flutter is an open-source UI software development toolkit created by Google. 
It is used to develop cross platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.
''';

  List<TextSpan> _highlightedText = [];

  void _searchText(String query) {
    setState(() {
      _highlightedText = _highlightMatches(_essay, query);
    });
  }

  List<TextSpan> _highlightMatches(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final matches = <TextSpan>[];
    final queryLC = query.toLowerCase();
    final textLC = text.toLowerCase();

    int start = 0;
    int index;

    while ((index = textLC.indexOf(queryLC, start)) != -1) {
      if (index > start) {
        matches.add(TextSpan(text: text.substring(start, index)));
      }
      matches.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(backgroundColor: Colors.yellow),
      ));
      start = index + query.length;
    }

    if (start < text.length) {
      matches.add(TextSpan(text: text.substring(start)));
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Search text...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _searchText(_controller.text),
              ),
            ),
            onSubmitted: _searchText,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: _highlightedText.isNotEmpty
                      ? _highlightedText
                      : [TextSpan(text: _essay)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
