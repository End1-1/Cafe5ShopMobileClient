import 'package:cafe5_shop_mobile_client/models/lists.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:flutter/material.dart';

class PartnerScreen extends StatelessWidget {
  final bool selectMode;

  PartnerScreen({super.key, this.selectMode = false});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: 'Partners', child: PartnersList(selectMode: selectMode));
  }
}

class PartnersList extends StatefulWidget {
  final bool selectMode;

  const PartnersList({super.key, required this.selectMode});

  @override
  State<StatefulWidget> createState() => _PartnersList();
}

class _PartnersList extends State<PartnersList> {
  final TextEditingController editSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
              child: TextFormField(
                autofocus: true,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            decoration: InputDecoration(
                iconColor: Colors.black12,
                isDense: true,
                contentPadding: const EdgeInsets.all(10),
                prefixIcon: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Image.asset('assets/images/search.png',
                        height: 30, width: 30))),
            controller: editSearch,
            onChanged: (text) {
              setState(() {});
            },
          ))
        ]),
        Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
          for (var e in Lists.filteredPartners(editSearch.text)) ...[
            InkWell(
                onTap: () {
                  if (widget.selectMode) {
                    Navigator.pop(context, e);
                  }
                },
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.black12))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(e.name),
                          Expanded(child: Container()),
                          Text(e.taxcode),
                        ]),
                        Row(
                          children: [Flexible(child: Text(e.address))],
                        )
                      ],
                    )))
          ]
        ])))
      ],
    );
  }
}
