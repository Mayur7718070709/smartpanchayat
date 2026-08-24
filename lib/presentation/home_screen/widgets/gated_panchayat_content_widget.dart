import 'package:flutter/material.dart';
import '../../../core/app_runtime.dart';
import '../../../models/panchayat_content_model.dart';
import '../../../theme/app_theme.dart';

enum PanchayatContentType { contacts, events }

class GatedPanchayatContentWidget extends StatefulWidget {
  const GatedPanchayatContentWidget({required this.type, super.key});
  final PanchayatContentType type;
  @override
  State<GatedPanchayatContentWidget> createState() => _State();
}

class _State extends State<GatedPanchayatContentWidget> {
  bool loading = true;
  String? error;
  List<Object> items = [];
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final value = widget.type == PanchayatContentType.contacts
          ? await AppRuntime.panchayatContent.contacts()
          : await AppRuntime.panchayatContent.events();
      if (mounted) {
        setState(() {
          items = value.cast<Object>();
          loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          error = 'Could not load Panchayat information.';
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (error != null) {
      return Center(
        child: TextButton.icon(
          onPressed: load,
          icon: const Icon(Icons.refresh),
          label: Text(error!),
        ),
      );
    }
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          widget.type == PanchayatContentType.events
              ? 'No upcoming official events are currently published.'
              : 'No official contacts are currently published.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return Column(
      children: items.map((item) {
        if (item is OfficialContact) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(item.nameMr),
              subtitle: Text(
                [
                  item.nameEn,
                  item.phone,
                  item.email,
                ].whereType<String>().join('\n'),
              ),
            ),
          );
        }
        final event = item as PanchayatEvent;
        return Card(
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(event.titleMr),
            subtitle: Text(
              '${event.titleEn}\n${event.venueEn}\n${event.startsAt.toLocal()}',
            ),
          ),
        );
      }).toList(),
    );
  }
}
