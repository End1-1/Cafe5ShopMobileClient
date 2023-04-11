import 'package:shared_preferences/shared_preferences.dart';

const pkServerName = 'pkServerName';
const pkServerAddress = 'pkServerAddress';
const pkServerPort = 'pkServerPort';
const pkServerAPIKey = 'pkServerAPIKey';
const pkFcmToken = 'pkFcmToken';
const pkPassHash = 'pkPassHash';
const pkFirstName = 'pkFirstName';
const pkLastName = 'pkLastName';
const pkDataLoaded = 'pkDataLoaded';
const pkAction = 'pkAction';
const pkData = 'pkData';
const pkStorageName = 'pkStorageName';
const pkStock = 'pkStock';
const pkGroup = 'pkGroup';

const rcServerList = 'serverList';

final List<Map<String, String>> servers = [];
late final SharedPreferences prefs;

const hqRegisterDevice = 1;
const hqLogin = 2;
const hqDownloadData = 3;
const hqCheckPassHash = 4;
const hqStock = 5;
const hqSaveOrder = 6;
const hqPreorders = 7;
const hqPreorderDetails = 8;
const hqDebts = 9;
const hqRoute = 10;
const hqPreorderStock = 11;

const prStorage = 14;