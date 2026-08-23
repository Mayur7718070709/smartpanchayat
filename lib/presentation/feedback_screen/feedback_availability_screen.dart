import 'package:flutter/material.dart';

import '../../core/app_runtime.dart';
import '../../core/network/api_exception.dart';
import '../../theme/app_theme.dart';

class FeedbackAvailabilityScreen extends StatefulWidget {
  const FeedbackAvailabilityScreen({super.key});

  @override
  State<FeedbackAvailabilityScreen> createState() =>
      _FeedbackAvailabilityScreenState();
}

class _FeedbackAvailabilityScreenState
    extends State<FeedbackAvailabilityScreen> {
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
      await AppRuntime.feedback.checkAvailability();
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Feedback'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isUnavailable
                          ? Icons.feedback_outlined
                          : Icons.cloud_off_rounded,
                      size: 64,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isUnavailable
                          ? 'Feedback is not available yet.'
                          : 'Could not check feedback availability.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No feedback was submitted or saved.',
                      textAlign: TextAlign.center,
                    ),
                    if (!_isUnavailable) ...[
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _checkAvailability,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
