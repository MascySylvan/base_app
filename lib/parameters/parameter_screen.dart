import 'package:base_app/model/base_app_parameter.dart';
import 'package:base_app/parameters/new_parameter.dart';
import 'package:base_app/service/parameter_service.dart';
import 'package:flutter/material.dart';

class ParameterScreen extends StatefulWidget {
  const ParameterScreen({super.key});

  @override
  State<ParameterScreen> createState() => _ParameterScreenState();
}

class _ParameterScreenState extends State<ParameterScreen> {
  final parameterService = ParameterService();
  var isLoading = false;
  List<BaseAppParameter>? parameters = [];
  List<BaseAppParameter>? filteredParameters = [];

  @override
  void initState() {
    super.initState();
    loadParameters();
  }

  void loadParameters() async {
    setState(() {
      isLoading = true;
    });

    var tempParameters = await parameterService.getParameters(
      context: context,
      paramClass: 'ALL',
    );

    setState(() {
      parameters = tempParameters;
      filteredParameters = tempParameters;
      isLoading = false;
    });
  }

  void addParameter() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewParameter(),
      ),
    );

    loadParameters();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'No Parameters Saved',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );

    if (isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    } else if (parameters != null && parameters!.isNotEmpty) {
      content = Column(
        children: [
          TextField(
            style: Theme.of(context).textTheme.titleMedium,
            onChanged: (value) {
              setState(() {
                filteredParameters = value.isNotEmpty
                    ? parameters
                          ?.where(
                            (param) => param.paramClass.toUpperCase().contains(
                              value.toUpperCase().replaceAll(' ', '_'),
                            ),
                          )
                          .toList()
                    : parameters;
              });
            },
            decoration: InputDecoration(
              label: Text('Search by Class'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredParameters!.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(filteredParameters![index].paramName),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: Color(
                    int.parse(filteredParameters![index].paramColor, radix: 16),
                  ),
                ),
                trailing: Text(
                  filteredParameters![index].paramClass,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Parameter Settings'),
        actions: [
          IconButton(
            onPressed: addParameter,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: content,
      ),
    );
  }
}
