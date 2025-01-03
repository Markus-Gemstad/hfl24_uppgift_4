import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:parkmycar_server/server_config.dart';

void main(List<String> args) async {
  Router router = ServerConfig.instance.router;

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  print('Server listening on port ${server.port}');

  // sigint handler

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    print('clean shutdown');
    server.close(force: true);
    ServerConfig.instance.store.close();
    exit(0);
  });
}
