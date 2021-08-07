import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/manage_products_cubit.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/ManageProductsScreen';

  Future<void> refreshProducts(BuildContext context, String authData) async {
    await BlocProvider.of<ManageProductsCubit>(context)
        .fetchAndSetProducts(authData);
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    return Scaffold(
        drawer: AppDrawer(auth['authToken'], auth['userId']),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Your Products'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: {'id': null, 'authData': auth['authToken']});
              },
            )
          ],
        ),
        body: FutureBuilder(
          builder: (context, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                )
              : RefreshIndicator(
                  onRefresh: () => refreshProducts(context, auth['authToken']),
                  color: Colors.purple,
                  child: BlocBuilder<ManageProductsCubit, LoadList>(
                    builder: (ctx, state) => ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(0, 5))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10.0),
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black45,
                                                offset: Offset(0, 2),
                                                blurRadius: 6.0),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          child: ClipOval(
                                            child: Image(
                                              height: 60.0,
                                              width: 60.0,
                                              image: NetworkImage(
                                                  state.items[i].imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 100,
                                          child: FittedBox(
                                              child: Text(
                                            state.items[i].title,
                                          )))
                                    ],
                                  ),
                                  Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            EditProductScreen.routeName,
                                            arguments: {
                                              'id': state.items[i].id,
                                              'authData': auth['authToken']
                                            });
                                      },
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                            color: Colors.amber.shade700,
                                            fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text('Are You Sure!'),
                                                  content: Text(
                                                      'You\'re about to delete this Product'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.amber),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                    TextButton(
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          try {
                                                            await BlocProvider
                                                                    .of<ManageProductsCubit>(
                                                                        context)
                                                                .deleteProduct(
                                                                    state
                                                                        .items[
                                                                            i]
                                                                        .id,
                                                                    auth[
                                                                        'authToken']);
                                                          } catch (error) {
                                                            print(error);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentSnackBar();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              content: Text(
                                                                'Couldn\'t delete this item now',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ));
                                                          }
                                                        })
                                                  ],
                                                ));
                                      },
                                      child: Text('Delete',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18)),
                                    )
                                  ])
                                ]));
                      },
                    ),
                  ),
                ),
        ));
  }
}
