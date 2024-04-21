import 'package:flutter/material.dart';

void main() => runApp(GuiComponentsApp());

class GuiComponentsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GUI Components App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GuiComponentsPage(),
    );
  }
}

class GuiComponentsPage extends StatefulWidget {
  @override
  _GuiComponentsPageState createState() => _GuiComponentsPageState();
}

class _GuiComponentsPageState extends State<GuiComponentsPage> {
  final TextEditingController _itemController = TextEditingController();
  List<String> _items = [];

  void _addItem() {
    final String item = _itemController.text.trim();
    if (item.isNotEmpty) {
      setState(() {
        _items.add(item);
        _itemController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUI Components App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Enter an item',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _items.isEmpty
                  ? Center(
                child: Text(
                  'No items added yet',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        _items[index],
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _items.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
