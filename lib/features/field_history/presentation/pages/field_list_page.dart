import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_gps_area/core/constants/route_constants.dart';
import 'package:smart_gps_area/core/gis/unit_converter.dart';
import 'package:smart_gps_area/features/field_history/presentation/bloc/field_history_bloc.dart';
import 'package:smart_gps_area/features/field_measurement/domain/entities/field_entity.dart';
import 'package:smart_gps_area/injection/injection_container.dart';

class FieldListPage extends StatelessWidget {
  const FieldListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FieldHistoryBloc>()..add(const FieldHistoryLoaded()),
      child: const _FieldListView(),
    );
  }
}

class _FieldListView extends StatelessWidget {
  const _FieldListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Fields')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search fields...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<FieldHistoryBloc>().add(
                  FieldHistorySearchChanged(query),
                );
              },
            ),
          ),
          // Fields list
          Expanded(
            child: BlocBuilder<FieldHistoryBloc, FieldHistoryState>(
              builder: (context, state) {
                if (state.status == FieldHistoryStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == FieldHistoryStatus.error) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }

                if (state.fields.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.landscape_outlined,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.searchQuery.isEmpty
                              ? 'No saved fields yet.\nMeasure a field to get started!'
                              : 'No fields matching "${state.searchQuery}"',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.fields.length,
                  itemBuilder: (context, index) {
                    final field = state.fields[index];
                    return _FieldCard(field: field);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.field});

  final FieldEntity field;

  @override
  Widget build(BuildContext context) {
    final converter = getIt<UnitConverter>();
    final hectares = converter.toHectares(field.areaSqMeters);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.terrain,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          field.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${hectares.toStringAsFixed(4)} ha  •  ${field.points.length} points',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmDelete(context, field),
        ),
        onTap: () {
          context.push(
            RouteConstants.fieldDetail.replaceFirst(':id', field.id),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, FieldEntity field) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Field?'),
        content: Text(
          'Are you sure you want to delete "${field.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<FieldHistoryBloc>().add(
                FieldHistoryDeleteRequested(field.id),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('"${field.name}" deleted')),
                );
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
