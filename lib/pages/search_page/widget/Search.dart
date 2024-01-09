import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sossoldi/database/sossoldi_database.dart';
import 'package:sossoldi/model/transaction.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<Search> {
  List<Map<String, dynamic>> searchResults =
      []; // Updated to use Map for results

  void onQueryChanged(String query) async {
    final results = await SossoldiDatabase.instance.searchTransactions(query);

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Transactions'),
      ),
      body: Column(
        children: [
          SearchBar(onQuery: onQueryChanged),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                // You can access the search results and display them here
                final transaction = searchResults[index];
                return ListTile(
                  title: Text(transaction[TransactionFields.note] +
                      ' ' +
                      transaction[TransactionFields.amount].toString()),
                  subtitle: Text(
                    '${transaction[TransactionFields.type].toString()
                    } at ${DateTime.parse(transaction[TransactionFields.date]).toLocal().toString().split('.')[0]}',
                  ),

                  // You can display other transaction details as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final void Function(String query) onQuery;

  const SearchBar({super.key, required this.onQuery});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        onChanged: (newQuery) {
          setState(() {
            query = newQuery;
          });
          widget.onQuery(
              newQuery); // Call the onQuery function passed from the parent widget
        },
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
