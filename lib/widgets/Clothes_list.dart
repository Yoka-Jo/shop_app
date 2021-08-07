import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_jumia_app/data/product_data.dart';
import 'package:shop_jumia_app/repositories/authentication.dart';
import '../cubit/click_cubit.dart';
import '../cubit/orders_cubit.dart';
import '../screens/clothes_detail_screen.dart';

class ClothesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final productAuth = Provider.of<Authentication>(context);
    return BlocBuilder<ClickCubit, ClickAction>(builder: (context, clickState) {
      final Product filteredItemsList =
          product.kind == clickState.categoryNameSelected ? product : null;
      return product.kind == clickState.categoryNameSelected ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ClothesDetailScreen.routeName,
                                  arguments: {
                                    'id': filteredItemsList.id,
                                    'clothesName': filteredItemsList.title,
                                    'photo': filteredItemsList.imageUrl,
                                    'price': filteredItemsList.price,
                                    'description':
                                        filteredItemsList.description,
                                  });
                            },
                            child: Container(
                              height: 105,
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/product-placeholder.png'),
                                  image: NetworkImage(
                                    filteredItemsList.imageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                  //ImageProvider(
                                  // height: 105,
                                  // width: 150,
                                  // image: NetworkImage(
                                  //     filteredItemsList.imageUrl),
                                  // fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                filteredItemsList.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Consumer<Product>(
                                builder: (context, productFav, _) => IconButton(
                                  icon: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    radius: 50,
                                    child: Icon(
                                      Icons.favorite,
                                      color: productFav.isFavourite
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    filteredItemsList.toggleFavouriteStatus(
                                        productAuth.userId  , filteredItemsList.id, productAuth.token);
                                         //filteredItemsList.id
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(width: 15),
                              Text(
                                '${filteredItemsList.price.toString()} \$',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              BlocBuilder<OrderCubit, OrderProvider>(
                                builder: (context, cartState) =>
                                    GestureDetector(
                                  onTap: () {
//                                                String productId, double price, String title , String imageUrl
                                    BlocProvider.of<OrderCubit>(context)
                                        .addItem(
                                      filteredItemsList.id,
                                      filteredItemsList.price,
                                      filteredItemsList.title,
                                      filteredItemsList.imageUrl,
                                    );
                                    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: FittedBox(
                                        child: Row(
                                          children: [
                                            Text('You Added'),
                                            Text(
                                              ' ${filteredItemsList.title} ',
                                              style: TextStyle(
                                                  color:
                                                      Colors.purple.shade300),
                                            ),
                                            Text('To The Cart'),
                                          ],
                                        ),
                                      ),
                                      action: SnackBarAction(
                                          label: 'Undo',
                                          textColor: Colors.amber,
                                          onPressed: () {
                                            BlocProvider.of<OrderCubit>(context)
                                                .removeItem(
                                                    filteredItemsList.id);
                                          }),
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6),
                                    height: 35,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Buy',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ) : Container();
    });
  }
}
