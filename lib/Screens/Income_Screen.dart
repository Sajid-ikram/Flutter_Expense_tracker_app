import 'package:transaction/providers/Symbol_Provider.dart';
import 'package:transaction/widgets/Search_bar.dart';
import 'package:transaction/widgets/errorDialog.dart';
import '../Screens/Add_new_transactions.dart';
import '../providers/Income_provider.dart';
import '../widgets/individual_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> with AutomaticKeepAliveClientMixin {
  String sym;

  Future<Null> _getIncomeData(BuildContext context) async {
    sym = await Provider.of<SymbolProvider>(context).getSymbol();
    Provider.of<IncomeProvider>(context, listen: false)
        .fetchAndSetIncome()
        .catchError((error) {
      onError(context);
    });

    return null;
  }
  @override
  Widget build(BuildContext context) {
    final siz = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    super.build(context);
    final proI = Provider.of<IncomeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text('Income',
              style: GoogleFonts.dancingScript(
                  color: Color(0xFF495464), fontSize: siz*0.038)),
          actions: [

            IconButton(

              icon: Icon(
                Icons.search,
                color: Color(0xFF495464),
                size: siz*0.031,
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(type: "Income",symbol: sym));
              },
            ),
            IconButton(
                padding: EdgeInsets.only(right: siz*0.02),
                icon: Icon(
                  Icons.add,
                  color: Color(0xFF495464),
                  size: siz*0.033,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddTransaction.routeName, arguments: {
                    'type': "Income",
                    'id': 0,
                  });
                })

          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: _getIncomeData(context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<IncomeProvider>(
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/income.jpg'),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                    ),
                  ),
                  builder: (ctx, incomes, ch) => incomes.incomeItemsLength <= 0
                      ? ch
                      : ListView.builder(
                          //reverse: true,
                          itemCount: proI.incomeItemsLength,
                          itemBuilder: (ctx, index) => IndividualItems(
                            symbol: sym,
                            title: proI.getIncomeItems[index].title,
                            type: "Income",
                            price: proI.getIncomeItems[index].price,
                            date: proI.getIncomeItems[index].datetime,
                            id: proI.getIncomeItems[index].id,
                            description: proI.getIncomeItems[index].description,
                          ),
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
