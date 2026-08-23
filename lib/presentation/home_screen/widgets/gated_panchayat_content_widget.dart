import 'package:flutter/material.dart';

import '../../../core/app_runtime.dart';
import '../../../core/network/api_exception.dart';
import '../../../theme/app_theme.dart';

enum PanchayatContentType { contacts, events }

class GatedPanchayatContentWidget extends StatefulWidget {
  const GatedPanchayatContentWidget({required this.type, super.key});

  final PanchayatContentType type;

  @override
  State<GatedPanchayatContentWidget> createState() =>
      _GatedPanchayatContentWidgetState();
}

class _GatedPanchayatContentWidgetState
    extends State<GatedPanchayatContentWidget> {
  bool _isLoading = true;
  bool _isUnavailable = false;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    setState(() {
      _isLoading = true;
      _isUnavailable = false;
    });
    try {
      if (widget.type == PanchayatContentType.contacts) {
        await AppRuntime.panchayatContent.checkContactsAvailability();
      } else {
        await AppRuntime.panchayatContent.checkEventsAvailability();
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isUnavailable = true;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _isUnavailable =
            error.code == ApiErrorCode.databaseContractGap ||
            error.code == ApiErrorCode.featureNotEnabled;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noun = widget.type == PanchayatContentType.contacts
        ? 'contacts'
        : 'events';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantLight),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : Column(
              children: [
                Icon(
                  _isUnavailable
                      ? Icons.info_outline_rounded
                      : Icons.cloud_off_rounded,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 8),
                Text(
                  _isUnavailable
                      ? 'Panchayat $noun are not available yet.'
                      : 'Could not check Panchayat $noun.',
                  textAlign: TextAlign.center,
                ),
                if (!_isUnavailable)
                  TextButton.icon(
                    onPressed: _checkAvailability,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
              ],
            ),
    );
  }
}
