part of 'server_list.dart';

extension ServerListExt on ServerList {
  void _save() {
    prefs.setString(pkServerAddress, _serverController.text);
    if (Navigator.canPop(prefs.context())) {
      Navigator.pop(prefs.context());
    } else {
      Navigator.pushAndRemoveUntil(prefs.context(),
          MaterialPageRoute(builder: (builder) => LoginScreen()), (_) => false);
    }
  }

  void _setDemoAddress() {
    _serverController.text = 'home.picasso.am';
  }
}
