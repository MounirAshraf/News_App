import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/bloc_observer.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/network/remote/dio_helper.dart';

import 'layout/news_layout.dart';


void main() {
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                textTheme: TextTheme(
                    titleSmall: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )
                ),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarBrightness: Brightness.dark,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0.0 ,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  elevation: 50.0,
                  selectedItemColor: Colors.deepOrange,
                )
            ),
            darkTheme: ThemeData(
                textTheme: TextTheme(
                    titleSmall: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )
                ),
                primarySwatch: Colors.deepOrange,
                scaffoldBackgroundColor: Color.fromRGBO(56, 59, 63, 1),
                appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Color.fromRGBO(56, 59, 63, 1),
                    statusBarBrightness: Brightness.light,
                  ),
                  backgroundColor: Color.fromRGBO(56, 59, 63, 1),
                  elevation: 0.0 ,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange,
                  backgroundColor: Color.fromRGBO(56, 59, 63, 0.3),
                  unselectedItemColor: Colors.white60,
                )
            ),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: Directionality(
                textDirection: TextDirection.rtl,
                child: NewsLayout()),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}



