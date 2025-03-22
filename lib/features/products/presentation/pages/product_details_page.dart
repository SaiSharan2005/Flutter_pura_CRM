import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/products/domain/entities/product_entity.dart';
import 'package:pura_crm/features/products/domain/entities/product_variant.dart';
import 'package:pura_crm/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:pura_crm/features/products/presentation/widgets/product_image_slider.dart';
import 'package:pura_crm/features/products/presentation/widgets/product_info_section.dart';
import 'package:pura_crm/features/products/presentation/widgets/order_section.dart';
import 'package:pura_crm/features/products/presentation/widgets/variant_selector.dart';
import 'package:pura_crm/features/products/presentation/widgets/variant_details.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final GetProductByIdUseCase getProductByIdUseCase;

  const ProductDetailsPage({
    Key? key,
    required this.productId,
    required this.getProductByIdUseCase,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Product> _productFuture;
  ProductVariant? _selectedVariant;
  int _currentImageIndex = 0;
  int? _latestCartId;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.getProductByIdUseCase.call(widget.productId);

    // Listen for latest cart ID from the CartBloc
    // context.read<CartBloc>().stream.listen((state) {
    //   if (state is CartsLoadSuccess && state.carts.isNotEmpty) {
    //     setState(() {
    _latestCartId = 2;
    //     });
    //   }
    // });
  }

  void _onVariantSelected(ProductVariant variant) {
    setState(() {
      _selectedVariant = variant;
      _currentImageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 16)));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('No product data found.',
                    style: TextStyle(fontSize: 16)));
          }

          final product = snapshot.data!;
          _selectedVariant ??=
              product.variants.isNotEmpty ? product.variants.first : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedVariant != null) ...[
                    ProductImageSlider(
                      variant: _selectedVariant!,
                      currentIndex: _currentImageIndex,
                      onPageChanged: (index) =>
                          setState(() => _currentImageIndex = index),
                    ),
                    const SizedBox(height: 16),
                    ProductInfoSection(product: product),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Variant',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    VariantSelector(
                      variants: product.variants,
                      selectedVariant: _selectedVariant!,
                      onVariantSelected: _onVariantSelected,
                    ),
                    const SizedBox(height: 10),
                    VariantDetails(variant: _selectedVariant!),
                    const SizedBox(height: 16),
                  ],
                  if (_latestCartId != null && _selectedVariant != null)
                    OrderSection(
                      variantId: _selectedVariant!.id!,
                      cartId: _latestCartId!,
                    )
                  else
                    const Text("Loading cart details..."),
                  const SizedBox(height: 16),
                  Text(
                    'Created At: ${product.createdDate.toLocal().toString().split(" ")[0]}',
                    style: const TextStyle(fontSize: 16),
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
