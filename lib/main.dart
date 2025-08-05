import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rest API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const PostsPage(),
    );
  }
}

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      final dio = Dio(BaseOptions(
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'FlutterApp/1.0',
        },
      ));
      
      final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
      
      if (response.statusCode == 200) {
        print("Data received: ${response.data.length} items");
        setState(() {
          posts = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch error: $e');
    }
  }

  void addPosts() async {
    try {
      final dio = Dio(BaseOptions(
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'FlutterApp/1.0',
        },
      ));

      final response = await dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {
          'title': 'New Post',
          'body': 'This is the body of the new post.',
          'userId': 1,
        },
      );

      print('Post Created: ${response.data}');
      setState(() {
        posts.insert(0, response.data);
      });
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  void deletePost(int postId, int index) async {
    try {
      final dio = Dio(BaseOptions(
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'FlutterApp/1.0',
        },
      ));

      final response = await dio.delete('https://jsonplaceholder.typicode.com/posts/$postId');

      if (response.statusCode == 200) {
        setState(() {
          posts.removeAt(index);
        });
        print('Post $postId deleted');
      } else {
        print('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete error: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  //leading: Text(posts[index]['id'].toString()),
                  title: Text(posts[index]['title']),
                  subtitle: Text(posts[index]['body']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletePost(posts[index]['id'], index),
                  ),
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: addPosts, child: const Text('Add Post')),
          )
        ],
      )
    );
  }
}
