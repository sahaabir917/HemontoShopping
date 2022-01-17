import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/categorybloc/category_bloc.dart';
import 'package:hemontoshoppin/blocs/subcategory_bloc/subcategory_bloc.dart';
import 'package:hemontoshoppin/blocs/subcategorywiseproductbloc/subcategorywiseproduct_bloc.dart';
import 'package:hemontoshoppin/util/ColorUtil.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var selectedItem = 1;
  ColorUtil colorUtil = ColorUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Categories"),
      ),
      // resizeToAvoidBottomInset: true,
      // body: NestedScrollView(
      //   floatHeaderSlivers: true,
      //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      //     return <Widget>[
      //       SliverAppBar(
      //         title: Text("All Product"),
      //         excludeHeaderSemantics: true,
      //         expandedHeight: 50.0,
      //         forceElevated: innerBoxIsScrolled,
      //       ),
      //     ];
      //   },
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width*.29,
              color: Colors.white,
              child: BlocBuilder<CategoryBloc, CategoryState>(
                  bloc: BlocProvider.of<CategoryBloc>(context),
                  builder: (context, categoryState) {
                    if (categoryState is CategoryInitial) {
                      return Center(child: CircularProgressIndicator());
                    } else if (categoryState is CategoryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (categoryState is CategoryOperationSuccess) {
                      return ListView.builder(
                          itemCount: categoryState.categoryModel.data.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                var singleCategory =
                                    categoryState.categoryModel.data[index];
                                BlocProvider.of<CategoryBloc>(context)
                                    .add(SetSelectedItemPosition(index));
                                BlocProvider.of<SubCategoryBloc>(context).add(
                                    GetSubCategoriesByCategory(categoryState
                                        .categoryModel.data[index].id));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 3, bottom: 3,left: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*.1,
                                  child: Row(
                                    children: <Widget>[
                                      AnimatedContainer(
                                          duration: Duration(microseconds: 500),
                                          height: (categoryState.categoryModel
                                                      .data[index].isSelected ==
                                                  true)
                                              ? MediaQuery.of(context).size.height*.15
                                              : MediaQuery.of(context).size.height*.15,
                                          color: (categoryState.categoryModel
                                                      .data[index].isSelected ==
                                                  true)
                                              ? Color(colorUtil.hexColor("#2196F3"))
                                              :  colorUtil.getColorByPosition(index),
                                          width: 5),
                                      Expanded(
                                        child: Container(
                                          color: (categoryState.categoryModel
                                                      .data[index].isSelected ==
                                                  true)
                                              ? Colors.tealAccent
                                              : Colors.black12,
                                          height: MediaQuery.of(context).size.height*.15,
                                          child: Column(
                                            children: [
                                              Container(
                                                  child: Image.network(
                                                      "https://ecotech.xixotech.net/public/" +
                                                          categoryState
                                                              .categoryModel
                                                              .data[index]
                                                              .catPhoto,
                                                      width: 120,
                                                      height: 60,
                                                      fit: BoxFit.fill),
                                              color: Colors.white,),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15,
                                                    left: 10,
                                                    right: 10),
                                                child: (!categoryState
                                                        .categoryModel
                                                        .data[index]
                                                        .isSelected)
                                                    ? Text(
                                                        categoryState
                                                            .categoryModel
                                                            .data[index]
                                                            .categoryName,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      )
                                                    : Text(
                                                        categoryState
                                                            .categoryModel
                                                            .data[index]
                                                            .categoryName,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: BlocBuilder<SubCategoryBloc, SubcategoryState>(
                        bloc: BlocProvider.of<SubCategoryBloc>(context),
                        builder: (context, subcategoryState) {
                          if (subcategoryState is SubcategoryInital) {
                            return Container();
                          } else if (subcategoryState is SubcategoryLoaded) {
                            return subcategoryState
                                        .subcategoryModel.subcategories.length >
                                    0
                                ? GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                    ),
                                    itemCount: subcategoryState
                                        .subcategoryModel.subcategories.length,
                                    itemBuilder: (ctx, i) => GridTile(
                                          child: InkWell(
                                            onTap: () {
                                              print("index"+i.toString());
                                              BlocProvider.of<
                                                          SubCategoryWiseProductBloc>(
                                                      context)
                                                  .add(
                                                      FetchProductBySubCategory(
                                                          subcategoryState
                                                              .subcategoryModel
                                                              .subcategories[i]
                                                              .subId));
                                              scheduleMicrotask(() => Navigator
                                                      .of(context)
                                                  .pushNamed(
                                                      "/subcat_wise_product"));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Card(
                                                elevation: 5,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    subcategoryState
                                                        .subcategoryModel
                                                        .subcategories[i]
                                                        .subcategoryName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                : Center(
                                    child: Text(
                                      "No data Found",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                          } else if (subcategoryState is SubCategoryLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }))),
          ),
        ],
      ),
    );
  }

  int hexColor(String color) {
    String newColor = '0xff' + color;
    newColor = newColor.replaceAll("#", '');
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  @override
  void initState() {
    BlocProvider.of<CategoryBloc>(context).add(FetchingAllCategory());
  }
}
