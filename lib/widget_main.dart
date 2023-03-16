import 'package:cafe5_shop_mobile_client/class_outlinedbutton.dart';
import 'package:cafe5_shop_mobile_client/config.dart';
import 'package:cafe5_shop_mobile_client/home_page.dart';
import 'package:cafe5_shop_mobile_client/screens/buyer_debts_screen/buyer_debts_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/sale_history/sale_history_screen.dart';
import 'package:cafe5_shop_mobile_client/screens/stock/stock_screent.dart';
import 'package:cafe5_shop_mobile_client/translator.dart';
import 'package:cafe5_shop_mobile_client/base_widget.dart';
import 'package:cafe5_shop_mobile_client/widget_check_qty.dart';
import 'package:cafe5_shop_mobile_client/screens/sale/sale_screen.dart';
import 'package:cafe5_shop_mobile_client/widget_sale_drafts.dart';
import 'package:flutter/material.dart';

class WidgetMain extends StatefulWidget {
  const WidgetMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return WidgetMainState();
  }
}

class WidgetMainState extends BaseWidgetState<WidgetMain> {
  bool _hideMenu = true;
  double startx = 0;
  int _menuAnimationDuration = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 35),
            child: Stack(children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(Config.getString(key_fullname)),
                  Expanded(child: Container()),
                  ClassOutlinedButton.createImage(_showMenu, "images/menu.png")
                ]),
              const Divider(height: 20, thickness: 2, color: Colors.black26),
                Align(alignment: Alignment.center, child: ClassOutlinedButton.createTextAndImage(_checkQty, tr("Check quantity"), "images/quantity.png" , w: 300)),
                const Divider(height: 30,),
                Align(alignment: Alignment.center, child: ClassOutlinedButton.createTextAndImage(_createNewSale, tr("Create new sale"), "images/quantity.png" , w: 300)),
                const Divider(height: 30,),
                Align(alignment: Alignment.center, child: ClassOutlinedButton.createTextAndImage(_showDrafts, tr("Drafts"), "images/quantity.png" , w: 300)),
                const Divider(height: 30,),
                Align(alignment: Alignment.center, child: ClassOutlinedButton.createTextAndImage(_showDebts, tr('Debts'), "images/currency.png" , w: 300)),
                const Divider(height: 30,),
                Align(alignment: Alignment.center, child: ClassOutlinedButton.createTextAndImage(_showSalesHistory, tr('Sales history'), "images/currency.png" , w: 300)),
                const Divider(height: 30,),
                Align(alignment: Alignment.center, child: ClassOutlinedButton.createTextAndImage(_showRoute, tr('Route'), "images/route.png" , w: 300)),
                const Divider(height: 30,)
              ]),
          _menu()])
            )
    );
  }

  void _showMenu() {
    setState(() {
      _hideMenu = false;
      startx = 0;
      _menuAnimationDuration = 300;
    });
  }

  void _checkQty() {
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const WidgetCheckQty()));
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StockScreen()));
  }

  void _createNewSale() {
    sq(tr("Create new sale document?"), (){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WidgetSaleDocument(saleUuid: "")));
    }, (){

    });
  }

  void _showDrafts() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const WidgetSaleDrafts()));
  }

  void _showDebts() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BuyerDebtsScreen()));
  }

  void _showSalesHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SaleHistoryScreen()));
  }

  Widget _menu() {
    return AnimatedPositioned(
        duration: Duration(milliseconds: _menuAnimationDuration),
        top: 0,
        right: _hideMenu ? -1 * (MediaQuery.of(context).size.width) : startx,
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _hideMenu = true;
              _menuAnimationDuration = 300;
            });
          },
          onPanStart: (details) {
            setState(() {
              _menuAnimationDuration = 1;
            });
          },
          onPanUpdate: (details) {
            if (startx - details.delta.dx > 0) {
              return;
            }
            setState(() {
              startx -= details.delta.dx;
            });
          },
          onPanEnd: (details) {
            setState(() {
              if (startx < -120) {
                _hideMenu = true;
              } else {
                startx = 0;
              }
              _menuAnimationDuration = 300;
            });
          },
          child: Container(
              color: Colors.white10,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 3),
                      child: Container(
                        color: const Color(0XffDDEEAA),
                        child: Column(
                          children: [
                            Container(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                    width: 36,
                                    height: 36,
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.all(2),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _hideMenu = true;
                                          });
                                        },
                                        child: Image.asset("images/cancel.png", width: 36, height: 36)))
                              ],
                            ),
                            Container(
                                height: 36,
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.all(2),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        sq(tr("Confirm to logout"), () {
                                          Config.setString(key_session_id, "");
                                          Config.setBool(key_data_dont_update, false);
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => WidgetHome()), (route) => false);
                                        }, () {});
                                      });
                                    },
                                    child: Row(children: [Image.asset("images/lock.png", width: 36, height: 36), Text(tr("Logout"))]))),
                            Expanded(child: Container())
                          ],
                        ),
                      ))
                ],
              )),
        ));
  }

  void _showRoute() {
    sd(tr('Route list is empty'));
  }
}
