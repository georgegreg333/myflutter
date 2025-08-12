import 'dart:async';

Future<String> fakeFetch() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Server: Hello!';
}
