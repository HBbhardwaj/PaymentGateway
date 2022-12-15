import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: PayMent(),
      ),
    );
  }
}

class PayMent extends StatefulWidget {
  const PayMent({Key? key}) : super(key: key);

  @override
  State<PayMent> createState() => _PayMentState();
}

class _PayMentState extends State<PayMent> {
  TextEditingController _controller = TextEditingController();
  late Razorpay _razorpay;
  @override
  void initState() {
    _razorpay = Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(width: 5, color: Colors.tealAccent))),
          ),
          ElevatedButton(
              onPressed: () {
                openCheckout();
              },
              child: Text("Pay Now"))
        ],
      )),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_tvqyeVLkumHON5',
      'amount':
          (double.parse(_controller.text) * 100.roundToDouble()).toString(),
      'name': 'Harshil Bhardwaj',
      'description': 'it is just payment process',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + "${response.paymentId}", timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " +
            response.code.toString() +
            " - " +
            "${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + "${response.walletName}",
        timeInSecForIosWeb: 4);
  }
}
