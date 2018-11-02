import 'dart:collection';

import 'package:flutter/material.dart';
import './global_bloc.dart';
import './state_provider.dart';
import './place_model.dart';
import './sub_model.dart';
import './orders_bloc.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  TabController _tabCont;
  @override
  void didChangeDependencies() {
    final GlobalBloc bloc = Provider.of<GlobalBloc>(context);
    _tabCont = TabController(vsync: this, length: bloc.placesList?.length ?? 0);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Place>>(
      stream: Provider.of<GlobalBloc>(context).places,
      builder: (_, AsyncSnapshot<UnmodifiableListView<Place>> places) {
        if (!places.hasData || places.hasError) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Getting available places'),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text('Cantina Delivery'),
                bottom: TabBar(
                  controller: _tabCont,
                  tabs: places.data
                      .map((Place p) => Tab(
                            text: p.name,
                          ))
                      .toList(),
                ),
              ),
              body: TabBarView(
                  controller: _tabCont,
                  children: List.generate(places.data?.length, (_) {
                   return StatefulProvider<OrdersBloc>(
                      valueBuilder:
                          (BuildContext context, OrdersBloc oldBloc) =>
                              oldBloc ??
                              OrdersBloc(places.data[_tabCont.index]?.uid),
                      onDispose: (BuildContext context, OrdersBloc bloc) =>
                          bloc.dipose(),
                      child: OrdersScreen(),
                    );
                  }))
              //   places.data
              //       .map((Place p) => OrdersScreen(place: p))
              //       .toList(),
              // ),
              );
        }
      },
    );
  }
}

class OrdersScreen extends StatelessWidget {
  final Place place;
  final String uid;
  OrdersScreen({Key key, this.place, this.uid}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<Sub>>(
      stream: Provider.of<OrdersBloc>(context).subs,
      builder: (_, AsyncSnapshot<UnmodifiableListView<Sub>> subs) {
        if (!subs.hasData || subs.hasError) {
         
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: subs.data?.length,
            itemBuilder: (_, int index) {
              return ListTile(
                title: Text(subs.data[index]?.phoneNumber??''),
                subtitle: Text(subs.data[index]?.subType??''),
              );
            },
          );
        }
      },
    );
  }
}
