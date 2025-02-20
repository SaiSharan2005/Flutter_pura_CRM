import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/repositories/logistic_person_repository.dart';
import 'package:pura_crm/features/auth/data/repositories/manager_repository_impl.dart';
import 'package:pura_crm/features/auth/presentation/pages/salesman_page.dart';
import 'package:pura_crm/features/customer/data/datasources/customer_remote_data_source.dart';
import 'package:pura_crm/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:pura_crm/features/customer/domain/repositories/customer_repository.dart';
import 'package:pura_crm/features/customer/domain/usecases/get_all_customers.dart';
import 'package:pura_crm/features/customer/presentation/pages/all_customer_page.dart';
import 'package:pura_crm/features/customer/presentation/pages/customer_create_page.dart';
import 'package:pura_crm/features/deals/data/datasource/deal_remote_data_source.dart';
import 'package:pura_crm/features/deals/presentation/pages/create_deal_page.dart';
import 'package:pura_crm/features/salesman/data/repositories/salesman_repository_impl.dart';
import 'package:pura_crm/features/auth/domain/repositories/logistic_repository.dart';
import 'package:pura_crm/features/auth/domain/repositories/manager_repository.dart';
import 'package:pura_crm/features/salesman/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/auth/presentation/pages/login_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/logistic_person_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/manager_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';
import 'package:pura_crm/features/deals/presentation/state/deal_bloc.dart';
import 'package:pura_crm/features/maps/presentation/pages/map_screen.dart';
import 'package:pura_crm/features/products/data/repositories/cart_repository.dart';
import 'package:pura_crm/features/products/data/repositories/product_repository_impl.dart';
import 'package:pura_crm/features/products/domain/repositories/product_repository.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/product_usecase.dart';
import 'package:pura_crm/features/products/presentation/pages/all_product_page.dart';
import 'package:pura_crm/features/products/presentation/pages/cart_page.dart';
import 'package:pura_crm/features/products/presentation/pages/product_page.dart';
import 'package:pura_crm/features/products/presentation/pages/product_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/salesman/presentation/pages/salesman_homepage.dart';
import 'package:pura_crm/features/salesman/presentation/pages/salesman_profile_page.dart';
import 'package:pura_crm/utils/dynamic_navbar.dart';
import 'package:pura_crm/features/deals/data/repositories/deal_repository_impl.dart';
import 'package:pura_crm/features/deals/domain/usecases/create_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_all_deals_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/get_deals_of_user_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/update_deal_usecase.dart';
import 'package:pura_crm/features/deals/domain/usecases/delete_deal_usecase.dart';
import 'package:pura_crm/features/deals/presentation/pages/deal_list_page.dart';
// Import Customer pages
import 'package:pura_crm/features/customer/presentation/pages/customer_detail_page.dart';
// Import Secure Storage Helper and User model
import 'package:pura_crm/features/auth/data/models/user_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final String apiBaseUrl = 'https://massive-susi-s-a-i-3e201788.koyeb.app/api';
  final apiClient = ApiClient(
      'https://massive-susi-s-a-i-3e201788.koyeb.app/api', http.Client());

  late final RemoteDataSource remoteDataSource;
  late final SalesmanRepository salesmanRepository;
  late final ManagerRepository managerRepository;
  late final LogisticPersonRepository logisticPersonRepository;
  late final ProductRepository productRepository;
  late final CreateProductUseCase createProductUseCase;
  late final CartRepositoryImpl cartRepository;
  late final CreateCartUseCase createCartUseCase;
  late final AddItemToCartUseCase addItemToCartUseCase;
  late final RemoveItemFromCartUseCase removeItemFromCartUseCase;
  late final UpdateCartItemUseCase updateCartItemUseCase;
  late final GetCartsByUserIdUseCase getCartsByUserIdUseCase;
  late final GetCartItemsUseCase getCartItemsUseCase;
  late final RemoveCartUseCase removeCartUseCase;

  late final DealRemoteDataSourceImpl dealRemoteDataSource;
  late final DealRepositoryImpl dealRepository;
  late final CreateDealUseCase createDealUseCase;
  late final GetAllDealsUseCase getAllDealsUseCase;
  late final GetDealsOfUserUseCase getDealsOfUserUseCase;
  late final UpdateDealUseCase updateDealUseCase;
  late final DeleteDealUseCase deleteDealUseCase;

  late final GetAllCustomers getAllCustomers;
  late final CustomerRepositoryImpl customerRepositoryImpl;
  late final CustomerRemoteDataSource customerRemoteDataSource;

  @override
  Widget build(BuildContext context) {
    // Initialize all the dependencies
    remoteDataSource = RemoteDataSource(apiClient);
    salesmanRepository = SalesmanRepositoryImpl(apiClient);
    managerRepository = ManagerRepositoryImpl(apiClient);
    logisticPersonRepository = LogisticPersonRepositoryImpl(apiClient);
    productRepository = ProductRepositoryImpl(apiClient);
    createProductUseCase = CreateProductUseCase(productRepository);
    cartRepository = CartRepositoryImpl(apiClient);

    createCartUseCase = CreateCartUseCase(cartRepository);
    addItemToCartUseCase = AddItemToCartUseCase(cartRepository);
    removeItemFromCartUseCase = RemoveItemFromCartUseCase(cartRepository);
    updateCartItemUseCase = UpdateCartItemUseCase(cartRepository);
    getCartsByUserIdUseCase = GetCartsByUserIdUseCase(cartRepository);
    getCartItemsUseCase = GetCartItemsUseCase(cartRepository);
    removeCartUseCase = RemoveCartUseCase(cartRepository);

    dealRemoteDataSource = DealRemoteDataSourceImpl(apiClient: apiClient);
    dealRepository = DealRepositoryImpl(remoteDataSource: dealRemoteDataSource);
    createDealUseCase = CreateDealUseCase(dealRepository);
    getAllDealsUseCase = GetAllDealsUseCase(dealRepository);
    getDealsOfUserUseCase = GetDealsOfUserUseCase(dealRepository);
    updateDealUseCase = UpdateDealUseCase(dealRepository);
    deleteDealUseCase = DeleteDealUseCase(dealRepository);

    customerRemoteDataSource =
        CustomerRemoteDataSourceImpl(apiClient: apiClient);
    customerRepositoryImpl =
        CustomerRepositoryImpl(remoteDataSource: customerRemoteDataSource);
    getAllCustomers = GetAllCustomers(customerRepositoryImpl);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SalesmanProvider(salesmanRepository)),
        BlocProvider(
          create: (_) => CartBloc(
            createCartUseCase: createCartUseCase,
            addItemToCartUseCase: addItemToCartUseCase,
            removeItemFromCartUseCase: removeItemFromCartUseCase,
            updateCartItemUseCase: updateCartItemUseCase,
            getCartsByUserIdUseCase: getCartsByUserIdUseCase,
            getCartItemsUseCase: getCartItemsUseCase,
            removeCartUseCase: removeCartUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => DealBloc(
            createDealUseCase: createDealUseCase,
            getAllDealsUseCase: getAllDealsUseCase,
            getDealsOfUserUseCase: getDealsOfUserUseCase,
            updateDealUseCase: updateDealUseCase,
            deleteDealUseCase: deleteDealUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pura CRM',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    Uri uri = Uri.parse(settings.name ?? '/');

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
      final productId = int.tryParse(uri.pathSegments[1]);
      if (productId != null) {
        return MaterialPageRoute(
          builder: (context) => ProductDetailsPage(
            productId: productId,
            getProductByIdUseCase: GetProductByIdUseCase(productRepository),
            getCartsByUserIdUseCase: GetCartsByUserIdUseCase(cartRepository),
          ),
        );
      }
    }
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'profile') {
      String? salesmanId;
      if (uri.pathSegments.length == 2) {
        salesmanId = uri.pathSegments[1];
      }
      return MaterialPageRoute(
        builder: (context) => SalesmanProfilePage(
          repository: salesmanRepository,
          salesmanId: salesmanId,
        ),
      );
    }

    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'customer') {
      if (uri.pathSegments.length == 2 && uri.pathSegments[1] == 'list') {
        return MaterialPageRoute(
          builder: (context) =>
              MainLayout(child: CustomerListPage(baseUrl: apiBaseUrl)),
        );
      } else if (uri.pathSegments.length == 2 &&
          uri.pathSegments[1] == 'create') {
        return MaterialPageRoute(
          builder: (context) =>
              MainLayout(child: CreateCustomerPage(baseUrl: apiBaseUrl)),
        );
      } else if (uri.pathSegments.length == 2 &&
          uri.pathSegments[1] == 'detail') {
        return MaterialPageRoute(
          builder: (context) => CustomerDetailPage(baseUrl: apiBaseUrl),
          settings: settings, // Pass along any arguments
        );
      }
    }

    // Fallback to _buildPage for legacy routes.
    return MaterialPageRoute(
      builder: (context) => MainLayout(
        child: _buildPage(settings.name ?? '/'),
      ),
    );
  }

  Widget _buildPage(String? routeName) {
    switch (routeName) {
      case '/signup':
        return RegistrationPage(remoteDataSource: remoteDataSource);
      case '/login':
        return LoginPage(remoteDataSource: remoteDataSource);
      case '/salesman':
        return SalesmanCreatePage();
      case '/manager':
        return ManagerCreatePage(repository: managerRepository);
      case '/logistic':
        return LogisticPersonCreatePage(repository: logisticPersonRepository);
      case '/product/add':
        return ProductCreatePage(createProductUseCase: createProductUseCase);
      case '/products':
        return AllProductsPage(
            getAllProductsUseCase: GetAllProductsUseCase(productRepository));
      case '/cart':
        return UserCartsPage();
      case '/salesmanHome':
        return SalesmanApp();
      case '/deals':
        // Fetch user id from secure storage dynamically.
        return FutureBuilder<UserDTO?>(
          future: SecureStorageHelper.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.id != null) {
              return UserDealsPage(
                userId: snapshot.data!.id,
                getDealsOfUserUseCase: getDealsOfUserUseCase,
              );
            }
            return Scaffold(
              body: Center(child: Text("User not logged in")),
            );
          },
        );
      case '/deals/create':
        // Fetch user id from secure storage dynamically.
        return FutureBuilder<UserDTO?>(
          future: SecureStorageHelper.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.id != null) {
              return DealCreatePage(
                userId: snapshot.data!.id,
                getAllCustomersUseCase: getAllCustomers,
                getCartsByUserIdUseCase: getCartsByUserIdUseCase,
                createDealUseCase: createDealUseCase,
              );
            }
            return Scaffold(
              body: Center(child: Text("User not logged in")),
            );
          },
        );
      case '/maps':
        return MapSample();
      default:
        return HomePage();
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text('Signup'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/salesmanHome'),
              child: Text('Salesman Home '),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/product/add'),
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/product/10'),
              child: Text('View Product 10'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deals'),
              child: Text('View Deals'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/maps'),
              child: Text('Maps'),
            ),
            // Optionally, add a button to navigate to the customer list.
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/customer/list'),
              child: Text('View Customers'),
            ),
          ],
        ),
      ),
    );
  }
}
