import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Core
import 'package:pura_crm/core/utils/api_client.dart';

// Auth
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/repositories/logistic_person_repository.dart';
import 'package:pura_crm/features/auth/data/repositories/manager_repository_impl.dart';
import 'package:pura_crm/features/auth/domain/repositories/manager_repository.dart';
import 'package:pura_crm/features/auth/domain/repositories/logistic_repository.dart';

// Customer
import 'package:pura_crm/features/customer/data/datasources/customer_remote_data_source.dart';
import 'package:pura_crm/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';
import 'package:pura_crm/features/customer/domain/usecases/get_all_customers.dart';

// Deals
import 'package:pura_crm/features/deals/data/datasource/deal_remote_data_source.dart';
import 'package:pura_crm/features/deals/data/repositories/deal_repository_impl.dart';
import 'package:pura_crm/features/deals/domain/usecases/create_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/delete_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_all_deals_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_deals_of_user_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/update_deal_usecase.dart';

// Products - Cart
import 'package:pura_crm/features/products/data/repositories/cart_repository.dart';
import 'package:pura_crm/features/products/data/repositories/product_repository_impl.dart';
import 'package:pura_crm/features/products/domain/repositories/cart_repository.dart';
import 'package:pura_crm/features/products/domain/repositories/product_repository.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/create_product_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/get_product_by_id_usecase.dart';

// Salesman
import 'package:pura_crm/features/salesman/data/repositories/salesman_repository_impl.dart';
import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  final String apiBaseUrl = 'http://localhost:8000/api';
  // final String apiBaseUrl = 'https://massive-susi-s-a-i-3e201788.koyeb.app/api';

  // Register ApiClient as a singleton.
  getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(apiBaseUrl, http.Client()));

  // Register DataSources.
  getIt.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSource(getIt<ApiClient>()));
  getIt.registerLazySingleton<CustomerRemoteDataSource>(
      () => CustomerRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));
  getIt.registerLazySingleton<DealRemoteDataSourceImpl>(
      () => DealRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));

  // Register Repositories.
  getIt.registerLazySingleton<SalesmanRepository>(
      () => SalesmanRepositoryImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<ManagerRepository>(
      () => ManagerRepositoryImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton(
      () => LogisticPersonRepositoryImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(getIt<ApiClient>()));
  getIt.registerLazySingleton<DealRepositoryImpl>(() =>
      DealRepositoryImpl(remoteDataSource: getIt<DealRemoteDataSourceImpl>()));

  // Register CustomerRepository using its interface.
  getIt.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(
      remoteDataSource: getIt<CustomerRemoteDataSource>()));

  // Register UseCases.
  // Customer UseCases.
  getIt.registerLazySingleton(
      () => GetAllCustomers(getIt<CustomerRepository>()));

  // Deals UseCases.
  getIt.registerLazySingleton(
      () => CreateDealUseCase(getIt<DealRepositoryImpl>()));
  getIt.registerLazySingleton(
      () => GetAllDealsUseCase(getIt<DealRepositoryImpl>()));
  getIt.registerLazySingleton(
      () => GetDealsOfUserUseCase(getIt<DealRepositoryImpl>()));
  getIt.registerLazySingleton(
      () => UpdateDealUseCase(getIt<DealRepositoryImpl>()));
  getIt.registerLazySingleton(
      () => DeleteDealUseCase(getIt<DealRepositoryImpl>()));

  // Cart UseCases.
  getIt.registerLazySingleton(() => CreateCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
      () => AddItemToCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
      () => RemoveItemFromCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
      () => UpdateCartItemUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
      () => GetCartsByUserIdUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
      () => GetCartItemsUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => RemoveCartUseCase(getIt<CartRepository>()));

  // Product UseCases.
  getIt.registerLazySingleton(
      () => CreateProductUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => GetAllProductsUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => GetProductByIdUseCase(getIt<ProductRepository>()));

  // Variant UseCases (if needed).
  // getIt.registerLazySingleton(() => AddVariantUseCase(getIt<ProductVariantRepository>()));
  // getIt.registerLazySingleton(() => UpdateVariantUseCase(getIt<ProductVariantRepository>()));
  // getIt.registerLazySingleton(() => DeleteVariantUseCase(getIt<ProductVariantRepository>()));
}
