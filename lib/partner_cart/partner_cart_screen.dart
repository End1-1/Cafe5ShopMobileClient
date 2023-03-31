import 'dart:convert';

import 'package:cafe5_shop_mobile_client/models/query_bloc/query_action.dart';
import 'package:cafe5_shop_mobile_client/models/query_bloc/query_bloc.dart';
import 'package:cafe5_shop_mobile_client/models/query_bloc/query_state.dart';
import 'package:cafe5_shop_mobile_client/partner_cart/partner_cart_model.dart';
import 'package:cafe5_shop_mobile_client/widgets/app_header.dart';
import 'package:cafe5_shop_mobile_client/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe5_shop_mobile_client/socket_message.dart';

import '../freezed/partner.dart';
import '../translator.dart';

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
    var bloc = QueryBloc(const QueryStateProgress());
    bloc.add(QueryActionLoad(op: SocketMessage.op_json_partner_debt, optional: [_model.partner.id]));
    return BlocProvider<QueryBloc>(
        create: (_) => bloc,
        child: AppScaffold(widgets: [
          AppHeader(title: tr('Partner cart')),
          Expanded(
              child: SingleChildScrollView(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Text(tr('Taxname'), style: label),
                Text(_model.partner.taxname, style: text),
                Text(tr('Address'), style: label),
                Text(_model.partner.address, style: text),
                Text(tr('Tax code'), style: label),
                Text(_model.partner.taxcode),
                Text(tr('Phone'), style: label),
                Text(tr(_model.partner.phone)),
                Text(tr('Contact'), style: label),
                Text(_model.partner.contact),
                Text(tr('Current credit'), style: label),
                BlocBuilder<QueryBloc, QueryState>(builder: (context, state) {
                  if (state is QueryStateProgress) {
                    return const SizedBox(height: 30, width: 30, child: CircularProgressIndicator());
                  } else if (state is QueryStateReady){
                    late String s;
                    try {
                      List<dynamic> l = jsonDecode(state.data);
                      s = l[0]['debt'].toString();
                    } catch (e) {
                      s = e.toString();
                    }
                    return Text(s, style: text);
                  }
                  return Container();
                })
              ],
            ),
          ))
        ]));
  }
}
