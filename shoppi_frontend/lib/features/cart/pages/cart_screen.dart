import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/features/cart/data/cart_model.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_bloc.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_event.dart';
import 'package:shoppi_frontend/features/cart/bloc/cart_state.dart';
import 'package:shoppi_frontend/features/order/bloc/order_bloc.dart';
import 'package:shoppi_frontend/features/order/bloc/order_event.dart';
import 'package:shoppi_frontend/features/order/bloc/order_state.dart';
import 'package:shoppi_frontend/features/order/data/input_order_model.dart';
import 'package:shoppi_frontend/features/order/pages/order_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartBloc cartBloc = CartBloc();
  final OrderBloc orderBloc = OrderBloc();

  List<CartItemModel> cartItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    cartBloc.add(EventGetCart());
  }

  void _updateQuantity(String productId, int newQuantity) {
    cartBloc.add(EventUpdateCart(id: productId, quantity: newQuantity));
  }

  void _removeItem(String productId) {
    cartBloc.add(EventModifyCart(id: productId, clear: false));
  }

  void _clearCart() {
    cartBloc.add(const EventModifyCart(clear: true));
  }

  double _calculateTotal() {
    return cartItems.fold(
      0,
      (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 0)),
    );
  }

  void _placeOrder() {
    if (cartItems.isEmpty) return;

    final items = cartItems
        .map((item) => InputOrderModel(
              productId: item.productId ?? '',
              quantity: item.quantity ?? 1,
            ))
        .toList();

    orderBloc.add(EventCreateOrder(items: items));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => cartBloc),
        BlocProvider(create: (_) => orderBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _clearCart,
            )
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<CartBloc, CartState>(
              listener: (context, state) {
                if (state is StateGetCart) {
                  setState(() {
                    if (state.success) {
                      cartItems = state.data ?? [];
                      errorMessage = null;
                    } else {
                      errorMessage = state.message ?? 'Failed to load cart';
                    }
                    isLoading = false;
                  });
                } else if (state is StateUpdateCart ||
                    state is StateModifyCart) {
                  cartBloc.add(EventGetCart());
                }
              },
            ),
            BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is StateCreateOrder) {
                  if (state.success) {
                    cartBloc.add(const EventModifyCart(clear: true));
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const OrderScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message ?? 'Order failed'),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
              },
            ),
          ],
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text('Error: $errorMessage'))
                  : cartItems.isEmpty
                      ? const Center(child: Text('Your cart is empty.'))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
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
                                                _updateQuantity(item.productId!,
                                                    item.quantity! - 1);
                                              }
                                            },
                                          ),
                                          Text('${item.quantity}'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              _updateQuantity(item.productId!,
                                                  item.quantity! + 1);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () =>
                                                _removeItem(item.productId!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
