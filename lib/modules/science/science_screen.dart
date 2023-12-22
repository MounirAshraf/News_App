import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/componants/componants.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';

class ScienceScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      builder: (context, state) {
        NewsCubit cubit = NewsCubit.get(context);
        List<dynamic> list = cubit.science ;
        return list.length == 0 ? Center(child: CircularProgressIndicator()) :
        articleBulder(list);
        },
      listener: (context, state) {

      },
    );
  }
}
