import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pura_crm/features/products/data/models/cartItem_model.dart';
import 'package:pura_crm/features/products/data/models/cart_model.dart';
import 'package:pura_crm/features/products/data/models/inventory_model.dart';
import 'package:pura_crm/features/products/data/models/product_variant_image_model.dart';
import 'package:pura_crm/features/products/data/models/product_variant_model.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/presentation/state/cart_event.dart';
import 'package:pura_crm/features/products/presentation/state/cart_state.dart';

class DemoCartBloc extends Bloc<CartEvent, CartState> {
  final GetCartsByUserIdUseCase getCartsByUserIdUseCase;

  DemoCartBloc({
    required this.getCartsByUserIdUseCase,
  }) : super(CartInitial()) {
    on<GetCartsByUserIdEvent>(_onGetCartsByUserId);
  }

  FutureOr<void> _onGetCartsByUserId(
      GetCartsByUserIdEvent event, Emitter<CartState> emit) async {
    // Simulate a network delay.
    await Future.delayed(const Duration(seconds: 1));

    // --- Variant 1 (500 gm) from JSON sample ---
    final variantImage1a = ProductVariantImageModel(
      id: 2,
      imageUrl:
          "https://res.cloudinary.com/div9ovdhn/image/upload/v1741722071/vybrmvi4sahmyzup6evj.jpg",
    );
    final variantImage1b = ProductVariantImageModel(
      id: 3,
      imageUrl:
          "https://res.cloudinary.com/div9ovdhn/image/upload/v1741722073/lt5gvq8xehrrhqwwkcrp.jpg",
    );
    final productVariant1 = ProductVariantModel(
      id: 2,
      variantName: "500 gm",
      price: 320.00,
      sku: "SKU-001",
      units: "packet",
      createdDate: DateTime.parse("2025-03-11T19:41:10"),
      updatedDate: DateTime.now(),
      imageUrls: [variantImage1a, variantImage1b],
      inventories: [],
    );

    // --- Variant 2 (5 kg) from JSON sample ---
    final variantImage2a = ProductVariantImageModel(
      id: 4,
      imageUrl:
          "https://res.cloudinary.com/div9ovdhn/image/upload/v1741722283/cj0vbg4b2hgakzxfkuoq.jpg",
    );
    final variantImage2b = ProductVariantImageModel(
      id: 5,
      imageUrl:
          "https://res.cloudinary.com/div9ovdhn/image/upload/v1741722284/ytwefzsp8irpk5jiinfm.jpg",
    );
    final productVariant2 = ProductVariantModel(
      id: 3,
      variantName: "5 kg",
      price: 2999.99,
      sku: "SKU-002",
      units: "Tins",
      createdDate: DateTime.parse("2025-03-11T19:44:42"),
      updatedDate: DateTime.now(),
      imageUrls: [variantImage2a, variantImage2b],
      inventories: [],
    );

    // Create cart items from each variant.
    final cartItem1 = CartItemModel(
      id: 1,
      productVariant: productVariant1,
      quantity: 1,
      price: productVariant1.price,
      totalPrice: productVariant1.price * 1,
    );
    final cartItem2 = CartItemModel(
      id: 2,
      productVariant: productVariant2,
      quantity: 1,
      price: productVariant2.price,
      totalPrice: productVariant2.price * 1,
    );

    // Create a demo cart containing both items.
    final demoCart = CartModel(
      id: 1,
      userId: event.userId,
      items: [cartItem1, cartItem2],
      status: "ACTIVE",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Emit the success state with the demo cart (converted to its entity).
    emit(CartsLoadSuccess([demoCart.toEntity()]));
  }
}
