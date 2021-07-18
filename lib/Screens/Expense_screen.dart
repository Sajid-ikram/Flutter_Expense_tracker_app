
import 'package:transaction/providers/Symbol_Provider.dart';
import 'package:transaction/widgets/errorDialog.dart';

import '../Screens/Add_new_transactions.dart';
import '../providers/Expanse_provier.dart';
import '../widgets/individual_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/Search_bar.dart';
import 'package:flutter/services.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen>
    with AutomaticKeepAliveClientMixin {

  String sym;

  Future<Null> _getExpenseData(BuildContext context) async {
    sym = await Provider.of<SymbolProvider>(context).getSymbol();
    Provider.of<ExpanseProvider>(context, listen: false)
        .fetchAndSetExpanse()
        .catchError(
      (error) {
        onError(context);
      },
    );

    return null;
  }

  @override
  Widget build(BuildContext context) {

    final siz = MediaQuery.of(context).size.height;


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    super.build(context);
    final proE = Provider.of<ExpanseProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text('Expense',
              style: GoogleFonts.dancingScript(
                  color: Color(0xFF495464), fontSize: siz * 0.038)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Color(0xFF495464),
                size: siz * 0.031,
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(type: "Expense",symbol: sym));
              },
            ),
            IconButton(
              padding: EdgeInsets.only(right: siz*0.02),
              icon: Icon(
                Icons.add,
                color: Color(0xFF495464),
                size: siz * 0.033,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddTransaction.routeName, arguments: {
                  'type': "Expense",
                  'id': 0,
                });
              },
            ),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: _getExpenseData(context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<ExpanseProvider>(
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/expense.png'),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                    ),
                  ),
                  builder: (ctx, expenses, ch) =>
                      expenses.expanseItemsLength <= 0
                          ? ch
                          : ListView.builder(
                              //reverse: true,
                              itemCount: proE.expanseItemsLength,
                              itemBuilder: (ctx, index) {
                                return IndividualItems(
                                  symbol: sym,
                                  title: proE.getExpenseItems[index].title,
                                  type: "Expense",
                                  price: proE.getExpenseItems[index].price,
                                  date: proE.getExpenseItems[index].datetime,
                                  id: proE.getExpenseItems[index].id,
                                  description:
                                      proE.getExpenseItems[index].description,
                                );
                              },
                            ),
                ),
        ),
        //bottomNavigationBar: ,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
