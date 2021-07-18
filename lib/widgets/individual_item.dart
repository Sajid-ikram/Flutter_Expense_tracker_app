

import '../providers/Expanse_provier.dart';
import '../providers/Income_provider.dart';
import '../Screens/Detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'errorDialog.dart';

class IndividualItems extends StatelessWidget {
  final String title;
  final String symbol;
  final String type;
  final String description;
  final int id;
  final DateTime date;
  final double price;


   IndividualItems({
    @required this.title,
    @required this.symbol,
    @required this.type,
    @required this.id,
    @required this.description,
    @required this.date,
    @required this.price,
  });

  Future<void> deleteTrans(Map _data, BuildContext context) async {
    if (_data['type'] == 'Expense') {
      await Provider.of<ExpanseProvider>(context, listen: false)
          .deleteExpanse(_data['id'])
          .then((value) => Navigator.of(context).pop())
          .catchError(
        (error) {
          return onError(context);
        },
      );

    } else {
      await Provider.of<IncomeProvider>(context, listen: false)
          .deleteIncome(_data['id'])
          .then((value) => Navigator.of(context).pop())
          .catchError((error) {
        return onError(context);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;


    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(DetailScreen.routeName, arguments: {
          'type': type,
          'id': id,
          'symbol' : symbol,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF9ad3bc)),
            //borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(80.0),
                topLeft: Radius.circular(80.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFd0ecfd), blurRadius: 5.0),
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: deviceHeight * 0.11,
              width: deviceHeight * 0.11,
              decoration: BoxDecoration(
                color: Color(0xFF9ad3bc),
                borderRadius: BorderRadius.circular(100),
              ),
              margin: EdgeInsets.only(right: 15),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$symbol${price.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.gabriela(
                        color: Color(0xFF292f38),
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  ),
                ),
              ),

            ),
            Expanded(
              child: Container(
                height: deviceHeight * 0.11,
                width: deviceWidth * 0.5,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: deviceHeight * 0.05,
                      child: Padding(
                        padding: EdgeInsets.all(deviceHeight * 0.0049),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.gabriela(
                            color: Color(0xFF292f38),
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                    Container(
                      height: deviceHeight * 0.05,
                      //color: Colors.brown,
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.all(deviceHeight * 0.0049),
                        child: Text(
                          DateFormat.yMd().format(date),
                          style: GoogleFonts.gabriela(
                              color: Color(0xFF292f38),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(

              height: deviceHeight * 0.11,
              width: deviceWidth * 0.2,
              alignment: Alignment.centerRight,
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: EdgeInsets.only(right: deviceWidth * 0.03),
                  child: IconButton(
                    splashColor: Colors.red[100],
                    splashRadius: deviceWidth * 0.05,
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                    iconSize: deviceHeight * 0.03,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Are you sure ?'),
                          content:
                              Text("Do you want to remove the Transaction ?"),
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
                                await deleteTrans({
                                  'type': type,
                                  'id': id,
                                }, context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
