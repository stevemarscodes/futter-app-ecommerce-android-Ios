import 'package:animate_do/animate_do.dart';
import 'package:australti_ecommerce_app/bloc_globals/notitification.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_bloc.dart';

import 'package:australti_ecommerce_app/models/store.dart';

import 'package:australti_ecommerce_app/profile_store.dart/product_detail.dart';
import 'package:australti_ecommerce_app/profile_store.dart/profile.dart';
import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';

import 'package:australti_ecommerce_app/services/catalogo.dart';
import 'package:australti_ecommerce_app/services/order_service.dart';
import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:australti_ecommerce_app/widgets/show_alert_error.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../global/extension.dart';
import 'order_progress.dart/progressBar.dart';

class MyNotifications extends StatefulWidget {
  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

const _textColor = Color(0xFF5C5657);

class _MyNotificationsState extends State<MyNotifications> {
  SocketService socketService;

  final category = new ProfileStoreCategory(id: '');

  bool loading = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    // final roomsModel = Provider.of<Room>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: <Widget>[
              makeHeaderCustom('Notificaciones'),
              makeListNotifications(context)
              //makeListProducts(context)
            ]),
      ),
    );
  }

  SliverList makeListNotifications(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      NotificationList(loading: loading),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: CustomAppBarHeaderPages(
                  showTitle: _showTitle,
                  title: title,
                  isAdd: false,
                  leading: true,
                  action: Container(),
                  //   Container()
                ))));
  }
}

class NotificationList extends StatefulWidget {
  NotificationList({this.loading});

  final bool loading;

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with TickerProviderStateMixin {
  final catalogoService = new StoreCategoiesService();

  List<TabCategory> catalogos = [];

  List<TabCategory> catalogosOrderPosition = [];
  SlidableController slidableController;
  Store storeAuth;
  @override
  void initState() {
    super.initState();
  }

  bool expanded = false;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final _bloc = Provider.of<OrderService>(context);

    final odersNotificationsClient = _bloc.orders;

    final odersNotificationsStore = _bloc.ordersStore;
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, left: 0),
            child: Text(
              'Notificaciones',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: currentTheme.accentColor),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: odersNotificationsClient.length,
              itemBuilder: (context, index) {
                if (odersNotificationsClient.length > 0) {
                  final order = odersNotificationsClient[index];
                  return Container(
                    height: _size.height / 5.1,
                    child: OrderNotificationStoreCard(
                      order: order,
                      isStore: false,
                    ),
                  );
                } else {
                  return Center(
                      child: Container(
                    child: Text('Aun no tienes notificaciones'),
                  ));
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: odersNotificationsStore.length,
              itemBuilder: (context, index) {
                final order = odersNotificationsStore[index];
                return Container(
                  height: _size.height / 5.1,
                  child: OrderNotificationStoreCard(
                    order: order,
                    isStore: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderNotificationStoreCard extends StatelessWidget {
  OrderNotificationStoreCard({this.order, this.isStore = false});

  final Order order;

  final bool isStore;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final id = order.id;

    final store = order.store;

    final notifiBloc = Provider.of<NotificationModel>(context);
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(context, orderProggressRoute(order, false, isStore));
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: currentTheme.cardColor,
        child: GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(left: 15, bottom: 0),
            child: SizedBox(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    child: Hero(
                      tag: 'order/$id',
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          child: (store.imageAvatar != "")
                              ? Container(
                                  child: cachedNetworkImage(
                                    store.imageAvatar,
                                  ),
                                )
                              : Image.asset(currentProfile.imageAvatar),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, right: 10),
                              child: Text(
                                (order.isCancelByClient ||
                                        order.isCancelByStore)
                                    ? 'Pedido cancelado'
                                    : (isStore)
                                        ? 'Pedido recibido'
                                        : 'Pedido en curso',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            if (isStore)
                              if (order.isNotifiCheckStore)
                                StreamBuilder(
                                  stream: notifiBloc.numberSteamNotifiBell,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    int number = (snapshot.data != null)
                                        ? snapshot.data
                                        : 0;

                                    if (number > 0)
                                      return Container(
                                        margin: EdgeInsets.only(right: 0),
                                        alignment: Alignment.centerRight,
                                        child: BounceInDown(
                                          from: 5,
                                          animate: (number > 0) ? true : false,
                                          child: Bounce(
                                            delay: Duration(seconds: 2),
                                            from: 5,
                                            controller: (controller) =>
                                                Provider.of<NotificationModel>(
                                                            context)
                                                        .bounceControllerBell =
                                                    controller,
                                            child: Container(
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              alignment: Alignment.center,
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  color:
                                                      currentTheme.accentColor,
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        ),
                                      );

                                    return Container();
                                  },
                                ),
                            if (!isStore)
                              if (order.isNotifiCheckClient)
                                StreamBuilder(
                                  stream: notifiBloc.numberSteamNotifiBell,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    int number = (snapshot.data != null)
                                        ? snapshot.data
                                        : 0;

                                    if (number > 0)
                                      return Container(
                                        margin: EdgeInsets.only(right: 0),
                                        alignment: Alignment.centerRight,
                                        child: BounceInDown(
                                          from: 5,
                                          animate: (number > 0) ? true : false,
                                          child: Bounce(
                                            delay: Duration(seconds: 2),
                                            from: 5,
                                            controller: (controller) =>
                                                Provider.of<NotificationModel>(
                                                            context)
                                                        .bounceControllerBell =
                                                    controller,
                                            child: Container(
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              alignment: Alignment.center,
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  color:
                                                      currentTheme.accentColor,
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        ),
                                      );

                                    return Container();
                                  },
                                ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0),
                          child: Text(
                            'Entrega estimada: 4 de Agosto',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                        Container(
                            child: ProgressBar(
                          key: ValueKey('order/$id'),
                          order: order,
                          principal: true,
                          isStore: isStore,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileStoreProductItem extends StatelessWidget {
  const ProfileStoreProductItem(this.product, this.categoryId);

  final String categoryId;

  final ProfileStoreProduct product;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final groceryBloc = Provider.of<GroceryStoreBLoC>(context);

    final _bloc = Provider.of<TabsViewScrollBLoC>(context);

    final tag = 'list_${product.images[0].url + product.name + '0'}';
    final size = MediaQuery.of(context).size;
    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(product.price);

    return GestureDetector(
      onTap: () async {
        groceryBloc.changeToDetails();
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    fromFavorites: true,
                    category: categoryId,
                    isAuthUser: false,
                    product: product,
                    bloc: _bloc,
                    onProductAdded: (int quantity) {
                      groceryBloc.addProduct(product, quantity);

                      _listenNotification(context);

                      showSnackBar(context, 'Agregado a la bolsa');
                    }),
              );
            },
          ),
        );
        groceryBloc.changeToNormal();
      },
      child: Container(
        height: size.height / 5.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: currentTheme.currentTheme.cardColor,
            child: Row(
              children: [
                Container(
                  child: Hero(
                      tag: tag,
                      child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  child: cachedContainNetworkImage(
                                      product.images[0].url))))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width / 2,
                        child: Text(
                          product.name.capitalize(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: (currentTheme.customTheme)
                                ? Colors.white
                                : _textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: size.width / 2,
                        child: Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$$priceformat',
                        style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : _textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listenNotification(context) {
    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;
    number++;
    notifiModel.numberNotifiBell = number;

    if (number >= 2) {
      //final controller = notifiModel.bounceControllerBell;
      //controller.forward(from: 0.0);
    }
  }
}
