import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/cores/widgets/widget_animation_click.dart';
import 'package:shoppi_frontend/features/auth/pages/login_screen.dart';
import 'package:shoppi_frontend/features/cart/pages/cart_screen.dart';
import 'package:shoppi_frontend/features/order/pages/order_screen.dart';
import 'package:shoppi_frontend/features/product/bloc/product_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/product_event.dart';
import 'package:shoppi_frontend/features/product/bloc/product_state.dart';
import 'package:shoppi_frontend/features/product/bloc/review/review_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/review/review_event.dart';
import 'package:shoppi_frontend/features/product/bloc/review/review_state.dart';
import 'package:shoppi_frontend/features/product/data/input_review_model.dart';
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
  final ReviewBloc reviewBloc = ReviewBloc();
  ProductModel? product;
  List<ReviewModel> listReview = [];
  bool canReview = false;
  final TextEditingController commentController = TextEditingController();
  double rating = 0;

  @override
  void initState() {
    super.initState();
    productBloc.add(EventProductDetail(widget.productId));
    reviewBloc.add(EventCheckReviewable(id: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => productBloc,
        ),
        BlocProvider(
          create: (context) => reviewBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
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
          ),
          BlocListener<ReviewBloc, ReviewState>(
            bloc: reviewBloc,
            listener: (context, state) {
              if (state is StateCheckReviewable) {
                setState(() {
                  canReview = state.result ?? false;
                });
              }

              if (state is StateAddReview) {
                if (state.success == true) {
                  productBloc.add(EventProductDetail(widget.productId));
                }
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFFF5722),
            title: Row(
              children: [
                const Icon(Icons.shopping_bag, size: 40, color: Colors.white),
                const SizedBox(width: 8),
                WidgetAnimationClick(
                  onTap: () => context.pop(),
                  child: const Text(
                    'Shoppi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for products, brands, and more...",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5722),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.receipt_long),
                tooltip: "My Orders",
                onPressed: () => context.goPage(const OrderScreen()),
              ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (canReview) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Leave a Review",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Review text input
                              TextField(
                                controller: commentController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: 'Write your review here...',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Rating stars with improved design
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      index < rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        rating = index +
                                            1.0; // Update rating on click
                                      });
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 16),
                              // Submit Review Button
                              ElevatedButton(
                                onPressed: () {
                                  final review = InputReviewModel(
                                    productId: widget.productId,
                                    rating: rating.toInt(),
                                    comment: commentController.text,
                                  );
                                  reviewBloc
                                      .add(EventAddReview(review: review));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF5722),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    "Submit Review",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                      if (listReview.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          "Customer Reviews",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        for (var review in listReview) _buildReview(review),
                      ] else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "No reviews yet. Be the first to review!",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
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

  Widget _buildReview(ReviewModel review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (review.rating ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                // Reviewer's name
                Text(
                  review.userId ?? "Anonymous",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Review comment
            Text(
              review.comment ?? "No comments",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
