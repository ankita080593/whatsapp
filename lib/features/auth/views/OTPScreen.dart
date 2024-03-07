import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/features/auth/controller/AuthController.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;

  const OTPScreen({required this.verificationId, Key? key}) : super(key: key);

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  String userOTP = "";

  void verifyOTP(BuildContext context, userOTP, WidgetRef ref) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          widget.verificationId,
          userOTP,
        );
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  @override
  void initState() {
    _listenOtp();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Text(
                'We have sent an SMS with a code.',
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: PinFieldAutoFill(
                  currentCode: userOTP,
                  codeLength: 6,
                  autoFocus: true,
                  onCodeChanged: (code) {
                    if (code!.length == 6) {
                       verifyOTP(context, code.toString(), ref,);
                    }
                  },
                  onCodeSubmitted: (value) {
                    verifyOTP(context, value, ref,);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
