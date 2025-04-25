import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/cores/widgets/widget_animation_click.dart';
import 'package:shoppi_frontend/features/home/pages/appbar_widget.dart';
import 'package:shoppi_frontend/features/product/bloc/product_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/product_event.dart';
import 'package:shoppi_frontend/features/product/bloc/product_state.dart';
import 'package:shoppi_frontend/features/product/data/product_model.dart';
import 'package:shoppi_frontend/features/product/pages/edit_product_screen.dart';
import 'package:shoppi_frontend/features/product/pages/product_detail_screen.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({super.key});

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  final ProductBloc productBloc = ProductBloc();
  List<ProductModel> listProduct = [];
  void _confirmDelete(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              productBloc.add(EventDeleteProduct(productId));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    productBloc.add(const EventMyProduct());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => productBloc,
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is StateMyProduct && state.data != null) {
            setState(() {
              listProduct = state.data!;
            });
          }
          if (state is StateDeleteProduct && state.success == true) {
            productBloc.add(const EventMyProduct());
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFFF5722),
            onPressed: () {
              context.goPage(EditProductScreen(
                onSave: () {
                  productBloc.add(const EventMyProduct());
                },
              ));
            },
            child: const Icon(Icons.add),
          ),
          appBar: const ShoppiAppBar(),
          body: listProduct.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: listProduct.length,
                  itemBuilder: (context, index) {
                    final product = listProduct[index];
                    return WidgetAnimationClick(
                      onTap: () {
                        context.goPage(
                            ProductDetailScreen(productId: product.id ?? ""));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                child: Image.network(
                                  product.image ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name ?? "Product Name",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${product.price?.toStringAsFixed(2) ?? "0.00"} \$",
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      product.description ?? "",
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(height: 8),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          "${product.stock ?? 0} left",
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.edit, size: 18),
                                          onPressed: () {
                                            context.goPage(EditProductScreen(
                                              product: product,
                                              onSave: () {
                                                productBloc.add(
                                                    const EventMyProduct());
                                              },
                                            ));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.red, size: 18),
                                          onPressed: () {
                                            _confirmDelete(product.id ?? "");
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
