import 'package:australti_ecommerce_app/authentication/auth_bloc.dart';
import 'package:australti_ecommerce_app/models/store.dart';
import 'package:australti_ecommerce_app/pages/add_edit_product.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/header_pages_custom.dart';
import 'package:australti_ecommerce_app/widgets/image_cached.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/profile_store.dart/product_detail.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import '../global/extension.dart';

const _textColor = Color(0xFF5C5657);

class ProductsByCategoryStorePage extends StatefulWidget {
  ProductsByCategoryStorePage(
      {@required this.category, this.products, this.bloc});

  final List<ProfileStoreProduct> products;
  final ProfileStoreCategory category;

  final TabsViewScrollBLoC bloc;
  @override
  _ProductsByCategoryStorePage createState() => _ProductsByCategoryStorePage();
}

Store storeAuth;

class _ProductsByCategoryStorePage extends State<ProductsByCategoryStorePage> {
  final product = new ProfileStoreProduct(id: '', name: '');

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    final authBloc = Provider.of<AuthenticationBLoC>(context, listen: false);

    storeAuth = authBloc.storeAuth;
    // tabsViewScrollBLoC.productsByCategory(widget.category.id);

    final productsBloc =
        Provider.of<TabsViewScrollBLoC>(context, listen: false);

    productsBloc.productsByCategory(widget.category.id);

    super.initState();
  }

  @override
  void didUpdateWidget(Widget old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    super.dispose();
  }

  TabController controller;

  int itemCount;
  IndexedWidgetBuilder tabBuilder;
  IndexedWidgetBuilder pageBuilder;
  Widget stub;
  ValueChanged<int> onPositionChange;
  ValueChanged<double> onScroll;
  int initPosition;
  bool isFallow;

  List<ProfileStoreProduct> productsByCategoryList = [];

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    productsByCategoryList =
        Provider.of<TabsViewScrollBLoC>(context).productsByCategoryList;

    return SafeArea(
      child: Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,

          // tab bar view

          body: NotificationListener<ScrollEndNotification>(
            onNotification: (_) {
              return false;
            },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                slivers: <Widget>[
                  makeHeaderCustom(widget.category.name),
                  makeListProducts(context)
                  //makeListProducts(context)
                ]),
          )),
    );
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
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                      showTitle: _showTitle,
                      title: title,
                      isAdd: true,
                      leading: true,
                      action: Container(),
                      onPress: () => {
                        HapticFeedback.lightImpact(),
                        Navigator.of(context).push(createRouteAddEditProduct(
                            product, false, widget.category.id)),
                      },
                      //   Container()
                      /*  IconButton(
                              icon: Icon(
                                Icons.add,
                                color: currentTheme.accentColor,
                              ),
                              iconSize: 30,
                              onPressed: () => {
                                    /*  Navigator.of(context).push(
                                        createRouteAddCatalogo(
                                            catalogo, false)), */
                                  }), */
                    )))));
  }

  SliverList makeListProducts(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      _buildProductsList(),
    ]));
  }

  Widget _buildProductsList() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              widget.category.name.capitalize(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 0),
            child: Text(
              'PRODUCTOS',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              controller: widget.bloc.scrollController,
              itemCount: productsByCategoryList.length,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemBuilder: (context, index) {
                final item = productsByCategoryList[index];

                return _ProfileAuthStoreProductItem(item, widget.category.id);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileAuthStoreProductItem extends StatelessWidget {
  const _ProfileAuthStoreProductItem(this.product, this.category);
  final ProfileStoreProduct product;
  final String category;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(product.price);

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: ProductStoreDetails(
                    category: category,
                    isAuthUser: true,
                    product: product,
                    onProductAdded: (int quantity) {}),
              );
            },
          ),
        );
      },
      child: Container(
        height: size.height / 5.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: currentTheme.currentTheme.cardColor,
            child: Row(
              children: [
                Container(
                  child: Hero(
                      tag: 'list_${product.images[0].url + product.name + '0'}',
                      child: Container(
                          width: 100,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              child: cachedContainNetworkImage(
                                  product.images[0].url)))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                      if (product.description != "")
                        Container(
                          width: size.width / 2,
                          child: Text(
                            product.description.capitalize(),
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
}

/* void _listenNotification(context) {
  final notifiModel = Provider.of<NotificationModel>(context, listen: false);
  int number = notifiModel.numberNotifiBell;
  number++;
  notifiModel.numberNotifiBell = number;

  if (number >= 2) {
    final controller = notifiModel.bounceControllerBell;
    controller.forward(from: 0.0);
  }
}
 */

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search,
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
            SizedBox(width: 10),
            Container(
                // margin: EdgeInsets.only(top: 0, left: 0),
                child: Text('Search product ...',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Route createRouteAddEditProduct(
    ProfileStoreProduct product, bool isEdit, String category) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateProductPage(
            product: product, isEdit: isEdit, category: category),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}
