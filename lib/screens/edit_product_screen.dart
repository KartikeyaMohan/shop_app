import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: ''
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)?.settings.arguments as String;
        _editedProduct = Provider.of<ProductProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty == true || 
          (_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) || 
          (_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid == false) {
      return;
    }
    _form.currentState?.save();
    if (_editedProduct.id != null) {
      Provider.of<ProductProvider>(context, listen: false).updateProduct(_editedProduct.id!, _editedProduct);
    }
    else {
      Provider.of<ProductProvider>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm, 
            icon:  const Icon(Icons.save)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5
        ),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(
                  labelText: 'Title'
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite, 
                    title: value as String, 
                    description: _editedProduct.description, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl)
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(
                  labelText: 'Price'
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a price';
                  }
                  if (value != null &&
                      double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (value != null &&
                      double.parse(value) == 0) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
                onSaved: (value) => {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    isFavourite: _editedProduct.isFavourite, 
                    title: _editedProduct.title, 
                    description: _editedProduct.description, 
                    price: double.parse(value as String), 
                    imageUrl: _editedProduct.imageUrl)
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(
                  labelText: 'Description'
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a description';
                  }
                  if (value != null &&
                      value.length < 10) {
                    return 'Description should be greater than 10 characters.';
                  }
                  return null;
                },
                onSaved: (value) => {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    isFavourite: _editedProduct.isFavourite, 
                    title: _editedProduct.title, 
                    description: value as String, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl)
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)
                    ),
                    child: _imageUrlController.text.isEmpty ? 
                      const Text('Enter a URL') : 
                      FittedBox(
                        child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Please enter a image url';
                        }
                        if (value != null &&
                            (!value.startsWith('http') && !value.startsWith('https'))) {
                          return 'Please enter a valud URL.';
                        }
                        if (value != null &&
                            (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg'))) {
                          return 'Please enter a valid image URL';
                        }
                        return null;
                      },
                      onSaved: (value) => {
                        _editedProduct = Product(
                          id: _editedProduct.id, 
                          isFavourite: _editedProduct.isFavourite, 
                          title: _editedProduct.title, 
                          description: _editedProduct.description, 
                          price: _editedProduct.price, 
                          imageUrl: value as String)
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}