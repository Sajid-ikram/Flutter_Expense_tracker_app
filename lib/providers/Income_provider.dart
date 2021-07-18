
import '../database/My_database.dart';
import '../widgets/Data_Structure.dart';
import 'package:flutter/material.dart';

class IncomeProvider with ChangeNotifier {
  List<DataSample> _incomeItems = [];

  List<DataSample> get getIncomeItems {
    return [..._incomeItems.reversed];
  }

  DataSample findId(int id) {
    return _incomeItems.firstWhere((element) => id == element.id);
  }

  Future<void> deleteIncome(int id) async {
    try {
      final MyDatabase dbManager = MyDatabase();
      await dbManager.deleteTransaction(id, "Income");
      _incomeItems.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }



  Future<void> updateIncome(DataSample newProduct) async {
    try {
      final MyDatabase dbManager = MyDatabase();
      await dbManager.updateTransaction(newProduct, "Income");
      final proIndex =
          _incomeItems.indexWhere((element) => element.id == newProduct.id);
      _incomeItems[proIndex] = newProduct;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<List<double>> allIncome() async {
    final forToday = DateTime.now().subtract(Duration(days: 1));
    final forWeek = DateTime.now().subtract(Duration(days: 7));
    final forMonth = DateTime.now().subtract(Duration(days: 30));
    final forYear = DateTime.now().subtract(Duration(days: 365));
    await fetchAndSetIncome().catchError((e) {
      throw e;
    });
    double cnt1 = 0, cnt2 = 0, cnt3 = 0, cnt4 = 0;

    for (int i = 0; i < _incomeItems.length; i++) {
      if (_incomeItems[i].datetime.isAfter(forToday)) {
        cnt4 += _incomeItems[i].price;
      }
      if (_incomeItems[i].datetime.isAfter(forWeek)) {
        cnt1 += _incomeItems[i].price;
      }
      if (_incomeItems[i].datetime.isAfter(forMonth)) {
        cnt2 += _incomeItems[i].price;
      }
      if (_incomeItems[i].datetime.isAfter(forYear)) {
        cnt3 += _incomeItems[i].price;
      }
    }
    return [cnt1, cnt2, cnt3, cnt4];
  }

  Future<void> addIncomeTransaction(DataSample newData) async {
    final MyDatabase dbManager = MyDatabase();
    try {
      int newId = await dbManager.insertData(newData, "Income");
      newData = DataSample(
        title: newData.title,
        datetime: newData.datetime,

        id: newId,
        price: newData.price,
        description: newData.description,
      );
      _incomeItems.add(newData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetIncome() async {
    final MyDatabase dbManager = MyDatabase();
    try {
      _incomeItems = await dbManager.getDataList("Income");
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  int get incomeItemsLength {
    return _incomeItems.length;
  }
}
