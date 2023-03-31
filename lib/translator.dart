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
  'create new sale': 'Նոր վաճառք',
  'sale document': 'Վաճառքի փասթաթուղթ',
  'new order': 'Նոր պատվեր',
  'order': 'Պատվեր',
  'currency':'Փոխարժեք',
  'create new sale document?' : 'Ստեղծել՞ նոր վաճառքի փասթաթուղթ',
  'drafts':'Սևագրեր',
  'retail': 'Մանրածախ',
  'whosale': 'Մեծածախ',
  'price':'Գին',
  'confirm to remove row': 'Հաստատեք տողի հեռացումը',
  'choose a warehouse':'Ընտրեք պահեստը',
  'debts':'Պարտքեր',
  'partner':'Գործընկեր',
  'discount':'Զեղչ',
  'debt':'Պարտք',
  'sales history':'Վաճառքների պատմություն',
  'please, wait': 'Սպասեք',
  'empty':'Ոչինչ չկա',
  'predefined list':'Ապրաների ցանկ 1',
  'scancode':'Բարկոդ',
  'route list is empty':'Երթուղին բացակայում է',
  'route':'Երթուղի',
  'access denied':'Իրավասությունների բացակայություն',
  'write order':'Գրանցել պատվերը',
  'goods not needed':'Ապրանք պետք չէ',
  'shop closed':'Խանութը փակ է',
  'taxname':'Կազմակերպության անվանում',
  'tax code':'ՀՎՀՀ',
  'phone':'Հեռախոս',
  'contact':'Կոնտակտ',
  'current credit':'Ընդացիկ պարտք',
  'confirm, that goods not needed':'Հաստատեք, որ ապրանք պետք չէ',
  'confirm, that shop was closed':'Հաստատեք, որ խանութը փակ էր',
  'not visited':'Չեմ այցելել',
  'confirm, that not visited':'Հաստատեք, որ չեկ այցելել',
  'blocked':'Արգելափակված է'
};

String tr(String s) {
  return Translator.tr(s);
}

class Translator {
  static String tr(String s) {
    if (vals.keys.contains(s.toLowerCase())) {
      return vals[s.toLowerCase()]!;
    }
    return s;
  }
}