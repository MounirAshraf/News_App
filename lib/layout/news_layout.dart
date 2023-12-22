
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class NewsLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context) => NewsCubit()..getBusiness(),
      child: BlocConsumer<NewsCubit,NewsStates>(
        builder: (context, state) {
          NewsCubit cubit = NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
                title: Text(cubit.appBar[cubit.curruntIndex]),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined)),
                IconButton(onPressed: (){AppCubit.get(context).changeThemeMode();}, icon: Icon(Icons.brightness_6_outlined)),
              ],
            ),
            body: cubit.screens[cubit.curruntIndex] ,
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              currentIndex: cubit.curruntIndex,
              onTap: (value) {
                cubit.changeBottomNav(value);
              },
            ),
          );
        },
        listener: (context, state) {
        } ,
      ),

    );
  }
}
