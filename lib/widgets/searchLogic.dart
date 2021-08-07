import 'package:flutter/material.dart';
import 'package:shop_jumia_app/data/product_data.dart';
import 'package:shop_jumia_app/screens/clothes_detail_screen.dart';

class DataSearch extends SearchDelegate<List<Product>>{
  final List<Product> namesList;
  DataSearch(this.namesList);
   

  // List<String> names;

  List<TextSpan> highlightOccurrences([String source, String query]) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase()) ) {         
        return null;
       
    }
    else{
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    print(children);
    return children;
    }
  }


  


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }




  @override
  Widget buildResults(BuildContext context) {
    final List<Product> suggestionList = namesList;

    return 
    ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {

          Navigator.of(context)
              .pushNamed(ClothesDetailScreen.routeName, arguments: {
            'id': namesList[index].id,
            'clothesName': namesList[index].title,
            'photo': namesList[index].imageUrl,
            'price': namesList[index].price,
            'description': namesList[index].description,
          });
        },
        title: RichText(
          text: TextSpan(
            children: highlightOccurrences(suggestionList[index].title, query),
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
      itemCount: suggestionList == null ? 0 : suggestionList.length,
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> suggestionList = namesList;
    print(namesList);
    // final suggestionList = query.isEmpty?recentCities:namesList.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
          itemBuilder: (context , index) => highlightOccurrences(suggestionList[index].title, query) != null ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              trailing: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(namesList[index].imageUrl),
              ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ClothesDetailScreen.routeName, arguments: {
                'id': namesList[index].id,
                'clothesName': namesList[index].title,
                'photo': namesList[index].imageUrl,
                'price': namesList[index].price,
                'description': namesList[index].description,
              });
            },
            title:RichText(
              text: TextSpan(
                children:highlightOccurrences(suggestionList[index].title, query),
                // query.length == 0 ? index : names.length
                style: TextStyle(color: Colors.grey),
              ),
            ),
              ),
          ) : Container(),
      itemCount:  suggestionList == null ? 0 :  suggestionList.length,
      //  query.length == 0 ? names.length : suggestionList == null ? 0 :  suggestionList.length,
    );

      // },
    // );
  }
}
