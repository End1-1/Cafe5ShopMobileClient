import 'package:shared_preferences/shared_preferences.dart';

const pkServerName = 'pkServerName';
const pkServerAddress = 'pkServerAddress';
const pkServerPort = 'pkServerPort';
const pkServerAPIKey = 'pkServerAPIKey';
const pkFcmToken = 'pkFcmToken';
const pkPassHash = 'pkPassHash';
const pkFirstName = 'pkFirstName';
const pkLastName = 'pkLastName';

const rcServerList = 'serverList';

final List<Map<String, String>> servers = [];
late final SharedPreferences prefs;

const hqRegisterDevice = 1;
const hqLogin = 2;
const hqDownloadData = 3;