import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/Symbol_Provider.dart';
import 'package:transaction/widgets/errorDialog.dart';

class Currencies extends StatefulWidget {
  static const routeName = 'Currency';

  @override
  _CurrenciesState createState() => _CurrenciesState();
}

class _CurrenciesState extends State<Currencies> {
  Color clr = Color(0xFF9ad3bc);
  int i = 2;
  String selectedSymbol = "\$";
  bool _isLoading = true;

  getSym() async {
    try {
      selectedSymbol =
          await Provider.of<SymbolProvider>(context, listen: false).getSymbol();
      setState(() {
        _isLoading = false;
      });

      if (selectedSymbol == null) {
        selectedSymbol = "\$";
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return onError(context);
    }
  }

  setSym() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Provider.of<SymbolProvider>(context, listen: false)
          .setSymbol(selectedSymbol);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
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
    final siz = MediaQuery.of(context).size.width;
    final sizHeight = MediaQuery.of(context).size.height;
    int cnt = (siz / 100).round();
    if (cnt < 4) {
      cnt = 4;
    }
    List<String> _currency = [
      "৳",
      "£",
      "\$",
      "¥",
      "Kč",
      "kr",
      "€",
      "Ft",
      "₹",
      "₪",
      "₩",
      "RM",
      "₱",
      "zł",
      "p.",
      "R",
      "fr.",
      "฿",
      "₺",
      "₫",
    ];

    for (int j = 0; j < _currency.length; j++) {
      if (selectedSymbol == _currency[j]) {
        i = j;
        break;
      }
    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF495464),
                size: sizHeight * 0.031,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            iconTheme: IconThemeData(color: Color(0xFF495464)),
            brightness: Brightness.light,
            title: Text('Symbols',
                style: GoogleFonts.dancingScript(
                    color: Color(0xFF495464), fontSize: sizHeight * 0.038)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                padding: EdgeInsets.only(right: siz * 0.02),
                icon: Icon(
                  Icons.save,
                  color: Color(0xFF495464),
                  size: sizHeight * 0.031,
                ),
                onPressed: () async {
                  await setSym();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.count(
                  crossAxisCount: cnt,
                  children: List.generate(_currency.length, (index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            i = index;
                            selectedSymbol = _currency[index];
                            clr = Color(0xFF9ad3bc);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                _currency[index],
                                style: TextStyle(
                                  fontSize: sizHeight * 0.03,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              color: index == i ? clr : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFd0ecfd), blurRadius: 5.0),
                              ],
                              border: Border.all(
                                color: Color(0xFF9ad3bc),
                                width: 1,
                              ),
                            ),
                          ),
                        ));
                  }),
                )),
    );
  }
}
