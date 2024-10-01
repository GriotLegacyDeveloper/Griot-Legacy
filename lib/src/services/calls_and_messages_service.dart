import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(String number) => launch("tel://$number");

  void sendSms(String number,String msg) => launch("sms:$number?body=Please download this beautiful app");

  void sendEmail(String email,String msg) => launch("mailto:$email?body=Please download this beautiful app");
}