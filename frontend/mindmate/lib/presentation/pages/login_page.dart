import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/state/user_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _recoveryController = TextEditingController();
  final List<TextEditingController> _recoveryWordControllers = List.generate(12, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _recoveryController.dispose();
    for (var controller in _recoveryWordControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.spaceMono()),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3E9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "VERIFICATION",
          style: GoogleFonts.spaceMono(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showErrorSnackBar(viewModel.errorMessage!);
              });
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildAuthContent(viewModel),
                  ),
                ),
                _buildBottomBadges(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAuthContent(AuthViewModel viewModel) {
    if (viewModel.currentState == AuthState.emailInput) {
      return _buildEmailInput(viewModel);
    } else if (viewModel.currentState == AuthState.otpInput) {
      return _buildOtpInput(viewModel);
    } else if (viewModel.currentState == AuthState.recoveryPhrase) {
      return _buildRecoveryPhrase(viewModel);
    } else if (viewModel.currentState == AuthState.recoverAccount) {
      return _buildRecoverAccount(viewModel);
    }
    return const SizedBox();
  }

  Widget _buildEmailInput(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PROVE YOU'RE A STUDENT.",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We'll send a code. Then forget your\nemail forever.",
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.spaceMono(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'your@college.ac.in',
              hintStyle: GoogleFonts.spaceMono(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            "× NOT STORED × NOT SOLD × NOT SHARED",
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            if (_emailController.text.trim().isNotEmpty) {
              viewModel.sendOtp(_emailController.text.trim());
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Color(0xFFFFEA00), width: 6),
                left: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                if (viewModel.isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                else
                  Text(
                    "SEND CODE →",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ENTER CODE",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: "Sent to ${viewModel.currentEmail} — ",
                  style: GoogleFonts.spaceMono(fontSize: 12, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "expires in ${viewModel.resendTimer}s",
                      style: GoogleFonts.spaceMono(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      String text = _otpController.text;
                      bool isFilled = index < text.length;
                      bool isCurrent = index == text.length;
                      return Container(
                        width: 44,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isFilled ? Colors.black : (isCurrent ? const Color(0xFFFFEA00) : Colors.white),
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isFilled ? text[index] : (isCurrent ? '|' : ''),
                            style: GoogleFonts.spaceMono(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isFilled ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Positioned.fill(
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      cursorColor: Colors.transparent,
                      style: const TextStyle(color: Colors.transparent),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "DIDN'T GET IT?",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: viewModel.canResendOtp ? viewModel.resendOtp : null,
                child: Text(
                  "RESEND",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: viewModel.canResendOtp ? Colors.blue : Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            if (_otpController.text.trim().length == 6) {
              viewModel.verifyOtp(_otpController.text.trim());
              _otpController.clear();
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Color(0xFFFFEA00), width: 6),
                left: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (viewModel.isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                else
                  Text(
                    "VERIFY →",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFFFEA00),
            border: Border(
              top: BorderSide(color: Colors.black, width: 2),
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Center(
            child: Text(
              "THIS CODE IS THE LAST TIME WE SEE YOUR EMAIL.",
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryPhrase(AuthViewModel viewModel) {
    final words = viewModel.recoveryPhrase?.split(' ') ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SAVE THIS PHRASE.",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Write down these 12 words. They are\nthe only way to recover your account.",
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEA00),
            border: Border.all(color: Colors.black, width: 2),
          ),
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(words.length, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  '${index + 1}. ${words[index]}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () async {
            final userProvider = context.read<UserProvider>();
            final navigator = Navigator.of(context);
            await viewModel.completeAuth();
            if (viewModel.errorMessage == null && mounted) {
              userProvider.reset();
              navigator.pushReplacementNamed('/profile-setup');
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Color(0xFFFFEA00), width: 6),
                left: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                if (viewModel.isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                else
                  Text(
                    "I SAVED IT SAFELY →",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecoverAccount(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "RECOVER ACCOUNT.",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Enter your 12-word recovery phrase to\nrestore your account access.",
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(12, (index) {
              return Container(
                width: (MediaQuery.of(context).size.width - 48 - 24) / 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: TextField(
                  controller: _recoveryWordControllers[index],
                  style: GoogleFonts.spaceMono(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '${index + 1}',
                    hintStyle: GoogleFonts.spaceMono(color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () async {
            final phrase = _recoveryWordControllers
                .map((c) => c.text.trim())
                .where((t) => t.isNotEmpty)
                .join(' ');

            if (phrase.split(' ').length != 12) {
              _showErrorSnackBar('Phrase must be exactly 12 words.');
              return;
            }

            final userProvider = context.read<UserProvider>();
            final navigator = Navigator.of(context);
            final repo = AuthRepository();

            final success = await viewModel.recoverAccount(phrase);
            if (!success || !mounted) return;

            userProvider.reset();
            await userProvider.loadProfile(repo);

            if (userProvider.hasUsername) {
              navigator.pushNamedAndRemoveUntil('/home', (route) => false);
            } else {
              navigator.pushNamedAndRemoveUntil('/profile-setup', (route) => false);
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
                bottom: BorderSide(color: Color(0xFFFFEA00), width: 6),
                left: BorderSide(color: Colors.black, width: 2),
                right: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                if (viewModel.isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                else
                  Text(
                    "RECOVER →",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBadges() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEA00),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 24, color: Colors.black),
                  const SizedBox(height: 4),
                  Text("ANONYMITY FIRST", style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 24, color: Colors.black54),
                  const SizedBox(height: 4),
                  Text("SECURE AUTH", style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
