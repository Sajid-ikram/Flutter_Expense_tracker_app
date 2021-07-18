import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:transaction/providers/Symbol_Provider.dart';
import 'package:transaction/widgets/errorDialog.dart';
import '../providers/Expanse_provier.dart';
import '../providers/Income_provider.dart';
import 'Currencies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> forIncome = [0, 0, 0, 0];

  List<double> forExpense = [0, 0, 0, 0];

  String currencySymbol = "\$";

  bool _isLoading = false;

  //Preferences _preferences = Preferences();

  Future<Null> _getIncomeExpenseData(BuildContext context) async {
    forExpense = await Provider.of<ExpanseProvider>(context, listen: false)
        .allExpense()
        .catchError((e) {
      onError(context);
    });

    forIncome = await Provider.of<IncomeProvider>(context, listen: false)
        .allIncome()
        .catchError((e) {
      onError(context);
    });

    return null;
  }

  getSym() async {
    try {
      setState(() {
        _isLoading = true;
      });

      currencySymbol =
          await Provider.of<SymbolProvider>(context, listen: false).getSymbol();

      setState(() {
        _isLoading = false;
      });

      if (currencySymbol == null) {
        currencySymbol = "\$";
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return onError(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getSym();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    final Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text('My Transactions',
              style: GoogleFonts.dancingScript(
                  color: Color(0xFF495464),
                  fontSize: deviceSize.height * 0.038)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: deviceSize.width * 0.02),
              icon: Icon(
                Icons.monetization_on_outlined,
                color: Color(0xFF495464),
                size: deviceSize.height* 0.031,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                      Currencies.routeName,
                    )
                    .then((value) => getSym());
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
                future: _getIncomeExpenseData(context),
                builder: (ctx, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _getIncomeExpenseData(context),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _containerDesign(deviceSize, 'Today',
                                      forIncome[3], forExpense[3]),
                                  _containerDesign(deviceSize, 'Last Week',
                                      forIncome[0], forExpense[0]),
                                  _containerDesign(deviceSize, 'Last Month',
                                      forIncome[1], forExpense[1]),
                                  _containerDesign(deviceSize, 'Last Year',
                                      forIncome[2], forExpense[2]),
                                ],
                              ),
                            ),
                          ),
              ),
      ),
    );
  }

  Widget _containerDesign(
      Size _size, String name, double incomeMoney, double expenseMoney) {
    return Container(
      margin: EdgeInsets.all(_size.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xFFd0ecfd), blurRadius: 5.0),
        ],
        border: Border.all(
          color: Color(0xFF9ad3bc),
          width: 2,
        ),
      ),
      height: _size.height * 0.3,
      width: _size.width * 0.96,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            name,
            style: GoogleFonts.gabriela(
                color: Color(0xFF292f38), fontSize: _size.width * 0.045),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _rows(_size, "Income", incomeMoney),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: _rows(_size, "Expense", expenseMoney),
          ),
          Divider(
            thickness: 1,
            color: Color(0xFF9ad3bc),
            endIndent: 10,
            indent: 10,
          ),
          if (incomeMoney - expenseMoney > 0)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child:
                  _rows(_size, "Income - Expense", incomeMoney - expenseMoney),
            ),
          if (incomeMoney - expenseMoney < 0)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child:
                  _rows(_size, "Expense - Income", expenseMoney - incomeMoney),
            ),
          if (incomeMoney - expenseMoney == 0)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: _rows(_size, "Income & Expense are equal", 0.00),
            ),
          SizedBox(height: _size.height * 0.006),
        ],
      ),
    );
  }

  Row _rows(Size _size, String name, double money) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "$name :   ",
          style: GoogleFonts.gabriela(
              color: Color(0xFF292f38), fontSize: _size.width * 0.045),
        ),
        Flexible(
          child: Text(
            "$currencySymbol${money.toStringAsFixed(2)}",
            style: GoogleFonts.gabriela(
                color: Color(0xFF292f38), fontSize: _size.width * 0.045),
          ),
        ),
      ],
    );
  }
}
