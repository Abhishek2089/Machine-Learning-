import 'package:flutter/material.dart';
import 'package:project_2021/dummy_data.dart';

class CategoriesScreen extends StatelessWidget {

  static const routeName = '/category-labours';

  //final String categoryId;
  //final String categoryTitle;

  //const CategoriesScreen(this.categoryId, this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    final routeArgs = 
    ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    final categoryList = DUMMY_MEALS.where((element) {
      return element.categories.contains(categoryId);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Text(categoryList[index].title);
        }, 
        itemCount: categoryList.length,
      ),
    );
  }
}