import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/features/home/pages/home_screen.dart';
import 'package:shoppi_frontend/features/order/bloc/order_bloc.dart';
import 'package:shoppi_frontend/features/order/bloc/order_event.dart';
import 'package:shoppi_frontend/features/order/bloc/order_state.dart';
import 'package:shoppi_frontend/features/order/data/input_order_model.dart';
import 'package:shoppi_frontend/features/order/data/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderBloc orderBloc = OrderBloc();
  List<OrderModel> orders = [];
  bool isLoading = true;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    orderBloc.add(EventGetOrder());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isPaid) {
          context.goUntil(const HomeScreen());
          return false;
        } else {
          return true;
        }
      },
      child: BlocProvider(
        create: (context) => orderBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("My Orders"),
            backgroundColor: const Color(0xFFFF5722),
          ),
          body: BlocListener<OrderBloc, OrderState>(
            bloc: orderBloc,
            listener: (context, state) {
              if (state is StateGetOrder) {
                if (state.success) {
                  setState(() {
                    orders = state.data ?? [];
                    isLoading = false;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(state.message ?? 'Error fetching orders')),
                  );
                }
              }
              if (state is StateOrderPayment) {
                if (state.success) {
                  setState(() {
                    isLoading = true;
                    isPaid = true;
                    orderBloc.add(EventGetOrder());
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment successful!")),
                  );
                }
              }
            },
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                    ? const Center(child: Text('No orders found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Order #${order.id?.substring(0, 6)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Chip(
                                        label:
                                            Text(order.status!.toUpperCase()),
                                        backgroundColor:
                                            order.status == "pending"
                                                ? Colors.orange.shade100
                                                : Colors.green.shade100,
                                        labelStyle:
                                            const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ...order.items!.map((product) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                product.product?.image ?? "",
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.product?.name ?? "",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "${product.quantity} x \$${product.product?.price?.toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total: \$${order.totalAmount}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      if (order.status != "paid")
                                        ElevatedButton(
                                          onPressed: () {
                                            final items = order.items!
                                                .map((item) => InputOrderModel(
                                                      productId: item
                                                              .productId ??
                                                          item.product?.id ??
                                                          '',
                                                      quantity:
                                                          item.quantity ?? 1,
                                                    ))
                                                .toList();
                                            orderBloc.add(EventOrderPayment(
                                                id: order.id ?? '',
                                                items: items));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFFF5722),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          child: const Text(
                                            "Pay Now",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
