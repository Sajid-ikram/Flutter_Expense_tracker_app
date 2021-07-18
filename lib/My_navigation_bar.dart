import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'Screens/Expense_screen.dart';
import 'Screens/Home_screen.dart';
import 'Screens/Income_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyNavigationBar extends StatefulWidget {
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {

  int _index = 1;
  PageController _pageController = PageController(initialPage: 1);

  List<Widget> _selectedScreen = <Widget>[
    IncomeScreen(),
    HomeScreen(),
    ExpenseScreen(),
  ];

  void _onPageChange(int value) {
      setState(() {
        _index = value;
      });
  }


  @override
  Widget build(BuildContext context) {
    final siz = MediaQuery.of(context).size.width;

    double a = siz * 0.13,b = siz * 0.077;

    if(siz * 0.13<50 || siz * 0.13>74){
      if(siz<600){
        a = 50.00;
        b = 29.00;
      }
      else if(siz<1000){
        a = 65.00;
        b = 40.00;
      }
      else{
        a = 73.00;
        b = 42.00;
      }
    }


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: PageView(
          controller: _pageController,
          children: _selectedScreen,
          onPageChanged: _onPageChange,

        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white60,
          height:a,
          buttonBackgroundColor: Colors.white,
          //color: Color(0xFF94B4A4),
          color: Color(0xFF9ad3bc),
          index: _index,
          items: <Widget>[
            Icon(Icons.account_balance_wallet_outlined,size : b,color: Color(0xFF495464),),
            Icon(Icons.home_outlined,size: b,color: Color(0xFF495464),),
            Icon(Icons.monetization_on_outlined,size: b,color: Color(0xFF495464),),
          ],
        
          animationCurve: Curves.bounceInOut,
          animationDuration:Duration(milliseconds: 300),
          onTap: (selectedIndex){
            _pageController.jumpToPage(selectedIndex);
          },
        ),
      ),
    );
  }
}
