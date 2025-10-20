import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isCheckingConnection = false;
  String _connectionStatus = 'Checking connection...';

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  Future<void> _checkConnectionStatus() async {
    setState(() {
      _isCheckingConnection = true;
      _connectionStatus = 'Checking connection...';
    });

    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResults.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn);

      if (mounted) {
        setState(() {
          _isCheckingConnection = false;
          if (hasConnection) {
            _connectionStatus = 'Connection restored!';
            // The ConnectivityGate will automatically handle the transition
            // No need to manually navigate - just show success message
          } else {
            _connectionStatus = 'No internet connection detected';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingConnection = false;
          _connectionStatus = 'Unable to check connection';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated connection icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isCheckingConnection
                      ? SizedBox(
                          key: const ValueKey('checking'),
                          width: 88,
                          height: 88,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.wifi_off,
                          key: const ValueKey('offline'),
                          size: 88,
                          color: theme.colorScheme.primary,
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Internet Connection',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection. The app will resume automatically when you are back online.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Connection status indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isCheckingConnection)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        )
                      else
                        Icon(
                          _connectionStatus.contains('restored')
                              ? Icons.check_circle
                              : Icons.error_outline,
                          size: 16,
                          color: _connectionStatus.contains('restored')
                              ? Colors.green
                              : theme.colorScheme.error,
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _connectionStatus,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _connectionStatus.contains('restored')
                              ? Colors.green
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed:
                      _isCheckingConnection ? null : _checkConnectionStatus,
                  icon: Icon(_isCheckingConnection
                      ? Icons.hourglass_empty
                      : Icons.refresh),
                  label: Text(_isCheckingConnection ? 'Checking...' : 'Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
