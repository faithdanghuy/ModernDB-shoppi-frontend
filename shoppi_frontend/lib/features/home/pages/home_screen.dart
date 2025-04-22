import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/cores/gen/assets.gen.dart';
import 'package:shoppi_frontend/cores/widgets/widget_animation_click.dart';
import 'package:shoppi_frontend/features/auth/pages/login_screen.dart';
import 'package:shoppi_frontend/features/cart/pages/cart_screen.dart';
import 'package:shoppi_frontend/features/order/pages/order_screen.dart';
import 'package:shoppi_frontend/features/product/bloc/product_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/product_event.dart';
import 'package:shoppi_frontend/features/product/bloc/product_state.dart';
import 'package:shoppi_frontend/features/product/data/product_model.dart';
import 'package:shoppi_frontend/features/product/pages/product_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductBloc productBloc = ProductBloc();
  List<ProductModel> listProduct = [];
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentBannerIndex = 0;

  final List<String> bannerImages = [
    Assets.lib.features.home.assets.banner1.path,
    Assets.lib.features.home.assets.banner2.path,
  ];

  @override
  void initState() {
    super.initState();
    productBloc.add(const EventProductList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => productBloc,
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is StateProductList && state.data != null) {
            setState(() {
              listProduct = state.data!;
            });
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFF5722),
            elevation: 0,
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 8),
                ),
              ),
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
          body: RefreshIndicator(
            onRefresh: () async {
              productBloc.add(const EventProductList());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          autoPlayInterval: const Duration(seconds: 3),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentBannerIndex = index;
                            });
                          },
                        ),
                        items: bannerImages.map((imageUrl) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.2),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSmoothIndicator(
                        activeIndex: _currentBannerIndex,
                        count: bannerImages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Colors.deepOrange,
                          dotColor: Colors.grey.shade300,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 6,
                          expansionFactor: 3,
                        ),
                        onDotClicked: (index) {
                          _carouselController.animateToPage(index);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  listProduct.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                context.goPage(ProductDetailScreen(
                                    productId: product.id ?? ""));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
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
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              "${product.price?.toStringAsFixed(2) ?? "0.00"} ₫",
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
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const SizedBox(height: 8),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.orange,
                                                    size: 14),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "${product.rating ?? 0}",
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "${product.stock ?? 0} left",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
