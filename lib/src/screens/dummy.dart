import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';


class DummyTest extends StatefulWidget {
  @override
  _DummyTestState createState() => _DummyTestState();
}




class _DummyTestState extends State<DummyTest> {
  FlutterPay flutterPay = FlutterPay();

  String result = "Result will be shown here";


  @override
  void initState() {
    super.initState();
  }

  void makePayment() async {
    try {
      bool result = await flutterPay.canMakePayments();
      setState(() {
        this.result = "Can make payments: $result";
      });
    } catch (e) {
      setState(() {
        result = "$e";
      });
    }

    try {
      bool result =
      await flutterPay.canMakePaymentsWithActiveCard(
        allowedPaymentNetworks: [
          PaymentNetwork.visa,
          PaymentNetwork.masterCard,
        ],
      );
      setState(() {
        this.result = "$result";
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }

    List<PaymentItem> items = [PaymentItem(name: "T-Shirt", price: 2.98)];

    flutterPay.setEnvironment(environment: PaymentEnvironment.Test);


    String token = await flutterPay.requestPayment(
      appleParameters:
      AppleParameters(merchantIdentifier: "merchant.com.griotLegacySocialMediaApp"),
      currencyCode: "USD",
      countryCode: "US",
      paymentItems: items,
    );
    print("token    $token");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  result,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      bool result = await flutterPay.canMakePayments();
                      setState(() {
                        this.result = "Can make payments: $result";
                      });
                    } catch (e) {
                      setState(() {
                        result = "$e";
                      });
                    }
                  },
                  child: Container(
                    child: const Text("Can make payments?"),

                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      bool result =
                          await flutterPay.canMakePaymentsWithActiveCard(
                        allowedPaymentNetworks: [
                          PaymentNetwork.visa,
                          PaymentNetwork.masterCard,
                        ],
                      );
                      setState(() {
                        this.result = "$result";
                      });
                    } catch (e) {
                      setState(() {
                        result = "Error: $e";
                      });
                    }
                  },
                  child: Container(
                    child: Text("Can make payments with verified card: $result"),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    makePayment();
                  },
                  child: Container(
                      child: const Text("Try to pay?"),

                      ),
                )
              ]),
        ),
      ),
    );
  }
}