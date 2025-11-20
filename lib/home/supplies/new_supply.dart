import 'package:base_app/model/base_app_parameter.dart';
import 'package:base_app/service/inventory_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class NewSupply extends StatefulWidget {
  const NewSupply({super.key, required this.categories});

  final List<BaseAppParameter> categories;

  @override
  State<NewSupply> createState() => _NewSupplyState();
}

class _NewSupplyState extends State<NewSupply> {
  final inventoryService = InventoryService();
  final formKey = GlobalKey<FormState>();
  var isSending = false;

  var enteredItemName = '';
  var enteredQty = 1;
  var enteredUnitPrice = 1.00;
  var selectedCategory = '';

  void save() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });

      formKey.currentState!.save();

      final response = await inventoryService.save(
        context: context,
        category: selectedCategory,
        itemName: enteredItemName,
        quantity: enteredQty,
        unitPrice: enteredUnitPrice,
      );

      if (response != null) {
        Navigator.of(context).pop(response);
      } else {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCategory.isEmpty) {
      setState(() {
        selectedCategory = widget.categories.first.uuid;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new supply'),
      ),
      body: Padding(
        padding: EdgeInsets.all(75),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 30,
              children: [
                //--

                //ITEM NAME INPUT
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    label: Text('Item Name'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 5,
                      ),
                    ),
                  ),
                  enabled: !isSending,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Input an item name';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    enteredItemName = value!;
                  },
                ),

                //ITEM QUANTITY INPUT
                SpinBox(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    label: Text('Item Quantity'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 5,
                      ),
                    ),
                  ),
                  min: 1,
                  max: 100,
                  value: 1,
                  enabled: !isSending,
                  onChanged: (value) {
                    enteredQty = value as int;
                  },
                ),

                //ITEM UNIT PRICE
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    label: Text('Unit Price'),
                    prefixText: "\$ ",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 5,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !isSending,
                  initialValue: "1.00",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Input an amount';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    enteredUnitPrice = double.parse(value!);
                  },
                ),

                DropdownButtonFormField(
                  initialValue: widget.categories.first,
                  decoration: InputDecoration(
                    label: Text('Supply Category'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        width: 5,
                      ),
                    ),
                  ),
                  items: widget.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Row(
                            spacing: 10,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                color: Color(
                                  int.parse(
                                    category.paramColor,
                                    radix: 16,
                                  ),
                                ),
                              ),
                              Text(
                                category.paramName.toString().toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: !isSending
                      ? (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            BaseAppParameter v = value as BaseAppParameter;
                            selectedCategory = v.uuid;
                          });
                        }
                      : null,
                ),

                ElevatedButton(
                  onPressed: isSending ? null : save,
                  child: isSending
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : Text('Save'),
                ),

                //--
              ],
            ),
          ),
        ),
      ),
    );
  }
}
