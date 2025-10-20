import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusIndicator extends StatefulWidget {
  final bool showText;
  final double size;
  final EdgeInsets padding;

  const ConnectionStatusIndicator({
    super.key,
    this.showText = true,
    this.size = 16.0,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<ConnectionStatusIndicator> createState() =>
      _ConnectionStatusIndicatorState();
}

class _ConnectionStatusIndicatorState extends State<ConnectionStatusIndicator> {
  bool _hasConnection = true;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final hasConnection = results.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn);

      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasConnection = true; // Assume connected on error
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        // Handle initial state
        if (_isInitializing) {
          return Container(
            padding: widget.padding,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }

        final results = snapshot.data;
        final hasConnection = results == null
            ? _hasConnection
            : results.any((r) =>
                r == ConnectivityResult.mobile ||
                r == ConnectivityResult.wifi ||
                r == ConnectivityResult.ethernet ||
                r == ConnectivityResult.vpn);

        // Update cached state
        if (results != null) {
          _hasConnection = hasConnection;
        }

        return Container(
          padding: widget.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  hasConnection ? Icons.wifi : Icons.wifi_off,
                  key: ValueKey(hasConnection ? 'connected' : 'disconnected'),
                  size: widget.size,
                  color: hasConnection
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                ),
              ),
              if (widget.showText) ...[
                const SizedBox(width: 4),
                Text(
                  hasConnection ? 'Online' : 'Offline',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: hasConnection
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class ConnectionStatusBanner extends StatefulWidget {
  const ConnectionStatusBanner({super.key});

  @override
  State<ConnectionStatusBanner> createState() => _ConnectionStatusBannerState();
}

class _ConnectionStatusBannerState extends State<ConnectionStatusBanner> {
  bool _hasConnection = true;
  bool _isInitializing = true;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final hasConnection = results.any((r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn);

      if (mounted) {
        setState(() {
          _hasConnection = hasConnection;
          _isInitializing = false;
          _showBanner = !hasConnection; // Show banner when offline
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasConnection = true;
          _isInitializing = false;
          _showBanner = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (_isInitializing) {
          return const SizedBox.shrink();
        }

        final results = snapshot.data;
        final hasConnection = results == null
            ? _hasConnection
            : results.any((r) =>
                r == ConnectivityResult.mobile ||
                r == ConnectivityResult.wifi ||
                r == ConnectivityResult.ethernet ||
                r == ConnectivityResult.vpn);

        // Update cached state and banner visibility
        if (results != null) {
          final wasConnected = _hasConnection;
          _hasConnection = hasConnection;

          // Show banner when connection is lost, hide when restored
          if (wasConnected && !hasConnection) {
            _showBanner = true;
          } else if (!wasConnected && hasConnection) {
            // Hide banner after a short delay when connection is restored
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _showBanner = false;
                });
              }
            });
          }
        }

        return AnimatedSlide(
          offset: _showBanner ? Offset.zero : const Offset(0, -1),
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: _showBanner ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: hasConnection
                    ? Colors.green.withOpacity(0.1)
                    : Theme.of(context).colorScheme.errorContainer,
                border: Border(
                  bottom: BorderSide(
                    color: hasConnection
                        ? Colors.green.withOpacity(0.3)
                        : Theme.of(context).colorScheme.error.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasConnection ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: hasConnection
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasConnection
                          ? 'Connection restored'
                          : 'No internet connection',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: hasConnection
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  if (!hasConnection)
                    TextButton(
                      onPressed: () {
                        // This will trigger the ConnectivityGate to show NoInternetScreen
                        setState(() {
                          _showBanner = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
