import 'package:flutter/material.dart';

class ClothesDetailScreen extends StatefulWidget {
  static const routeName = '/ChooseDetailScreen';

  @override
  _ClothesDetailScreenState createState() => _ClothesDetailScreenState();
}

class _ClothesDetailScreenState extends State<ClothesDetailScreen> {
  bool isfullScreen = true;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Clothes'),
        backgroundColor: Colors.purple,
      ),
      body: GestureDetector(
        child: Stack(children: [
          InkWell(
            onTap: (){
              setState(() {
                isfullScreen = !isfullScreen;
              });
            },
                      child: FadeInImage(
                placeholder: AssetImage('assets/product-placeholder.png'),
              image: NetworkImage(
                  routeArgs['photo'],
                ),
                 fit: isfullScreen ?  BoxFit.cover : BoxFit.scaleDown ,
                  height: isfullScreen ?  400 : MediaQuery.of(context).size.height -100 ,
                  width: isfullScreen ? MediaQuery.of(context).size.width : 400,
                  alignment:isfullScreen ?  Alignment.topCenter : Alignment.center,
              ),
          ),
          if(isfullScreen) Stack(fit: StackFit.expand, children: [
            Positioned(
              bottom: 0.0,
              child: Container(
                padding: EdgeInsets.all(2),
                height: 330,
                width: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.purple[200],
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 20, left: 20),
                    height: 300,
                    width: 360,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        color: Colors.black38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routeArgs['clothesName'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(routeArgs['description'] , style: TextStyle(color: Colors.white.withOpacity(.95)),),
                      ],
                    )),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                padding: EdgeInsets.all(4),
                height: 80,
                width: 360,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    ),
                child: Container(
                  height: 80,
                  width: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white),
                  child: Center(child: Text('${routeArgs['price'].toString()} \$' , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),) ),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
