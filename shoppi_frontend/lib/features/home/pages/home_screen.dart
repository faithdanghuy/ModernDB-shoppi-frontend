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

  final List<Map<String, String>> categories = [
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/2f/52/8e/00ab5fbea9d35fcc3cadbc28d7c6b14e.png',
      'title': 'TOP DEAL',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/72/8d/23/a810d76829d245ddd87459150cb6bc77.png',
      'title': 'Shoppi Trading',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/8b/a4/9f/84d844f70e365515b6e4e3e745dac1d5.png',
      'title': 'Coupon siêu hot',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/a5/d8/06/cb6ff520f12973013c81a8b14ad5e5b3.png',
      'title': 'Xả kho giảm nửa giá',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/61/0d/97/fb78a6e527eeea974705bcb7ba009a36.png',
      'title': 'Deal hời mỗi ngày',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/2c/22/e0/d9d268206e9224b0f8ec5efb4095fdad.png',
      'title': 'Du lịch sành điệu',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/c6/9c/4b/ddd8330163b9432e5f81b8429ca8b8f0.png',
      'title': 'Hạ Nhiệt Thần Tốc',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/b2/05/8a/cbdd6befd51ca4945290f6df9522ac52.png',
      'title': 'Đón đầu xu hướng',
    },
    {
      'iconUrl':
          'https://salt.tikicdn.com/ts/upload/b5/71/55/e2ccf948e0d8b14a646d2b8fe07cac37.png',
      'title': 'Mua là có quà',
    },
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
            title: Row(
              children: [
                const Icon(Icons.shopping_bag, size: 40, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'Shoppi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
          body: RefreshIndicator(
            onRefresh: () async {
              productBloc.add(const EventProductList());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  height: 180,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.9,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentBannerIndex = index;
                                    });
                                  },
                                ),
                                items: bannerImages.map((imageUrl) {
                                  return ClipRRect(
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
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      Assets.lib.features.home.assets.banner1
                                          .path,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      Assets.lib.features.home.assets.banner2
                                          .path,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    child: Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(categories.length, (index) {
                          final category = categories[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                category['iconUrl']!,
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category['title']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
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
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const SizedBox(height: 8),
                                            const Spacer(),
                                            Row(
                                              children: [
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFFF5722),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Shoppi is your one-stop shop for all your needs. We provide the best deals, fast delivery, and excellent customer service.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Contact Us",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Email: support@shoppi.com\nPhone: +123 456 7890",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
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
