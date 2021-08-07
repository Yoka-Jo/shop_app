import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_jumia_app/repositories/authentication.dart';
import '../cubit/manage_products_cubit.dart';
import '../data/product_data.dart';
import '../models/Lists_name.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageFocusUrl = FocusNode();
  var product;

  TextEditingController imageController;
  String selectedKind ;
  var _initValues = {
  'kind': '',
  'title': '',
  'description': '',
  'price': '',
  'imageUrl': '',
  };

  DropdownButton <String> kindDropList(){
    List <DropdownMenuItem<String>> dropDownItems = [];
    for(var kind in kindData) {
      var newItem = DropdownMenuItem(
          child: Text(kind),
          value: kind
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      underline: Container(),
      value: selectedKind,
      items: dropDownItems,
      onChanged: (value){
        setState((){
            selectedKind = value;
        });

      }
    );
  }

  Product _editedProduct =
  Product(
      kind: '',
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '');

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    product = ModalRoute.of(context).settings.arguments as Map<String , String>;
   if(product['id'] != null){
     _editedProduct = BlocProvider.of<ManageProductsCubit>(context).findById(product['id']);
     _initValues = {
       'kind': _editedProduct.kind,
       'title': _editedProduct.title,
       'description': _editedProduct.description,
       'price': _editedProduct.price.toString(),
       'imageUrl': '',
     };
     imageController.text = _editedProduct.imageUrl;
     selectedKind = _initValues['kind'];
   }
   else{
     selectedKind = 'T-Shirts';
   }
    super.didChangeDependencies();
  }


  @override
  void initState() {
    imageController = TextEditingController();
    _imageFocusUrl.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageFocusUrl.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    imageController.dispose();
    _imageFocusUrl.removeListener(_updateImageUrl);
    _imageFocusUrl.dispose();
    super.dispose();
  }

  void _saveForm(String userId) async{
    final validate = _form.currentState.validate();
    if (!validate) {
      return;
    }

    _form.currentState.save();


    setState(() {
      _isLoading = true;
    });

    _editedProduct = Product(
        kind: selectedKind,
        id: _editedProduct.id,
        isFavourite: _editedProduct.isFavourite,
        title: _editedProduct.title,
        description: _editedProduct.description,
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl
    );
   
    if(_editedProduct.id != null){
      try{
        await BlocProvider.of<ManageProductsCubit>(context).updateProduct(_editedProduct.id, _editedProduct , product['authData']);
      }catch(error){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong...'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    else{
      try{
        await context.read<ManageProductsCubit>().addProduct(_editedProduct , product['authData'] ,userId);
      }catch (error){
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong...'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Authentication>(context).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(userId),
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              TextForm(
                initialValue: _initValues['title'],
                suffix: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: kindDropList(),
                ),
                labelName: 'Title',
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter something';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    kind: _editedProduct.kind,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextForm(
                initialValue: _initValues['description'],
                labelName: 'Description',
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Something';
                  } else if (value.length < 10) {
                    return 'Please Enter More Than 10 Characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      kind: _editedProduct.kind,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextForm(
                  initialValue: _initValues['price'],
                  labelName: 'Price',
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Something';
                    } else if (double.parse(value) < 0) {
                      return 'Please Enter Positve Number';
                    } else if (double.tryParse(value) == null) {
                      return 'Please Enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        kind: _editedProduct.kind,
                        id: _editedProduct.id,
                        isFavourite: _editedProduct.isFavourite,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value),
                        imageUrl: _editedProduct.imageUrl);
                  }),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)
                    ),
                    child: imageController.text.isEmpty ? FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Add Image'),
                        )) : Container(
                        height: 120,
                        width: 120,
                        child: Image.network(
                          imageController.text, fit: BoxFit.cover,)
                    ),
                  ),
                  Expanded(
                      child: TextForm(
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _saveForm(userId);
                          },
                          focusNode: _imageFocusUrl,
                          labelName: 'Image URL',
                          controller: imageController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter something';
                            } else if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please Enter a valid URL.';
                            } else if (value.endsWith('png') &&
                                value.endsWith('jpg') &&
                                value.endsWith('jpeg')) {
                              return 'Please Enter a valid Image URL.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                kind: _editedProduct.kind,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value);
                          }
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextForm extends StatelessWidget {
  final Widget suffix;
  final Function (String) onFieldSubmitted;
  final TextInputAction textInputAction;
  final String labelName;
  final TextEditingController controller;
  final String Function(String) validator;
  final int maxLines;
  final FocusNode focusNode;
  final String initialValue;
  final void Function(String) onSaved;

  const TextForm({this.labelName,
    this.controller,
    this.validator,
    this.maxLines = 1,
    this.onSaved, this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffix, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffix,
          labelText: labelName,
          labelStyle: TextStyle(color: Colors.grey),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
