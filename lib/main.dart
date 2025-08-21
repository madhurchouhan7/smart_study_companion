import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_study_companion/config/app_colors.dart';
import 'package:smart_study_companion/home/home_page.dart';
import 'package:flutter_quill/flutter_quill.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_study_companion/notes/model/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox<Note>('notesBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        // Add your localization delegates here
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      title: 'Smart Study App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          surface: AppColors.backgroundColor,
          error: AppColors.errorColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
