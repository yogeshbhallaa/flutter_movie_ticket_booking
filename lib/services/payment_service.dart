import 'package:stripe_payment/stripe_payment.dart';

class PaymentService {
  static void initializeStripe() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: "your-publishable-key",
        merchantId: "your-merchant-id",
        androidPayMode: 'test',
      ),
    );
  }
}
