import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../providers/Expanse_provier.dart';
import '../providers/Income_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/Data_Structure.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class AddTransaction extends StatefulWidget {
  static const routeName = 'AddTransaction';

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var _initState = true;
  var trData;
  String initialPrice = '';

  var _newTransaction = DataSample(
    id: null,
    datetime: null,
    title: '',
    price: 0.0,
    description: '',
  );

  @override
  void didChangeDependencies() {
    if (_initState) {
      trData = ModalRoute.of(context).settings.arguments as Map;
      if (trData['id'] != 0) {
        if (trData['type'] == "Expense") {
          _newTransaction = Provider.of<ExpanseProvider>(context, listen: false)
              .findId(trData['id']);
        } else {
          _newTransaction = Provider.of<IncomeProvider>(context, listen: false)
              .findId(trData['id']);
        }
        _selectedDate = _newTransaction.datetime;
        initialPrice = _newTransaction.price.toString();


      }
    }
    _initState = false;
    super.didChangeDependencies();
  }

  final _gKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();



  void _presentDatePicker() {

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      setState(() {
        _selectedDate = pickedDate == null ? _selectedDate : pickedDate;
      });
    });
  }

  void _saveInput(String page) {
    final _isValid = _gKey.currentState.validate();
    if (!_isValid) {
      return;
    }

    _gKey.currentState.save();
    _newTransaction = DataSample(
      title: _newTransaction.title,
      datetime: _selectedDate,

      id: _newTransaction.id,
      price: _newTransaction.price,
      description: _newTransaction.description,
    );

    deleteOrUpdate(page);
  }

  Future<void> deleteOrUpdate(String page) async {
    if (_newTransaction.id == null) {
      if (page == 'Expense') {
        await Provider.of<ExpanseProvider>(context, listen: false)
            .addExpanseTransaction(_newTransaction)
            .then((value) => Navigator.of(context).pop())
            .catchError((error) {
          return _onError();
        });
      } else {
        await Provider.of<IncomeProvider>(context, listen: false)
            .addIncomeTransaction(_newTransaction)
            .then((value) => Navigator.of(context).pop())
            .catchError((error) {
          return _onError();
        });
      }
    } else {
      if (page == 'Expense') {
        await Provider.of<ExpanseProvider>(context, listen: false)
            .updateExpense(_newTransaction)
            .then((value) => Navigator.of(context).pop())
            .catchError((error) {
          return _onError();
        });
      } else {
        await Provider.of<IncomeProvider>(context, listen: false)
            .updateIncome(_newTransaction)
            .then((value) => Navigator.of(context).pop())
            .catchError((error) {
          return _onError();
        });
      }
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

  @override
  Widget build(BuildContext context) {
    final siz = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
    ));
    return Scaffold(
        backgroundColor: Color(0xFF9ad3bc),
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Color(0xFF495464)),
          title: Text(trData['type'],
              style: GoogleFonts.dancingScript(
                  color: Color(0xFF495464), fontSize: siz*0.038)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                size: siz*0.031,
              ),
              onPressed: () {
                _saveInput(trData['type']);
              },
            )
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _gKey,
            child: ListView(
              children: <Widget>[

                SizedBox(height: 15),
                TextFormField(
                  initialValue: _newTransaction.title,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a title';
                    }
                    if (value.length>40) {
                      return 'Title length should not cross 40 character';
                    }
                    return null;
                  },

                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9ad3bc)),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9ad3bc)),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: 'Title',
                  ),
                  maxLength: 40,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _newTransaction = DataSample(
                      title: value,
                      datetime: _newTransaction.datetime,
                      id: _newTransaction.id,
                      price: _newTransaction.price,
                      description: _newTransaction.description,
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: initialPrice,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid price';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price should be greater then zero !';
                    }
                    if (value.length>15) {
                      return 'Enter a price less then 16 Character';
                    }
                    return null;
                  },
                  maxLength: 15,
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9ad3bc)),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9ad3bc)),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: 'Amount',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _newTransaction = DataSample(
                      title: _newTransaction.title,
                      datetime: _newTransaction.datetime,
                      id: _newTransaction.id,
                      price: double.parse(value),
                      description: _newTransaction.description,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _newTransaction.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9ad3bc)),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9ad3bc)),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: 'Description',
                  ),
                  onSaved: (value) {
                    _newTransaction = DataSample(
                      title: _newTransaction.title,
                      datetime: _newTransaction.datetime,
                      id: _newTransaction.id,
                      price: _newTransaction.price,
                      description: value,
                    );
                  },
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? ' No Date Chosen!'
                              : ' Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text('Choose Date',
                            style: GoogleFonts.gabriela(
                                color: Colors.black87, fontSize: 15)),
                        onPressed: _presentDatePicker,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
