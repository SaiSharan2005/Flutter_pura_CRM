import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Import pages, state, and utilities
import 'package:pura_crm/features/auth/presentation/pages/login_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/logistic_person_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/manager_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart';
import 'package:pura_crm/features/customer/domain/entities/customer_entity.dart';
import 'package:pura_crm/features/customer/presentation/pages/deal_customer_create_page.dart';
import 'package:pura_crm/features/deals/domain/entities/deal_entity.dart';
import 'package:pura_crm/features/products/domain/usecases/cart_usecase.dart';
import 'package:pura_crm/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:pura_crm/features/products/presentation/pages/all_product_page.dart';
import 'package:pura_crm/features/products/presentation/pages/cart_page.dart';
import 'package:pura_crm/features/products/presentation/pages/deal_product_add_page.dart';
import 'package:pura_crm/features/products/presentation/pages/product_create_page.dart';
import 'package:pura_crm/features/salesman/presentation/pages/craete_salesman_page.dart';
import 'package:pura_crm/features/salesman/presentation/pages/manager_home.dart';
import 'package:pura_crm/features/salesman/presentation/pages/salesman_homepage.dart';
import 'package:pura_crm/features/salesman/presentation/pages/salesman_profile_page.dart';
import 'package:pura_crm/features/products/presentation/pages/product_details_page.dart';
import 'package:pura_crm/features/deals/presentation/pages/deal_details_page.dart';
import 'package:pura_crm/features/customer/presentation/pages/customer_detail_page.dart';
import 'package:pura_crm/features/customer/presentation/pages/customer_create_page.dart';
import 'package:pura_crm/features/customer/presentation/pages/all_customer_page.dart';
import 'package:pura_crm/features/deals/presentation/pages/deal_list_page.dart';
import 'package:pura_crm/features/deals/presentation/pages/create_deal_page.dart';
import 'package:pura_crm/features/maps/presentation/pages/map_screen.dart';
import 'package:pura_crm/features/auth/data/models/user_details.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';

import 'package:pura_crm/features/deals/presentation/state/deal_bloc.dart';
import 'package:pura_crm/features/products/presentation/state/cart_bloc.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';
import 'package:pura_crm/injection_container.dart';
// Import the dynamic navbar from your utils folder.
import 'package:pura_crm/utils/dynamic_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SecureStorageHelper.saveToken(
  //     "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYWxlc21hbiIsInVzZXJJZCI6MiwiYXV0aG9yaXRpZXMiOlt7ImF1dGhvcml0eSI6IlNBTEVTTUFOIn1dLCJpYXQiOjE3NDEwODUyNDgsImV4cCI6MTc0MzY3NzI0OH0.gp1x8iUYo3ptBdr6xuBtaecjuRL6LRItFgPyFSxQiAU");
  await setupInjection(); // Initialize dependencies via GetIt
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // final String apiBaseUrl = 'https://massive-susi-s-a-i-3e201788.koyeb.app/api';
  final String apiBaseUrl = 'http://localhost:8000/api';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide SalesmanProvider
        ChangeNotifierProvider(
          create: (_) => SalesmanProvider(GetIt.instance()),
        ),
        // Provide CartBloc (with necessary use cases)
        BlocProvider(
          create: (_) => DemoCartBloc(
            // createCartUseCase: GetIt.instance(),
            // addItemToCartUseCase: GetIt.instance(),
            // removeItemFromCartUseCase: GetIt.instance(),
            // updateCartItemUseCase: GetIt.instance(),
            getCartsByUserIdUseCase: GetIt.instance(),
            // getCartItemsUseCase: GetIt.instance(),
            // removeCartUseCase: GetIt.instance(),
          ),
        ),
        // Provide DealBloc
        BlocProvider(
          create: (_) => DealBloc(
            createDealUseCase: GetIt.instance(),
            getAllDealsUseCase: GetIt.instance(),
            getDealsOfUserUseCase: GetIt.instance(),
            updateDealUseCase: GetIt.instance(),
            deleteDealUseCase: GetIt.instance(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pura CRM',
        theme: ThemeData(primarySwatch: Colors.blue),
        // Use custom route generation.
        onGenerateRoute: buildRoutes,
      ),
    );
  }

  /// The buildRoutes function handles all routing.
  Route<dynamic> buildRoutes(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    // Dynamic route: Product details e.g. "/product/10"
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
      final productId = int.tryParse(uri.pathSegments[1]);
      if (productId != null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MainLayout(
            child: ProductDetailsPage(
              productId: productId,
              getProductByIdUseCase: GetIt.instance(),
            ),
          ),
        );
      }
    }

    // Dynamic route: Deal details e.g. "/deals/detail/456"
    if (uri.pathSegments.length >= 2 &&
        uri.pathSegments[0] == 'deals' &&
        uri.pathSegments[1] == 'detail') {
      final deal = settings.arguments as DealEntity?;
      if (deal != null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MainLayout(
            child: DealDetailsPage(deal: deal),
          ),
        );
      }
    }

    // Dynamic routes for Customer pages.
    if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'customer') {
      if (uri.pathSegments.length == 2 && uri.pathSegments[1] == 'list') {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              MainLayout(child: CustomerListPage(baseUrl: apiBaseUrl)),
        );
      } else if (uri.pathSegments.length == 2 &&
          uri.pathSegments[1] == 'create') {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              MainLayout(child: CreateCustomerPage(baseUrl: apiBaseUrl)),
        );
      } else if (uri.pathSegments.length == 2 &&
          uri.pathSegments[1] == 'detail') {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              MainLayout(child: CustomerDetailPage(baseUrl: apiBaseUrl)),
        );
      }
    }

    // Static routes using switch-case.
    switch (settings.name) {
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => RegistrationPage(remoteDataSource: GetIt.instance()),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(remoteDataSource: GetIt.instance()),
        );
      case '/salesman/create':
        return MaterialPageRoute(builder: (_) => SalesmanCreatePage());
      // Existing manager route - you can choose to update this page if needed.
      case '/manager':
        return MaterialPageRoute(
          builder: (_) => ManagerCreatePage(repository: GetIt.instance()),
        );
      // Added manager home route.
      case '/managerHome':
        return MaterialPageRoute(
          builder: (_) => MainLayout(child: ManagerHomePage()),
        );
      case '/logistic':
        return MaterialPageRoute(
          builder: (_) =>
              LogisticPersonCreatePage(repository: GetIt.instance()),
        );
      case '/product/add':
        return MaterialPageRoute(
          builder: (_) =>
              ProductCreatePage(createProductUseCase: GetIt.instance()),
        );
      case '/products':
        return MaterialPageRoute(
          builder: (_) =>
              AllProductsPage(getAllProductsUseCase: GetIt.instance()),
        );
      case '/cart':
        return MaterialPageRoute(builder: (_) => UserCartsPage());
      case '/salesmanHome':
        return MaterialPageRoute(
          builder: (_) => MainLayout(child: SalesmanApp()),
        );
      case '/deals':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<UserDTO?>(
            future: SecureStorageHelper.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData && snapshot.data != null) {
                return UserDealsPage(
                  userId: snapshot.data!.id,
                  // getDealsOfUserUseCase: GetIt.instance(),
                );
              }
              return const Scaffold(
                  body: Center(child: Text("User not logged in")));
            },
          ),
        );
      case '/deals/create':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<UserDTO?>(
            future: SecureStorageHelper.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData && snapshot.data != null) {
                return DealCreatePage(
                  userId: snapshot.data!.id,
                  getAllCustomersUseCase: GetIt.instance(),
                  getCartsByUserIdUseCase: GetIt.instance(),
                  createDealUseCase: GetIt.instance(),
                );
              }
              return const Scaffold(
                  body: Center(child: Text("User not logged in")));
            },
          ),
        );
      case '/deal/customer/create':
        return MaterialPageRoute(
          builder: (_) => MainLayout(child: DealCustomerCreatePage()),
        );
      case '/deal/product/add':
        return MaterialPageRoute(
          builder: (context) {
            // Safely extract the customer from the arguments.
            final customer =
                ModalRoute.of(context)!.settings.arguments as Customer?;
            if (customer == null) {
              // Display an error message or redirect as needed.
              return Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('No customer was provided')),
              );
            }
            return MainLayout(
              child: DealProductAddPage(
                customer: customer,
                getAllProductsUseCase: GetIt.I<GetAllProductsUseCase>(),
                createCartUseCase: GetIt.I<CreateCartUseCase>(),
                addItemToCartUseCase: GetIt.I<AddItemToCartUseCase>(),
              ),
            );
          },
        );
      case '/maps':
        return MaterialPageRoute(builder: (_) => MapSample());
      default:
        return MaterialPageRoute(builder: (_) => MainLayout(child: HomePage()));
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('Signup'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/salesmanHome'),
              child: const Text('Salesman Home'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/managerHome'),
              child: const Text('Manager Home'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/product/add'),
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/product/10'),
              child: const Text('View Product 10'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deals'),
              child: const Text('View Deals'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/maps'),
              child: const Text('Maps'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/customer/list'),
              child: const Text('View Customers'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/managerHome'),
              child: const Text('managerHome'),
            ),
          ],
        ),
      ),
    );
  }
}
