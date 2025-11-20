import 'package:base_app/home/chart/chart.dart';
import 'package:base_app/home/supplies/new_supply.dart';
import 'package:base_app/home/supplies/supplies_list.dart';
import 'package:base_app/model/base_app_inventory_item.dart';
import 'package:base_app/model/base_app_parameter.dart';
import 'package:base_app/service/inventory_service.dart';
import 'package:base_app/service/parameter_service.dart';
import 'package:flutter/material.dart';

class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({super.key});

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  var isLoading = false;
  final parameterService = ParameterService();
  final inventoryService = InventoryService();
  List<BaseAppParameter>? parameters = [];
  List<BaseAppInventoryItem> inventoryList = [];

  @override
  void initState() {
    super.initState();
    loadParameters();
    loadSupplies();
  }

  void loadParameters() async {
    setState(() {
      isLoading = true;
    });

    var tempParameters = await parameterService.getParameters(
      context: context,
      paramClass: 'BASE_WEAPON',
    );

    setState(() {
      parameters = tempParameters;
      isLoading = false;
    });
  }

  void loadSupplies() async {
    setState(() {
      isLoading = true;
    });

    var tempInventory = await inventoryService.getInventory(
      context: context,
    );

    await Future.delayed(Durations.medium1);
    setState(() { 
      inventoryList = tempInventory!;
      isLoading = false;
    });
  }

  void addSupply() async {
    var newSupply = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewSupply(
          categories: parameters!,
        ),
      ),
    );

    if (newSupply != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(newSupply),
        ),
      );
    }

    loadSupplies();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text('No supplies found'),
    );

    if (isLoading) {
      mainContent = Center(
        child: CircularProgressIndicator(),
      );
    } else if (inventoryList.isNotEmpty) {
      mainContent = SuppliesList(
        inventoryList: inventoryList,
        categories: parameters!,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Supply Manager',
        ),
        actions: [
          IconButton(
            onPressed: addSupply,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(
            isLoading,
            inventoryList: inventoryList,
            categories: parameters!,
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
