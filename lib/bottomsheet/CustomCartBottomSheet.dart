import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hemontoshoppin/blocs/cartbloc/cart_bloc.dart';
import 'package:hemontoshoppin/blocs/productbloc/product_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CustomCartBottomSheet extends StatefulWidget {
  final String productId;

  CustomCartBottomSheet(@required this.productId);

  @override
  _CustomCartBottomSheetState createState() =>
      _CustomCartBottomSheetState(productId);
}

class _CustomCartBottomSheetState extends State<CustomCartBottomSheet> {
  String productId;


  _CustomCartBottomSheetState(String productId) {
    this.productId = productId;
  }

  TextEditingController cartQuantityController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: ListView(controller: controller, children: <Widget>[

          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Hemontika",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                height: 40,
              ),
            ],
          ),
          BlocBuilder<CartBloc, CartState>(
              bloc: BlocProvider.of<CartBloc>(context),
              builder: (context, cartState) {
                if(cartState is CartInitial){
                  return Center(child: CircularProgressIndicator());
                }
                else if(cartState is UserCartOperationSucess){
                  return Container(
                    child: Text(""),
                  );
                }
                else if(cartState is AfterAddToCart){
                   Fluttertoast.showToast(
                       msg: 'Added successfully',
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       backgroundColor: Colors.lightBlueAccent,
                       textColor: Colors.black);
                }
                else {
                  Container(
                      child : Center(child: CircularProgressIndicator())
                  );
                }
              }),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: TextFormField(
                    controller: cartQuantityController,
                    style: TextStyle(color: Colors.black,fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Enter Quantity",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      hintStyle: TextStyle(color: Colors.black12),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  child: RaisedButton(
                    onPressed: () {
                      var quantity = cartQuantityController.text;
                      // reviewController.createReview(comment,tourController.tourModel[index].id,5);
                      BlocProvider.of<CartBloc>(context)
                          .add(AddToCart(productId, quantity));
                    },
                    color: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      "Add To Cart",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),

        ]),
      ),
    );
  }
}
