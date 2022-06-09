import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtapflutter/widget/search_widget.dart';

import 'api/users_api.dart';
import 'model/users.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'YouTap Flutter Task';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<User> users = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final users = await UsersApi.getUsers(query);

    setState(() => this.users = users);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(MyApp.title),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Card(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Id : " + user.id.toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 2,
                          ),
                        ),
                        Text(
                          "Name : " + user.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 2,
                          ),
                        ),
                        Text(
                          "Email : " + user.email,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 2,
                          ),
                        ),
                        Text(
                          "Phone : " + user.phone,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search By ID or Name',
        onChanged: searchUser,
      );

  Future searchUser(String query) async => debounce(() async {
        final users = await UsersApi.getUsers(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.users = users;
        });
      });
}
