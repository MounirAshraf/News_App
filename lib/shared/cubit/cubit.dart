import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  // int currentIndex = 0;
  // List screen = [TaskScreen(), DoneScreen(), ArchivedScreen()];
  // List appBar = ['Task Screen', 'Done Screen', 'Archived Screen'];

  // void changeIndex(int index) {
  //   currentIndex = index;
  //   emit(AppChangeBottomNavBarState());
  // }


  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void crateDatabase() {
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
    }
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT,date TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((onError) {
          print('Error when creating table ${onError.toString()}');
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print('database Opned');
      },
    ).then((value) {
      database = value;
      emit(AppCreatDatabaseState());
    });
  }

  insertDatebase({required String title,
    required String time,
    required String date,}) async {
    await database!.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks (title, time, date, status) VALUES (?,?,?,?)',
          [title, time, date, 'new']).then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print('Error when inserting new record ${onError.toString()}');
      });
    });
  }

  void getDataFromDatabase(db) {
    newTasks = [];
    doneTasks = [] ;
    archivedTasks = [] ;
    emit(AppGetDatabaseLoadingState());
    db!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        // print(element['status']);
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        };
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,

  }) {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database) ;
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,

  }) {
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value) {
      getDataFromDatabase(database) ;
      emit(AppDeletDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false ;
  bool changeThemeMode(){
    isDark = !isDark ;
    emit(ChangeThemeMode());
    return isDark;
  }
}
