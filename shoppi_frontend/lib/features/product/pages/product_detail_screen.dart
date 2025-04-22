import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/features/auth/pages/login_screen.dart';
import 'package:shoppi_frontend/features/cart/pages/cart_screen.dart';
import 'package:shoppi_frontend/features/product/bloc/product_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/product_event.dart';
import 'package:shoppi_frontend/features/product/bloc/product_state.dart';
import 'package:shoppi_frontend/features/product/data/product_model.dart';
import 'package:shoppi_frontend/features/product/data/review_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductBloc productBloc = ProductBloc();
  ProductModel? product;
  List<ReviewModel> listReview = [];

  @override
  void initState() {
    super.initState();
    productBloc.add(EventProductDetail(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => productBloc,
      child: BlocListener<ProductBloc, ProductState>(
        bloc: productBloc,
        listener: (context, state) {
          if (state is StateProductDetail) {
            if (state.success == true) {
              setState(() {
                product = state.data;
                listReview = state.dataReview ?? [];
              });
            }
          }
          if (state is StateAddToCart && state.success == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Added to cart successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFFF5722),
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search on Shopee",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 8),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.goPage(const CartScreen()),
              ),
              const WidgetLoginIcon(),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: product != null ? 1 : 0,
                    itemBuilder: (context, index) {
                      if (product == null) return const SizedBox.shrink();
                      return Image.network(
                        product?.image ?? "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? "",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${product?.price.toString() ?? ""} \$",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          productBloc.add(EventAddToCart(product?.id ?? ""));
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF5722),
                          side: const BorderSide(color: Color(0xFFFF5722)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Add to Cart"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Product Description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product?.description ?? "",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // ⭐ Reviews
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      for (var review in listReview)
                        _buildReview(
                            review.comment ?? "", review.rating.toString()),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReview(String name, String review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(review),
        const SizedBox(height: 8),
      ],
    );
  }
}
