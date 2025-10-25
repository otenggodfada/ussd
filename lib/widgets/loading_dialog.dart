import 'package:flutter/material.dart';
import 'package:ussd_plus/widgets/ad_loading_indicator.dart';

class LoadingDialog extends StatefulWidget {
  final String message;
  final String? subtitle;
  final bool showProgress;
  final double? progress;

  const LoadingDialog({
    super.key,
    required this.message,
    this.subtitle,
    this.showProgress = false,
    this.progress,
  });

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();

  static void show(BuildContext context, String message, {String? subtitle}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(
        message: message,
        subtitle: subtitle,
      ),
    );
  }

  static void showWithProgress(
    BuildContext context,
    String message, {
    String? subtitle,
    double? progress,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(
        message: message,
        subtitle: subtitle,
        showProgress: true,
        progress: progress,
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AdLoadingIndicator(
        message: widget.message,
        subtitle: widget.subtitle,
        progress: widget.progress,
        showProgress: widget.showProgress,
      ),
    );
  }
}

