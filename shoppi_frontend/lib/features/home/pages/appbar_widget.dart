import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/cores/store/store.dart';
import 'package:shoppi_frontend/cores/widgets/widget_animation_click.dart';
import 'package:shoppi_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:shoppi_frontend/features/auth/bloc/auth_state.dart';
import 'package:shoppi_frontend/features/auth/pages/login_screen.dart';
import 'package:shoppi_frontend/features/cart/pages/cart_screen.dart';
import 'package:shoppi_frontend/features/home/pages/home_screen.dart';
import 'package:shoppi_frontend/features/order/pages/order_screen.dart';
import 'package:shoppi_frontend/cores/extensions/extension_context.dart';
import 'package:shoppi_frontend/features/product/pages/my_product_screen.dart';

class ShoppiAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ShoppiAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ShoppiAppBar> createState() => _ShoppiAppBarState();
}

class _ShoppiAppBarState extends State<ShoppiAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isSeller = CacheData.instant.userType.isNotEmpty &&
            CacheData.instant.userType == "Seller";

        return AppBar(
          backgroundColor: const Color(0xFFFF5722),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Icon(Icons.shopping_bag, size: 40, color: Colors.white),
              const SizedBox(width: 8),
              WidgetAnimationClick(
                onTap: () => context.goPage(const HomeScreen()),
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
            if (isSeller && state is! StateLogout)
              IconButton(
                onPressed: () => context.goPage(const MyProductScreen()),
                icon: const Icon(Icons.store, color: Colors.white),
              ),
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
        );
      },
    );
  }
}
