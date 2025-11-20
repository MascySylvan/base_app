import 'package:base_app/parameters/wheel_color_picker.dart';
import 'package:base_app/service/parameter_service.dart';
import 'package:flutter/material.dart';

class NewParameter extends StatefulWidget {
  const NewParameter({super.key});

  @override
  State<NewParameter> createState() {
    return _NewParameterState();
  }
}

class _NewParameterState extends State<NewParameter> {
  final parameterService = ParameterService();
  final formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredClass = '';
  var selectedColor = "FF000000";
  var isSending = false;

  void saveItem() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isSending = true;
      });

      var response = await parameterService.saveParameter(
        context: context,
        paramClass: enteredClass,
        paramName: enteredName,
        paramColor: selectedColor,
      );

      if (response != null) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new parameter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 10,
            children: [
              TextFormField(
                maxLength: 50,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  label: Text('Parameter Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 Characters';
                  }

                  return null;
                },
                enabled: !isSending,
                onSaved: (value) {
                  enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 50,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        label: Text('Parameter Class'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Must be between 1 and 50 Characters';
                        }

                        return null;
                      },
                      enabled: !isSending,
                      onSaved: (value) {
                        enteredClass = value!.toUpperCase().replaceAll(
                          ' ',
                          '_',
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          WheelColorPicker(
                            initialColorString: selectedColor,
                            onColorSelected: (colorString) {
                              setState(() {
                                selectedColor = colorString;
                              });
                            },
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                color: Color(
                                  int.parse(selectedColor, radix: 16),
                                ),
                              ),
                              Text(
                                selectedColor,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            formKey.currentState!.reset();
                          },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: isSending ? null : saveItem,
                    child: isSending
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text('Add Parameter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
