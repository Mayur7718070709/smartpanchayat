import 'package:flutter/material.dart';

import '../../core/app_runtime.dart';
import '../../core/network/api_exception.dart';
import '../../models/feedback_model.dart';
import '../../theme/app_theme.dart';
import 'feedback_screen.dart';

class FeedbackAvailabilityScreen extends StatefulWidget {
  const FeedbackAvailabilityScreen({super.key});
  @override
  State<FeedbackAvailabilityScreen> createState() =>
      _FeedbackAvailabilityScreenState();
}

class _FeedbackAvailabilityScreenState
    extends State<FeedbackAvailabilityScreen> {
  bool _loading = true;
  String? _error;
  List<FeedbackEligibleRequest> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await AppRuntime.feedback.eligibleRequests();
      if (mounted) {
        setState(() {
          _items = items;
          _loading = false;
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load completed requests.';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.backgroundLight,
    appBar: AppBar(
      title: const Text('Feedback'),
      backgroundColor: AppTheme.surfaceLight,
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!),
                TextButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          )
        : _items.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No completed service request is currently eligible for feedback.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final item = _items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.serviceNameEn),
                    subtitle: Text(item.requestNumber),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => FeedbackScreen(
                          serviceTitle: item.serviceNameEn,
                          requestId: item.serviceRequestId,
                          serviceType: item.serviceId,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
  );
}
