import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer<AuthViewModel>(
            builder: (context, viewModel, child) {
              // Listen for errors
              if (viewModel.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showErrorSnackBar(viewModel.errorMessage!);
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  // Top Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png', height: 32, color: Colors.black, errorBuilder: (context, error, stackTrace) => const Icon(Icons.spa, size: 32)),
                      const SizedBox(width: 8),
                      // Image.asset('assets/title.png', height: 32, color: Colors.black),
                      Text('MindMate', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Welcome Text
                  Text(
                    'Welcome back to your safe space',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4B39EF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Take a deep breath and settle in.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Login Card based on state
                  _buildAuthCard(viewModel),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard(AuthViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.currentState == AuthState.emailInput) ...[
            _buildEmailInput(viewModel),
          ] else if (viewModel.currentState == AuthState.otpInput) ...[
            _buildOtpInput(viewModel),
          ] else if (viewModel.currentState == AuthState.recoveryPhrase) ...[
            _buildRecoveryPhrase(viewModel),
          ] else if (viewModel.currentState == AuthState.recoverAccount) ...[
            _buildRecoverAccount(viewModel),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailInput(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'College Email',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'yourname@university.edu',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF0EFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'Send OTP',
          isLoading: viewModel.isLoading,
          onPressed: () {
            if (_emailController.text.trim().isNotEmpty) {
              viewModel.sendOtp(_emailController.text.trim());
            }
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              viewModel.startRecoveryFlow();
            },
            child: Text(
              'Recover Existing Account',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w500,
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter OTP',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            TextButton(
              onPressed: () {
                viewModel.resetToEmail();
              },
              child: Text(
                'Change Email',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryPurple),
              ),
            ),
          ],
        ),
        Text(
          'Sent to ${viewModel.currentEmail}',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: '123456',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF0EFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'Verify OTP',
          isLoading: viewModel.isLoading,
          onPressed: () {
            if (_otpController.text.trim().length == 6) {
              viewModel.verifyOtp(_otpController.text.trim());
              _otpController.clear(); // Delete OTP immediately
            }
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: viewModel.canResendOtp ? viewModel.resendOtp : null,
            child: Text(
              viewModel.canResendOtp
                  ? 'Resend OTP'
                  : 'Resend OTP in ${viewModel.resendTimer}s',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: viewModel.canResendOtp ? AppColors.primaryPurple : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
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
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Save Your Recovery Phrase',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'This 12-word phrase is your only way to recover your account if you lose access. Write it down. It will only be shown once.',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(words.length, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Text(
                  '${index + 1}. ${words[index]}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'I have saved it safely',
          isLoading: viewModel.isLoading,
          onPressed: () async {
            await viewModel.completeAuth();
            if (viewModel.errorMessage == null && context.mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
      ],
    );
  }

  final TextEditingController _recoveryController = TextEditingController();

  Widget _buildRecoverAccount(AuthViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recover Account',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            TextButton(
              onPressed: () {
                viewModel.resetToEmail();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryPurple),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your 12-word recovery phrase to restore your account access.',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _recoveryController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'word1 word2 word3...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF0EFFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          text: 'Recover',
          isLoading: viewModel.isLoading,
          onPressed: () async {
            final phrase = _recoveryController.text.trim();
            if (phrase.split(' ').length == 12) {
              final success = await viewModel.recoverAccount(phrase);
              if (success && context.mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            } else {
              _showErrorSnackBar('Phrase must be exactly 12 words.');
            }
          },
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFF9484FF)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
      ),
    );
  }
}
