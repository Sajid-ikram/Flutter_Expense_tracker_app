import 'package:transaction/Screens/Detail_screen.dart';
import 'package:transaction/providers/Symbol_Provider.dart';
import 'Screens/Add_new_transactions.dart';
import 'providers/Expanse_provier.dart';
import 'providers/Income_provider.dart';
import 'My_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/Currencies.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ExpanseProvider()),
        ChangeNotifierProvider.value(value: IncomeProvider()),
        ChangeNotifierProvider.value(value: SymbolProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,

            appBarTheme: AppBarTheme(
              elevation: 0,
            )),
        title: 'My Transactions',
        home: MyNavigationBar(),
        routes: {

          AddTransaction.routeName: (ctx) => AddTransaction(),
          DetailScreen.routeName: (ctx) => DetailScreen(),
          Currencies.routeName : (ctx) => Currencies(),
        },
      ),
    );
  }
}
