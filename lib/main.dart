import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pura_crm/core/utils/api_client.dart';
import 'package:pura_crm/features/auth/data/datasources/remote_data_source.dart';
import 'package:pura_crm/features/auth/data/repositories/logistic_person_repository.dart';
import 'package:pura_crm/features/auth/data/repositories/manager_repository_impl.dart';
import 'package:pura_crm/features/auth/data/repositories/salesman_repository_impl.dart';
import 'package:pura_crm/features/auth/domain/repositories/logistic_repository.dart';
import 'package:pura_crm/features/auth/domain/repositories/manager_repository.dart';
import 'package:pura_crm/features/auth/domain/repositories/salesman_repository.dart';
import 'package:pura_crm/features/auth/presentation/pages/404_not_found.dart';
import 'package:pura_crm/features/auth/presentation/pages/login_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/logistic_person_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/manager_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/register_page.dart';
import 'package:pura_crm/features/auth/presentation/pages/salesman_page.dart';
import 'package:pura_crm/features/auth/presentation/state/salesman_provider.dart';
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
import 'package:pura_crm/utils/dynamic_navbar.dart';

// Add these imports if they are not already included
import 'package:pura_crm/features/products/presentation/pages/product_details_page.dart';
import 'package:pura_crm/features/products/domain/usecases/product_usecase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final String apiBaseUrl = 'http://localhost:8005/api';
  final apiClient = ApiClient('http://localhost:8005/api', http.Client());

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
    final args = settings.arguments;

    switch (settings.name) {
      case '/signup':
        return MaterialPageRoute(
          builder: (context) =>
              RegistrationPage(remoteDataSource: remoteDataSource),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => LoginPage(remoteDataSource: remoteDataSource),
        );
      case '/salesman':
        return MaterialPageRoute(
          builder: (context) => SalesmanCreatePage(),
        );
      case '/manager':
        return MaterialPageRoute(
          builder: (context) =>
              ManagerCreatePage(repository: managerRepository),
        );
      case '/logistic':
        return MaterialPageRoute(
          builder: (context) =>
              LogisticPersonCreatePage(repository: logisticPersonRepository),
        );
      case '/product/add':
        return MaterialPageRoute(
          builder: (context) =>
              ProductCreatePage(createProductUseCase: createProductUseCase),
        );
      case '/products':
        return MaterialPageRoute(
          builder: (context) => AllProductsPage(
              getAllProductsUseCase: GetAllProductsUseCase(productRepository)),
        );
      case '/cart':
        return MaterialPageRoute(
          builder: (context) => UserCartsPage(),
        );
      case '/salesmanHome':
        return MaterialPageRoute(
          builder: (context) => SalesmanApp(),
        );
      case '/product':
        if (args is ProductDetailsArguments) {
          return MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              getProductByIdUseCase: args.getProductByIdUseCase,
              productId: args.productId,
            ),
          );
        }
        // If args are not valid, return a fallback or error page.
        return MaterialPageRoute(
          builder: (context) => NotFoundPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
    }
  }

  // Fallback page in case of an error
  Widget _errorPage() {
    return Scaffold(
      body: Center(
        child: Text('Error: Route not found!'),
      ),
    );
  }
}

// Define arguments for the ProductDetailsPage
class ProductDetailsArguments {
  final GetProductByIdUseCase getProductByIdUseCase;
  final int productId;

  ProductDetailsArguments(
      {required this.getProductByIdUseCase, required this.productId});
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   final String apiBaseUrl = 'http://localhost:8005/api';
//   final apiClient = ApiClient('http://localhost:8005/api', http.Client());

//   late final RemoteDataSource remoteDataSource;
//   late final SalesmanRepository salesmanRepository;
//   late final ManagerRepository managerRepository;
//   late final LogisticPersonRepository logisticPersonRepository;
//   late final ProductRepository productRepository;
//   late final CreateProductUseCase createProductUseCase;
//   late final CartRepositoryImpl cartRepository;
//   late final CreateCartUseCase createCartUseCase;
//   late final AddItemToCartUseCase addItemToCartUseCase;
//   late final RemoveItemFromCartUseCase removeItemFromCartUseCase;
//   late final UpdateCartItemUseCase updateCartItemUseCase;
//   late final GetCartsByUserIdUseCase getCartsByUserIdUseCase;
//   late final GetCartItemsUseCase getCartItemsUseCase;

//   @override
//   Widget build(BuildContext context) {
//     // Initialize all the dependencies
//     remoteDataSource = RemoteDataSource(apiClient);
//     salesmanRepository = SalesmanRepositoryImpl(apiClient);
//     managerRepository = ManagerRepositoryImpl(apiClient);
//     logisticPersonRepository = LogisticPersonRepositoryImpl(apiClient);
//     productRepository = ProductRepositoryImpl(apiClient);
//     createProductUseCase = CreateProductUseCase(productRepository);
//     cartRepository = CartRepositoryImpl(apiClient);

//     createCartUseCase = CreateCartUseCase(cartRepository);
//     addItemToCartUseCase = AddItemToCartUseCase(cartRepository);
//     removeItemFromCartUseCase = RemoveItemFromCartUseCase(cartRepository);
//     updateCartItemUseCase = UpdateCartItemUseCase(cartRepository);
//     getCartsByUserIdUseCase = GetCartsByUserIdUseCase(cartRepository);
//     getCartItemsUseCase = GetCartItemsUseCase(cartRepository);

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//             create: (_) => SalesmanProvider(salesmanRepository)),
//         BlocProvider(
//           create: (_) => CartBloc(
//             createCartUseCase: createCartUseCase,
//             addItemToCartUseCase: addItemToCartUseCase,
//             removeItemFromCartUseCase: removeItemFromCartUseCase,
//             updateCartItemUseCase: updateCartItemUseCase,
//             getCartsByUserIdUseCase: getCartsByUserIdUseCase,
//             getCartItemsUseCase: getCartItemsUseCase,
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Pura CRM',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         onGenerateRoute: _generateRoute,
//       ),
//     );
//   }

//   Route<dynamic> _generateRoute(RouteSettings settings) {
//     return MaterialPageRoute(
//       builder: (context) => MainLayout(
//         child: _buildPage(settings.name ?? '/'),
//       ),
//     );
//   }

//   Widget _buildPage(String? routeName) {
//     switch (routeName) {
//       case '/signup':
//         return RegistrationPage(remoteDataSource: remoteDataSource);
//       case '/login':
//         return LoginPage(remoteDataSource: remoteDataSource);
//       case '/salesman':
//         return SalesmanCreatePage();
//       case '/manager':
//         return ManagerCreatePage(repository: managerRepository);
//       case '/logistic':
//         return LogisticPersonCreatePage(repository: logisticPersonRepository);
//       case '/product/add':
//         return ProductCreatePage(createProductUseCase: createProductUseCase);
//       case '/products':
//         return AllProductsPage(
//             getAllProductsUseCase: GetAllProductsUseCase(productRepository));
//       case '/cart':
//         return UserCartsPage();
//       case '/salesmanHome':
//         return SalesmanApp();
//       default:
//         return HomePage();
//     }
//   }
// }

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
          ],
        ),
      ),
    );
  }
}
