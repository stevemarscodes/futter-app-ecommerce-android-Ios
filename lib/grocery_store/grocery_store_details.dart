import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_product.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../global/extension.dart';

const _textHighColor = Color(0xFF241E1E);
const _textColor = Color(0xFF5C5657);

class GroceryStoreDetails extends StatefulWidget {
  const GroceryStoreDetails({
    Key key,
    @required this.product,
    this.onProductAdded,
  }) : super(key: key);
  final GroceryProduct product;
  final ValueChanged<int> onProductAdded;

  @override
  _GroceryStoreDetailsState createState() => _GroceryStoreDetailsState();
}

class _GroceryStoreDetailsState extends State<GroceryStoreDetails> {
  String heroTag = '';
  int quantity = 1;

  void _addToCart(BuildContext context) {
    setState(() {
      heroTag = 'details';
    });
    widget.onProductAdded(quantity);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final priceformat =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Hero(
                          tag: 'list_${widget.product.name}$heroTag',
                          child: Image.asset(
                            widget.product.image,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.36,
                          ),
                        ),
                      ),
                      Text(
                        widget.product.name.capitalize(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: _textHighColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.weight,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: _textColor,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _textColor,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 2) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            '\$$priceformat',
                            style:
                                Theme.of(context).textTheme.headline4.copyWith(
                                      color: _textHighColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'About the product',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: _textColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.product.description,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w200,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 25,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                        onPressed: () => null,
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            currentTheme.currentTheme.primaryColor),
                      ),
                      /*    color: Color(0xFFF4C459),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), */
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () => _addToCart(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
