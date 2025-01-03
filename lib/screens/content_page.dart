import 'package:flutter/material.dart';
import '../services/content_service.dart';
import '../models/content_model.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final ContentService _contentService = ContentService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  List<ContentModel> _contents = [];

  @override
  void initState() {
    super.initState();
    _fetchContents();
  }

  Future<void> _fetchContents() async {
    final contents = await _contentService.getAllContents();
    setState(() {
      _contents = contents;
    });
  }

  Future<void> _addContent() async {
    final content = ContentModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text,
      category: _categoryController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      about: _aboutController.text,
    );
    await _contentService.addContent(content);
    _fetchContents();
    _clearFields();
  }

  void _clearFields() {
    _nameController.clear();
    _categoryController.clear();
    _priceController.clear();
    _aboutController.clear();
  }

  Future<void> _deleteContent(String id) async {
    await _contentService.deleteContent(id);
    _fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Content CRUD')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _aboutController,
              decoration: InputDecoration(labelText: 'About'),
            ),
          ),
          ElevatedButton(
            onPressed: _addContent,
            child: Text('Add Content'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contents.length,
              itemBuilder: (context, index) {
                final content = _contents[index];
                return ListTile(
                  title: Text(content.name),
                  subtitle: Text(content.category),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteContent(content.id.toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
