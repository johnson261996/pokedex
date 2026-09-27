import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapp/app/controller/network_controller.dart';

class FakeConnectivity implements NetworkConnectionService {
  FakeConnectivity(this.results);

  final List<ConnectivityResult> results;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => results;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value(results);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('wifi without internet is treated as disconnected', () async {
    final controller = NetworkController(
      connectivity: FakeConnectivity([ConnectivityResult.wifi]),
      internetCheck: () async => false,
      homeController: null,
    );

    await controller.refreshConnectionStatus();

    expect(controller.isConnected.value, isFalse);
  });

  test('mobile data with internet access is treated as connected', () async {
    final controller = NetworkController(
      connectivity: FakeConnectivity([ConnectivityResult.mobile]),
      internetCheck: () async => true,
      homeController: null,
    );

    await controller.refreshConnectionStatus();

    expect(controller.isConnected.value, isTrue);
  });
}
