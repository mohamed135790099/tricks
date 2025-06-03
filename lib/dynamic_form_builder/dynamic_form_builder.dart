import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class DynamicFormPage extends StatefulWidget {
  @override
  _DynamicFormPageState createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  Map<String, dynamic> formConfig = {};
  Map<String, TextEditingController> controllers = {};
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadFormConfig();
  }

  Future<void> _loadFormConfig() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/register_form_config.json');
      setState(() {
        formConfig = jsonDecode(jsonString);
        _initializeControllers();
      });
    } catch (e) {
      print('Error loading form config: $e');
    }
  }

  void _initializeControllers() {
    List<dynamic> fields = formConfig['form']['fields'];
    for (var field in fields) {
      if (field['type'] == 'text' ||
          field['type'] == 'email' ||
          field['type'] == 'phone') {
        controllers[field['name']] = TextEditingController();
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
            primary:
                _getColorFromHex(formConfig['form']['theme']['primaryColor']),
          )),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formData['birth_date'] = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse("0xFF$hexColor"));
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'location_city':
        return Icons.location_city;
      case 'calendar_today':
        return Icons.calendar_today;
      default:
        return Icons.text_fields;
    }
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Widget _buildField(Map<String, dynamic> field) {
    final theme = formConfig['form']['theme'];
    final borderRadius = theme['borderRadius']?.toDouble() ?? 12.0;

    switch (field['type']) {
      case 'text':
      case 'email':
      case 'phone':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            controller: controllers[field['name']],
            decoration: InputDecoration(
              labelText: field['label'],
              hintText: field['placeholder'],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              prefixIcon: Icon(_getIconData(field['icon'] ?? 'text_fields')),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            keyboardType: field['type'] == 'email'
                ? TextInputType.emailAddress
                : field['type'] == 'phone'
                    ? TextInputType.phone
                    : TextInputType.text,
            validator: (value) {
              if (field['required'] && (value == null || value.isEmpty)) {
                return 'هذا الحقل مطلوب';
              }
              if (field['validation'] != null) {
                if (field['type'] == 'text' &&
                    field['validation']['minLength'] != null &&
                    value!.length < field['validation']['minLength']) {
                  return 'يجب أن يكون طول النص على الأقل ${field['validation']['minLength']} أحرف';
                }
                if (field['type'] == 'text' &&
                    field['validation']['maxLength'] != null &&
                    value!.length > field['validation']['maxLength']) {
                  return 'يجب أن لا يتجاوز طول النص ${field['validation']['maxLength']} أحرف';
                }
                if ((field['type'] == 'email' || field['type'] == 'phone') &&
                    !RegExp(field['validation']).hasMatch(value!)) {
                  return field['type'] == 'email'
                      ? 'بريد إلكتروني غير صالح'
                      : 'رقم هاتف غير صالح';
                }
              }
              return null;
            },
            onSaved: (value) {
              formData[field['name']] = value;
            },
          ),
        );

      case 'dropdown':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field['label'],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              prefixIcon:
                  Icon(_getIconData(field['icon'] ?? 'arrow_drop_down')),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            items: (field['options'] as List<dynamic>)
                .map((option) => DropdownMenuItem<String>(
                      value: option.toString(),
                      child: Text(option.toString()),
                    ))
                .toList(),
            onChanged: (value) {
              formData[field['name']] = value;
            },
            validator: (value) {
              if (field['required'] && value == null) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
          ),
        );

      case 'date':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: field['label'],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                prefixIcon:
                    Icon(_getIconData(field['icon'] ?? 'calendar_today')),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    selectedDate == null
                        ? 'اختر التاريخ'
                        : "${selectedDate!.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        );

      case 'checkbox':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FormField<bool>(
            validator: (value) {
              if (field['required'] && (value == null || !value)) {
                return 'يجب الموافقة على الشروط والأحكام';
              }
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: formData[field['name']] ?? false,
                        onChanged: (value) {
                          setState(() {
                            formData[field['name']] = value;
                          });
                          state.didChange(value);
                        },
                      ),
                      Expanded(
                        child: Text(
                          field['label'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );

      case 'submit':
        final buttonStyle = field['buttonStyle'] ?? {};
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                controllers.forEach((key, controller){
                  if (kDebugMode) {
                    print('$key: ${controller.text}');
                  }
                });

                _formKey.currentState!.save();
               // _showSuccessDialog();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColorFromHex(
                  buttonStyle['backgroundColor'] ??
                      formConfig['form']['theme']['primaryColor'] ??
                      '#4CAF50'),
              elevation: buttonStyle['elevation']?.toDouble() ?? 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.all(buttonStyle['padding']?.toDouble() ?? 16.0),
              child: Text(
                field['label'],
                style: TextStyle(
                  fontSize: 18,
                  color:
                      _getColorFromHex(buttonStyle['textColor'] ?? '#FFFFFF'),
                ),
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم بنجاح'),
        content: const Text('تم حفظ البيانات بنجاح'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (formConfig.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final formTheme = formConfig['form']['theme'];
    final primaryColor =
        _getColorFromHex(formTheme['primaryColor'] ?? '#4CAF50');

    return Theme(
      data: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.light(primary: primaryColor),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                formTheme['borderRadius']?.toDouble() ?? 12.0),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
            title: Text(formConfig['form']['title']),
            centerTitle: true,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                    formTheme['borderRadius']?.toDouble() ?? 16.0),
              ),
            )),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (formConfig['form']['description'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    formConfig['form']['description'],
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              Card(
                elevation: formTheme['cardElevation']?.toDouble() ?? 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      formTheme['borderRadius']?.toDouble() ?? 12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: (formConfig['form']['fields'] as List<dynamic>)
                          .map((field) => _buildField(field))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
