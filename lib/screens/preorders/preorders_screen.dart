import 'package:cafe5_shop_mobile_client/models/http_query/http_preorders.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_bloc.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_event.dart';
import 'package:cafe5_shop_mobile_client/screens/bloc/screen_state.dart';
import 'package:cafe5_shop_mobile_client/screens/screen/app_scaffold.dart';
import 'package:cafe5_shop_mobile_client/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreordersScreen extends StatelessWidget {
  const PreordersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Preorders', child:
    BlocProvider<ScreenBloc>(
      create: (_) => ScreenBloc(SSInProgress())..add(SEHttpQuery(query: HttpPreorders())),
      child: BlocListener<ScreenBloc, ScreenState>(listener: (context, state) {
        if (state is SSError) {
          appDialog(context, state.error);
        }
      }, child: BlocBuilder<ScreenBloc, ScreenState> (
        builder: (context, state) {
          if (state is SSInProgress) {
            return const Center(child: SizedBox(height: 36, width: 36, child: CircularProgressIndicator()));
          } else if (state is SSError) {

          }
          return Container();
        }
      ))
    )
    );
  }

}