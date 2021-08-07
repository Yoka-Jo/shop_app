import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';
import '/cubit/cart_cubit.dart';
import '/cubit/click_cubit.dart';
import '/cubit/manage_products_cubit.dart';
import '/cubit/orders_cubit.dart';
import '/screens/cart_screen.dart';
import '/screens/edit_product_screen.dart';
import '/screens/main_screen.dart';
import '/screens/manage_products_screen.dart';
import '/screens/order_Screen.dart';
import 'repositories/authentication.dart';
import 'screens/clothes_detail_screen.dart';
import 'screens/loginout/logoScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Authentication(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ManageProductsCubit>(
            create: (BuildContext context) => ManageProductsCubit()..fetchAndSetProducts(),
          ),
          BlocProvider<OrderCubit>(
            create: (BuildContext context) => OrderCubit(),
          ),
          BlocProvider<CartCubit>(
            create: (BuildContext context) => CartCubit(),
          ),
          BlocProvider<ClickCubit>(
            create: (BuildContext context) => ClickCubit(),
          ),
        ],
        child: Consumer<Authentication>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                appBarTheme: AppBarTheme(
                    color: Colors.black, brightness: Brightness.dark)),
            home: auth.isAuth ? MainScreen() : 
            FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context , authSnapShot) => authSnapShot.connectionState == ConnectionState.waiting ? SplashScreen() :
              authSnapShot.data ?  MainScreen() : LogoScreen()
              
              ),

            routes: {
              ClothesDetailScreen.routeName: (context) => ClothesDetailScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
              ManageProductsScreen.routeName: (context) =>
                  ManageProductsScreen(),
              MainScreen.routeName: (context) => MainScreen(),
              CartScreen.routeName: (context) => CartScreen(),
            },
          ),
        ),
      ),
    );
  }
}
