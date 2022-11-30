import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum Env {
  production('production'),
  development('development');

  const Env(this.value);

  final String value;
}

class FirebaseService {
  const FirebaseService._();

  static Env? _env;
  static FirebaseApp? _app;

  static Env get env => _env!;

  static FirebaseAuth get firebaseAuth {
    return FirebaseAuth.instanceFor(app: _app!);
  }

  static FirebaseMessaging get firebaseMessaging {
    return FirebaseMessaging.instance;
  }

  static Future<void> production() async {
    _env = Env.production;
    _app ??= await Firebase.initializeApp();
  }

  static Future<void> development() async {
    _env = Env.development;
    _app ??= await Firebase.initializeApp();
  }
}
