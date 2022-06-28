import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteblock/bloc/home_page_cubit/home_page_cubit.dart';
import 'package:noteblock/pages/home_page.dart';

void main() {
  runApp(const NoteBlock());
}

class NoteBlock extends StatelessWidget {
  const NoteBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return HomePageCubit();
        }),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

