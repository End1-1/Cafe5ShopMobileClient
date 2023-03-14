import 'package:flutter/cupertino.dart';

import '../../freezed/partner.dart';

class PartnersModel {
  static late Partners partners;
  final TextEditingController partnerTextController = TextEditingController();

  Partners filtered() {
    if (partnerTextController.text.isEmpty) {
      return partners;
    }
    var p = <Partner>[];
    for (var e in partners.partners) {
      if (e.taxcode.toLowerCase().contains(partnerTextController.text.toLowerCase())
      || e.taxname.toLowerCase().contains(partnerTextController.text.toLowerCase())
      || e.contact.toLowerCase().contains(partnerTextController.text.toLowerCase())) {
        p.add(e);
      }
    }
    return Partners(partners: p);
  }
}