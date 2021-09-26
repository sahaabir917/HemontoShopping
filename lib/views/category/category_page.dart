import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/categorybloc/category_bloc.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var selectedItem = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text("All Product"),
              excludeHeaderSemantics: true,
              expandedHeight: 50.0,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: SingleChildScrollView(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              color: Colors.tealAccent,
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
                              },
                              child: Container(
                                width: 190,
                                child: Row(
                                  children: <Widget>[
                                    AnimatedContainer(
                                        duration: Duration(microseconds: 500),
                                        height: (categoryState.categoryModel
                                                    .data[index].isSelected ==
                                                true)
                                            ? 80
                                            : 0,
                                        color: (categoryState.categoryModel
                                                    .data[index].isSelected ==
                                                true)
                                            ? Colors.blue
                                            : Colors.white,
                                        width: 5),
                                    Expanded(
                                      child: Container(
                                        color: (categoryState.categoryModel
                                                    .data[index].isSelected ==
                                                true)
                                            ? Colors.white
                                            : Colors.tealAccent,
                                        height: 80,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 25, left: 10, right: 10),
                                          child: Text(categoryState
                                              .categoryModel
                                              .data[index]
                                              .categoryName),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }),
            )
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    BlocProvider.of<CategoryBloc>(context).add(FetchingAllCategory());
  }
}
