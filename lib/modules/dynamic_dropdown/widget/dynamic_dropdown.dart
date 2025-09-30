import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/modules/dynamic_dropdown/cubit/dropdown_cubit.dart';

class DynamicDropdown extends StatelessWidget {
  final String title;
  final String firestoreField;
  final String? nestedKey; // for nested maps
  final dynamic currentValue;
  final Function(dynamic) onChanged;

  const DynamicDropdown({
    super.key,
    required this.title,
    required this.firestoreField,
    this.nestedKey,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DynamicDropdownCubit(firestoreField, nestedKey: nestedKey),
      child: BlocBuilder<DynamicDropdownCubit, List<String>>(
        builder: (context, items) {
          return DropdownButtonFormField(
            
            dropdownColor: PColors.backgrndPrimary,
            decoration: InputDecoration(labelText: title,fillColor: PColors.primaryVariant,border: OutlineInputBorder()),
            value: items.contains(currentValue) ? currentValue : null,
            items: [
              ...items.map((e) => DropdownMenuItem(child: Text(e), value: e)),
              DropdownMenuItem(child: Text('+ Add new'), value: '__addnew__'),
            ],
            onChanged: (val) async {
              if (val == '__addnew__') {
                String? newValue = await showDialog(
                  context: context,
                  builder: (_) {
                    String name = '';
                    return AlertDialog(
                      title: Text('Add new $title'),
                      content: TextField(
                        decoration: InputDecoration(labelText: "$title name"),
                        onChanged: (value) => name = value,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: Text("Cancel")),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, name),
                            child: Text("Add")),
                      ],
                    );
                  },
                );
                if (newValue != null && newValue.isNotEmpty) {
                  await context.read<DynamicDropdownCubit>().addNewItem(newValue);
                  onChanged(newValue);
                }
              } else {
                onChanged(val);
              }
            },
          );
        },
      ),
    );
  }
}
