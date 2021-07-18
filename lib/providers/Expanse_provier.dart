
import '../widgets/Data_Structure.dart';
import 'package:flutter/material.dart';
import '../database/My_database.dart';

class ExpanseProvider with ChangeNotifier {
  List<DataSample> _expenseItems = [];


  List<DataSample> get getExpenseItems {
    return [..._expenseItems.reversed];
  }

  DataSample findId(int id) {
    return _expenseItems.firstWhere((element) => id == element.id);
  }

  Future<void> deleteExpanse(int id) async {
    try {
      final MyDatabase dbManager = MyDatabase();
      await dbManager.deleteTransaction(id, "Expense");
      _expenseItems.removeWhere((element) => element.id == id);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }



  Future<void> updateExpense(DataSample newProduct) async {
    try {
      final MyDatabase dbManager = MyDatabase();
      await dbManager.updateTransaction(newProduct, "Expense");
      final proIndex =
          _expenseItems.indexWhere((element) => element.id == newProduct.id);
      _expenseItems[proIndex] = newProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addExpanseTransaction(DataSample newData) async {
    final MyDatabase dbManager = MyDatabase();
    try {
      int newId = await dbManager.insertData(newData, "Expense");
      newData = DataSample(
        title: newData.title,
        datetime: newData.datetime,
        id: newId,
        price: newData.price,
        description: newData.description,
      );
      _expenseItems.add(newData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<List<double>> allExpense() async {
    final forToday = DateTime.now().subtract(Duration(days: 1));
    final forWeek = DateTime.now().subtract(Duration(days: 7));
    final forMonth = DateTime.now().subtract(Duration(days: 30));
    final forYear = DateTime.now().subtract(Duration(days: 365));
    try {
      await fetchAndSetExpanse();
      double cnt1 = 0, cnt2 = 0, cnt3 = 0, cnt4 = 0;

      for (int i = 0; i < _expenseItems.length; i++) {
        if (_expenseItems[i].datetime.isAfter(forToday)) {
          cnt4 += _expenseItems[i].price;
        }
        if (_expenseItems[i].datetime.isAfter(forWeek)) {
          cnt1 += _expenseItems[i].price;
        }
        if (_expenseItems[i].datetime.isAfter(forMonth)) {
          cnt2 += _expenseItems[i].price;
        }
        if (_expenseItems[i].datetime.isAfter(forYear)) {
          cnt3 += _expenseItems[i].price;
        }
      }
      return [cnt1, cnt2, cnt3, cnt4];

    } catch (e) {
      throw  e;
    }

  }

  Future<void> fetchAndSetExpanse() async {
    final MyDatabase dbManager = MyDatabase();

    try {
      _expenseItems = await dbManager.getDataList("Expense");
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  int get expanseItemsLength {
    return _expenseItems.length;
  }

}
