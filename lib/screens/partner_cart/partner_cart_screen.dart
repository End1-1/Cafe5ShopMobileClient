import 'package:cafe5_shop_mobile_client/models/http_query/http_partner_cart.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/partner_cart/partner_cart_model.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/data_types.dart' show Partner;
import 'package:cafe5_shop_mobile_client/utils/translator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartnerCartScreen extends StatelessWidget {
  late final PartnerCartModel _model;
  final TextStyle label =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  final TextStyle text =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 16);

  PartnerCartScreen({super.key, required Partner partner}) {
    _model = PartnerCartModel(partner: partner);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenBloc>(
        create: (_) => ScreenBloc(SSInit())
          ..add(SEHttpQuery(
              query: HttpPartnerCart(partnerId: _model.partner.id))),
        child: AppScaffold(
            title: tr('Partner cart'),
            child: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Text(tr('Taxname'), style: label),
                    Text(_model.partner.taxname ?? '', style: text),
                    Text(tr('Address'), style: label),
                    Text(_model.partner.address ?? '', style: text),
                    Text(tr('Tax code'), style: label),
                    Text(_model.partner.taxcode ?? ''),
                    Text(tr('Phone'), style: label),
                    Text(tr(_model.partner.phonenumber ?? '')),
                    Text(tr('Contact'), style: label),
                    Text(_model.partner.contact ?? ''),
                    Text(tr('Current credit'), style: label),
                    //Text('${_model.partner.debt ?? '0'}', style: text)
                  ],
                ),
              ))
            ])));
  }
}
