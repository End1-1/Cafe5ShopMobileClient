import 'package:cafe5_shop_mobile_client/freezed/partner.dart';
import 'package:cafe5_shop_mobile_client/screens/partners/partners_model.dart';
import 'package:flutter/material.dart';

class PartnersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PartnersScreen();
}

class _PartnersScreen extends State<PartnersScreen> {
  final PartnersModel _model = PartnersModel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height / 4),
        child: Column(children: [
          TextFormField(
            controller: _model.partnerTextController,
            onChanged: (text) {
              setState(() {

              });
            },
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: _partners(context),
          )))
        ]));
  }

  List<Widget> _partners(BuildContext context) {
    final List<Widget> l = [];
    for (Partner p
        in _model.filtered().partners) {
      l.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: InkWell(
              onTap: () {
                Navigator.pop(context, p);
              },
              child: Row(children: [
                SizedBox(width: 100, child: Text(p.taxname)),
                SizedBox(width: 100, child: Text(p.taxcode)),
              ]))));
    }
    return l;
  }
}
