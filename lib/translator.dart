const Map<String, String> vals = {
  'yes':'Այո',
  'no': 'Ոչ',
  'sign in':'Մուտք',
  'login':'Մուտք',
  'username or password incorrect':'Գաղտնաբառը կամ օգտագործողը սխալ է',
  'tasks':'Առցանց պատվեր',
  'always use this hall': 'Միշտ օգտագործել այս սրահը',
  'update date':'Թարմացնել տվյալները',
  'logout':'Ելք',
  'confirm to logout': 'Հաստատեք ելքը',
  'check quantity': 'Ստուգել առկայությունը',
  'new order': 'Նոր պատվեր',
  'order': 'Պատվեր'
};

String tr(String s) {
  return Translator.tr(s);
}

class Translator {
  static String tr(String s) {
    if (vals.containsKey(s.toLowerCase())) {
      return vals[s.toLowerCase()]!;
    }
    return s;
  }
}