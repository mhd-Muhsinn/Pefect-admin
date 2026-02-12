import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/blocs/transaction_cubit/transaction_cubit.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      buildWhen: (prev, next) => prev.search != next.search,
      builder: (context, state) {
        if (_controller.text != state.search) {
          _controller.text = state.search;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _controller,
            onChanged: (value) => context.read<TransactionsCubit>().setSearch(value),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search course or customer...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
              suffixIcon: state.search.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        context.read<TransactionsCubit>().clearFilters();
                        _controller.clear();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
