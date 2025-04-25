import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/product_bloc.dart';
import 'package:shoppi_frontend/features/product/bloc/product_event.dart';
import 'package:shoppi_frontend/features/product/bloc/product_state.dart';
import 'package:shoppi_frontend/features/product/data/input_product_model.dart';
import 'package:shoppi_frontend/features/product/data/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final Function onSave;
  final ProductModel? product;

  const EditProductScreen({
    super.key,
    required this.onSave,
    this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descController;
  late final TextEditingController priceController;

  final ProductBloc _productBloc = ProductBloc();

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? "");
    descController =
        TextEditingController(text: widget.product?.description ?? "");
    priceController =
        TextEditingController(text: widget.product?.price?.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _productBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "Edit Product" : "Create Product"),
          backgroundColor: const Color(0xFFFF5722),
        ),
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is StateUpdateProduct && state.success == true) {
              widget.onSave();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product updated!"),
                ),
              );
              Navigator.pop(context);
            }
            if (state is StateAddProduct && state.success == true) {
              widget.onSave();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product created!"),
                ),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Something went wrong")),
              );
            }
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildField(
                        controller: nameController,
                        label: "Product Name",
                        validator: (value) =>
                            value!.isEmpty ? "Enter product name" : null,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: descController,
                        label: "Description",
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? "Enter product description" : null,
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: priceController,
                        label: "Price",
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? "Enter price" : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final input = InputProductModel(
                              productId: widget.product?.id ??
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                              name: nameController.text,
                              description: descController.text,
                              price: priceController.text,
                            );
                            widget.product == null
                                ? _productBloc.add(EventAddProduct(input))
                                : _productBloc.add(EventUpdateProduct(input));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5722),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isEdit ? "Update Product" : "Create Product",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
