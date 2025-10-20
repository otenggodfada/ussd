import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Test screen to demonstrate real-time connectivity detection
class ConnectivityTestScreen extends StatefulWidget {
  const ConnectivityTestScreen({super.key});

  @override
  State<ConnectivityTestScreen> createState() => _ConnectivityTestScreenState();
}

class _ConnectivityTestScreenState extends State<ConnectivityTestScreen> {
  List<ConnectivityResult> _currentResults = [];
  bool _isListening = false;
  Stream<List<ConnectivityResult>>? _connectivityStream;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      setState(() {
        _currentResults = results;
      });
    } catch (e) {
      print('Error checking connectivity: $e');
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _connectivityStream = Connectivity().onConnectivityChanged;
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _connectivityStream = null;
    });
  }

  String _getConnectionType(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'None';
    }
  }

  Color _getConnectionColor(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Colors.blue;
      case ConnectivityResult.mobile:
        return Colors.green;
      case ConnectivityResult.ethernet:
        return Colors.orange;
      case ConnectivityResult.vpn:
        return Colors.purple;
      case ConnectivityResult.bluetooth:
        return Colors.cyan;
      case ConnectivityResult.other:
        return Colors.grey;
      case ConnectivityResult.none:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Test'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isListening ? null : _startListening,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Listening'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isListening ? _stopListening : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Listening'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Manual check button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _checkInitialConnectivity,
                icon: const Icon(Icons.refresh),
                label: const Text('Check Now'),
              ),
            ),
            const SizedBox(height: 24),
            
            // Status indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _currentResults.isEmpty || _currentResults.contains(ConnectivityResult.none)
                      ? Colors.red
                      : Colors.green,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _currentResults.isEmpty || _currentResults.contains(ConnectivityResult.none)
                            ? Icons.wifi_off
                            : Icons.wifi,
                        color: _currentResults.isEmpty || _currentResults.contains(ConnectivityResult.none)
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentResults.isEmpty || _currentResults.contains(ConnectivityResult.none)
                            ? 'No Connection'
                            : 'Connected',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _currentResults.isEmpty || _currentResults.contains(ConnectivityResult.none)
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last checked: ${DateTime.now().toString().substring(11, 19)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Connection types
            Text(
              'Connection Types:',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            if (_currentResults.isEmpty)
              Text(
                'No connection detected',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
              )
            else
              ..._currentResults.map((result) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getConnectionColor(result).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getConnectionColor(result).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getConnectionType(result) == 'WiFi' ? Icons.wifi :
                      _getConnectionType(result) == 'Mobile Data' ? Icons.signal_cellular_alt :
                      _getConnectionType(result) == 'Ethernet' ? Icons.cable :
                      _getConnectionType(result) == 'VPN' ? Icons.vpn_key :
                      Icons.bluetooth,
                      color: _getConnectionColor(result),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getConnectionType(result),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _getConnectionColor(result),
                      ),
                    ),
                  ],
                ),
              )),
            
            const SizedBox(height: 24),
            
            // Real-time stream
            if (_isListening) ...[
              Text(
                'Real-time Updates:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<ConnectivityResult>>(
                  stream: _connectivityStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final results = snapshot.data!;
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return ListTile(
                            leading: Icon(
                              _getConnectionType(result) == 'WiFi' ? Icons.wifi :
                              _getConnectionType(result) == 'Mobile Data' ? Icons.signal_cellular_alt :
                              _getConnectionType(result) == 'Ethernet' ? Icons.cable :
                              _getConnectionType(result) == 'VPN' ? Icons.vpn_key :
                              Icons.bluetooth,
                              color: _getConnectionColor(result),
                            ),
                            title: Text(_getConnectionType(result)),
                            subtitle: Text('Updated: ${DateTime.now().toString().substring(11, 19)}'),
                            tileColor: _getConnectionColor(result).withOpacity(0.1),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Text('Waiting for connectivity changes...');
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
