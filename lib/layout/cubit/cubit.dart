import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/layout/cubit/states.dart';

import '../../../shared/network/remote/dio_helper.dart';
import '../../modules/business/business_screen.dart';
import '../../modules/science/science_screen.dart';
import '../../modules/sports/sports_screen.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState()) ;

  static NewsCubit get(context) => BlocProvider.of(context);

  int curruntIndex = 0 ;
  List<String> appBar =['Business' , 'Sports' , 'Science'];
  List<Widget> screens = [BusinessScreen() , SportsScreen() , ScienceScreen()];
  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon:Icon(Icons.business_sharp) ,label:'Bussiness' ),
    BottomNavigationBarItem(icon: Icon(Icons.sports_basketball) ,label: 'Sports'),
    BottomNavigationBarItem(icon:Icon(Icons.science_outlined) ,label:'Science' ),
  ] ;



  void changeBottomNav (index){
    curruntIndex = index ;
    switch (index) {
      case 1 :{
        getSport();
      }break;
      case 2 :{
        getScience();
      }break;
    }

    emit(NewsBottomNavState()) ;
  }

  List<dynamic> business = [];
  void getBusiness(){
    emit(NewsLoadingBusinessState());
    if(business.length == 0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'business',
            'apikey':'65f7f556ec76449fa7dc7c0069f040ca',
          }
      ).then((value) {
        business = value?.data['articles'] ;
        // print(business);
        emit(NewsGetBusinessSuccessState());
      }).catchError((onError){
        emit(NewsGetBusinessErrorState(onError.toString()));
      });
    }else{
      emit(NewsGetBusinessSuccessState());
    }

  }

  List<dynamic> sport = [];
  void getSport(){
    emit(NewsLoadingSportsState());
    if(sport.length == 0){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'sport',
            'apikey':'65f7f556ec76449fa7dc7c0069f040ca',
          }
      ).then((value) {
        sport = value?.data['articles'] ;
        emit(NewsGetSportsSuccessState());
      }).catchError((onError){
        emit(NewsGetSportsErrorState(onError.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessState());
    }

  }

  List<dynamic> science = [];
  void getScience(){
    emit(NewsLoadingScienceState());
    if(science.length == 0 ){
      DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'eg',
            'category':'science',
            'apikey':'65f7f556ec76449fa7dc7c0069f040ca',
          }
      ).then((value) {
        science = value?.data['articles'] ;
        emit(NewsGetScienceSuccessState());
      }).catchError((onError){
        emit(NewsGetScienceErrorState(onError.toString()));
      });
    }else{
      emit(NewsGetScienceSuccessState());
    }

  }


}