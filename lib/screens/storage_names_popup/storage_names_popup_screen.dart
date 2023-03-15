import 'package:cafe5_shop_mobile_client/models/storage_names_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorageNamesPopupScreen extends StatelessWidget {
  const StorageNamesPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView (
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: _children(context)
        )
      )
    );
  }

  List<Widget> _children(BuildContext context) {
    List<Widget> l = [];
    for (var s in StorageNamesModel.storageNames.storages) {
      l.add(
        Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: InkWell(
            onTap: (){
              Navigator.pop(context, s);
            },
          child: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18)))
        )
      );
    }
    return l;
  }

}