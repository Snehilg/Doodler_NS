import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _FORCE_UPDATE_REQUIRED_STORE = "force_update_required_store";
const String _FORCE_UPDATE_CURRENT_VERSION_STORE =
    "force_update_current_version_store";
const String _FORCE_UPDATE_STORE_URL_STORE = "force_update_store_url_store";

class RemoteConfigService {
  final RemoteConfig? _remoteConfig;
  final defaults = <String, dynamic>{
    _FORCE_UPDATE_REQUIRED_STORE: false,
    _FORCE_UPDATE_CURRENT_VERSION_STORE: 35,
    _FORCE_UPDATE_STORE_URL_STORE:
        "https://play.google.com/store/apps/details?id=com.pietylabs.Doodler",
  };

  static RemoteConfigService? _instance;
  static Future<RemoteConfigService?> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }
    return _instance;
  }

  RemoteConfigService({RemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig;

  bool get forceUpdateRequiredStore =>
      _remoteConfig!.getBool(_FORCE_UPDATE_REQUIRED_STORE);
  int get forceUpdateCurrentVersionStore =>
      _remoteConfig!.getInt(_FORCE_UPDATE_CURRENT_VERSION_STORE);
  String get forceUpdateStoreUrlStore =>
      _remoteConfig!.getString(_FORCE_UPDATE_STORE_URL_STORE);

  Future initialize() async {
    try {
      await _remoteConfig!.setDefaults(defaults);
      await _fetchAndActivate();
    }
    /*on FetchThrottledException catch (e) {
      print("Remote Config fetch throttled: $e");
    } */
    catch (e) {
      print('Unable to fetch remote config. Default value will be used');
    }
  }

  Future _fetchAndActivate() async {
    /*await _remoteConfig!.fetch(expiration: Duration(seconds: 0));
    await _remoteConfig!.activateFetched();*/
    print("update::: $forceUpdateRequiredStore");
    print("url::: $forceUpdateStoreUrlStore");
    print("version::: $forceUpdateCurrentVersionStore");
  }
}
