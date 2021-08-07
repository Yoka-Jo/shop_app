import 'package:flutter/material.dart';
import 'package:shop_jumia_app/cubit/cart_cubit.dart';
import 'package:shop_jumia_app/repositories/authentication.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../screens/main_screen.dart';
import '../screens/manage_products_screen.dart';

class AppDrawer extends StatelessWidget {
  final String authToken;
  final String userId;
  AppDrawer([this.authToken , this.userId]);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 250,
        child: Drawer(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(
              height: 10,
            ),
            Text('Hello Friend', style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),

            DrawerData(icon: Icons.home,
                name: 'Home',
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                      MainScreen.routeName);
                }),
                DrawerDivider(),

                DrawerData(icon: Icons.shopping_cart,
                  name: 'Orders',
                  onPressed: (){
                  Navigator.of(context).popAndPushNamed(CartScreen.routeName , arguments: {'authToken': authToken , 'userId':userId});
                  },),
                DrawerDivider(),

                DrawerData(
                  icon: Icons.edit, name: 'Manage Product', onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                      ManageProductsScreen.routeName , arguments: {'authToken':authToken , 'userId': userId});
                },),
                DrawerDivider(),

                DrawerData(
                  icon: Icons.exit_to_app, name: 'LogOut', onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    context.read<CartCubit>().reset();
                    Provider.of<Authentication>(context , listen: false).logOut();
                  },),
                ]
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.amber, thickness: 1, indent: 40, endIndent: 5,);
  }
}

class DrawerData extends StatelessWidget {
  final IconData icon;
  final String name;
  final Function onPressed;

  const DrawerData({
    @required this.icon,
    @required this.name,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon, color: Colors.amber,),
      label: Text(name, style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12),),
      onPressed: onPressed,
    );
  }
}
