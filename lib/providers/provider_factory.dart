import 'package:style_ml/providers/data_provider.dart';
import 'package:style_ml/providers/firestore_provider.dart';

abstract class DataProviderFactory {
  DataProvider get provider;
}

class FirestoreProviderFactory implements DataProviderFactory {
  static final instance = FirestoreProviderFactory._();
  FirestoreProvider? _provider;

  FirestoreProviderFactory._();

  @override
  DataProvider get provider {
    _provider ??= FirestoreProvider();
    return _provider!;
  }
}
