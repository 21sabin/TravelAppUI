import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travel_app/provider/places.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/screens/favourite_place_screen.dart';
import 'package:travel_app/screens/place_search_deligate_screen.dart';
import './place_detail.dart';
import './circulatIndicator.dart';

const kHeaderTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Widget> widgets = [Places(), Emotions(), Inspiration()];

  bool flag = true;
  int index = 0;
  bool init = false;
  List<String> listOptions = ['Places', 'Inspiration', 'Emotions'];
  @override
  void initState() {
    super.initState();
  }

  Future<void> getPlacesData() async {
    await Provider.of<PlacesProvider>(context, listen: false).getPlaces();
    setState(() {
      init = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!init) {
      getPlacesData();
    }
  }

  void updateIndex(int i) {
    setState(() {
      index = i;
    });
  }

  void onClose() {
    setState(() {
      selectedIndex = 0;
    });
  }

  int selectedIndex = 0;
  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (selectedIndex == 1) {
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => FavouritePlaceList()))
          .then((value) => setState(() {
                selectedIndex = 0;
              }));
    } else if (selectedIndex == 2) {
      showSearch(context: context, delegate: PlaceSearchDelegate(onClose));
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel is never',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'a matter of money',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 16.0,
                  backgroundImage: NetworkImage(
                      "https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg"),
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  'Zillur Mia',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: bottomNavBar(selectedIndex, onItemTap),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Text('Travel is never', style: kHeaderTextStyle),
              //     const Text('a matter of money', style: kHeaderTextStyle)
              //   ],
              // ),
              // if (flag) ...[Text('test'), Text('second')],
              //tabbar
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Expanded(
                    child: TabBar(
                      labelPadding: const EdgeInsets.only(left: 5, right: 30),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      isScrollable: true,
                      indicator: CircleTabIndicator(
                          color: Color(0xFFFF7800), radius: 4),
                      // controller: tabController,
                      tabs: [
                        Tab(text: 'Places'),
                        Tab(text: 'Inspiration'),
                        Tab(text: 'Emotions'),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  // height: 450,
                  // width: double.maxFinite,
                  child: TabBarView(
                    // controller: tabController,
                    children: [
                      SingleChildScrollView(
                        child: Places(),
                      ),
                      Text('hi'),
                      Text('hi'),
                    ],
                  ),
                ),
              )
              //end tabbar
            ],
          ),
        ),
      ),
    );
  }
}

Widget dotIndicator() {
  return Container(
    width: 5,
    height: 5,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.deepPurpleAccent,
    ),
  );
}

class Places extends StatelessWidget {
  const Places({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<PlacesProvider>(context).placesList;
    return places.length > 0
        ? StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            itemCount: places.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => PlaceDetail(
                            id: places[index].id,
                          )));
                },
                child: Container(
                  // height: 100,
                  // width: 80,

                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'PlaceDetail' + places[index].id.toString(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

Widget bottomNavBar(int index, Function(int index) onTapItem) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    currentIndex: index,
    selectedItemColor: Color(0xFFFF7800),
    unselectedItemColor: Colors.grey.withOpacity(0.5),
    onTap: onTapItem,
    items: [
      BottomNavigationBarItem(
        icon: new Icon(Icons.apps_outlined),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite_border_outlined,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search_outlined),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outlined),
        label: '',
      )
    ],
  );
}

class Emotions extends StatelessWidget {
  const Emotions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Emotions comming soon'));
  }
}

class Inspiration extends StatelessWidget {
  const Inspiration({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Inspiration comming soon'));
  }
}
