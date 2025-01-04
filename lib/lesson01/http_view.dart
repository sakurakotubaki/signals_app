import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signals/signals_flutter.dart';

const url = 'https://jsonplaceholder.typicode.com/users';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }
}

final u = asyncSignal<List<User>>(AsyncState.data([]));

Future<void> getUser() async {
  u.value = AsyncState.loading();

  try {
    final response = await http.get(Uri.parse(url));
    final List<dynamic> data = jsonDecode(response.body);

    if (data.isEmpty) {
      u.value = AsyncState.error('No data', null);
      return;
    }

    final users = data.map((json) => User.fromJson(json)).toList();
    u.value = AsyncState.data(users);
  } catch (e) {
    u.value = AsyncState.error('Exception: $e', null);
  }
}

class HttpView extends StatelessWidget {
  const HttpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch.builder'),
      ),
      body: Center(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                getUser();
              },
              icon: const Icon(Icons.refresh),
            ),
            Expanded(
              child: Watch.builder(builder: (context) {
                if (u.value.isLoading) {
                  return const CircularProgressIndicator();
                }
                if (u.value.hasError) {
                  return Text('Error: ${u.value.error}');
                }

                final users = u.value.value;
                if (users!.isEmpty) {
                  return const Text('No data');
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text('名前: ${user.name}'),
                      subtitle: Text('メール: ${user.email}'),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}