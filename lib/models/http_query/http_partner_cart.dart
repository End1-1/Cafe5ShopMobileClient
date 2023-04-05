import 'package:freezed_annotation/freezed_annotation.dart';
import 'http_query.dart';

class HttpPartnerCart extends HttpQuery {
  final int partnerId;
  HttpPartnerCart({required this.partnerId});
}