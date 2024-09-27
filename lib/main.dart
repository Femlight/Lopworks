import 'package:flutter/material.dart';
import 'bloc/mail_bloc.dart';
import 'bloc/mail_event.dart';
import 'src/app/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => MailBloc()..add(FetchMailsEvent()),
        child: const App(),
      ),
    );
  }
}
