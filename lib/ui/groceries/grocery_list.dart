import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
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


class _GroceryListState extends State<GroceryList> {
  int _currenTabIndex = 0; // by default
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
        index: _currenTabIndex,
        children: [GroceriesTab(), SeearchTab()],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: _currenTabIndex,
        onTap: (index) {
          setState(() {
            _currenTabIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Groceries'),
        ],
      ),
    );
  }
}

class SeearchTab extends StatefulWidget {
  const SeearchTab({super.key});

  @override
  State<SeearchTab> createState() => _SeearchTabState();
}

class _SeearchTabState extends State<SeearchTab> {
  String searchText = "";

  void onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  List<Grocery> get filteredList {
    List<Grocery> result = [];
    for(Grocery g in dummyGroceryItems) {
      if (g.name.startsWith(searchText)) {
        result.add(g);
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextField(onChanged: onSearchChanged),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) =>
                  GroceryTile(grocery: filteredList[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class GroceriesTab extends StatelessWidget {
  const GroceriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (dummyGroceryItems.isNotEmpty) {
      //  Display groceries with an Item builder and  LIst Tile
      content = ListView.builder(
        itemCount: dummyGroceryItems.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: dummyGroceryItems[index]),
      );
    }

    return content;

  }
}

