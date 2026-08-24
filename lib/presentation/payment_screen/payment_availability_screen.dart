import 'dart:math';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../core/app_runtime.dart';
import '../../core/network/api_exception.dart';
import '../../models/payment_model.dart';
import '../../theme/app_theme.dart';
import 'payment_history_screen.dart';

class PaymentAvailabilityScreen extends StatefulWidget {
  const PaymentAvailabilityScreen({super.key});

  @override
  State<PaymentAvailabilityScreen> createState() =>
      _PaymentAvailabilityScreenState();
}

class _PaymentAvailabilityScreenState extends State<PaymentAvailabilityScreen> {
  late final Razorpay _razorpay;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isStartingPayment = false;
  List<CitizenDue> _dues = const [];
  PaymentOrder? _activeOrder;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentFailure)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    _loadDues();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  String _newUuid() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> _startPayment(CitizenDue due) async {
    if (_isStartingPayment) return;
    setState(() => _isStartingPayment = true);
    try {
      final order = await AppRuntime.payments.createOrder(
        dueId: due.id,
        idempotencyKey: _newUuid(),
      );
      if (!mounted) return;
      if (order.providerOrderId == null || order.checkoutKeyId == null) {
        throw const ApiException(
          code: ApiErrorCode.unknownError,
          message: 'The payment order is not ready for checkout.',
        );
      }
      _activeOrder = order;
      final prefill = <String, String>{};
      final phone = AppRuntime.auth.currentUserPhone;
      final email = AppRuntime.auth.currentUserEmail;
      if (phone != null && phone.isNotEmpty) prefill['contact'] = phone;
      if (email != null && email.isNotEmpty) prefill['email'] = email;
      _razorpay.open({
        'key': order.checkoutKeyId,
        'amount': order.amountPaise,
        'currency': order.currency,
        'order_id': order.providerOrderId,
        'name': 'Smart Panchayat',
        'description': due.titleEn,
        'timeout': 300,
        if (prefill.isNotEmpty) 'prefill': prefill,
      });
    } on ApiException catch (error) {
      _showMessage(error.message);
      if (mounted) setState(() => _isStartingPayment = false);
    } catch (_) {
      _showMessage('Could not start payment. Please retry.');
      if (mounted) setState(() => _isStartingPayment = false);
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    final order = _activeOrder;
    final paymentId = response.paymentId;
    final providerOrderId = response.orderId;
    final signature = response.signature;
    if (order == null ||
        paymentId == null ||
        providerOrderId == null ||
        signature == null) {
      _showMessage('Payment confirmation details are incomplete.');
      if (mounted) setState(() => _isStartingPayment = false);
      return;
    }
    try {
      final confirmed = await AppRuntime.payments.confirmOrder(
        localOrderId: order.id,
        providerOrderId: providerOrderId,
        providerPaymentId: paymentId,
        providerSignature: signature,
      );
      _showMessage(
        confirmed.status == 'PAID'
            ? 'Payment confirmed successfully.'
            : 'Payment received. Final confirmation is in progress.',
      );
      await _loadDues();
    } on ApiException catch (error) {
      _showMessage(error.message);
    } finally {
      _activeOrder = null;
      if (mounted) setState(() => _isStartingPayment = false);
    }
  }

  void _onPaymentFailure(PaymentFailureResponse response) {
    _activeOrder = null;
    if (mounted) setState(() => _isStartingPayment = false);
    _showMessage(response.message ?? 'Payment was cancelled or failed.');
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    _showMessage(
      'Continue payment in ${response.walletName ?? 'the selected wallet'}.',
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadDues() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final dues = await AppRuntime.payments.listDues();
      if (!mounted) return;
      setState(() {
        _dues = dues;
        _isLoading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-${value.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        title: const Text('Dues & Payments'),
        actions: [
          IconButton(
            tooltip: 'Payment history',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PaymentHistoryScreen()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
              child: TextButton.icon(
                onPressed: _loadDues,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Could not load dues. Retry'),
              ),
            )
          : _dues.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 64,
                      color: AppTheme.textTertiary,
                    ),
                    SizedBox(height: 16),
                    Text('No dues found.', textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDues,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _dues.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _dueCard(_dues[index]),
              ),
            ),
    );
  }

  Widget _dueCard(CitizenDue due) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    due.titleMr,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '₹${due.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              due.titleEn,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Text('Reference: ${due.referenceNumber}'),
            Text('Due date: ${_date(due.dueDate)}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(due.status.replaceAll('_', ' '))),
                if (due.isPayable)
                  FilledButton(
                    onPressed: _isStartingPayment
                        ? null
                        : () => _startPayment(due),
                    child: Text(
                      _isStartingPayment ? 'Please wait…' : 'Pay online',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
