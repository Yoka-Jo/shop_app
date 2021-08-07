import 'package:provider/provider.dart';
import 'package:shop_jumia_app/repositories/authentication.dart';
import '../widgets/SearchLogic.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/categories_list.dart';
import 'package:flutter/material.dart';
import '../widgets/Clothes_list.dart';
import '../screens/order_Screen.dart';
import '../widgets/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/manage_products_cubit.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  var productData;
  
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
        productData = Provider.of<Authentication>(context);
      BlocProvider.of<ManageProductsCubit>(context)
          .fetchAndSetProducts(productData.token , productData.userId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.read<ManageProductsCubit>().items;
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: AppDrawer(productData.token ,  productData.userId),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(products));
            },
            child: Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Search on Market',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    ],
                  ),
                )),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(OrderScreen.routeName , arguments: {'authToken':productData.token , 'userId': productData.userId});
                }),
          ],
        ),
        body:
        _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                        items: _sliderList
                            .map(
                              (e) => Container(
                                padding: EdgeInsets.all(2),
                                                                margin: EdgeInsets.symmetric(vertical: 8),

                                color: Colors.black12,
                                                              child: Container(
                                  // padding: EdgeInsets.symmetric(vertical: 10),
                                  child: e,
                                ),
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            autoPlayCurve: Curves.easeInOut,
                            height: 300)),
                    CategoriesList(),
                     ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: products.length,
                                itemBuilder: (context, i) =>
                                    ChangeNotifierProvider.value(
                                  value: products[i],
                                  child: ClothesList(),
                                ),
                              ),
                  ],
                ),
              ),
      ),
    );
  }

  final _sliderList = [
    Image.network(
      "https://image.freepik.com/free-photo/green-front-sweater_125540-736.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://image.freepik.com/free-photo/black-front-sweater_125540-763.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://image.freepik.com/free-photo/pink-sweater-front_125540-746.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://image.freepik.com/free-photo/blue-t-shirt_125540-727.jpg",
      fit: BoxFit.cover,
    )
  ];
}
