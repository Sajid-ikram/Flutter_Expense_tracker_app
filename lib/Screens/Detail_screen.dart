import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transaction/providers/Income_provider.dart';
import 'package:transaction/widgets/Data_Structure.dart';
import '../providers/Expanse_provier.dart';
import '../Screens/Add_new_transactions.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = 'DetailScreen';

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Widget _information(String about, Object data, double size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$about : ',
              style: GoogleFonts.gabriela(
                  color: Color(0xFF292f38),
                  fontSize: size * 0.045,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                '$data',
                style: GoogleFonts.gabriela(
                    color: Color(0xFF292f38), fontSize: size * 0.042),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Color(0xFF495464),
      endIndent: 10,
      indent: 10,
    );
  }

  DataSample loadedProduct;
  Map idType;

  @override
  void didChangeDependencies() {
    idType = ModalRoute.of(context).settings.arguments as Map;
    if (idType["type"] == "Expense") {
      loadedProduct = Provider.of<ExpanseProvider>(context, listen: false)
          .findId(idType["id"]);
    } else {
      loadedProduct = Provider.of<IncomeProvider>(context, listen: false)
          .findId(idType["id"]);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final siz = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));

    String des = loadedProduct.description.isEmpty
        ? "No Description"
        : loadedProduct.description;

    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text('Expense',
              style: GoogleFonts.dancingScript(
                  color: Color(0xFF495464), fontSize: siz*0.038)),
          iconTheme: IconThemeData(
            color: Color(0xFF495464),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              _information('Title', loadedProduct.title, deviceWidth),
              _divider(),
              _information('Amount', '${loadedProduct.price.toStringAsFixed(2)} ${idType["symbol"]}', deviceWidth),
              _divider(),
              _information('Date',
                  DateFormat.yMd().format(loadedProduct.datetime), deviceWidth),
              _divider(),
              Container(
                  padding: EdgeInsets.all(13),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Description',
                        style: GoogleFonts.gabriela(
                            color: Color(0xFF292f38),
                            fontSize: deviceWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 35,
                        thickness: 1,
                        color: Color(0xFF495464),
                        endIndent: deviceWidth * 0.25,
                        indent: deviceWidth * 0.25,
                      ),
                      Text(
                        '$des',
                        style: GoogleFonts.gabriela(
                            color: Color(0xFF292f38),
                            fontSize: deviceWidth * 0.042),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Are you sure ?'),
                              content: Text(
                                  "Do you want to remove the Transaction ?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () async {
                                    await deleteTrans(idType, context).then(
                                        (value) => Navigator.of(ctx).pop());
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              size: deviceWidth * 0.073,
                              color: Colors.deepOrange,
                            ),
                            Text(
                              "  Delete",
                              style: GoogleFonts.gabriela(
                                  color: Color(0xFF292f38),
                                  fontSize: deviceWidth * 0.05),
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddTransaction.routeName, arguments: {
                          'type': idType['type'],
                          'id': idType['id'],
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            size: deviceWidth * 0.073,
                            color: Color(0xFF495464),
                          ),
                          Text(
                            "  Edit",
                            style: GoogleFonts.gabriela(
                                color: Color(0xFF292f38),
                                fontSize: deviceWidth * 0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteTrans(Map _data, BuildContext context) async {
    if (_data['type'] == 'Expense') {
      await Provider.of<ExpanseProvider>(context, listen: false)
          .deleteExpanse(_data['id'])
          .then((value) => Navigator.of(context).pop())
          .catchError((error) {
        return _onError();
      });
    } else {
      await Provider.of<IncomeProvider>(context, listen: false)
          .deleteIncome(_data['id'])
          .then((value) => Navigator.of(context).pop())
          .catchError((error) {
        return _onError();
      });
    }
  }

  Future _onError() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred'),
        content: Text('Something went wrong'),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
