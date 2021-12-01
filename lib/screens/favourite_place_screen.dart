import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/place.dart';
import 'package:travel_app/provider/places.dart';
import 'package:travel_app/screens/place_detail.dart';

class FavouritePlaceList extends StatefulWidget {
  FavouritePlaceList({Key key}) : super(key: key);

  @override
  _FavouritePlaceListState createState() => _FavouritePlaceListState();
}

class _FavouritePlaceListState extends State<FavouritePlaceList> {
  @override
  Widget build(BuildContext context) {
    List<Place> favouritePlaces =
        Provider.of<PlacesProvider>(context).getFavouritePlaces();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Favourite Places',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Consumer<PlacesProvider>(
            builder: (ctx, data, child) {
              final places = data.getFavouritePlaces();
              return favouritePlaces.length > 0
                  ? StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: favouritePlaces.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    PlaceDetail(id: places[index].id)));
                          },
                          child: Container(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: 'PlaceDetail' +
                                      places[index].id.toString(),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: Image.network(places[index].imageUrl,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    child: Text(
                                      places[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) {
                        return StaggeredTile.count(2, index.isEven ? 2.2 : 1.4);
                      },
                      mainAxisSpacing: 9.0,
                      crossAxisSpacing: 4.0,
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No favourite places',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
