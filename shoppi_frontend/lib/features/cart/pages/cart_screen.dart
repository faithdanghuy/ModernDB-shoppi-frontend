import 'package:flutter/material.dart';
import 'package:shoppi_frontend/features/cart/data/cart_model.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_bloc.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_event.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartBloc cartBloc = CartBloc();
  List<CartItemModel> cartItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    cartBloc.add(EventGetCart());
    await Future.delayed(
        const Duration(milliseconds: 500)); // Wait for Bloc async to complete

    final state = cartBloc.state;
    if (state is StateGetCart && state.success) {
      setState(() {
        cartItems = state.data ?? [];
        isLoading = false;
      });
    } else if (state is StateGetCart) {
      setState(() {
        errorMessage = state.message;
        isLoading = false;
      });
    }
  }

  void _updateQuantity(String productId, int newQuantity) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        cartItems[index].quantity = newQuantity;
      }
    });

    cartBloc.add(EventUpdateCart(id: productId, quantity: newQuantity));
  }

  void _removeItem(String productId) {
    setState(() {
      cartItems.removeWhere((item) => item.productId == productId);
    });

    cartBloc.add(EventModifyCart(id: productId, clear: false));
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });

    cartBloc.add(const EventModifyCart(clear: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearCart,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : cartItems.isEmpty
                  ? const Center(child: Text('Your cart is empty.'))
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        CartItemModel item = cartItems[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: Image.network(
                              item.image ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.name ?? 'No name'),
                            subtitle: Text(
                                'Price: \$${item.price} x ${item.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if ((item.quantity ?? 1) > 1) {
                                      _updateQuantity(
                                          item.productId!, item.quantity! - 1);
                                    }
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    _updateQuantity(
                                        item.productId!, item.quantity! + 1);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeItem(item.productId!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
