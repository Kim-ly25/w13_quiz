import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  int _currentTab = 0;

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: IndexedStack(
        index: _currentTab,
        children: [GroceryTab(), GrocerySearch()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[400],
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: "Grocery",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}

class GroceryTab extends StatelessWidget {
  const GroceryTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (dummyGroceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: dummyGroceryItems.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: dummyGroceryItems[index]),
      );
    }
    return content;
  }
}

class GrocerySearch extends StatefulWidget {
  const GrocerySearch({super.key});

  @override
  State<GrocerySearch> createState() => _GrocerySearchState();
}

class _GrocerySearchState extends State<GrocerySearch> {
  String _searchQuery = "";

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  List<Grocery> get filteredGroceries {
    final List<Grocery> result = [];
    for (final Grocery grocery in dummyGroceryItems) {
      if (grocery.name.toLowerCase().startsWith(_searchQuery)) {
        result.add(grocery);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(onChanged: _onSearchChanged),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGroceries.length,
              itemBuilder: (context, index) =>
                  GroceryTile(grocery: filteredGroceries[index]),
            ),
          ),
        ],
      ),
    );
  }
}
