import 'dart:async';
import 'dart:io';

// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    startMonitoring();
  }

  void startMonitoring() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      await _handleConnectivityChange(result);
    });

    // Initial check
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      List<ConnectivityResult> status = await _connectivity.checkConnectivity();
      await _handleConnectivityChange(status);
    } catch (e) {
      debugPrint("Error checking connectivity: $e");
    }
  }

  Future<void> _handleConnectivityChange(List<ConnectivityResult> result) async {
    if (result.contains(ConnectivityResult.none)) {
      _isOnline = false;
    } else if (result.contains(ConnectivityResult.mobile) ||
               result.contains(ConnectivityResult.wifi) ||
               result.contains(ConnectivityResult.ethernet) ||
               result.contains(ConnectivityResult.vpn) ||
               result.contains(ConnectivityResult.bluetooth) ||
               result.contains(ConnectivityResult.other)) {
      _isOnline = await _updateConnectionStatus();
    }
    notifyListeners();
  }

  Future<bool> _updateConnectionStatus() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}