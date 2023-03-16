import 'package:flutter/cupertino.dart';

import '../../freezed/partner.dart';
import '../../models/lists.dart';

class PartnersModel {
  final TextEditingController partnerTextController = TextEditingController();

  Partners filtered() {
    if (partnerTextController.text.isEmpty) {
      return Lists.partners;
    }
    var p = <Partner>[];
    for (var e in Lists.partners.partners) {
      if (e.taxcode.toLowerCase().contains(partnerTextController.text.toLowerCase())
      || e.taxname.toLowerCase().contains(partnerTextController.text.toLowerCase())
      || e.contact.toLowerCase().contains(partnerTextController.text.toLowerCase())) {
        p.add(e);
      }
    }
    return Partners(partners: p);
  }
}