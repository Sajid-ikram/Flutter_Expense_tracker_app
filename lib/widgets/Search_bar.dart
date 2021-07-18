import 'package:flutter/material.dart';
import 'package:transaction/providers/Expanse_provier.dart';
import 'package:transaction/providers/Income_provider.dart';
import '../widgets/Data_Structure.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'individual_item.dart';

class CustomSearchDelegate extends SearchDelegate<DataSample> {
  final String type;
  final String symbol;
  CustomSearchDelegate({@required this.type,@required this.symbol});

  @override
  String get searchFieldLabel => 'Search by Title or Date';

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<DataSample> searchItems;
    if (type == "Expense") {
      searchItems = Provider.of<ExpanseProvider>(context, listen: false)
          .getExpenseItems
          .where((element) =>
              (element.title.toLowerCase().contains(query.toLowerCase())) ||
              (DateFormat.yMd().format(element.datetime).contains(query)))
          .toList();
    } else {
      searchItems = Provider.of<IncomeProvider>(context, listen: false)
          .getIncomeItems
          .where((element) =>
              (element.title.toLowerCase().contains(query.toLowerCase())) ||
              (DateFormat.yMd().format(element.datetime).contains(query)))
          .toList();
    }

    return ListView.builder(
        itemCount: searchItems.length,
        itemBuilder: (ctx, index) {
          return IndividualItems(
            symbol: symbol,
            title: searchItems[index].title,
            type: type,
            price: searchItems[index].price,
            date: searchItems[index].datetime,
            id: searchItems[index].id,
            description: searchItems[index].description,
          );
        },

    );
  }
}
