import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_10/item_model.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi List Item',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: ItemListPage(),
    );
  }
}

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<ItemModel> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // BARU: Controller dan variabel state untuk fitur pencarian
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<ItemModel> _dummyItems = [
    ItemModel(id: 1, name: 'Laptop', description: 'Laptop Gamink'),
    ItemModel(id: 2, name: 'Mouse', description: 'Mouse Tetikus'),
    ItemModel(id: 3, name: 'Keyboard', description: 'Keyboard Mekanik'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString('items_list');

    if (itemsString != null) {
      List<dynamic> itemsMap = json.decode(itemsString);
      setState(() {
        _items = itemsMap.map((item) => ItemModel.fromMap(item)).toList();
      });
    } else {
      setState(() {
        _items = List.from(_dummyItems);
      });
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> itemsMap = _items.map((item) => item.toMap()).toList();
    String itemsString = json.encode(itemsMap);
    await prefs.setString('items_list', itemsString);
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama dan Deskripsi tidak boleh kosong')),
      );
      return;
    }
    int newId = _items.isNotEmpty ? _items.last.id + 1 : 1;
    ItemModel newItem = ItemModel(
      id: newId,
      name: _nameController.text,
      description: _descController.text,
    );
    setState(() {
      _items.add(newItem);
    });
    await _saveData();
    _nameController.clear();
    _descController.clear();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item berhasil ditambahkan')),
    );
  }

  Future<void> _deleteItem(int id) async {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
    await _saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item berhasil dihapus')),
    );
  }

  void _showAddDialog() {
    showDialog(context: context,
     builder: (context) {
      return AlertDialog(
        title: Text('Tambah Item Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Item'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
           _nameController.clear();
           _descController.clear();
           Navigator.pop(context);
           },
           child: Text('Batal'),
           ),
           ElevatedButton(onPressed: _addItem,
            child: Text('Simpan'),
            )
        ],
      );
     }
    );
  }

  @override
  Widget build(BuildContext context) {
    // BARU: Logika filter. Hanya item yang mengandung teks pencarian yang akan dimasukkan ke list ini.
    List<ItemModel> displayedItems = _items.where((item) {
      return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             item.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
        centerTitle: true,
      ),
      // BARU: Mengubah body menjadi Column agar bisa menampung Search Bar dan ListView
      body: Column(
        children: [
          // UI SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Memperbarui UI setiap kali pengguna mengetik
                setState(() {
                  _searchQuery = value; 
                });
              },
              decoration: InputDecoration(
                labelText: 'Cari Item...',
                prefixIcon: Icon(Icons.search),
                // Tombol "X" untuk mereset teks pencarian
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          // UI LIST VIEW
          // BARU: Dibungkus dengan Expanded agar ListView mengambil sisa ruang layar
          Expanded(
            child: displayedItems.isEmpty
                ? Center(
                    // Pesan dinamis: Apakah kosong karena belum ada item, atau karena tidak ketemu saat dicari
                    child: Text(_searchQuery.isEmpty 
                        ? 'Tidak ada data. Tambahkan item baru' 
                        : 'Item tidak ditemukan'),
                  )
                : ListView.builder(
                    itemCount: displayedItems.length, // Gunakan displayedItems, bukan _items
                    itemBuilder: (context, index) {
                      final item = displayedItems[index]; // Gunakan displayedItems, bukan _items
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${item.id}'),
                            backgroundColor: Colors.blueGrey,
                          ),
                          title: Text(
                            item.name, 
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(item.description),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: CupertinoColors.destructiveRed),
                            onPressed: () {
                              _deleteItem(item.id);
                            },
                          ),
                        ),
                      );
                    }
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        tooltip: 'Tambah Item',
      ),
    );
  }
}