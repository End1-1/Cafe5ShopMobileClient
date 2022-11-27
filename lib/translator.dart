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
  'print order':'Տպել՞ պատվերը',
  'incorrect license plate':'Սխալ պետհամարանիշ',
  'select car model': 'Ընտրեք մեքենաի մատնիշը',
  'enter the customer name':'Մուտքագրեք հաճախորդի անունը',
  'create new order?':'Ստեղծել՞ նոր պատվեր',
  'car plate number':'Պետհամարանիշ',
  "car model":"Մեքենաի մատնիշ",
  "customer name":"Հաճախորդի անուն",
  "customer phone number":"Հաճախորդի հեռախոսահամար",
  "set the car first": 'Մեքենան նշված չէ',
  'unknown':'Անհայտ',
  'dish comment': 'Ուտեստի մեկնաբանություն',
  'dish manual comment': 'Մեկնաբանության խմբագրում',
  'confirm to logout': 'Հաստատեք ելքը',
  'dish required comment': 'Ուտեստի պարտադիր մեկնաբանություն',
  'cancel': 'Հրաժարվել',
  'quantity of ' : 'Քանակ',
  'comment for' : 'Մեկնաբանություն',
  'print bill': 'Տպել հաշիվը'
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