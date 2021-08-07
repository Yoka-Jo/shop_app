import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/click_cubit.dart';
import '../models/Lists_name.dart';
class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
        children: [
         CategoriesData(0),
         CategoriesData(1),
         CategoriesData(2),
         CategoriesData(3),
        ],
      )
    ]
    );
  }
}

class CategoriesData extends StatelessWidget {

  final int listPosition;

  const CategoriesData(this.listPosition);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          BlocProvider.of<ClickCubit>(context , listen: false).categoryClickColor(categoriesName[listPosition]);
        },
        child: BlocBuilder<ClickCubit , ClickAction>(
          builder: (ctx , state) => Container(
//              margin: EdgeInsets.symmetric(horizontal: 3),
            height: 30,
            width: 73,
            decoration: BoxDecoration(
              color: state.categoryNameSelected == categoriesName[listPosition]
                  ? Colors.deepPurple :  Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(child: Text(categoriesName[listPosition] , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 12),)),
          ),
        ),
      ),
    );
  }
}
