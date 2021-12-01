import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/place.dart';
import 'package:travel_app/provider/places.dart';

class PlaceSearchDelegate extends SearchDelegate {
  Function onClose;
  PlaceSearchDelegate(this.onClose);
  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData themeData = Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
          elevation: 3,
          iconTheme: IconThemeData(color: Colors.black),
          color: Colors.white),
      primaryIconTheme: IconThemeData(color: Colors.black),

      // inputDecorationTheme: InputDecorationTheme(
      //     fillColor: Colors.green,
      //     isDense: true,
      //     focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(20),
      //         borderSide: BorderSide(
      //           color: Colors.black,
      //         )),
      //     border: OutlineInputBorder(
      //         borderSide: BorderSide(color: Colors.black)))
    );
    return themeData;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, '');
          onClose();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isEmpty
        ? Center(child: Text('Search through the place name'))
        : Consumer<PlacesProvider>(
            builder: (ctx, data, child) {
              return Text('Search is comming soon');
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? Center(child: Text('Search through the place name'))
        : Consumer<PlacesProvider>(
            builder: (ctx, data, child) {
              List<Place> searchResults = data.getSearchResult(query);
              return ListView.separated(
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Image.network(
                          searchResults[index].imageUrl,
                          height: 80,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              searchResults[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.orange),
                                Text(
                                  searchResults[index].location,
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemCount: searchResults.length);
            },
          );
  }
}
