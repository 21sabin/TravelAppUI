import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/place.dart';
import 'package:travel_app/provider/places.dart';
import 'dart:math';

class PlaceDetail extends StatefulWidget {
  int id;
  PlaceDetail({Key key, this.id}) : super(key: key);

  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  @override
  Widget build(BuildContext context) {
    Place place = Provider.of<PlacesProvider>(context).findPlaceById(widget.id);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.grey[300].withOpacity(0.4),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const CircleAvatar(
              radius: 16.0,
              backgroundImage: NetworkImage(
                  "https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg"),
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Container(
                height: size.height * 0.5,
                child: Hero(
                    tag: 'PlaceDetail' + widget.id.toString(),
                    child: Image.network(place.imageUrl, fit: BoxFit.cover))),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.44),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: size.height * 0.7,
              child: Column(
                children: [
                  setPadding(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                place.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Chip(
                                  backgroundColor: Colors.green,
                                  label: Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 16, color: Colors.white),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${place.rating}/5',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFFFF7800),
                            ),
                            Text(place.location,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  setPadding(
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Features',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Wrap(
                            children: [
                              for (var i = 0; i < place.features.length; i++)
                                featureItem(place.features[i], i)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    flex: 2,
                    child: setPadding(Container(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: [Text(place.description)],
                      ),
                    )),
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 4.0,
                              spreadRadius: 6.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<PlacesProvider>(
                                builder: (ctx, placeState, _) => Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Color(0xFF98e8fa), width: 2),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      placeState.addFavourite(widget.id);

                                      if (place.isFavourite)
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Places added to favourite")));
                                    },
                                    child: Icon(
                                        place.isFavourite
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: Color(0xFF98e8fa)),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFFF7800),
                                  ),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 13),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('BOOK NOW'),
                              ),
                            ],
                          ),
                        ) // child widget, replace with your own
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
//  boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(0.0, 1.0), //(x,y)
//                     blurRadius: 6.0,
//                   ),
//                 ],

Color getRandomColor() {
  Random random = new Random();
  List<Color> colors = [
    Color(0xfcba03),
    Color(0xFF2f8fde),
    // Color(0xFF8f2f17),
    // Color(0xFFffd503),
  ];
  int randomNumber = random.nextInt(colors.length);
  print(colors[randomNumber]);
  return Color(0xFFfcba03);
  // return colors[randomNumber];
}

Widget featureItem(String title, int i) {
  Color color = i % 2 == 0 ? Color(0xFF2f8fde) : Color(0xFFfcba03);
  double width = 50;
  return Container(
      margin: EdgeInsets.all(5),
      alignment: Alignment.bottomLeft,
      width: width,
      height: 54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 4),
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: iconUtility(title),
          ),
          SizedBox(
            height: 4,
          ),
          Text(title),
        ],
      ));
}

Widget setPadding(child) {
  return Padding(
    padding: EdgeInsets.only(left: 25, top: 10, right: 1),
    child: child,
  );
}

Widget iconUtility(String feature) {
  switch (feature.toLowerCase()) {
    case 'wifi':
      return Icon(Icons.wifi);
      break;
    case 'parking':
      return Icon(Icons.local_parking_outlined);
      break;
    case 'bar':
      return Icon(Icons.view_week_outlined);
      break;
    case 'gym':
      return Icon(Icons.fitness_center_outlined);
      break;
    case 'heater':
      return Icon(Icons.microwave_outlined);
      break;
    case 'food':
      return Icon(Icons.fastfood_outlined);
      break;
    default:
      return Icon(Icons.wifi);
  }
}
